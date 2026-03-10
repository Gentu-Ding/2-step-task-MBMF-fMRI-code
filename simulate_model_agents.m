clear all
close all
tic;
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));

%task_MBMF_sim = initTask();

%allFiles1=dir('/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/sub*.csv');

allFiles1 = readtable('ID_list.csv');

Sub_list = readtable('R01_control_clusterID_wMF_formal_updated.csv');

group_subs = Sub_list.ID; %(Sub_list.clusterID==3); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other


id=0;
% Simulate data from scratch
for sI=1:size(allFiles1,1)
    
    
    name = allFiles1.name{sI};
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
    if TF1==1
        
        
        
        
        id=id+1;
        % point to the director with data we want to fit
        %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
        allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/' name_sf '.csv']);
        
        
        %sI=1;
        subData = allData;
        
   
        
        %nameMat = ['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_MF/lap_' name_sf '.mat' ];
        nameMat = 'params_mb.mat';
        load(nameMat)
        
        %lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE
        
        params = mean(params_mb);
        %params = cbm.output.parameters;
        
        %params_arb(id,:) = params;
        %params = mean_params;
        
        
        [negLLE, fitData] = generateData_magMF_binMB_MB_rewMag_WSLS(params, subData);
        
        
        subData.Resp1 = fitData.resp1;
        subData.outcome1 = fitData.outcome1;
        subData.outcome2 = fitData.outcome2;
        subData.outcomeBin = fitData.outcomeBin;
        subData.outcomeMag = fitData.outcomeMag;
        
  
        
        % isStay = nan(size(subData,1),1);
        leftOption = subData.rewPWin_1;
        rightOption = subData.rewPWin_3;
        leftRew = leftOption > rightOption & leftOption >0.5;
        rightRew = rightOption > leftOption & rightOption > 0.5;
        
        corrChoice = zeros(300,1);
        corrChoice(leftRew) = subData.Resp1(leftRew) ==1;
        corrChoice (rightRew)  = subData.Resp1(rightRew) ==2;
        
        corrTrials = leftRew | rightRew ;
        correct = corrChoice(corrTrials);
        
        
        Accuracy (sI,1) = sum(correct)/size(correct,1);
        Name{sI,1} = name;
        

        
        acc(sI,1) = nansum(subData.outcomeBin)/length(subData.outcomeBin(~isnan(subData.outcomeBin)));
        
        %RT(sI,1) = mean(subData.RT1(~isnan(subData.outcomeBin)));
        
        %rng(25);
        for tI = 1:size(subData,1)
            random_choice(tI,1) = randi([1,2]);
            if random_choice(tI,1)==1
                if subData.condContingent(tI)==1
                    random_outcome(tI,1) = subData.rewBinary_1(tI);
                else
                    if subData.state2_1(tI)==1
                        random_outcome(tI,1) = subData.rewBinary_1(tI);
                    elseif subData.state2_1(tI)==2
                        random_outcome(tI,1) = subData.rewBinary_2(tI);
                    elseif subData.state2_1(tI)==3
                        random_outcome(tI,1) = subData.rewBinary_3(tI);
                    else
                        
                        random_outcome(tI,1) = subData.rewBinary_4(tI);
                    end
                end
            else
                if subData.condContingent(tI)==1
                    random_outcome(tI,1) = subData.rewBinary_3(tI);
                else
                    if subData.state2_2(tI)==1
                        random_outcome(tI,1) = subData.rewBinary_1(tI);
                    elseif subData.state2_2(tI)==2
                        random_outcome(tI,1) = subData.rewBinary_2(tI);
                    elseif subData.state2_2(tI)==3
                        random_outcome(tI,1) = subData.rewBinary_3(tI);
                    else
                        
                        random_outcome(tI,1) = subData.rewBinary_4(tI);
                    end
                end
            end
            
            
            
        end
        
        acc_random(sI,1) = sum(random_outcome(~isnan(subData.outcomeBin)))/length(random_outcome(~isnan(subData.outcomeBin)));
        
        IDs_acc(sI,1) = ID;
        

        
        sub_name{id,1}=name;
        
    end
    
    
    
end


[h,p,ci,stats]=ttest2(acc,acc_random)

close all
figure(1)

h1 = histogram(acc, 'BinWidth',0.01);
%h.NumBins = 7;
xlim([0.3 0.6])
%ylim([0 8])
h1.FaceColor = [0 0.5 0.7];
h1.EdgeColor = 'b';

hold on
h2 = histogram(acc_random, 'BinWidth',0.01);
%h.NumBins = 12;
%ylim([0 30])
hold on
xlabel('Proportion of Rewarded Trials')
ylabel('Number of Agents')
title('Simulation: Performance of MB agents')
legend({'MB agents';"Random agents"})
set(gca,'FontSize',18);





%% Overall regression estimates on generated data

clear all;
close all;



clearvars -except mdl_mb mdl_mf mdl_fw mdl_arb mdl_random

allData_all = readtable(['reg_mf_all.csv']); % reg_fw_all.csv; reg_mb_all.csv; reg_random_all.csv
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

mdl_arb = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare+ (1+isPrevWin*isPrevRare|subIndex)', 'Distribution', 'binomial');

mdl_mf = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare+ (1+isPrevWin*isPrevRare|subIndex)', 'Distribution', 'binomial');

mdl_fw = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare+ (1+isPrevWin*isPrevRare|subIndex)', 'Distribution', 'binomial');

mdl_mb = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare+ (1+isPrevWin*isPrevRare|subIndex)', 'Distribution', 'binomial');

mdl_random = fitglme(aregTable, 'isStay ~ isPrevWin*isPrevRare+ (1+isPrevWin*isPrevRare|subIndex)', 'Distribution', 'binomial');

mdl_mb % show regression estimates
 

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_mb);
mb_o_ot = beta(3:4);
std_mb_o_ot = stats_fix.SE(3:4);

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_mf);
mf_o_ot = beta(3:4);
std_mf_o_ot = stats_fix.SE(3:4);

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_fw);
fw_o_ot = beta(3:4);
std_fw_o_ot = stats_fix.SE(3:4);

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_arb);
arb_o_ot = beta(3:4);
std_arb_o_ot = stats_fix.SE(3:4);

clear beta betanames stats_fix
[beta,betanames,stats_fix] = fixedEffects(mdl_random);
random_o_ot = beta(3:4);
std_random_o_ot = stats_fix.SE(3:4);



close all
figure(1)

x=1:2;


y=fw_o_ot;

errorbar(x, y, std_fw_o_ot,'--g','LineWidth', 4); 

hold on

y=mb_o_ot;

errorbar(x, y, std_mb_o_ot,'--b','LineWidth', 4); 

hold on 

y=mf_o_ot;

errorbar(x, y, std_mf_o_ot,'--r','LineWidth', 4); 

hold on
y=random_o_ot;

errorbar(x, y, std_random_o_ot,'--','Color', [0.7 0.7 0.7],'LineWidth', 4); 
hold on

yline(0);
ylabel('Beta Coefficients')
xlim([0.5 2.5])
ylim([-1.5 1.5])
xticks([1:2])
xticklabels({'Outcome','Outcome x Transition'})
%xlabel('Lag (Trials)')
title('Simluation: Regression Effects')
legend({'Mixture agent';'MB agent';'MF agent';'Random agent'})
%legend({'Data: MB Group';'Simulation: MB agent';'Simulation: Reward-as-cue agent';'Simulation: Latent-state agent'})
set(gca,'FontSize',20)


