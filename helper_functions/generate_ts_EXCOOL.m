function ts = generate_ts_EXCOOL()
% ts = generate_ts_EXCOOL

% Three block desgin
% A total 4 run 
% 18 trials per run 
% 6 trials per block


% total run = 6;
% total trial = 12;
targeto = [];
words_val = [];
rng('shuffle');
%% EXPERIMENTAL PARAMETER
% ** Word itself
block_all= []; 
T1pos = []; 
T1neg = []; 
T1=readtable('data/wordlists/kor_personal.xlsx');

pos1 = T1.WID(find(T1.positive==+1));
neg1 = T1.WID(find(T1.positive==-1));

for i =1:3
    T1pos{i} = pos1(randperm(12));
    T1neg{i} = neg1(randperm(12));
end

WID=1:24;    
trial_idx = [1:3; 4:6; 7:9; 10:12];
% BLOCK DESGIN 
for run_i=1:4    
    rnNB = randperm(3);
    target_all{run_i} = [repmat(rnNB(1),6,1);repmat(rnNB(2),6,1);repmat(rnNB(3),6,1)]';
    WID_ALL{run_i} = [T1neg{rnNB(1)}(trial_idx(run_i,:))' T1pos{rnNB(1)}(trial_idx(run_i,:))' ...
        T1neg{rnNB(2)}(trial_idx(run_i,:))' T1pos{rnNB(2)}(trial_idx(run_i,:))' ...
        T1neg{rnNB(3)}(trial_idx(run_i,:))' T1pos{rnNB(3)}(trial_idx(run_i,:))'];
    
    % ** ITI and ISI
    temp_iti = repmat({[4 4], [3 5], [5 3]},1,6); % ISI    
    rnNB = randperm(18);
    ITI{run_i} = temp_iti(rnNB);
end

%% save ts
ts = [];
ts.table = T1; 
ts.target = target_all;
ts.WID = WID_ALL; % word ID 
ts.time_generated = datestr(clock, 0);
ts.ITI = ITI;
ts.descrip = {'4RUNS, 18TRIALS'};

disp('Trial sequences is generated');