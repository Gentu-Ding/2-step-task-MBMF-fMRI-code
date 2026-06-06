%% regression for sub-groups
clear all;
close all;

clearvars -except mdl mdl_MB mdl_hmm mdl_rac

allData_all = readtable(['reg_control_sf_all_10_trials_updated.csv']); 

% or 
allData_all = readtable(['reg_rac_mbGroup.csv']);

all_names = allData_all.subIndex;

cluster_ID_table = readtable('../R01_control_clusterID_wMF_formal_updated.csv');

clusterID = cluster_ID_table.clusterID;

Mixture_group = cluster_ID_table.ID (clusterID==1);
MF_group = cluster_ID_table.ID (clusterID==2);
MB_group = cluster_ID_table.ID (clusterID==3);
Other_group = cluster_ID_table.ID (clusterID==4);

All_group = cluster_ID_table.ID;

Sub_list = readtable('../ID_list.csv');

for i =1: size(Sub_list,1)
   include_subs(i,1) = str2double(Sub_list.name{i}(4:7)) ;
end

group_of_interest = MB_group;

idx_cluster = ismember(all_names,include_subs) & ismember(all_names,group_of_interest);

allData = allData_all(idx_cluster,:);

isStay = allData.isStay;
isPrevRare = allData.isPrevRare;
isPrevWin = allData.isPrevWin;

RT = allData.RT;
subID = allData.subID;
subIndex = allData.subIndex;


isMB_cont= allData.condContingent;

isMB_spe= allData.condState;
isMB_rpe= allData.condReward;



isLeft = allData.isLeft;
isLeft_t1 = allData.isLeft_t1;
isLeft_t2 = allData.isLeft_t2;
isLeft_t3 = allData.isLeft_t3;
isLeft_t4 = allData.isLeft_t4;
isLeft_t5 = allData.isLeft_t5;
isLeft_t6 = allData.isLeft_t6;
isLeft_t7 = allData.isLeft_t7;
isLeft_t8 = allData.isLeft_t8;
isLeft_t9 = allData.isLeft_t9;
isLeft_t10 = allData.isLeft_t10;

isStay_t1 = allData.isStay_t1;
isStay_t2 = allData.isStay_t2;
isStay_t3 = allData.isStay_t3;
isStay_t4 = allData.isStay_t4;
isStay_t5 = allData.isStay_t5;
isStay_t6 = allData.isStay_t6;
isStay_t7 = allData.isStay_t7;
isStay_t8 = allData.isStay_t8;
isStay_t9 = allData.isStay_t9;
isStay_t10 = allData.isStay_t10;

isRare_t1 = allData.isRare_t1;
isRare_t2 = allData.isRare_t2;
isRare_t3 = allData.isRare_t3;
isRare_t4 = allData.isRare_t4;
isRare_t5 = allData.isRare_t5;
isRare_t6 = allData.isRare_t6;
isRare_t7 = allData.isRare_t7;
isRare_t8 = allData.isRare_t8;
isRare_t9 = allData.isRare_t9;
isRare_t10 = allData.isRare_t10;

isWin_t1 = allData.isWin_t1;
isWin_t2 = allData.isWin_t2;
isWin_t3 = allData.isWin_t3;
isWin_t4 = allData.isWin_t4;
isWin_t5 = allData.isWin_t5;
isWin_t6 = allData.isWin_t6;
isWin_t7 = allData.isWin_t7;
isWin_t8 = allData.isWin_t8;
isWin_t9 = allData.isWin_t9;
isWin_t10 = allData.isWin_t10;

CR1=isRare_t1==0 & isWin_t1==1;
CR2=isRare_t2==0 & isWin_t2==1;
CR3=isRare_t3==0 & isWin_t3==1;
CR4=isRare_t4==0 & isWin_t4==1;
CR5=isRare_t5==0 & isWin_t5==1;
CR6=isRare_t6==0 & isWin_t6==1;
CR7=isRare_t7==0 & isWin_t7==1;
CR8=isRare_t8==0 & isWin_t8==1;
CR9=isRare_t9==0 & isWin_t9==1;
CR10=isRare_t10==0 & isWin_t10==1;

CN1=isRare_t1==0 & isWin_t1==0;
CN2=isRare_t2==0 & isWin_t2==0;
CN3=isRare_t3==0 & isWin_t3==0;
CN4=isRare_t4==0 & isWin_t4==0;
CN5=isRare_t5==0 & isWin_t5==0;
CN6=isRare_t6==0 & isWin_t6==0;
CN7=isRare_t7==0 & isWin_t7==0;
CN8=isRare_t8==0 & isWin_t8==0;
CN9=isRare_t9==0 & isWin_t9==0;
CN10=isRare_t10==0 & isWin_t10==0;

