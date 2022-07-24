function ts = generate_ts_SEP(cond)

% ts = generate_ts_SEP

% total run = 6;
% total trial = 16;
rng('shuffle');

S1 = []; 
I1 = [];
R1 = []; 

if contains(lower(cond),'fmri')
    
    
    % 1. Generating ts for the Stimulus intensity % 16 trials
    for ii = 1:6
        temp_int = []; 
        for i = 1:4
            %S1{1} = repmat({'LV1'; 'LV2'; 'LV3'; 'LV4'}, 4, 1);
            inte = [1,2,3,4];
            rnNB = randperm(4);
            temp_int = [temp_int rnNB(inte)];
        end        
        S1{ii} = temp_int;
    end
    
    % 2. Generating ts for the ITI and ISI % 16 trials
    %temp_iti = [] ;    
    temp_iti = repmat({{4,4,4}, {3,4,5}},1,8); % ISI 
    for i = 1:6 
        rnNB = randperm(16); 
        I1{i} = temp_iti(rnNB);    
    end
    
    % 3. Generating ts for the ITI and ISI % 16 trials
    %R1{1} = repmat({'INTE','UNPLEA'},2,1); %rating % intensity','unpleasantness
    temp_ratin = repmat({{'Intensity','Unpleasantness'}, {'Unpleasantness','Intensity'}},1,8); % ISI 
    for i = 1:6
        rnNB = randperm(16);
        
        ttemp_ratin = [];        
        ttemp_ratin=temp_ratin(rnNB);
        R1{i} = ttemp_ratin;
    end
    
    
    condname = 'fMRI';
elseif contains(cond,'obser')
    
    % conditions
    I1{2} = repmat({4,4,4}, {3,4,5},2,1);
    % Per trial
    R1{1} = repmat({'intensity','unpleasantness'},2,1);
    
    
    condname = 'observers';
else
    error('Please check the condition name')
end

%% shuffle
temp_int = [];
ts = [];
ts.cond_type = condname;
ts.time_generated = datestr(clock, 0);
ts.descrip = {'This is for both ''fMRI task'' and ''estimating task','Because these two tasks should have same sequences of ISI and rating questions'};
ts.orig.S1 = S1;
ts.orig.R1 = R1;
ts.orig.I1 = I1;
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