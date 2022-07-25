function ts = generate_ts_EXCOOL()

% ts = generate_ts_SEP

% total run = 6;
% total trial = 12;
rng('shuffle');

S1 = [];
I1 = [];
R1 = [];
targeto = [];
words_val = [];
rng('shuffle');
%% EXPERIMENTAL PARAMETER
% ** Word itself
T=readtable('data/wordlists/kor_personal.xlsx');
T2 = vertcat(addvars(T,repmat({'나'},24,1), 'NewVariableNames','Target'), ...
    addvars(T,repmat({'조세호'},24,1), 'NewVariableNames','Target'),...
    addvars(T,repmat({'친구'},24,1),'NewVariableNames','Target'));
% randomization
for run_i = 1:6
    % ** Target
    % 1: self
    % 2: friend
    % 3: celebrities
    tar_cond = [1 2 3];
    temp_tar = [];
    
    for tar_i = 1:4
        rnNB = randperm(3);
        temp_tar{tar_i}= tar_cond(rnNB);
    end
    targeto{run_i} = cell2mat(temp_tar);
    
    % ** Valence (word)
    % -1: Negative
    % +1: Positive
    temp_val = [];
    tar_val = [-1 +1];
    for tar_i = 1:6
        rnNB = randperm(2);
        temp_val{tar_i}= tar_val(rnNB);
    end
    words_val{run_i} = cell2mat(temp_val);
    
    
    T.WID(T.positive == words_val{run_i})
    
    
    % ** ITI and ISI
    temp_iti = repmat({[4 4], [3 5], [5 3]},1,4); % ISI    
    rnNB = randperm(12);
    I1{run_i} = temp_iti(rnNB);
    
end


%% ISI ITI
temp_int = [];
ts = [];
ts.cond_type = condname;
ts.time_generated = datestr(clock, 0);
ts.target = targeto;
ts.words_val = words_val;

for run_i = 1:6
    
    % for each trial
    for trial_i = 1:16
        ts.t{run_i}{trial_i}.stimlv = S1{run_i}(trial_i);
        
        ts.t{run_i}{trial_i}.ITI = I1{run_i}{trial_i}{1};
        ts.t{run_i}{trial_i}.ISI1 = I1{run_i}{trial_i}{2};
        ts.t{run_i}{trial_i}.ISI2 = I1{run_i}{trial_i}{3};
        
        
        ts.t{run_i}{trial_i}.rating1 = R1{run_i}{trial_i}{1};
        ts.t{run_i}{trial_i}.rating2 = R1{run_i}{trial_i}{2};
        
        
    end
end

disp('Trial sequences is generated');