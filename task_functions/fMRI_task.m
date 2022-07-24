function fMRI_task(SID, ts, runNumber, opts)
%
%  :: WORKING ON::
%       : Suhwan Gim (suhwan.gim.psych@gmail.com)
%               Last updated (July. 23. 2022)
%
%   :: The things you should know on this functions
%       - This function is for running experimental paradigm for Suhwan's
%       project (disdaq = 10 secs).
%
%       1) See something 
%       2) rating
%
%   :: Requirements for this experiments and fucntions ::
%       1) Latest version of PsychophysicsToolbox3
%       2) Recommeded version of Gstreamer (see help GStreamer)
%
%   ====================================================================%
%   ** Usage **
%
%   ** In singal **
%       - Scanner trigger
%       - obserber's webcam
%   ** Optional Input **
%       - 'test': Lower reslutions. (1600 900 px)
%       - 'fmri': If you run this script in sMRI . This option can
%       receive 's' trigger from sync box.
%
%   ====================================================================
%% SETUP: Check OPTIONS
% if (~isfield(opts,'dofmri')) | (~isfield(opts,'doBiopac'))  | (~isfield(opts,'testmode'))
%     error('Check options');
% end
%% SETUP: OPTIONS
testmode = opts.testmode;
dofmri = opts.dofmri;
start_trial = 1;
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
[fname,trial_previous] = subjectinfo_check_EXOOL(SID.ExpID, savedir,runNumber, 'task');

if exist(fname, 'file')
    % load previous dat files
    load(fname,'dat');
    start_trial = trial_previous; % start with this trial
