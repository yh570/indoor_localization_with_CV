function [x,y] = localization(image_name, option_flag, video_flag)
% Description:
%   Get camera's position in world coordinates
%   Default zero point is at cube's left-middel-down corner...
%
% Usage:
%   e.g [x,y] = localization('cube1_1.jpeg', 1, 0)
%
% option_flag:
%   0 = previous data, if previous data not exist, will capture the new data
%   1 = new data

% video_flag:
%   0 = image
%   1 = video


%% Initialize

pixel_size = 1.5 * 10^-4; % 1.5 micro meter
cube_size = 5.7; % in cm

if video_flag == 1
    f = 4.6 / 10;
else
    f = 4.15 / 10; % focal length = 4.15mm
end


%filename = strcat(image_name, '.jpeg');
filename = image_name;
data_name = strcat(image_name, '_data');
data_mat = strcat(data_name, '.mat');


%% Get image coordinates

% Check previous data exist or not
image_flag = exist(data_mat);

% get image coordinate
% load previous data if exist and option = load
if image_flag == 2
    if option_flag == 0
        load(data_name);
    else 
        % get new data if option = get new data
        %[image_x, image_y] = get_image_coordinate(filename);
        [image_x, image_y] = get_red(filename, 0);
        save(data_name, 'image_x', 'image_y');
    end
else
    % get new data if previous data is NOT exist
    %[image_x, image_y] = get_image_coordinate(filename);
    [image_x, image_y] = get_red(filename, 0);
    save(data_name, 'image_x', 'image_y');
end

if length(image_x) < 4 || length(image_y) < 4
    x = NaN;
    y = NaN;
    return
end


%% Self calibration: project from pixels to camera

% Calculate the camera coordinate from pixel and Instrisncs parameter
% camera_y = f * sin(theta) * (image_y - v0) / beta
% camera_x = f * (image_x - u0 + alpha * cot(theta)/f)/a



if video_flag == 1
    load('video_parameter');

% iamge
else
    load('camera_parameter');
end

camera_x = image_x;
camera_y = image_y;
 %{
%length(image_x)
for i = 1 : length(image_x),
    temp_y = sin(theta) * (image_y(i) - v0) / b;
    temp_x = (image_x(i) - u0 + a * cot(theta) * temp_y);
    temp_y = f * sin(theta) * (image_y(i) - v0) / b;
    temp_x = f * (image_x(i) - u0 + a * cot(theta) * temp_y / f) / a;
    camera_x = [camera_x, temp_x];
    camera_y = [camera_y, temp_y];
end
%}



%% Get cube size in image
if video_flag == 1
    % video
    A = [camera_x(1), camera_y(1)];
    B = [camera_x(4), camera_y(4)]; % center of the coordinates
    C = [camera_x(2), camera_y(2)];
    D = [camera_x(3), camera_y(3)];
  
% image
else
    A = [camera_x(4), camera_y(4)];
    B = [camera_x(3), camera_y(3)]; % center of the coordinates
    C = [camera_x(1), camera_y(1)];
    D = [camera_x(2), camera_y(2)];
end


AB = norm(A-B) * pixel_size;
CD = norm(C-D) * pixel_size;

% f/z' = D/Z
Depth_AB = f / AB * cube_size;
Depth_CD = f / CD * cube_size;

% [0,0] is 1st cube's position
[x, y] = get_coordinate([0,0], Depth_AB, Depth_CD, cube_size)




%% Multi cubes
%{
weight = Depth_AB;

if length(camera_x) > 4
    return
    A = [camera_x(5), camera_y(5)];
    B = [camera_x(6), camera_y(6)]; % center of the coordinates
    C = [camera_x(7), camera_y(7)];
    D = [camera_x(8), camera_y(8)];

    AB = norm(A-B) * pixel_size;
    CD = norm(C-D) * pixel_size;

    % f/z' = D/Z
    Depth_AB = f / AB * cube_size; 
    Depth_CD = f / CD * cube_size;

    [x1, y1] = get_coordinate([-100,0], Depth_AB, Depth_CD, cube_size);
    
    % using weight to get average
    x = x*weight/(weight+Depth_AB) + x1*Depth_AB/(weight+Depth_AB);
    y = y*weight/(weight+Depth_AB) + y1*Depth_AB/(weight+Depth_AB);
end
%}
