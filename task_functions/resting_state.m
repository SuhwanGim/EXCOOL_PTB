function resting_state(SID, runNumber, opts)
%% SETUP: OPTIONS
testmode = opts.testmode;
dofmri = opts.dofmri;
%% SETUP: GLOBAL variables
global theWindow W H window_num;                  % window screen property
global white red red_Alpha orange bgcolor yellow; % set color
global window_rect lb rb tb bb scale_H            % scale size parameter
global lb1 rb1 lb2 rb2;
global fontsize;                                  % fontsize
global anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors
global cir_center
%global Participant; % response box
%% SETUP: DATA and Subject INFO
savedir = fullfile(pwd,'data');
% subfunction %start_trial
fname = subjectinfo_check_EXOOL(SID.ExpID, savedir, runNumber, 'resting');
if exist(fname, 'file')
    % load previous dat files
    load(fname);
else
    % generate and save data
    dat.ver= 'EXCOOL_Ver1_July-23-2022_Suhwan';
    dat.subjects = SID;     % subject name
    dat.datafile = fname;  % filename
    dat.starttime = datestr(clock, 0); % date-time
    dat.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial
    dat.runNumber = runNumber;
    save(dat.datafile,'dat');
end
%% SETUP: Screen size
Screen('Clear');
Screen('CloseAll');
window_num = 0;
Screen('Preference', 'SkipSyncTests', 1);
if testmode
    window_rect = [0 0 1600 900]; % in the test mode, use a little smaller screen [but, wide resoultions]
    fontsize = 32;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    window_info = Screen('Resolution', window_num);
    %window_rect = [0 0 1920 1080];
    window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 44;
    HideCursor();
end
W = window_rect(3); %width of screen
H = window_rect(4); %height of screen


tb = H/5+100;           % in 800, it's 310
bb = H/2+100;           % in 800, it's 450, bb-tb = 340
scale_H = (bb-tb).*0.25;

anchor_xl = lb-80; % 284
anchor_xr = rb+20; % 916
anchor_yu = tb-40; % 170
anchor_yd = bb+20; % 710

% y location for anchors of rating scales -
anchor_y = H/2+10+scale_H;

% For rating scale
lb = 5*W/18;            % left bound
rb = 13*W/18;           % right bound


lb1 = 5*W/18;            % left bound
rb1 = 13*W/18;           % right bound

% For overall rating scale
lb2 = 5*W/18; %
rb2 = 13*W/18; %s

cir_center = [(lb1+rb1)/2 H*3/4+100];
%% SETUP: Screen color
bgcolor = 80;
white = 255;
red = [255 0 0];
red_Alpha = [255 164 0 130]; % RGB + A(Level of tranceprency)
orange = [255 164 0];
yellow = [255 220 0];
%% SETUP: External device name for matching
%===== Experimenter
iscomp = 3;
if iscomp == 1
    device(1).product = 'Apple Keyboard';   % imac scanner (full keyboard)
    device(1).vendorID= 1452;
elseif iscomp == 2
    device(1).product = 'Magic Keyboard';   % imac vcnl (short keyboard)
    device(1).vendorID= 1452;
elseif iscomp == 3
    device(1).product = 'Apple Internal Keyboard / Trackpad';   % macbook
    device(1).vendorID= 1452;
elseif iscomp == 4
    device(1).product = 'Magic Keyboard';         % my pc
    device(1).vendorID = 1452;
end
experimenter = IDkeyboards(device(1));
if dofmri
    % ===== Participant's button box
    % "HID KEY 12345"
    device(2).product = '932';
    device(2).vendorID= [1240 6171];
    
    Participant  = IDkeyboards(device(2));
    
    
    % ===== Scanner trigger
    device(3).product = 'KeyWarrior8 Flex';
    device(3).vendorID= 1984;
    scanner = IDkeyboards(device(3));    
end
%% SETUP: Screen parameters
font = 'NanumBarunGothic';
stimText = '+';
%% START: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect);       % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');                  % text encoding
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using transparent color e.g., alpha value of [R G B alpha]
Screen('TextSize', theWindow, fontsize);
Screen('TextFont', theWindow, font); % setting font
try
    %% PREP: INSTRUCTION before task
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
        display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (Trigger, USB, etc). \n 모두 준비되었으면 실험자는 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
    end
    
    while (1)
        % if this is for fMRI experiment, it will start with "s",
        % but if behavioral, it will start with "r" key.
        
        if dofmri
            [~,~,keyCode] = KbCheck(scanner); % experiment
            if keyCode(KbName('s'))==1 % get 's' from a sync box
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
            
        else % for behavior or testmode
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('r'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        
        display_runmessage(dofmri); % until 5 or r; see subfunctions
    end
    
    
    %% PREP: do fMRI (disdaq_sec = about 10 secs)
    if dofmri
        dat.disdaq_sec = 18; % 10 TRs
        fmri_t = GetSecs;
        % gap between 5 key push and the first stimuli (disdaqs: dat.disdaq_sec)
        display_expmessage('시작합니다...');
        %         Screen(theWindow, 'FillRect', bgcolor, window_rect);
        %         DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2); % 4 seconds
        Screen('Flip', theWindow);
        dat.runscan_starttime = GetSecs;
        waitsec_fromstarttime(fmri_t, 4);
        
        % 4 seconds: Blank
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        waitsec_fromstarttime(fmri_t, dat.disdaq_sec); % ADJUST THIS
    end
    
    %% ========================================================= %
    %                   START: RESTING
    % ========================================================== %
    t_time = GetSecs;
    dat.RunStartTime = t_time ;
    seconds = 550; % 600 secs without disdaq
    
    %DrawFormattedText(theWindow, double(stimText), 'center', 'center', white, [], [], [], 1.2);    
    display_expmessage('+');
    
    
    waitsec_fromstarttime(t_time, seconds);
    dat.RunEndTime = GetSecs;
    %% ========================================================= %
    %                   START: RATING
    % ========================================================== %
    Screen('Flip', theWindow);
    display_expmessage('');
    waitsec_fromstarttime(dat.RunEndTime, 5);
    % WHICH RATING SHOULD BE INCLUDED HERE (by Suhwan)
    
    %% ========================================================= %
    %                   FINALZING EXPERIMENT
    % ========================================================== %
    save(dat.datafile, '-append', 'dat');
    waitsec_fromstarttime(GetSecs, 2);
    %% END MESSAGE
    str = '잠시만 기다려주세요 (space)';
    display_expmessage(str);
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q'))==1
            break
        elseif keyCode(KbName('space'))== 1
            break
        end
    end
    ShowCursor();
    Screen('Clear');
    Screen('CloseAll');
catch err
    % ERROR
    disp(err);
    ShowCursor();
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end
end


function display_runmessage(dofmri)

% MESSAGE FOR EACH RUN

% HERE: YOU CAN ADD MESSAGES FOR EACH RUN USING RUN_NUM and RUN_I

global theWindow white bgcolor window_rect; % rating scale
global fontsize

if dofmri
    Run_start_text = double('참가자가 준비되었으면 이미징을 시작합니다 (s).');
else
    Run_start_text = double('참가자가 준비되었으면, r을 눌러주세요.');
end
msg = Run_start_text;
% display
%Screen(theWindow,'FillRect',bgcolor, window_rect);
%DrawFormattedText(theWindow, Run_start_text, 'center', 'center', white, [], [], [], 1.5);
DrawFormattedText2([double(sprintf('<size=%d><font=-:lang=ko><color=ffffff>',fontsize)) msg],'win',theWindow,'sx','center','sy','center','xalign','center','yalign','center');
Screen('Flip', theWindow);

end