RR1=isRare_t1==1 & isWin_t1==1;
RR2=isRare_t2==1 & isWin_t2==1;
RR3=isRare_t3==1 & isWin_t3==1;
RR4=isRare_t4==1 & isWin_t4==1;
RR5=isRare_t5==1 & isWin_t5==1;
RR6=isRare_t6==1 & isWin_t6==1;
RR7=isRare_t7==1 & isWin_t7==1;
RR8=isRare_t8==1 & isWin_t8==1;
RR9=isRare_t9==1 & isWin_t9==1;
RR10=isRare_t10==1 & isWin_t10==1;

RN1=isRare_t1==1 & isWin_t1==0;
RN2=isRare_t2==1 & isWin_t2==0;
RN3=isRare_t3==1 & isWin_t3==0;
RN4=isRare_t4==1 & isWin_t4==0;
RN5=isRare_t5==1 & isWin_t5==0;
RN6=isRare_t6==1 & isWin_t6==0;
RN7=isRare_t7==1 & isWin_t7==0;
RN8=isRare_t8==1 & isWin_t8==0;
RN9=isRare_t9==1 & isWin_t9==0;
RN10=isRare_t10==1 & isWin_t10==0;


%regTable = table(isStay_t1,isStay_t2,isStay_t3,isStay_t4,isStay_t5,isStay_t6,isStay_t7,isStay_t8,isStay_t9,isStay_t10,CR1,CR2,CR3,CR4,CR5,CR6,CR7,CR8,CR9,CR10,...
%     CN1,CN2,CN3,CN4,CN5,CN6,CN7,CN8,CN9,CN10,RR1,RR2,RR3,RR4,RR5,RR6,RR7,RR8,RR9,RR10,RN1,RN2,RN3,RN4,RN5,RN6,RN7,RN8,RN9,RN10,RT,subIndex);

 
regTable = table(isLeft, isLeft_t1, isLeft_t2, isLeft_t3, isLeft_t4, isLeft_t5,isLeft_t6, isLeft_t7, isLeft_t8, isLeft_t9, isLeft_t10,...
     isRare_t1, isRare_t2, isRare_t3, isRare_t4, isRare_t5,isRare_t6, isRare_t7, isRare_t8, isRare_t9, isRare_t10,...
     isWin_t1, isWin_t2, isWin_t3, isWin_t4, isWin_t5,isWin_t6, isWin_t7, isWin_t8, isWin_t9, isWin_t10, RT,subID);

 
%regTable = table(isStay, isPrevRare, isPrevWin, isMB_cont, isMB_spe, isMB_rpe, RT, subID, subIndex);

%selectTable = table(regTable.isPrevWin);

% remove any nan-values
%regTable( any(ismissing(selectTable),2), :) = [];


filter = regTable.RT~=0 & regTable.RT<=2;

%filter2 = regTable.RT<=2;

regTable = regTable(filter,:);

%aregTable = regTable(regTable.sub_label==1,:);

% Choice regression 

aregTable = regTable; %(regTable.groupID==1,:); %(regTable.isMB_cont==1,:);

aregTable.isLeft (aregTable.isLeft==0) = 0;

aregTable.isLeft_t1 (aregTable.isLeft_t1==0) = -1;
aregTable.isLeft_t2 (aregTable.isLeft_t2==0) = -1;
aregTable.isLeft_t3 (aregTable.isLeft_t3==0) = -1;
aregTable.isLeft_t4 (aregTable.isLeft_t4==0) = -1;
aregTable.isLeft_t5 (aregTable.isLeft_t5==0) = -1;
aregTable.isLeft_t6 (aregTable.isLeft_t6==0) = -1;
aregTable.isLeft_t7 (aregTable.isLeft_t7==0) = -1;
aregTable.isLeft_t8 (aregTable.isLeft_t8==0) = -1;
aregTable.isLeft_t9 (aregTable.isLeft_t9==0) = -1;
aregTable.isLeft_t10 (aregTable.isLeft_t10==0) = -1;

aregTable.isWin_t1 (aregTable.isWin_t1==0) = -1;
aregTable.isWin_t2 (aregTable.isWin_t2==0) = -1;
aregTable.isWin_t3 (aregTable.isWin_t3==0) = -1;
aregTable.isWin_t4 (aregTable.isWin_t4==0) = -1;
aregTable.isWin_t5 (aregTable.isWin_t5==0) = -1;
aregTable.isWin_t6 (aregTable.isWin_t6==0) = -1;
aregTable.isWin_t7 (aregTable.isWin_t7==0) = -1;
aregTable.isWin_t8 (aregTable.isWin_t8==0) = -1;
aregTable.isWin_t9 (aregTable.isWin_t9==0) = -1;
aregTable.isWin_t10 (aregTable.isWin_t10==0) = -1;

aregTable.isRare_t1 (aregTable.isRare_t1==0) = -1;
aregTable.isRare_t2 (aregTable.isRare_t2==0) = -1;
aregTable.isRare_t3 (aregTable.isRare_t3==0) = -1;
aregTable.isRare_t4 (aregTable.isRare_t4==0) = -1;
aregTable.isRare_t5 (aregTable.isRare_t5==0) = -1;
aregTable.isRare_t6 (aregTable.isRare_t6==0) = -1;
aregTable.isRare_t7 (aregTable.isRare_t7==0) = -1;
aregTable.isRare_t8 (aregTable.isRare_t8==0) = -1;
aregTable.isRare_t9 (aregTable.isRare_t9==0) = -1;
aregTable.isRare_t10 (aregTable.isRare_t10==0) = -1;


