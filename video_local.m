function [x,y] = video_local(video_name, option_flag)
% Description:
%   Get camera's position in world coordinates from videos
%   Default zero point is at cube's left-middel-down corner...
%
% Usage:
%   e.g [x,y] = video_local('IMG.MOV', 1)
%
% option_flag:
%   0 = previous data, if previous data not exist, will capture the new data
%   1 = new data
close all

x = [];
y = [];

%% Split video to images
vid = VideoReader(video_name);
numFrames = vid.NumberOfFrames;
n = numFrames;
mkdir Video2Images;
currentFolder = pwd;

for i = 1:5:n
frames = read(vid, i);
imwrite(frames,[currentFolder '/Video2Images/image' int2str(i), '.jpeg']);
im(i) = image(frames);
end

for i = 1:5:n
    image_name = strcat(currentFolder, '/Video2Images/image', num2str(i), '.jpeg');
    fprintf('No %d\n', i);
    [temp_x, temp_y] = localization(image_name, option_flag, 1);
    if isnan(temp_x) || isnan(temp_y)
        fprintf('Incorrect: %2d\n', i);
        continue
    end
    x = [x, temp_x];
    y = [y, temp_y];
end


%% Moving average Processing

n = 5;
x = x';
y = y';
s1 = size(x, 1);
M  = s1 - mod(s1, n);
x_reshape  = reshape(x(1:M), n, []);
x_n = transpose(sum(x_reshape, 1) / n);


s2 = size(y, 1);
M  = s2 - mod(s2, n);
y_reshape  = reshape(y(1:M), n, []);
y_n = transpose(sum(y_reshape, 1) / n);



%% Ploting
figure;
set(gcf, 'Position', get(0, 'ScreenSize'));

s = 5.7;

A = [0 0 0];
B = [1 0 0];
C = [0 1 0];
D = [0 0 1];
E = [0 1 1];
F = [1 0 1];
G = [1 1 0];
H = [1 1 1];
P = [A;B;F;H;G;C;A;D;E;H;F;D;E;C;G;B] * s;
plot3(P(:,1),P(:,2),P(:,3), 'r-')
grid on
axis([-70 70 -130 10 0 140])
hold on
z(1:length(x_n)) = 10;

for i = 1:length(x_n)
    plot3(x_n(1:i), y_n(1:i), z(1:i), 'b-*', 'LineWidth', 2);
    pause(1);
end

hold off
