function get_blue(image_name)
close all;

%% Read image
filename = strcat(image_name, '.jpeg');
image = imread(filename); 

figure;  
% Maximize the figure. 
set(gcf, 'Position', get(0, 'ScreenSize'));


%% Extract the image to 3 channel
% Plot the original image.
subplot(3, 4, 1);
imshow(image);
drawnow;

% Extract image to red, blue and green
red_channel = image(:, :, 1); 
green_channel = image(:, :, 2); 
blue_channel = image(:, :, 3); 

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


%% Generating the histogram

% Plot red histogram. 
hR = subplot(3, 4, 6); 
[count_red, grayLevelsR] = imhist(red_channel); 
max_gray_level_R = find(count_red > 0, 1, 'last'); 
max_count_R = max(count_red); 
bar(count_red, 'r'); 
grid on; 
xlabel('Gray Levels'); 
ylabel('Pixel Count'); 
title('Histogram of Red channel');
drawnow; 

% Plot green histogram. 
hG = subplot(3, 4, 7); 
[count_green, grayLevelsG] = imhist(green_channel); 
max_gray_level_G = find(count_green > 0, 1, 'last'); 
max_count_G = max(count_green); 
bar(count_green, 'g', 'BarWidth', 0.95); 
grid on; 
xlabel('Gray Levels'); 
ylabel('Pixel Count'); 
title('Histogram of Green channel');
drawnow; 

% Plot blue histogram. 
hB = subplot(3, 4, 8); 
[count_blue, grayLevelsB] = imhist(blue_channel); 
max_gray_level_B = find(count_blue > 0, 1, 'last'); 
max_count_B = max(count_blue); 
bar(count_blue, 'b'); 
grid on; 
xlabel('Gray Levels'); 
ylabel('Pixel Count'); 
title('Histogram of Blue channel');
drawnow;

% Plot them together
maxGL = max([max_gray_level_R,  max_gray_level_G, max_gray_level_B]); 
max_count_ = max([max_count_R,  max_count_G, max_count_B]); 
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
maxGrayLevel = max([max_gray_level_R, max_gray_level_G, max_gray_level_B]); 
% Trim x-axis to just the max gray level on the bright end. 
drawnow;


%% Setup 3 channel's threshold number(manually)

xlim([0 maxGrayLevel]); 

% keep red and cutoff green and blue
redThresholdLow = 0;
redThresholdHigh = 80;
greenThresholdLow = 0;
greenThresholdHigh = 80;
blueThresholdLow = 100;
blueThresholdHigh = 255;




%% get 3 color's mask image
redMask = (red_channel >= redThresholdLow) & (red_channel <= redThresholdHigh);
greenMask = (green_channel >= greenThresholdLow) & (green_channel <= greenThresholdHigh);
blueMask = (blue_channel >= blueThresholdLow) & (blue_channel <= blueThresholdHigh);

% plot 3 mask
subplot(3, 4, 10);
imshow(redMask, []);
title('Is-Not-Red Mask');
drawnow;

subplot(3, 4, 11);
imshow(greenMask, []);
title('Is-Not-Green Mask');
drawnow;

subplot(3, 4, 12);
imshow(blueMask, []);
title('Is-Blue Mask');
drawnow;

% Combine 3 mask to figure the red only object
redObjectsMask = uint8(redMask & greenMask & blueMask);
subplot(3, 4, 9);
imshow(redObjectsMask, []);
title('Mask of Only blue objects');
drawnow;


%% Optimize the mask
% Delete small object
figure;  
set(gcf, 'Position', get(0, 'ScreenSize'));

smallestAcceptableArea = 5000; % Keep areas only if they're bigger than this.

redObjectsMask = uint8(bwareaopen(redObjectsMask, smallestAcceptableArea));
subplot(2, 2, 1);
imshow(redObjectsMask, []);
temp_string = sprintf('removed objects\nsmaller than %d pixels', smallestAcceptableArea);
title(temp_string);
drawnow;

% Smooth the border
structuringElement = strel('disk', 4);
redObjectsMask = imclose(redObjectsMask, structuringElement);

% Fill in any holes in the regions
redObjectsMask = uint8(imfill(redObjectsMask, 'holes'));
subplot(2, 2, 2);
imshow(redObjectsMask, []);
title('Regions filled and border smoothed');
drawnow;


subplot(2,2,3)
redObjectsMask = imgaussfilt(redObjectsMask, 10.0);
imshow(redObjectsMask, []);
temp_string = sprintf('gauss filter');
title(temp_string);
drawnow;

%% Corner Detection
corners = detectHarrisFeatures(redObjectsMask);

subplot(2, 2, 4);
imshow(image); hold on;
plot(corners.selectStrongest(4));
drawnow;


