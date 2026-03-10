%% 

clear;
close all;

allData = readtable(['reg_control_sf_all_5_trials_updated.csv']); 
all_names = allData.subIndex;


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
%regTable = table(isStay, isPrevRare, isPrevWin, isMB_spe,
%isMB_rpe,isMB_cont, PrevRewMag,subID);

% remove any nan-values
regTable( any(ismissing(selectTable),2), :) = [];

% Choice regression 
filter = regTable.RT~=0 & regTable.RT<=2; % filtering out missing-response trials



regTable = regTable(filter,:);

aregTable = regTable; %(regTable.groupID==1,:); %(regTable.isMB_cont==1,:);


aregTable.isMB_cont(aregTable.isMB_cont==0) = -1;
aregTable.isMB_spe(aregTable.isMB_spe==0) = -1;
aregTable.isMB_rpe(aregTable.isMB_rpe==0) = -1;

aregTable.isStay(aregTable.isStay==0) = 0;
%aregTable.isSwitch = -aregTable.isStay;
aregTable.isPrevRare(aregTable.isPrevRare==0) = -1;
aregTable.isPrevWin(aregTable.isPrevWin==0) = -1;


mdl = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare*(isMB_spe + isMB_rpe + isMB_cont)+ (1+isPrevWin*isPrevRare*(isMB_spe + isMB_rpe + isMB_cont)|subIndex)', 'Distribution', 'binomial');
 

[beta,betanames,stats_fix] = fixedEffects(mdl);


[B,Bnames,stats_random] = randomEffects(mdl);

unique_IDs = unique(Bnames.Level);

sorted_unique_IDs=sort(str2double(unique_IDs));

NumReg =16;

for sI=1:size(sorted_unique_IDs,1)


    w_choice.subID{sI,1} = sorted_unique_IDs(sI);
    
  
    w_choice.intercept_CHOICE(sI,1) = B(NumReg*sI-15,1) + beta(1);
    w_choice.transition_CHOICE(sI,1) = B(NumReg*sI-14,1) + beta(2);
    w_choice.outcome_CHOICE(sI,1) = B(NumReg*sI-13,1)+beta(3);
    w_choice.outcome_transition_CHOICE(sI,1) = B(NumReg*sI-9,1)+beta(7);
    

end

w_df_choice = struct2table(w_choice);

table1_regChoice = w_df_choice(:,1:end); % choice related regression features


% RT regression 

aregTable = regTable; %(regTable.groupID==1,:); %(regTable.isMB_cont==1,:);


aregTable.isMB_cont(aregTable.isMB_cont==0) = -1;
aregTable.isMB_spe(aregTable.isMB_spe==0) = -1;
aregTable.isMB_rpe(aregTable.isMB_rpe==0) = -1;

aregTable.isStay(aregTable.isStay==0) = -1;
%aregTable.isSwitch = -aregTable.isStay;
aregTable.isPrevRare(aregTable.isPrevRare==0) = -1;
aregTable.isPrevWin(aregTable.isPrevWin==0) = -1;


aregTable.RT = log(aregTable.RT);

mdl = fitglme(aregTable, 'RT ~ isPrevWin*isPrevRare*isStay + (1+isPrevWin*isPrevRare*isStay |subIndex)', 'Distribution', 'Normal');


[beta,betanames,stats_fix] = fixedEffects(mdl);


[B,Bnames,stats_random] = randomEffects(mdl);
   
unique_IDs = unique(Bnames.Level);
sorted_unique_IDs=sort(str2double(unique_IDs));

NumReg =8;

for sI=1:size(sorted_unique_IDs,1)

    w_RT.subID{sI,1} = sorted_unique_IDs(sI);
    
    w_RT.intercept_RT(sI,1) = B(NumReg*sI-7,1) + beta(1);
    w_RT.stay_RT(sI,1) = B(NumReg*sI-6)+beta(2);
    w_RT.transition_RT(sI,1) = B(NumReg*sI-5,1) + beta(3);
    w_RT.outcome_RT(sI,1) = B(NumReg*sI-4,1)+beta(4);
    w_RT.stay_transition_RT(sI,1) = B(NumReg*sI-3,1)+beta(5);
    w_RT.stay_outcome_RT(sI,1) = B(NumReg*sI-2,1)+beta(6);
    w_RT.outcome_transition_RT(sI,1) = B(NumReg*sI-1,1)+beta(7);
    w_RT.stay_outcome_transition_RT(sI,1) = B(NumReg*sI,1)+beta(8);

end

w_df_RT = struct2table(w_RT); 

table2_regRT = w_df_RT(:,2:end); % RT related regression features


%% summary statistics of behavioral features

tic;
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));


allFiles=dir('Control_csv_sf/sub*.csv');

id=0;

for sI=1:size(allFiles,1)
    
     
    name = allFiles(sI).name;
    
    
    allData = readtable(['Control_csv_sf/' name]);
   
    id=id+1;
        
    subData = allData;
    
    w.subID{id,1}=name(4:7);
    
 
    isStay = [nan [subData.Resp1(1:end-1) == subData.Resp1(2:end)]']';
    isPrevRare = [nan subData.doRareTrans(1:end-1)']';
    isPrevWin = [nan subData.outcomeBin(1:end-1)']';
    

    for j = 1:size(subData,1)
        if isnan(subData.Resp1(j,1))
            isStay(j,1)=NaN;
            if j~= size(subData,1)
                isStay(j+1,1)=NaN;
            end
        end
    end
    
    isStay(subData.trialID==1)=NaN;
%
    
    pStay_CW = nanmean(isStay(isPrevRare == 0 & isPrevWin == 1));
    pStay_RW = nanmean(isStay(isPrevRare == 1 & isPrevWin == 1));
    pStay_CL = nanmean(isStay(isPrevRare == 0 & isPrevWin == 0));
    pStay_RL = nanmean(isStay(isPrevRare == 1 & isPrevWin == 0));
    
       
    w.p_rarewin(id,1) = pStay_RW;
    w.p_rareloss(id,1) = pStay_RL;
    w.p_commonwin(id,1) = pStay_CW;
    w.p_commonloss(id,1) = pStay_CL;
    
   
    w.transScore(id,1) =(pStay_CW - pStay_RW) - (pStay_CL - pStay_RL);
    w.rewScore(id,1) = (pStay_CW + pStay_RW) - (pStay_CL + pStay_RL);
    w.ScoreAbs(id,1) = abs(pStay_CW-pStay_CL) + abs(pStay_RW-pStay_RL);
    

end

w_df_behav_stats = struct2table(w);

table3_behav_stats = w_df_behav_stats(:,2:end); % features related to the summary statistics of the behaviors

% Combine all three parts of the cluster-feature tables

combined_table = horzcat(table1_regChoice,table2_regRT,table3_behav_stats);

writetable(combined_table,'R01_control_cluster_features_3Arb_logRT_without_groupID_updated.csv')


