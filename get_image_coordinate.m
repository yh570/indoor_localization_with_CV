function [image_x, image_y] = get_image_coordinate(image_name)
% Description:
%   Select the points in image and return selected point's pixel coordinates
%
% Usage:
%   e.g [x,y] = get_image_coordinate('cube1.jpeg')

RGB = imread(image_name);
[image_x, image_y, p] = impixel(RGB);
