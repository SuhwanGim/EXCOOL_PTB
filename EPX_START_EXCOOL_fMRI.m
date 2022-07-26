%% Written by Suhwan 
%% SETUP: FILE PATH
exp_dir = pwd; 
addpath(genpath(pwd));
cd(pwd);
%% SETUP: EXPERIMENT OPTIONS
opts = [];

opts.dofmri = 1;      % 0: do not get trigger 
                      % 1: get trigger 
                      
opts.testmode = 0;    % do test mode (not full screens)

opts.kbd = 1;         % 0: own keyboard
                      % 1: external button-box
                      % 2. external wheel
%% SETUP: Subj Information 
ts = []; 
ts = generate_ts_EXCOOL();
ts.target_names = {'나','진민규','정우성'}; 
% {1}: ME
% {2}: Friends
% {3}: clebritiy
ts.opts = opts;
SID.ExpID = 'EX010';           % ID for fMRI exp participants
 %% START 
% RUN1 : RESTING-STATE (10mins)
 resting_state(SID, 1, opts);
% %% RUN2 : RESTING-STATE (10mins)
% resting_state(SID, 2, opts);
%% PRACTICE 

%% TASK1  
opts.testmode = 0;   
fMRI_task(SID, ts, 1, opts);

%% TASK2 
fMRI_task(SID, ts, 2, opts);

%% TASK3
fMRI_task(SID, ts, 3, opts);

%% TASK4  

fMRI_task(SID, ts, 4 , opts);
%% Structural imaging (10mins)