function [corner_x, corner_y] = get_red(image_name, enable_plot)
% Description:
%   Get red object only from image, and return the corner of the object
%   
% Usage:
%   e.g [x,y] = get_red('cube1_1.jpeg', 1)
%
% enable_plot:
%   0 = disable
%   1 = enable


%% Read image
image = imread(image_name); 

if enable_plot == 1
    figure;  
    % Maximize the figure. 
    set(gcf, 'Position', get(0, 'ScreenSize'));

    
    % Plot the original image.
    subplot(3, 4, 1);
    imshow(image);
    drawnow;
end

%% Extract the image to RGB channel

red_channel = image(:, :, 1); 
green_channel = image(:, :, 2); 
blue_channel = image(:, :, 3); 

if enable_plot == 1
    % Plot red
    subplot(3, 4, 2);
    imshow(red_channel);
    title('Red channel');
    drawnow;

    % Plot green
    subplot(3, 4, 3);
    imshow(green_channel);
    title('Green channel');
    drawnow;

    % Plot blue
    subplot(3, 4, 4);
    imshow(blue_channel);
    title('Blue channel');
    drawnow; 
end


%% Generating the histogram

[count_red, grayLevelsR] = imhist(red_channel); 
max_gray_level_R = find(count_red > 0, 1, 'last'); 
max_count_R = max(count_red); 

[count_green, grayLevelsG] = imhist(green_channel); 
max_gray_level_G = find(count_green > 0, 1, 'last'); 
max_count_G = max(count_green);

[count_blue, grayLevelsB] = imhist(blue_channel); 
max_gray_level_B = find(count_blue > 0, 1, 'last'); 
max_count_B = max(count_blue);

% find maximum gray leverl
maxGL = max([max_gray_level_R,  max_gray_level_G, max_gray_level_B]); 
max_count_ = max([max_count_R,  max_count_G, max_count_B]); 
maxGrayLevel = max([max_gray_level_R, max_gray_level_G, max_gray_level_B]);


if enable_plot == 1
    % Plot red histogram. 
    hR = subplot(3, 4, 6); 
    bar(count_red, 'r'); 
    grid on; 
    xlabel('Gray Levels'); 
    ylabel('Pixel Count'); 
    title('Histogram of Red channel');
    drawnow; 

    % Plot green histogram. 
    hG = subplot(3, 4, 7);  
    bar(count_green, 'g', 'BarWidth', 0.95); 
    grid on; 
    xlabel('Gray Levels'); 
    ylabel('Pixel Count'); 
    title('Histogram of Green channel');
    drawnow; 

    % Plot blue histogram. 
    hB = subplot(3, 4, 8); 
    bar(count_blue, 'b'); 
    grid on; 
    xlabel('Gray Levels'); 
    ylabel('Pixel Count'); 
    title('Histogram of Blue channel');
    drawnow;

    % Plot them together
    axis([hR hG hB], [0 maxGL 0 max_count_]); 

    subplot(3, 4, 5); 
    plot(grayLevelsR, count_red, 'r', 'LineWidth', 2); 
    grid on; 
    xlabel('Gray Levels'); 
    ylabel('Pixel Count'); 
    hold on; 
    plot(grayLevelsG, count_green, 'g', 'LineWidth', 2); 
    plot(grayLevelsB, count_blue, 'b', 'LineWidth', 2); 
    title('Histogram of All channels'); 
     
    % Trim x-axis to just the max gray level on the bright end. 
    drawnow;
end


%% Setup 3 channel's threshold number(manually)

xlim([0 maxGrayLevel]); 

% keep red and cutoff green and blue
redThresholdLow = 100;
redThresholdHigh = 255;
greenThresholdLow = 0;
greenThresholdHigh = 80;
blueThresholdLow = 0;
blueThresholdHigh = 80;


%% get 3 color's mask image
% keep the majority of red channel and cut off green and blue
redMask = (red_channel >= redThresholdLow) & (red_channel <= redThresholdHigh);
greenMask = (green_channel >= greenThresholdLow) & (green_channel <= greenThresholdHigh);
blueMask = (blue_channel >= blueThresholdLow) & (blue_channel <= blueThresholdHigh);
redObjectsMask = uint8(redMask & greenMask & blueMask);

