load('camera_parameter');

image_name = 'cube1_1.jpeg';

K = [ a, -a*cot(theta), u0;
      0, b/sin(theta),  v0;
      0, 0              1 ];
  
k_inv = inv(K);

k_inv_homo = [k_inv; [0,0,0]];


[image_x, image_y] = get_image_coordinate(image_name);

pixel = [image_x, image_y, 1]';

world = [0.0, 0.0, 0.0, 1]';

temp = k_inv_homo * pixel
