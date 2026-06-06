clear all
close all
tic;
s=RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 21));
%rng(default)

allFiles = readtable('../ID_list.csv');


LOW_RPE     = 2;
HIGH_RPE    = 1;

LOW_SPE     = 2;
HIGH_SPE    = 1;

STATE_CONT  = 2;
STIM_CONT   = 1;

Sub_list = readtable('../R01_control_clusterID_wMF_formal_updated.csv');

group_subs = Sub_list.ID(Sub_list.clusterID==3); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other

id=0;
for sI=1:size(allFiles,1)
    
    
    %set_name  = allFiles(sI).name;
    
    name = allFiles.name{sI}(1:end-4);
    
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
    if TF1==1
        
        id=id+1;
        
        
        %name_sf = [name(1:7) name(end-7:end-4)];
        
        
        % point to the director with data we want to fit
        %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
        %allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/' set_name]);
        
        
        allData = readtable(['../Control_csv_sf/' name '.csv']);
        
        %sI=1;
        subData = allData; %(1:100,:);
        
        
        %subData.runID = ones(size(subData,1),1);
        
        
        %nameMat = ['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/lap_subjects_sfMRI/lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE/lap_' name '.mat'  ];
        nameMat = ['../lap_subjects_sfMRI/lap_control_hmm_2_state/lap_' name '.mat'  ];
        
        
        load(nameMat)
        
        %nameMat = 'params_hmm_mbGroup.mat';
        %load(nameMat)
        
        %idx = randi(44,1);
        
        params = cbm.output.parameters;
        %params = params_hmm_mbGroup(id,:);
        
        
        %[negLLE, fitData] = generateData_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, subData);
        
        [negLLE, fitData] = generateData_hmm_2_state(params, subData);
        
        
        subData.Resp1 = fitData.resp1;
        subData.outcome1 = fitData.outcome1;
        subData.outcome2 = fitData.outcome2;
        subData.outcomeBin = fitData.outcomeBin;
        subData.outcomeMag = fitData.outcomeMag;
        
        
        writetable(subData,['../generated_dataset/hmm_model_mbGroup/' name '.csv' ])
        
    end
    
end


%% Model Identification

clear all
close all


ID_table = readtable('../ID_list.csv');

includeIDs =ID_table.name;

Sub_list = readtable('../R01_control_clusterID_wMF_formal_updated.csv');

group_subs = Sub_list.ID(Sub_list.clusterID==3); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other


id=0;