else
    % generate and save data
    dat.ver= 'EXCOOL_Ver1_July-23-2022_Suhwan';
    dat.subjects = SID;     % subject name
    dat.datafile = fname;  % filename
    dat.starttime = datestr(clock, 0); % date-time
    dat.starttime_getsecs = GetSecs; % in the same format of timestamps for each trial
    dat.run_umber = runNumber;
    dat.ts = ts; % trial sequences (predefiend)
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
%% SETUP: Screen parameters
font = 'NanumBarunGothic';
%font = 'D2Coding';
%% START: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect);       % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');                  % text encoding
Screen('BlendFunction', theWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % For using transparent color e.g., alpha value of [R G B alpha]
Screen('TextSize', theWindow, fontsize);
Screen('TextFont', theWindow, font); % setting font
%% START: SCREEN FOR PARTICIPANTS
try
    %% PREP: INSTRUCTION before task
    while (1)
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('space'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
        display_expmessage('실험자는 모든 것이 잘 준비되었는지 체크해주세요 (Biopac,trigger, USB, etc). \n 모두 준비되었으면 실험자는 SPACE BAR를 눌러주세요.'); % until space; see subfunctions
    end
    
    while (1)
        % if this is for fMRI experiment, it will start with "s",
        % but if behavioral, it will start with "r" key.
        
        if dofmri
            [~,~,keyCode] = KbCheck; % experiment
            if keyCode(KbName('s'))==1 % get 's' from a sync box
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        else % for behavior
            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('r'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment;
            end
        end
        display_runmessage(dofmri); % until 5 or r; see subfunctions
    end
    
    
    %% PREP: do fMRI (disdaq_sec = about 10 secs) and 
    if dofmri
        dat.disdaq_sec = 18 ; % 10 TRs
        fmri_t = GetSecs;
        % gap between 5 key push and the first stimuli (disdaqs: dat.disdaq_sec)
        %Screen(theWindow, 'FillRect', bgcolor, window_rect);
        %DrawFormattedText(theWindow, double('시작합니다...'), 'center', 'center', white, [], [], [], 1.2); % 4 seconds               
    end            
    display_expmessage('시작합니다... ');    
    %% PREP: Wait 10 secs more 
    if dofmri
        dat.runscan_starttime = GetSecs;
        waitsec_fromstarttime(fmri_t, 4);        
        % 4 seconds: Blank        
        Screen('Flip', theWindow);
        waitsec_fromstarttime(fmri_t, dat.disdaq_sec); % ADJUST THIS + 8 secs for stable modeling 
    end 
    
    %% ========================================================= %
    %                   TRIAL START
    % ========================================================== %
    dat.RunStartTime = GetSecs;
    for trial_i = start_trial:16 % length(ts.t{1})        
            
        % Trial begins
        trial_t = GetSecs;
        dat.dat{trial_i}.TrialStartTimestamp = trial_t;
        % --------------------------------------------------------- %
        %         1. ITI (fixPoint)
        % --------------------------------------------------------- %
        DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2); % as exactly same as function fixPoint(trial_t, ttp , white, '+') % ITI
        Screen('Flip', theWindow);        
        %-------------------------------------------------
        waitsec_fromstarttime(trial_t, ts.t{runNumber}{trial_i}.ITI);
        dat.dat{trial_i}.ITI_EndTime = GetSecs;
        
        
        
        % --------------------------------------------------------- %
        %         2. Target cue 
        % --------------------------------------------------------- %
        % black screen
        Screen('Flip',theWindow); % black screen
        DrawFormattedText(theWindow, double(''), 'center', 'center', white, [], [], [], 1.2); % as exactly same as function fixPoint(trial_t, ttp , white, '+') % ITI
        Screen('Flip', theWindow);
        waitsec_fromstarttime(trial_t, ts.t{runNumber}{trial_i}.ITI + 12); % From start + ITI + thermal (12 sec)
        
        
        % --------------------------------------------------------- %
        %         3. ISI1
        % --------------------------------------------------------- %
        ttp = []; % total
        ttp = ts.t{runNumber}{trial_i}.ITI + 12 + ts.t{runNumber}{trial_i}.ISI1;
        fixPoint(trial_t, ttp , white, '+') % ITI
        dat.dat{trial_i}.ISI1_EndTime=GetSecs;
        
        % --------------------------------------------------------- %
        %         4. Trait 
        % --------------------------------------------------------- %
        ttp = ttp + 5;
        temp_ratings = [];
        temp_ratings = get_ratings(ttp, trial_t); % get_ratings(rating_type, total_secs, start_t )
        
        % --------------------------------------------------------- %
        %         5. ISI2
        % --------------------------------------------------------- %
        ttp = ttp + ts.t{runNumber}{trial_i}.ISI2;
        fixPoint(trial_t, ttp , white, '+') % ISI2
        dat.dat{trial_i}.ISI2_EndTime=GetSecs;
        
        % --------------------------------------------------------- %
        %         6. Ratings 
        % --------------------------------------------------------- %
        
        ttp = ttp + 5;
        temp_ratings = [];
        temp_ratings = get_ratings( ttp, trial_t); % get_ratings(rating_type, total_secs, start_t )
        
        dat.dat{trial_i}.ratings_end_timestamp = GetSecs;
        dat.dat{trial_i}.ratings_con_time_fromstart = temp_ratings.con_time_fromstart;
        dat.dat{trial_i}.ratings_con_xy = temp_ratings.con_xy;
        dat.dat{trial_i}.ratings_con_clicks = temp_ratings.con_clicks;
        dat.dat{trial_i}.norms_ratings = temp_ratings.norms_ratings;
        
                
        % ------------------------------------ %
        %  End of trial (save data)
        % ------------------------------------ %
        dat.dat{trial_i}.TrialEndTimestamp=GetSecs;
        if mod(trial_i,2)
            save(dat.datafile, '-append', 'dat');
        end
    end
    
    %% FINALZING EXPERIMENT
    dat.RunEndTime = GetSecs;
    DrawFormattedText(theWindow, double(' '), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    waitsec_fromstarttime(dat.RunEndTime, 10);
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
    % print ERROR   
    disp(err);
    ShowCursor();
    for i = 1:numel(err.stack)
        disp(err.stack(i));
    end
    abort_experiment;
end
end % function end
%% ====================================================================== %
%                   IN-LINE FUNCTION                                      %
% ======================================================================= %

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



%% ------------------------------------------ %
%           TASK                              %
%  ------------------------------------------ %
function temp_ratings = get_ratings(total_secs, start_t)

global theWindow W H window_num;                  % window screen property
global white red red_Alpha orange bgcolor yellow; % set color
global window_rect lb rb tb bb scale_H            % scale size parameter
global lb1 rb1 lb2 rb2;
global cir_center
global fontsize
%%



rec_i = 0;
start_while = GetSecs;
SetMouse(cir_center(1),cir_center(2));
while GetSecs - start_t < total_secs
    [x,y,button]=GetMouse(theWindow);
    y = H/2+scale_H/2;%bb;
    rec_i= rec_i+1;
    % send to arc of semi-circle
    if x<lb
        x = lb;
    end
    
    if  x>rb
        x = rb;
    end
    SetMouse(x,y);
    xloc = num2str((x-lb)./(rb-lb)); % nomalized ratings (from zero to 1) 
    
    
    msg = double(msg);
    %DrawFormattedText(theWindow, msg, 'center', 150, orange, [], [], [], 2);
    DrawFormattedText2([double(sprintf('<size=%d><font=-:lang=ko><color=ffffff>',fontsize)) msg],'win',theWindow,'sx','center','sy',(window_rect(2)+window_rect(4))/3,'xalign','center','yalign','center');
    draw_scale('line2');
    Screen('DrawDots', theWindow, [x y], 15, orange, [0 0], 1);
    Screen('Flip', theWindow);
    
    % recording    
    temp_ratings.con_time_fromstart(rec_i,1) = GetSecs-start_while;
    temp_ratings.norms_ratings(rec_i,1) = xloc;
    temp_ratings.con_xy(rec_i,:) = [x-cir_center(1) cir_center(2)-y];
    temp_ratings.con_clicks(rec_i,:) = button;        
    
    if button(1)
        draw_scale('line2');
        Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
        Screen('Flip',theWindow);
        WaitSecs(min(0.5, 5-(GetSecs-start_while)));
        ready3=0;
        while ~ready3 %GetSecs - sTime> 5
            msg = double(' ');
            DrawFormattedText(theWindow, msg, 'center', 150, white, [], [], [], 1.2);
            Screen('Flip',theWindow);
            if  GetSecs - start_while > 5
                break
            end
        end
        break;
    else
        %do nothing
    end
    
end

end