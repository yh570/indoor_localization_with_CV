Indoor localization with camera

Description:
The primary goal of this project is to detect multiple specified objects/QR codes, and localize the position of a camera or a user in the map based on these objects/QR codes’ position. Current version works fine with a Rubik’s cube with 5.7 cm edge. For imaging an iPhone 6 plus is used, whose focal length for still camera is 4.15 mm and 4.6 mm for the video camera. The pixel size in both still image and video is 1.5 micro meter. For the video footage, the frames of the video are extracted and then used as single images for the calculations. 

Current progress:
Working on QR code detection, and extract the information from QR code to localize the camera.

Main script and usage:
  video_local.m: indoor localization with video input
    usage: video_local(‘./sample/IMG.MOV', 0) //option_flag == 0 for previous data, 1 for new data
  image_local.m: indoor localization with image input
    usage: image_local(‘./sample/cube1_', 8, 1); //number == number of images, option_flag == 0 for previous data, 1 for new data

Important functions:
  localization.m: get camera's position from image/frame
  get_red.m: object detection for red object only
  get_coordinate.m: get x,y coordinate from triangulation

Helper functions:
  get_blue.m: object detection for blue object only
  get_green.m: object detection for green object only
  extrinsics.m: get extrinsics parameter with known instrincs
  get_image_coordinate.m: manually select points from image

Data:
  camera_parameter.mat: Instrincs parameters of Iphone 6 plus' still camera
  cube1_*.jpeg_data: saved data for images cube1_*.jpeg
  video_parameter.mat: Instrincs parameters of Iphone 6 plus' video camera

Folder:
  sample: sample video and images
  Video2Images: extracted frames from video "IMG.MOV"