for sI=1:size(includeIDs,1)
    
    
    
    %set_name  = allFiles(sI).name;
    
    name = includeIDs{sI}(1:end-4);
    
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
    if TF1==1
        
        id=id+1;
        %name_sf = [name(1:7) name(end-7:end-4)];
        
        
        % point to the director with data we want to fit
        %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
        %allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/' set_name]);
        
        allData = readtable(['../generated_dataset/hmm_model_mbGroup/' name '.csv']);
        
        %sI=1;
        subData = allData; %(1:100,:);
        
        
        %     data = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
        %             'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
        %             'outcome2', subData.outcome2, 'outcomeMag', subData.outcomeMag,...
        %             'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
        %             'condState', subData.condState,'condContingency', subData.condContingent,...
        %             'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
        %             'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);
        
        %     subData.isPost_ContState = [nan (subData.condContingency(1:end-1)==2)']';
        %     subData.isPost_RewHigh = [nan (subData.condReward(1:end-1)==1)']';
        %     subData.isPost_StateLow = [nan (subData.condState(1:end-1)==2)']';
        
        %subData.runID = ones(size(subData,1),1);
        
        subData.resp1=subData.Resp1;
        nameMat = ['../lap_subjects_parameter_recovery_R01/lap_control_hmm_fit_hmm_model_mbGroup/lap_' name '.mat'  ];
        
        clear cbm
        load(nameMat)
        
        clear params
        params = cbm.output.parameters;
        %params = mean_params;
        LME(id,1) = cbm.output.log_evidence;
        
        clear negLLE
        [negLLE, fitData] =comp_getLLE_hmm_2_state_updated(params, subData);
        hmm_LLE(id,1) = negLLE;
        hmm_AIC(id,1)= fitData.AIC;
        hmm_BIC(id,1)= fitData.BIC;
        
        nameMat = ['../lap_subjects_parameter_recovery_R01/lap_control_hmm_fit_mb_model_mbGroup/lap_' name '.mat'  ];
        clear cbm
        load(nameMat)
        
        clear params
        params = cbm.output.parameters;
        %params = mean_params;
        LME(id,2) = cbm.output.log_evidence;
        
        clear negLLE
        [negLLE, fitData] =comp_getLLE_magMF_binMB_MB_rewMag_WSLS(params, subData);
        MB_LLE(id,1) = negLLE;
        MB_AIC(id,1) = fitData.AIC;
        MB_BIC(id,1) = fitData.BIC;
        %logLLE_full_fitFW(sI,1) = negLLE;
        
        
        %D  = 2*(hmm_LLE(sI,1) - MB_LLE(sI,1));
        %df = 3;
        %p  = 1 - chi2cdf(D, df);
        
        %LLE_test_pval_hmm_better(sI,1) = p;
    end
    
end

prop = sum(hmm_AIC<MB_AIC)/size(hmm_AIC,1)

prop = sum(hmm_BIC<MB_BIC)/size(hmm_BIC,1)


[alpha, exp_r, xp, pxp, bor] = spm_BMS(LME);


clear hmm_LLE MB_LLE hmm_BIC MB_BIC LME
id=0;
for sI=1:size(includeIDs,1)
    
    
    
    %set_name  = allFiles(sI).name;
    
    name = includeIDs{sI}(1:end-4);
    
    
    %name_sf = [name(1:7) name(end-7:end-4)];
    
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
    if TF1==1
        
        id=id+1;
        
        % point to the director with data we want to fit
        %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
        %allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/' set_name]);
        
        allData = readtable(['../generated_dataset/mb_model_mbGroup/' name '.csv']);
        
        %sI=1;
        subData = allData; %(1:100,:);
        
        
        %     data = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
        %             'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
        %             'outcome2', subData.outcome2, 'outcomeMag', subData.outcomeMag,...
        %             'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
        %             'condState', subData.condState,'condContingency', subData.condContingent,...
        %             'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
        %             'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);
        
        %     subData.isPost_ContState = [nan (subData.condContingency(1:end-1)==2)']';
        %     subData.isPost_RewHigh = [nan (subData.condReward(1:end-1)==1)']';
        %     subData.isPost_StateLow = [nan (subData.condState(1:end-1)==2)']';
        
        %subData.runID = ones(size(subData,1),1);
        
        subData.resp1=subData.Resp1;
        nameMat = ['../lap_subjects_parameter_recovery_R01/lap_control_mb_fit_hmm_model_mbGroup/lap_' name '.mat'  ];
        
        clear cbm
        load(nameMat)
        
        clear params
        params = cbm.output.parameters;
        %params = mean_params;
        LME(id,1) = cbm.output.log_evidence;
        
        clear negLLE
        [negLLE, fitData] =comp_getLLE_hmm_2_state_updated(params, subData);
        hmm_LLE(id,1) = negLLE;
        hmm_AIC(id,1)= fitData.AIC;
        hmm_BIC(id,1)= fitData.BIC;
        
        nameMat = ['../lap_subjects_parameter_recovery_R01/lap_control_mb_fit_mb_model_mbGroup/lap_' name '.mat'  ];
        clear cbm
        load(nameMat)
        
        clear params
        params = cbm.output.parameters;
        %params = mean_params;
        LME(id,2) = cbm.output.log_evidence;
        
        clear negLLE
        [negLLE, fitData] =comp_getLLE_magMF_binMB_MB_rewMag_WSLS(params, subData);
        MB_LLE(id,1) = negLLE;
        MB_AIC(id,1) = fitData.AIC;
        MB_BIC(id,1) = fitData.BIC;
        %logLLE_full_fitFW(sI,1) = negLLE;
        
        
        %D  = 2*(hmm_LLE(sI,1) - MB_LLE(sI,1));
        %df = 3;
        %p  = 1 - chi2cdf(D, df);
        
        %LLE_test_pval_hmm_better(sI,1) = p;
    end
    
end

prop = sum(hmm_AIC>MB_AIC)/size(hmm_AIC,1)

prop = sum(hmm_BIC>MB_BIC)/size(hmm_BIC,1)

[alpha, exp_r, xp, pxp, bor] = spm_BMS(LME);



close
figure(1)
cm = [1 0;
      0 1];

% Convert to percentage for display
cm_percent = cm * 100;

% Plot heatmap
h = heatmap({'Reward-as-cue','MB'}, ...
            {'Reward-as-cue','MB'}, ...
            cm_percent);

h.XLabel = 'Recovered Model';
h.YLabel = 'True Model';
h.Title  = 'Confusion Matrix (by AIC)';
h.CellLabelFormat = '%.1f%%';  % format as percentage

set(gca,'FontSize',22);

close
figure(1)
cm = [0.9318 0.0682;
      0.0455 0.9545];

% Convert to percentage for display
cm_percent = cm * 100;

% Plot heatmap
h = heatmap({'Latent-state','MB'}, ...
            {'Latent-state','MB'}, ...
            cm_percent);

h.XLabel = 'Recovered Model';
h.YLabel = 'True Model';
h.Title  = 'Confusion Matrix (by AIC)';
h.CellLabelFormat = '%.1f%%';  % format as percentage

set(gca,'FontSize',22);


 
 