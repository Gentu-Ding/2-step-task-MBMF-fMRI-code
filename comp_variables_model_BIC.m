%% Computational Variables for fMRI
clear
close all

csvFiles_functional = readtable('ID_list.csv');


id=0;
func2nd78 = 78;
for sI = 1: size(csvFiles_functional,1)
    
    
    name = csvFiles_functional.name{sI};
    
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];

    ID =str2double(name(4:7));
    
    
    id=id+1;
    
    % extract computational variables for model-driven fMRI analysis
    % (functional session only)
   
    allData = readtable(['Control_csv_sf/' name_sf '.csv']);
    
    ID_list{id,1} = name;
    
    subData = allData;
    
    
    data = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
        'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
        'outcome2', subData.outcome2, 'outcomeMag', subData.outcomeMag,...
        'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
        'condState', subData.condState,'condContingency', subData.condContingent,...
        'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
        'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);

    clear cbm
    nameMat = ['lap_subjects_sfMRI/lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE/lap_' name_sf '.mat' ];
    load(nameMat)
    clear params
    params  = cbm.output.parameters; 
    
    clear fitData
    [negLLE, fitData] = comp_getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, data);

    fitData.wMF  = params(8);
    fitData.arb_mbRPE = params(10);
    fitData.arb_mfRPE = params(11);
    fitData.arb_SPE = params(12);
    
    fitData.MF_RPE_all = abs(fitData.mfRPE1) + abs(fitData.mfRPE2) + abs(fitData.mfRPE3);
    fitData.MB_RPE_all = abs(fitData.mbRPE1) + abs(fitData.mbRPE2) + abs(fitData.mbRPE3);

    fitData.outcomeMag = allData.outcomeMag;
     
    %filename = ['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/comp_variables/lap_subjects_sfMRI/new5_magMF_binMB_no_spe_lr/' name_f '.mat'];

    %save(filename,'fitData')
    
    
    % Compute the BIC score for each of the four candidate models
    % (structural + functional session)

    allData = readtable(['Control_csv_sf/' name_sf '.csv']);
    

    
    subData = allData;
    
    
    data = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
        'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
        'outcome2', subData.outcome2, 'outcomeMag', subData.outcomeMag,...
        'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
        'condState', subData.condState,'condContingency', subData.condContingent,...
        'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
        'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);
    
    clear cbm
    nameMat = ['lap_subjects_sfMRI/lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE/lap_' name_sf '.mat' ];

    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
 
    clear fitData
    [negLLE, fitData] = comp_getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, data);
    
    a.wMF_baseline = 1./(1+exp(-1*params(8)));
    a.arb_mbRPE = params(10);
    a.arb_mfRPE = params(11);
    a.arb_SPE = params(12);
    
    a.wMF_overall_sf = nanmean(fitData.wMF_trial);
    at = struct2table(a);
    
    %writetable(at,'test.csv');
    
    AIC_arb(id,1) = fitData.AIC;
    BIC_arb(id,1) = fitData.BIC;

    
    clear cbm
    nameMat = ['lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_FW/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
    
    
    clear fitData
    [negLLE, fitData] = comp_getLLE_magMF_binMB_FW_rewMag_WSLS(params, data);
    

    AIC_fw(id,1) = fitData.AIC;
    BIC_fw(id,1) = fitData.BIC;

    
    clear cbm
    nameMat = ['lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_MF/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
    
    
    clear fitData
    [negLLE, fitData] = comp_getLLE_magMF_binMB_MF_rewMag_WSLS(params, data);
    
    AIC_mf(id,1) = fitData.AIC;
    BIC_mf(id,1) = fitData.BIC;
 
    clear cbm
    nameMat = ['lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_MB/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
   
    clear fitData
    [negLLE, fitData] = comp_getLLE_magMF_binMB_MB_rewMag_WSLS(params, data);
    
    AIC_mb(id,1) = fitData.AIC;
    BIC_mb(id,1) = fitData.BIC;
    


    
    
end


% Mean AIC scores for candidate models
[mean(AIC_arb),mean(AIC_fw),mean(AIC_mf), mean(AIC_mb)]
[std(AIC_arb),std(AIC_fw),std(AIC_mf), std(AIC_mb)]

% Mean BIC scores for candidate models
% [mean(BIC_arb),mean(BIC_fw),mean(BIC_mf), mean(BIC_mb)]
% [std(BIC_arb),std(BIC_fw),std(BIC_mf), std(BIC_mb)]

[h,p]= ttest(AIC_arb,AIC_mf) % compare the arbitration mixture vs. fixed-weight mixture model


% F-test of all four models
y = vertcat(AIC_arb,AIC_fw,AIC_mf,AIC_mb);
group_arb(1:179,1) = {'arb'};
group_fw(1:179,1) = {'fw'};
group_mf(1:179,1) = {'mf'};
group_mb(1:179,1) = {'mb'};

group = vertcat(group_arb,group_fw,group_mf, group_mb);

p = anova1(y, group);
