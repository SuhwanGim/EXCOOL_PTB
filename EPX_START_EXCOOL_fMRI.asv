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
%% SETUP: Subj Information 
SID.date = date;
SID.ExpID = '';           % ID for fMRI exp participants
%% START 
% RUN1 : RESTING-STATE (10mins)
resting_state(SID, 1, opts);

%% RUN2 : RESTING-STATE (10mins)
resting_state(SID, 2, opts);

%% TASK1 : RESTING-STATE (10mins)
fMRI_task(SID, 1, opts);

%% TASK2 : RESTING-STATE (10mins)
fMRI_task(SID, 2, opts);

%% Structural imaging (10mins)