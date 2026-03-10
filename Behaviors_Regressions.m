%% Overall regression estimates on choices (N=179) 

clear all;
close all;

allData_all = readtable(['reg_control_sf_all_10_trials_updated.csv']);
all_names = allData_all.subIndex;


Sub_list = readtable('ID_list.csv');

for i =1: size(Sub_list,1)
   include_subs(i,1) = str2double(Sub_list.name{i}(4:7)) ;
end

% 
idx = ismember(all_names,include_subs);
allData = allData_all(idx,:);

isStay = allData.isStay;
isPrevRare = allData.isPrevRare;
isPrevWin = allData.isPrevWin;

RT = allData.RT;
subID = allData.subID;
subIndex = allData.subIndex;


isMB_cont= allData.condContingent;

isMB_spe= allData.condState;
isMB_rpe= allData.condReward;


regTable = table(isStay, isPrevRare, isPrevWin, isMB_cont, isMB_spe, isMB_rpe, RT, subID, subIndex);

selectTable = table(regTable.isPrevWin);

% remove any nan-values
regTable( any(ismissing(selectTable),2), :) = [];


filter = regTable.RT~=0 & regTable.RT<=2;

%filter2 = regTable.RT<=2;

regTable = regTable(filter,:);

%aregTable = regTable(regTable.sub_label==1,:);

% Choice regression 

aregTable = regTable; %(regTable.groupID==1,:); %(regTable.isMB_cont==1,:);


aregTable.isMB_cont(aregTable.isMB_cont==0) = -1;
aregTable.isMB_spe(aregTable.isMB_spe==0) = -1;
aregTable.isMB_rpe(aregTable.isMB_rpe==0) = -1;

aregTable.isStay(aregTable.isStay==0) = 0;
%aregTable.isSwitch = -aregTable.isStay;
aregTable.isPrevRare(aregTable.isPrevRare==0) = -1;
aregTable.isPrevWin(aregTable.isPrevWin==0) = -1;


mdl = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare+ (1+isPrevWin*isPrevRare|subIndex)', 'Distribution', 'binomial');

mdl % show regression estimates
 
[beta,betanames,stats_fix] = fixedEffects(mdl);

[B,Bnames,stats_random] = randomEffects(mdl);



%% Statistical tests of outcome/outcome-transition effects across sub-groups
clear all
close all

cluster_feature_table=readtable('R01_control_cluster_features_3Arb_logRT_updated.csv');
subID= cluster_feature_table.subID;
groupID = cluster_feature_table.groupID;
outcome =cluster_feature_table.outcome_CHOICE;
outcome_transition = cluster_feature_table.outcome_transition_CHOICE;

% outcome effect
clear id_cluster
for i = 1:size(groupID,1)
    
    label = groupID{i};
    
    if contains(label,'Mixture') 
        id_cluster(i,1) = 2;
    elseif contains(label,'MF') 
        id_cluster(i,1) = 3;
    elseif contains(label,'MB') 
        id_cluster(i,1) = 1;
    elseif contains(label,'Other') 
        id_cluster(i,1) = 0;
    end
    
end

includeID_table = readtable('ID_list.csv');

for i = 1:size(includeID_table,1)
    
   include_IDs(i,1) = str2double(includeID_table.name{i}(4:7)); 
    
end

include_index = ismember(subID,include_IDs);

filter = include_index & id_cluster~=0;

mdl = fitglm(outcome(filter),id_cluster(filter));

filter1 =  include_index & id_cluster==0;   % Other
filter2 =  include_index & id_cluster==1;   % MB 
filter3 =  include_index & id_cluster==2;   % Mixture
filter4 =  include_index & id_cluster==3;   % MF

mean(outcome(filter1))
mean(outcome(filter2))
mean(outcome(filter3))
mean(outcome(filter4))

[h,p]=ttest2(outcome(filter1),outcome(filter2)) % two-sample t-tests

% outcome-transition effect
clear id_cluster
for i = 1:size(groupID,1)
    
    label = groupID{i};
    
    if contains(label,'Mixture') 
        id_cluster(i,1) = 2;
    elseif contains(label,'MF') 
        id_cluster(i,1) = 1;
    elseif contains(label,'MB') 
        id_cluster(i,1) = 3;
    elseif contains(label,'Other') 
        id_cluster(i,1) = 0;
    end
    
end

includeID_table = readtable('ID_list.csv');

for i = 1:size(includeID_table,1)
    
   include_IDs(i,1) = str2double(includeID_table.name{i}(4:7)); 
    
end

include_index = ismember(subID,include_IDs);

filter = include_index & id_cluster~=0;

mdl = fitglm(outcome_transition(filter),id_cluster(filter));


filter1 =  include_index & id_cluster==0; % Other
filter2 =  include_index & id_cluster==1; % MF
filter3 =  include_index & id_cluster==2; % Mixture
filter4 =  include_index & id_cluster==3; % MB

mean(outcome_transition(filter1))
mean(outcome_transition(filter2))
mean(outcome_transition(filter3))
mean(outcome_transition(filter4))

[h,p]=ttest2(outcome_transition(filter1),outcome_transition(filter4)) % two-sample t-tests

