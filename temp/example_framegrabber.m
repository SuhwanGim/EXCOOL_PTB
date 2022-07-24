% vid = videoinput('winvideo');
% preview(vid);
% 
% 
% %%
% 
% out = imaqhwinfo
% %%
% info = imaqhwinfo('winvideo');
% %%
% vid = videoinput('winvideo', 2);
% imaq.VideoDevice('winvideo', 2);
% %%
% info
%%
imaqreset;
info=imaqhwinfo;

vid = videoinput(info.InstalledAdaptors{1}, 1,'NTSC_M:RGB24 (720x480)' );

%%
frame = getsnapshot(vid);

image(frame) 
%% Configure the object for manual trigger mode.
triggerconfig(vid, 'manual');
% Now that the device is configured for manual triggering, call START.
% This will cause the device to send data back to MATLAB, but will not log
% frames to memory at this point.
start(vid)
%%
t = [];
video = VideoWriter('yourvideo_high_test_210720_tmp2.mp4','MPEG-4'); %create the video object
open(video); %open the file for writing
starttime = GetSecs;
duration = 300;
i = 1;


while GetSecs - starttime < duration
    frame = getsnapshot(vid);
    image(frame);
   
    %writeVideo(video,frame ); %write the image to file
    snapnow;
    t(i) = GetSecs - starttime;
     i = i+1;
end
close(video)
%stop(vid)
%%
t2 = [];
t = GetSecs;
while GetSecs - t < secs
    %ima = imread(snapshot(camObj));
    %t1(i) = GetSecs-t; % low res
    t2(i) = GetSecs-t; % high res
    i=i+1;
    ima = snapshot(camObj);
    % ima = imresize(ima,0.5,'nearest');    
        
    
    
    tex1 = Screen('MakeTexture', theWindow, ima, [], [],[],[],[]);
    Screen('DrawTexture', theWindow,tex1,[], [5*W/18 5*H/18 13*W/18 13*H/18],[],[],[],[],[],[]);
    
    % Draw quiz
    %DrawFormattedText(theWindow, num2str(double(GetSecs - t)), 'center', 'center', white, [], [], [], 1.2); % null screen
    %DrawFormattedText2([double(sprintf('<size=%d><font=-:lang=ko><color=ff0000>',round(GetSecs-t))) double('김수환환환')],'win',theWindow,'sx','center','sy','center','xalign','center','yalign','center');
    %DrawFormattedText(theWindow, double('김수환'), 'center', 'center', white, [], [], [], 1.2); % null screen
    Screen('Flip', theWindow);
    
end
tic;
close(video); %close and save the file 
toc; % Elapsed time is 0.041624 seconds.

sca;
disp('done')


