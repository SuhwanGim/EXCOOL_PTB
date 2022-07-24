function movie_task(SID, ts, sessionNumber, runNumber, ip, port, opts)
%%





%% SETUP: Check OPTIONS
if (~isfield(opts,'dofmri')) | (~isfield(opts,'doBiopac'))  | (~isfield(opts,'testmode'))
    if ismissing(opts.dofmri)
        error('Check options');
    end
end
%% SETUP: OPTIONS
testmode = opts.testmode;
dofmri = opts.dofmri;
%doBiopac = opts.doBiopac;
doWebcam = opts.doFace;
doPathway = opts.Pathway;
doSendTrigger = opts.obs;
start_trial = 1;

%iscomp = 3; % default: macbook keyboard
%% SETUP: GLOBAL variables
global theWindow W H window_num;                  % window screen property
global white red red_Alpha orange bgcolor yellow; % set color
global window_rect lb rb tb bb scale_H            % scale size parameter
global lb1 rb1 lb2 rb2;
global fontsize;                                  % fontsize
global anchor_y anchor_y2 anchor anchor_xl anchor_xr anchor_yu anchor_yd anchor_lms anchor_lms_y anchor_lms_x; % anchors
global cir_center
%global Participant; % response box
end