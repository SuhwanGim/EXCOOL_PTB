function [fname, trial_n] = subjectinfo_check_EXOOL(SID, savedir, run_number, varargin)
% Get subject information, and check if the data file exists?
%
% :Usage:
% ::
%     [fname, start_line, SID] = subjectinfo_check(savedir, run_number,varargin)
%
%
% :Inputs:
%
%   **savedir:**
%       The directory where you save the data
%
% :Optional Inputs:
%
%   **'task':**
%       Check the data file for Motor_task.m
%
%   **'resting':**
%       Check the data file for Motor_task.m

%% SETUP: varargin
foldername = [];
for i = 1:length(varargin)
    if ischar(varargin{i})
        switch varargin{i}
            % functional commands
            case {'task', 'fmri'}
                foldername ='task';
            case {'resting','rest'}
                foldername ='resting';
            otherwise
                erorr('Unknown Error');
        end
    end
    if isempty(foldername);  error('Please check the inputs'); end
end
fname = fullfile(savedir, foldername,  sprintf('EXC_%s_Sub-%s_run%02d.mat',foldername, SID, run_number)); % file_name
%%
if ~exist(fullfile(savedir, foldername), 'dir')
    mkdir(fullfile(savedir, foldername));
    whattodo = 1;
else
    if exist(fname, 'file')
        if run_number == 1
            str = ['The Subject ' SID ' data file exists. Press a button for the following options'];
            disp(str);
            whattodo = input('1:Save new file, 2:Save the data from where we left off, Ctrl+C:Abort? ');
        else
            str = ['The Subject ' SID ' data file exists and not first trial. Press a button for the follwing options'];
            disp(str);
            whattodo = input('1:Go next run, 2:Save the data from where we left off, Ctrl+C: Abort? ');
        end
    else
        whattodo = 1;
    end
end


if whattodo == 2
    % if you want to start the experiment from specific trial
    load(fname);
    trial_n = 1;
    for i = 1:numel(data.dat)
        trial_n = trial_n + numel(data.dat{i});
    end
    
else
    trial_n = 1;
end

end