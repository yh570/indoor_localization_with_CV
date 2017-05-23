function [x,y] = get_coordinate(Origin, Depth_AB, Depth_CD, cube_size)
%% Get localization
% by using Heron's formular
% l = (a+b+c)/s
% Triangle aera = (l*(l-a)*(l-b)*(l-c))^(1/2)

l = (Depth_AB + Depth_CD + cube_size) / 2;
S = sqrt(l * (l - Depth_AB) * (l - Depth_CD) * (l - cube_size));

% Triangle aera = (cube_size * height)/2
% where height is y coordinate = 2 * aera / cube_size
% and x coordinate is ((Depth_AB)^2 - y^2)^0.5

y = -2 * S / cube_size + Origin(2);
x_temp = sqrt(Depth_AB^2 - y^2);

% Triangle angle is based on cos equation
% costheta = (a^2 + b^2 - c^2)/2*a*b
% if costheta > 0, x > 0
% if costheta < 0, x < 0

costheta = ((Depth_AB)^2 + (cube_size)^2 - (Depth_CD)^2) / (2 * Depth_AB * cube_size);
if costheta < 0
    x = Origin(1) - x_temp;
else
    x = Origin(1) + x_temp;
end