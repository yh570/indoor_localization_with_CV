Indoor localization with camera
Current version: detect Rubick’s cube and evaluate the distance between the camera with the cube.
To do: QR code detection, and extract the information from QR code and localize the camera.

Main script:
  video_local.m: indoor localization with video input
    usage: video_local('IMG.MOV', 0) //option_flag == 0 for previous data, 1 for new data
  image_local.m: indoor localization with image input
    usage: image_local('cube1_', 8, 1); //number == number of images, option_flag == 0 for previous data, 1 for new data

Important functions:
  localization.m: get camera's position from image/frame
  get_red.m: object detection for red object only
  get_coordinate.m: get x,y coordinate from triangulation

Helper functions:
  PlaceThresholdBars.m: place threshold bars in histogram
  get_blue.m: object detection for blue object only
  get_green.m: object detection for green object only
  extrinsics.m: get extrinsics parameter with known instrincs
  get_image_coordinate.m: manually select points from image

Data:
  camera_parameter.mat: Instrincs parameters of Iphone 6 plus' still camera
  cube1_*.jpeg_data: saved data for images cube1_*.jpeg
  video_parameter.mat: Instrincs parameters of Iphone 6 plus' video camera

Folder:
  Video2Images: extracted frames from video "IMG.MOV"