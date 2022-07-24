
% Construct a webcam object
%close(camObj);
camObj = webcam(1); % The resoultion of webcam can be modified in WinOS
% Preview a stream of image frames.
%preview(camObj);

% Acquire and display a single image frame.

%imshow(img);

%%

%% Global variable
global theWindow W H; % window property
global white red orange bgcolor; % color
global window_rect prompt_ex lb rb lb1 rb1 lb2 rb2 tb bb scale_H promptW promptH; % rating scale
global fontsize anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors


Screen('Clear');
Screen('CloseAll');
    
window_num = 0;
Screen('Preference', 'SkipSyncTests', 1);
window_rect = [0 0 1920 1080]; % in the test mode, use a little smaller screen [but, wide resoultions]
fontsize = 32;
bgcolor = 80;
white = 255;
red = [255 0 0];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
% For rating scale
lb = 5*W/18;            % left bound
rb = 13*W/18;           % right bound
% For cont rating scale 
lb1 = 1*W/18; %
rb1 = 17*W/18; %

% For overall rating scale
lb2 = 5*W/18; %
rb2 = 13*W/18; %s

red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency)
orange = [255 164 0];
yellow = [255 220 0];
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect);       % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');                  % text encoding
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using transparent color e.g., alpha value of [R G B alpha]
Screen('Preference','TextRenderer',1)
Screen('TextSize', theWindow, fontsize);
font = 'NanumBarunGothic';
Screen('TextFont', theWindow, font); % setting font
%ima=imread(img);

secs = 12;
i = 1;
% Create video 
%video = VideoWriter('yourvideo_high.avi','Uncompressed AVI'); %create the video object
video = VideoWriter('yourvideo_high.mp4','MPEG-4'); %create the video object
open(video); %open the file for writing
t2 = [];
t = GetSecs;
while GetSecs - t < secs
    %ima = imread(snapshot(camObj));
    %t1(i) = GetSecs-t; % low res
    t2(i) = GetSecs-t; % high res
    i=i+1;
    ima = snapshot(camObj);
    % ima = imresize(ima,0.5,'nearest');    
    writeVideo(video,ima ); %write the image to file    
    
    draw_scale('overall_predict_semicircular_SEP');
    tex1 = Screen('MakeTexture', theWindow, ima, [], [],[],[],[]);
    Screen('DrawTexture', theWindow,tex1,[], [5*W/18 1*H/18 13*W/18 9*H/18],[],[],[],[],[],[]);
    
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


