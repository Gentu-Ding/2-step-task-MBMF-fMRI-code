clear all;
close all;


addpath(genpath('cbm-master'))


tic; % for measuring time

allFiles = dir('Control_csv_sf/sub*.csv'); % An example of raw data folder


data_subj={};
dataFolder = 'lap_subjects_sfMRI/lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE'; % folder to store the first-level fit

mkdir(dataFolder);


n_par = 12;
parfor sI = 1:size(allFiles,1)

        
        data_subj={};
        name = allFiles(sI).name;
        
        allData = readtable(['Control_csv_sf/' name]);
        
        

        subData = allData;
   
        
        data_subj{1} = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
            'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
            'outcome2', subData.outcome2 , 'outcomeMag', subData.outcomeMag,...
            'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
            'condState', subData.condState,'condContingency', subData.condContingent,...
            'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
            'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID); %'TOI',TOI_trials(:,sI));
        
        
        prior_hybrid = struct( 'mean' , zeros(n_par, 1), 'variance' , 6.25); % Number of parameters
        
      
        % we save all output files in the lap_subjects directory
        fname_subj = fullfile( dataFolder ,[ 'lap_' name(1:end-4) '.mat' ]);
        
        fprintf(num2str(sI))
        fprintf('\n')
        fprintf(name)
        fprintf('\n')
        cbm_lap(data_subj, @model_getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS, prior_hybrid, fname_subj);
        
    %end
    
end

toc;
