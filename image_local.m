function [x,y] = image_local(image_prefix, number, option_flag)
% Description:
%   Get camera's position in world coordinates from multi images
%   Default zero point is at cube's left-middel-down corner...
%
% Usage:
%   e.g [x,y] = image_local('./sample/cube1_', 8, 1)
%
% option_flag:
%   0 = previous data, if previous data not exist, will capture the new data
%   1 = new data
close all

x = [];
y = [];

for i = 1:number
    image_name = strcat(image_prefix, num2str(i));
    filename = strcat(image_name, '.jpeg');
    fprintf('No %d\n', i);
    [temp_x, temp_y] = localization(filename, option_flag, 0);
    if isnan(temp_x) || isnan(temp_y)
        fprintf('Incorrect: %2d\n', i);
        continue
    end
    x = [x, temp_x];
    y = [y, temp_y];
end



%% Ploting

figure;

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
axis([-45 45 -80 10 0 90])
hold on
z(1:length(x)) = 10;

for i = 1:length(x)
    plot3(x(1:i), y(1:i), z(1:i), 'b-*', 'LineWidth', 2);
    pause(1);
end
hold off
