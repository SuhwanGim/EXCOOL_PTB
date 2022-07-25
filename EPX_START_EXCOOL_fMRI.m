%% Written by Suhwan 
%% SETUP: FILE PATH
exp_dir = pwd; 
addpath(genpath(pwd));
cd(pwd);
%% SETUP: EXPERIMENT OPTIONS
opts = [];

opts.dofmri = 0;      % 0: do not get trigger 
                      % 1: get trigger 
                      
opts.testmode = 1;    % do test mode (not full screens)

opts.kbd = 1;         % 0: own keyboard
                      % 1: external button-box
                      % 2. external wheel

ts = generate_ts_EXCOOL();
ts.target_names = {'나','김덕배','서강준'}; 
ts.opts = opts;
%% SETUP: Subj Information 
SID.ExpID = 'ttteeee';           % ID for fMRI exp participants
%% START 
% RUN1 : RESTING-STATE (10mins)
resting_state(SID, 1, opts);
% %% RUN2 : RESTING-STATE (10mins)
% resting_state(SID, 2, opts);

%% TASK1 
fMRI_task(SID, ts, 1, opts);

%% TASK2 
fMRI_task(SID, ts, 2, opts);

%% TASK3
fMRI_task(SID, ts, 3, opts);

%% TASK4 
fMRI_task(SID, ts, 4, opts);


%% Structural imaging (10mins)