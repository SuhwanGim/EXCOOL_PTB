%% WEBCAM examples
% this package is needed (MATLAB Support Package for USB Webcams )
% see
% (https://kr.mathworks.com/help/supportpkg/usbwebcams/ug/installing-the-webcams-support-package.html)
%%
camList = webcamlist;
% Connect to the webcam.
cam = webcam(1);
%% Preview
preview(cam);
%% Acquire and display a single image frame.
% img = snapshot(cam);
% imshow(img);
for idx = 1:50
    img = snapshot(cam);
    image(img);
    
end
%% Writing video file usign videoWriter
vidWriter = VIdeoWriter('temp_videos.avi');
open(vidWriter);
for i = 1:500
    % Acquire frame for processing
    img = snapshot(cam);
    % Write frame to video
    writeVideo(vidWriter,img);
end
close(vidWriter)
%% close connection 
clear cam;