if enable_plot == 1
    % plot 3 mask
    subplot(3, 4, 10);
    imshow(redMask, []);
    title('Is-Red Mask');
    drawnow;

    subplot(3, 4, 11);
    imshow(greenMask, []);
    title('Not-Green Mask');
    drawnow;

    subplot(3, 4, 12);
    imshow(blueMask, []);
    title('Not-Blue Mask');
    drawnow;

    % Combine 3 mask to figure the red only object
    redObjectsMask = uint8(redMask & greenMask & blueMask);
    subplot(3, 4, 9);
    imshow(redObjectsMask, []);
    title('Mask of Only red objects');
    drawnow;
end




%% Optimize the mask
% Delete small object
lim_object = 5000; % Keep areas only if they're bigger than this.

% delete the small pieces of red object
redObjectsMask = uint8(bwareaopen(redObjectsMask, lim_object));


if enable_plot == 1
    figure;  
    set(gcf, 'Position', get(0, 'ScreenSize'));

    subplot(2, 2, 1);
    imshow(redObjectsMask, []);
    temp_string = sprintf('removed objects smaller than %d pixels', lim_object);
    title(temp_string);
    drawnow;
end

% Smooth the border
structuringElement = strel('disk', 4);
redObjectsMask = imclose(redObjectsMask, structuringElement);

% Fill in any holes in the regions
redObjectsMask = uint8(imfill(redObjectsMask, 'holes'));


if enable_plot == 1
    subplot(2, 2, 2);
    imshow(redObjectsMask, []);
    title('Regions filled and border smoothed');
    drawnow;
end


% Gaussian filter
redObjectsMask = imgaussfilt(redObjectsMask, 20.0);
%redObjectsMask = imgaussfilt(redObjectsMask, 10.0);


if enable_plot == 1
    subplot(2, 2, 3);
    imshow(redObjectsMask, []);
    title('Gaussian');
    drawnow;
end



%% Detect the corner

BW = edge(redObjectsMask, 'sobel');

if enable_plot == 1
    figure
    imshow(BW), title('edge')
end

%# get boundary
B = bwboundaries(BW, 8, 'noholes');
B = B{1};

%%# boudary signature
%# convert boundary from cartesian to ploar coordinates
objB = bsxfun(@minus, B, mean(B));
[theta, rho] = cart2pol(objB(:,2), objB(:,1));

if enable_plot == 1
    figure, plot(theta, rho, '.');
end

a = 16;
b = ones(1, a)/a;
rho_filtered = filtfilt(b, a, rho);

%# find corners
corners = find( diff(diff(rho_filtered)>0) < 0 )     %# find peaks
corners = corners';

%{
for i = 3 : length(rho)-2
    if rho(i) > rho(i-1) && rho(i-1) > rho(i-2) && rho(i) > rho(i+1) && rho(i+1) > rho(i+2)
        if ismember(i, corners) == 0
            corners = [corners, i];
        end
    end
end
%}

%[~,order] = sort(rho_filtered, 'descend');
%corners = order(1:4);

%[pkstemp, corners] = findpeaks(rho_filtered, 'MINPEAKHEIGHT', 0.0); % pkstemp get the peak value, and locstemp get location



%# plot boundary signature + corners
if enable_plot == 1
    figure, plot(theta, rho_filtered, '.'), hold on
    plot(theta(corners), rho_filtered(corners), 'ro', 'MarkerSize',20), hold off
end
%# plot image + corners


if length(corners) < 4
    corner_x = [];
    corner_y = [];
    return
end

[Sorted, I] = sort(rho_filtered(corners), 'descend');
corners_4 = sort(corners(I(1:4))); 


corner_x = B(corners_4, 2);
corner_y = B(corners_4, 1);

if enable_plot == 1
    figure, imshow(image), hold on
    plot(corner_x(1), corner_y(1), 's', 'MarkerSize',15, 'MarkerFaceColor','b')
    plot(corner_x(2), corner_y(2), 's', 'MarkerSize',15, 'MarkerFaceColor','b')
    plot(corner_x(3), corner_y(3), 's', 'MarkerSize',15, 'MarkerFaceColor','b')
    plot(corner_x(4), corner_y(4), 's', 'MarkerSize',15, 'MarkerFaceColor','b')

    hold off, title('Corners')
end