mdl     = fitglme(aregTable, 'isLeft ~ isLeft_t1*isRare_t1*isWin_t1 + isLeft_t2*isRare_t2*isWin_t2 + isLeft_t3*isRare_t3*isWin_t3 + isLeft_t4*isRare_t4*isWin_t4 + isLeft_t5*isRare_t5*isWin_t5 +isLeft_t6*isRare_t6*isWin_t6 +isLeft_t7*isRare_t7*isWin_t7 +isLeft_t8*isRare_t8*isWin_t8 + isLeft_t9*isRare_t9*isWin_t9 + isLeft_t10*isRare_t10*isWin_t10+(1|subID)','Distribution', 'binomial');

mdl_MB  = fitglme(aregTable, 'isLeft ~ isLeft_t1*isRare_t1*isWin_t1 + isLeft_t2*isRare_t2*isWin_t2 + isLeft_t3*isRare_t3*isWin_t3 + isLeft_t4*isRare_t4*isWin_t4 + isLeft_t5*isRare_t5*isWin_t5 +isLeft_t6*isRare_t6*isWin_t6 +isLeft_t7*isRare_t7*isWin_t7 +isLeft_t8*isRare_t8*isWin_t8 + isLeft_t9*isRare_t9*isWin_t9 + isLeft_t10*isRare_t10*isWin_t10+(1|subID)','Distribution', 'binomial');

mdl_rac = fitglme(aregTable, 'isLeft ~ isLeft_t1*isRare_t1*isWin_t1 + isLeft_t2*isRare_t2*isWin_t2 + isLeft_t3*isRare_t3*isWin_t3 + isLeft_t4*isRare_t4*isWin_t4 + isLeft_t5*isRare_t5*isWin_t5 +isLeft_t6*isRare_t6*isWin_t6 +isLeft_t7*isRare_t7*isWin_t7 +isLeft_t8*isRare_t8*isWin_t8 + isLeft_t9*isRare_t9*isWin_t9 + isLeft_t10*isRare_t10*isWin_t10+(1|subID)','Distribution', 'binomial');


mdl_hmm = fitglme(aregTable, 'isLeft ~ isLeft_t1*isRare_t1*isWin_t1 + isLeft_t2*isRare_t2*isWin_t2 + isLeft_t3*isRare_t3*isWin_t3 + isLeft_t4*isRare_t4*isWin_t4 + isLeft_t5*isRare_t5*isWin_t5 +isLeft_t6*isRare_t6*isWin_t6 +isLeft_t7*isRare_t7*isWin_t7 +isLeft_t8*isRare_t8*isWin_t8 + isLeft_t9*isRare_t9*isWin_t9 + isLeft_t10*isRare_t10*isWin_t10+(1|subID)','Distribution', 'binomial');






clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl);

data_left_rewBinRare_1_10 = beta(62:71);

std_data_left_rewBinRare_1_10 = stats_fix.SE(62:71);


clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_MB);

MB_left_rewBinRare_1_10 = beta(62:71);

std_MB_left_rewBinRare_1_10 = stats_fix.SE(62:71);

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_rac);

rac_left_rewBinRare_1_10 = beta(62:71);

std_rac_left_rewBinRare_1_10 = stats_fix.SE(62:71);

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_hmm);

hmm_left_rewBinRare_1_10 = beta(62:71);

std_hmm_left_rewBinRare_1_10 = stats_fix.SE(62:71);


close all
figure(1)

x=-10:-1;

y=flip(data_left_rewBinRare_1_10);

%plot(x,y,'--or')
errorbar(x, y, std_data_left_rewBinRare_1_10,'-k','LineWidth', 2); 

hold on

y=flip(MB_left_rewBinRare_1_10);

%plot(x,y,'--or')
errorbar(x, y, std_MB_left_rewBinRare_1_10,'--b','LineWidth', 2); 

hold on 

y=flip(rac_left_rewBinRare_1_10);

errorbar(x, y, std_rac_left_rewBinRare_1_10,'--r','LineWidth', 2); 

hold on 

y=flip(hmm_left_rewBinRare_1_10);

errorbar(x, y, std_hmm_left_rewBinRare_1_10,'--g','LineWidth', 2);

hold on
yline(0);
ylabel('Beta Coefficients')
xticks([-10:-1])
%xticklabels({'RareReward t-1','RareReward t-2','RareReward t-3','RareReward t-4','RareReward t-5'})
xlabel('Lag (Trials)')
title('Outcome x Transition Effects')

legend({'Data: MB Group';'Simulation: MB agent';'Simulation: Reward-as-cue agent';'Simulation: Latent-state agent'})
set(gca,'FontSize',20)







