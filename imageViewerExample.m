%% make sure used tools are on path
addpath('tools/Singleton');
addpath('tools/GetFullPath');
addpath('tools/ParameterStore');
addpath('tools/Logger');
addpath('tools/ImageSaver');
%% Create Image viewer
im=ImageViewer();

%% load and add images
im1=imread('stones.png');
im.addImageFunc(im.output,im1,'stone image');
im2 = edge(rgb2gray(im1),'canny');
im.addImageFunc(im.output,im2,'edges');
