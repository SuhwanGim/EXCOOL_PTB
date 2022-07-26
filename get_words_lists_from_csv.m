%% Get lists
% ciataion (Chavez et el., 2020; JPSP)
T = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/runA.csv',"Delimiter",',');
T2 = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/runB.csv',"Delimiter",',');
T3 = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/runC.csv',"Delimiter",',');
T4 = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/runD.csv',"Delimiter",',');
T5 = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/runE.csv',"Delimiter",',');
T6 = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/runF.csv',"Delimiter",',');
%%
S1 = readtable('/Users/suhwan/Dropbox/Projects/EXCOOL/resources/data/wordlists/ORIGINAL/list2_trials.xlsx');
%%
unlists = unique([T2.word T.word T3.word T4.word T5.word T6.word]);
unlists(1) = [];
%%
all=vertcat(T,T2,T3,T4,T5,T6);
new_valence = []; 
for w_i = 1:length(unlists)
    new_valence{w_i} = unique(all.valence(find(contains(all.word,unlists{w_i}))));       
end
% rearrange 
new_valence = cat(2,cellfun(@(x) x{1}, new_valence, 'UniformOutput', false)');
%%
TT=table(unlists, new_valence,'VariableNames',{'words','Valence'});
writetable(TT,fullfile('data','wordlists','ENG_TRAIT_LISTS.csv'),'Delimiter',',');