%% Computational Variables for fMRI
clear
close all

csvFiles_functional = readtable('../ID_list.csv');

id=0;
func2nd78 = 78;
for sI = 1: size(csvFiles_functional,1)
    
    
    name = csvFiles_functional.name{sI};
    
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];

    ID =str2double(name(4:7));
    
    IDs(sI,1) = ID;
    
    id=id+1;
    
       

    
    % Compute the BIC score for each of the four candidate models
    % (structural + functional session)

    allData = readtable(['../Control_csv_sf/' name_sf '.csv']);
    
    subData = allData;
    
    %subData = allData(106:end,:);
    
    
    data = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
        'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
        'outcome2', subData.outcome2, 'outcomeMag', subData.outcomeMag,...
        'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
        'condState', subData.condState,'condContingency', subData.condContingent,...
        'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
        'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);
    
    clear cbm
    nameMat = ['../lap_subjects_sfMRI/lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE/lap_' name_sf '.mat' ];

    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
 
    clear fitData
    [negLLE_arb, fitData] = comp_getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, data);
     
    wMF_baseline(id,1) = 1./(1+exp(-1*params(8)));
    arb_mbRPE(id,1) = params(10);
    arb_mfRPE(id,1) = params(11);
    arb_SPE(id,1) = params(12);
    
    wMF_overall_sf(id,1) = nanmean(fitData.wMF_trial);
    
    arb_params(id,:) = fitData.transParams;
    %at = struct2table(a);
    
    %writetable(at,'test.csv');
    BIC_arb(id,1) = fitData.BIC;
    
    AIC_arb(id,1) = fitData.AIC;

    wMF_arb(id,1) = nanmean(fitData.wMF_trial);
    
    chosen_mfUtil_arb =  fitData.chosen_mfUtility;
    unchosen_mfUtil_arb =  fitData.unchosen_mfUtility;
        
    chosen_mbUtil_arb =  fitData.chosen_mbUtility;
    unchosen_mbUtil_arb =  fitData.unchosen_mbUtility;
    
    SPE1_arb = fitData.SPE1;
    SPE2_arb = fitData.SPE2;
    
    
    clear cbm
    nameMat = ['../lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_FW/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
    
    
    clear fitData
    [negLLE_FW, fitData] = comp_getLLE_magMF_binMB_FW_rewMag_WSLS(params, data);
    

    BIC_fw(id,1) = fitData.BIC;
    AIC_fw(id,1) = fitData.AIC;

    
    clear cbm
    nameMat = ['../lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_MF/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
    
    
    clear fitData
    [negLLE_MF, fitData] = comp_getLLE_magMF_binMB_MF_rewMag_WSLS(params, data);
    
    BIC_mf(id,1) = fitData.BIC;
    AIC_mf(id,1) = fitData.AIC;
  
    chosen_mfUtil_mf =  fitData.chosen_mfUtility;
    unchosen_mfUtil_mf =  fitData.unchosen_mfUtility;
        
    chosen_mbUtil_mf =  fitData.chosen_mbUtility;
    unchosen_mbUtil_mf =  fitData.unchosen_mbUtility;
    
    SPE1_mf = fitData.SPE1;
    SPE2_mf = fitData.SPE2;
    
    smB_mf(id,1) = exp(params(1));
    lr_mf(id,1) = 1./(1+ exp(-params(2)));
    
 
    clear cbm
    nameMat = ['../lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_MB/lap_' name_sf '.mat' ];
    load(nameMat)
    
    %
    clear params
    params  = cbm.output.parameters; 
    mb_params(id,:)=params;
    
    clear fitData
    [negLLE_MB, fitData] = comp_getLLE_magMF_binMB_MB_rewMag_WSLS(params, data);
    
    BIC_mb(id,1) = fitData.BIC;
    AIC_mb(id,1) = fitData.AIC;
       
    chosen_mfUtil_mb =  fitData.chosen_mfUtility;
    unchosen_mfUtil_mb =  fitData.unchosen_mfUtility;
        
    chosen_mbUtil_mb =  fitData.chosen_mbUtility;
    unchosen_mbUtil_mb =  fitData.unchosen_mbUtility;
    
    SPE1_mb = fitData.SPE1;
    SPE2_mb = fitData.SPE2;
    
    %reward-as-cue MF strategy
    clear cbm
    nameMat = ['../lap_subjects_sfMRI/lap_control_rac/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
    rac_params(id,:)=params;
    
    clear fitData
    [negLLE_rac, fitData] = comp_getLLE_RAC(params, data);
    
    BIC_rac(id,1) = fitData.BIC;
    AIC_rac(id,1) = fitData.AIC;

    
    % hmm
    clear cbm
    nameMat = ['../lap_subjects_sfMRI/lap_control_hmm_2_state/lap_' name_sf '.mat' ];
    load(nameMat)
    %
    clear params
    params  = cbm.output.parameters; 
   
    hmm_params(id,:)= params;
    
    clear fitData
    [negLLE_hmm, fitData] = comp_getLLE_hmm_2_state(params, data);
    
    BIC_hmm(id,1) = fitData.BIC;
    AIC_hmm(id,1) = fitData.AIC;
    
    

    % random agent
    clear fitData
    [negLLE_random, fitData] = comp_getLLE_random_agent(data);
    
    BIC_random(id,1) = fitData.BIC;
    AIC_random(id,1) = fitData.AIC;
    
        

    % Likelihood Ratio Test    
    D  = 2*(negLLE_arb - negLLE_FW);
    df = 3;
    p  = 1 - chi2cdf(D, df);
    
    LLE_test_pval_full_better(id,1) = p;
  
    
    % compare arb vs. mf model
    rho = corr(chosen_mfUtil_arb,chosen_mfUtil_mf);
    corr_arb_mf_chosen_mfUtil (id,1) = rho;
        
    rho = corr(unchosen_mfUtil_arb,unchosen_mfUtil_mf);
    corr_arb_mf_unchosen_mfUtil (id,1) = rho;
    
        
    rho = corr(chosen_mbUtil_arb,chosen_mbUtil_mf);
    corr_arb_mf_chosen_mbUtil (id,1) = rho;
        
    rho = corr(unchosen_mbUtil_arb,unchosen_mbUtil_mf);
    corr_arb_mf_unchosen_mbUtil (id,1) = rho;
    
        
    rho = corr(SPE1_arb,SPE1_mf);
    corr_arb_mf_SPE1 (id,1) = rho;
        
    rho = corr(SPE2_arb,SPE2_mf);
    corr_arb_mf_SPE2 (id,1) = rho;
    

        
    % compare arb vs. mb model
    rho = corr(chosen_mfUtil_arb,chosen_mfUtil_mb,'rows', 'complete');
    corr_arb_mb_chosen_mfUtil (id,1) = rho;
        
    rho = corr(unchosen_mfUtil_arb,unchosen_mfUtil_mb,'rows', 'complete');
    corr_arb_mb_unchosen_mfUtil (id,1) = rho;
    
        
    rho = corr(chosen_mbUtil_arb,chosen_mbUtil_mb,'rows', 'complete');
    corr_arb_mb_chosen_mbUtil (id,1) = rho;
        
    rho = corr(unchosen_mbUtil_arb,unchosen_mbUtil_mb,'rows', 'complete');
    corr_arb_mb_unchosen_mbUtil (id,1) = rho;
    
    
    rho = corr(SPE1_arb,SPE1_mb,'rows', 'complete');
    corr_arb_mb_SPE1 (id,1) = rho;
        
    rho = corr(SPE2_arb,SPE2_mb,'rows', 'complete');
    corr_arb_mb_SPE2 (id,1) = rho;
    
end

params_mean = mean(arb_params);

SEM = std(arb_params)./sqrt(length(arb_params));

mean(wMF_overall_sf)
SEM_wMF_overall = std(wMF_overall_sf)./sqrt(length(wMF_overall_sf));

% Mean AIC scores for candidate models

[mean(AIC_arb),mean(AIC_fw),mean(AIC_mf), mean(AIC_mb) mean(AIC_rac) mean(AIC_hmm) mean(AIC_random)]

[h,p]= ttest(AIC_arb,AIC_mb) % compare the arbitration mixture vs. fixed-weight mixture model


% F-test of all four models
y = vertcat(AIC_arb,AIC_fw,AIC_mf,AIC_mb);
group_arb(1:179,1) = {'arb'};
group_fw(1:179,1) = {'fw'};
group_mf(1:179,1) = {'mf'};
group_mb(1:179,1) = {'mb'};

group = vertcat(group_arb,group_fw,group_mf, group_mb);

p = anova1(y, group);


%% Computational variables of sub-groups

clusterTable= readtable('../R01_control_clusterID_wMF_formal_updated.csv');

cID = clusterTable.ID;
clusterID_all = clusterTable.clusterID;


idx = ismember(cID,IDs);

clusterID = clusterID_all(idx);

% Mixture group
wMF_overall_Mixture = wMF_overall_sf(clusterID==1);

mean_wMF_Mixture = mean(wMF_overall_Mixture);
SEM_wMF_Mixture = std(wMF_overall_sf(clusterID==1))./sqrt(length(wMF_overall_sf(clusterID==1)));

params_Mixture = mean(arb_params(clusterID==1,:));
SEM_Mixture = std(arb_params(clusterID==1,:))./sqrt(length(arb_params(clusterID==1,:)));


AIC_arb_Mixture = AIC_arb(clusterID==1);
AIC_fw_Mixture = AIC_fw(clusterID==1);
AIC_mf_Mixture = AIC_mf(clusterID==1);
AIC_mb_Mixture = AIC_mb(clusterID==1);
AIC_rac_Mixture = AIC_rac(clusterID==1);
AIC_hmm_Mixture = AIC_hmm(clusterID==1);
AIC_random_Mixture = AIC_random(clusterID==1);

AIC_Mixture = horzcat(AIC_arb_Mixture,AIC_fw_Mixture,AIC_mf_Mixture,AIC_mb_Mixture,AIC_rac_Mixture,AIC_hmm_Mixture,AIC_random_Mixture);

[h,p]= ttest(AIC_fw_Mixture,AIC_mf_Mixture)

% 1-arb; 2-fw; 3-mf; 4-mb; 5-random
for i = 1:size(AIC_Mixture,1)
    best_model_Mixture(i,1) = find(AIC_Mixture(i,:)==min(AIC_Mixture(i,:))); 
end

% MF group
wMF_overall_MF = wMF_overall_sf(clusterID==2);

mean_wMF_MF = mean(wMF_overall_MF);
SEM_wMF_MF = std(wMF_overall_sf(clusterID==2))./sqrt(length(wMF_overall_sf(clusterID==2)));

params_MF = mean(arb_params(clusterID==2,:));
SEM_MF = std(arb_params(clusterID==2,:))./sqrt(length(arb_params(clusterID==2,:)));


AIC_arb_MF = AIC_arb(clusterID==2);
AIC_fw_MF = AIC_fw(clusterID==2);
AIC_mf_MF = AIC_mf(clusterID==2);
AIC_mb_MF = AIC_mb(clusterID==2);
AIC_rac_MF = AIC_rac(clusterID==2);
AIC_hmm_MF = AIC_hmm(clusterID==2);
AIC_random_MF = AIC_random(clusterID==2);

smB_MF = smB_mf(clusterID==2);
lr_MF = lr_mf(clusterID==2);

AIC_MF = horzcat(AIC_arb_MF,AIC_fw_MF,AIC_mf_MF,AIC_mb_MF,AIC_rac_MF,AIC_hmm_MF,AIC_random_MF);

[h,p]= ttest(AIC_arb_MF,AIC_mf_MF)

for i = 1:size(AIC_MF,1)
    best_model_MF(i,1) = find(AIC_MF(i,:)==min(AIC_MF(i,:))); 
end

mfUtil_chosen_corr_MF = corr_arb_mf_chosen_mfUtil(clusterID==2);
mfUtil_unchosen_corr_MF = corr_arb_mf_unchosen_mfUtil(clusterID==2);


% MB group
wMF_overall_MB = wMF_overall_sf(clusterID==3);

mean_wMF_MB = mean(wMF_overall_MB);
SEM_wMF_MB = std(wMF_overall_sf(clusterID==3))./sqrt(length(wMF_overall_sf(clusterID==3)));

params_MB = mean(arb_params(clusterID==3,:));
SEM_MB = std(arb_params(clusterID==3,:))./sqrt(length(arb_params(clusterID==3,:)));


AIC_arb_MB = AIC_arb(clusterID==3);
AIC_fw_MB = AIC_fw(clusterID==3);
AIC_mf_MB = AIC_mf(clusterID==3);
AIC_mb_MB = AIC_mb(clusterID==3);
AIC_rac_MB = AIC_rac(clusterID==3);
AIC_hmm_MB = AIC_hmm(clusterID==3);
AIC_random_MB = AIC_random(clusterID==3);


AIC_MB = horzcat(AIC_arb_MB,AIC_fw_MB,AIC_mf_MB,AIC_mb_MB,AIC_rac_MB,AIC_hmm_MB,AIC_random_MB);

[h,p]= ttest(AIC_fw_MB,AIC_arb_MB)


for i = 1:size(AIC_MB,1)
    best_model_MB(i,1) = find(AIC_MB(i,:)==min(AIC_MB(i,:))); 
end

mbUtil_chosen_corr_MB = corr_arb_mb_chosen_mbUtil(clusterID==3);
mbUtil_unchosen_corr_MB = corr_arb_mb_unchosen_mbUtil(clusterID==3);

% Other group
wMF_overall_Other = wMF_overall_sf(clusterID==4);

mean_wMF_Other = mean(wMF_overall_Other);
SEM_wMF_Other = std(wMF_overall_sf(clusterID==4))./sqrt(length(wMF_overall_sf(clusterID==4)));

params_Other = mean(arb_params(clusterID==4,:));
SEM_Other = std(arb_params(clusterID==4,:))./sqrt(length(arb_params(clusterID==4,:)));


AIC_arb_Other = AIC_arb(clusterID==4);
AIC_fw_Other = AIC_fw(clusterID==4);
AIC_mf_Other = AIC_mf(clusterID==4);
AIC_mb_Other = AIC_mb(clusterID==4);
AIC_rac_Other = AIC_rac(clusterID==4);
AIC_hmm_Other = AIC_hmm(clusterID==4);
AIC_random_Other = AIC_random(clusterID==4);

smB_Other = smB_mf(clusterID==4);
lr_Other = lr_mf(clusterID==4);

AIC_Other = horzcat(AIC_arb_Other,AIC_fw_Other,AIC_mf_Other,AIC_mb_Other,AIC_rac_Other,AIC_hmm_Other,AIC_random_Other);

[h,p]= ttest(AIC_arb_Other,AIC_mf_Other)

AIC_Other_2 = horzcat(AIC_arb_Other,AIC_fw_Other,AIC_mf_Other,AIC_mb_Other,AIC_random_Other);

for i = 1:size(AIC_Other_2,1)
    best_model_Other_2(i,1) = find(AIC_Other_2(i,:)==min(AIC_Other_2(i,:))); 
end


[h,p]= ttest2(wMF_overall_Mixture,wMF_overall_Other) % compare the arbitration mixture vs. fixed-weight mixture model




close all
figure(1)
subplot(4,1,1)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range

hold on
histogram(wMF_overall_Mixture, 'NumBins', 15, 'FaceAlpha', 0.5);
hold off;
%xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('Mixture Group')
ylim([0 15])
xlim([0 1])
set(gca,'FontSize',18);

subplot(4,1,2)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range

hold on
histogram(wMF_overall_MF, 'NumBins', 15, 'FaceAlpha', 0.5);
hold off;
%xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('MF Group')
ylim([0 15])
xlim([0 1])
set(gca,'FontSize',18);

subplot(4,1,3)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range

hold on
histogram(wMF_overall_MB, 'NumBins', 15, 'FaceAlpha', 0.5);
hold off;
%xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('MB Group')
ylim([0 15])
xlim([0 1])
set(gca,'FontSize',18);

subplot(4,1,4)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range
hold on
histogram(wMF_overall_Other, 'NumBins', 15, 'FaceAlpha', 0.5);
hold off;
xlabel('Average MF Weight')
ylabel('# of Participants')
title('Other Group')
ylim([0 15])
xlim([0 1])
set(gca,'FontSize',18);
%legend({'Behaviors'})


x = [31 10];   % Other group MF model vs. alternative model
n = [53 53]; % Other group totals

p_pool = sum(x)/sum(n);
z = (x(1)/n(1) - x(2)/n(2)) / sqrt(p_pool*(1-p_pool)*(1/n(1)+1/n(2)));
p = 1 - normcdf(z);  % one-sided test: A > B


mfUtil_chosen_corr_Other = corr_arb_mf_chosen_mfUtil(clusterID==4);
mfUtil_unchosen_corr_Other = corr_arb_mf_unchosen_mfUtil(clusterID==4);

close all
figure(1)
group1 = mfUtil_chosen_corr_MF;
group2 = mfUtil_unchosen_corr_MF;
group3 = mbUtil_chosen_corr_MB;
group4 = mbUtil_unchosen_corr_MB;
group5 = mfUtil_chosen_corr_Other;
group6 = mfUtil_unchosen_corr_Other;

% Combine all data into one vector
allData = [group1; group2; group3; group4; group5; group6];

% Create a grouping variable (same length as allData)

groupLabels = [repmat(1,34,1); repmat(2,34,1); repmat(3,44,1); repmat(4,44,1); repmat(5,53,1);repmat(6,53,1)];

% Plot boxplots
boxplot(allData, groupLabels);
yline(0, '--k', 'LineWidth', 1.5);
% Customize axes
xticklabels({'Arb vs. MF Chosen V','Arb vs. MF Unchosen V', 'Arb vs. MB Chosen V', 'Arb vs. MB Unchosen V', 'Arb vs. MF Chosen V','Arb vs. MF Unchosen V'});
ylabel('Pearson Correlation');
title('Value Correlations Between Models');
set(gca,'FontSize',20);



% wMF mean across groups: Mix 0.6436  MF 0.7332    MB 0.2684   Other
% 0.5215; std: 0.1793   0.1327    0.1394    0.1742
[mean(wMF_overall_Mixture), mean(wMF_overall_MF), mean(wMF_overall_MB), mean(wMF_overall_Other)]
[std(wMF_overall_Mixture), std(wMF_overall_MF), std(wMF_overall_MB), std(wMF_overall_Other)]

[mean(BIC_arb_Mixture),mean(BIC_fw_Mixture),mean(BIC_mf_Mixture), mean(BIC_mb_Mixture), mean(BIC_rac_Mixture), mean(BIC_hmm_Mixture),mean(BIC_random_Mixture)]

[mean(BIC_arb_MF),mean(BIC_fw_MF),mean(BIC_mf_MF), mean(BIC_mb_MF),mean(BIC_rac_MF),mean(BIC_hmm_MF), mean(BIC_random_MF)]

[mean(BIC_arb_MB),mean(BIC_fw_MB),mean(BIC_mf_MB), mean(BIC_mb_MB),mean(BIC_rac_MB), mean(BIC_hmm_MB), mean(BIC_random_MB)]

[mean(BIC_arb_Other),mean(BIC_fw_Other),mean(BIC_mf_Other), mean(BIC_mb_Other), mean(BIC_rac_Other), mean(BIC_hmm_Other), mean(BIC_random_Other)]


[mean(AIC_arb_Mixture),mean(AIC_fw_Mixture),mean(AIC_mf_Mixture), mean(AIC_mb_Mixture), mean(AIC_rac_Mixture), mean(AIC_hmm_Mixture),mean(AIC_random_Mixture)]

[mean(AIC_arb_MF),mean(AIC_fw_MF),mean(AIC_mf_MF), mean(AIC_mb_MF),mean(AIC_rac_MF),mean(AIC_hmm_MF), mean(AIC_random_MF)]

[mean(AIC_arb_MB),mean(AIC_fw_MB),mean(AIC_mf_MB), mean(AIC_mb_MB),mean(AIC_rac_MB), mean(AIC_hmm_MB), mean(AIC_random_MB)]

[mean(AIC_arb_Other),mean(AIC_fw_Other),mean(AIC_mf_Other), mean(AIC_mb_Other), mean(AIC_rac_Other), mean(AIC_hmm_Other), mean(AIC_random_Other)]


mixture_group = [mean(AIC_arb_Mixture) mean(AIC_fw_Mixture) mean(AIC_mb_Mixture) mean(AIC_mf_Mixture)  mean(AIC_random_Mixture)];
mf_group = [mean(AIC_arb_MF) mean(AIC_fw_MF) mean(AIC_mb_MF) mean(AIC_mf_MF)  mean(AIC_random_MF)];
mb_group = [mean(AIC_arb_MB) mean(AIC_fw_MB) mean(AIC_mb_MB) mean(AIC_mf_MB)  mean(AIC_random_MB)];
other_group = [mean(AIC_arb_Other) mean(AIC_fw_Other) mean(AIC_mb_Other) mean(AIC_mf_Other)  mean(AIC_random_Other)];


SEM1 = nanstd(AIC_arb_Mixture)/sqrt(length(AIC_arb_Mixture));
errhigh1 = SEM1;
errlow1  = SEM1;

SEM2 = nanstd(AIC_fw_Mixture)/sqrt(length(AIC_fw_Mixture));
errhigh2 = SEM2;
errlow2  = SEM2;

SEM3 = nanstd(AIC_mb_Mixture)/sqrt(length(AIC_mb_Mixture));
errhigh3 = SEM3;
errlow3  = SEM3;

SEM4 = nanstd(AIC_mf_Mixture)/sqrt(length(AIC_mf_Mixture));
errhigh4 = SEM4;
errlow4  = SEM4;

SEM5 = nanstd(AIC_random_Mixture)/sqrt(length(AIC_random_Mixture));
errhigh5 = SEM5;
errlow5  = SEM5;

SEM_mixture = [SEM1 SEM2 SEM3 SEM4 SEM5];
errlow_mixture = [errlow1 errlow2 errlow3 errlow4 errlow5];
errhigh_mixture = [errhigh1 errhigh2 errhigh3 errhigh4 errhigh5];

%
SEM1 = nanstd(AIC_arb_MF)/sqrt(length(AIC_arb_MF));
errhigh1 = SEM1;
errlow1  = SEM1;

SEM2 = nanstd(AIC_fw_MF)/sqrt(length(AIC_fw_MF));
errhigh2 = SEM2;
errlow2  = SEM2;

SEM3 = nanstd(AIC_mb_MF)/sqrt(length(AIC_mb_MF));
errhigh3 = SEM3;
errlow3  = SEM3;

SEM4 = nanstd(AIC_mf_MF)/sqrt(length(AIC_mf_MF));
errhigh4 = SEM4;
errlow4  = SEM4;

SEM5 = nanstd(AIC_random_MF)/sqrt(length(AIC_random_MF));
errhigh5 = SEM5;
errlow5  = SEM5;

SEM_mf = [SEM1 SEM2 SEM3 SEM4 SEM5];
errlow_mf = [errlow1 errlow2 errlow3 errlow4 errlow5];
errhigh_mf = [errhigh1 errhigh2 errhigh3 errhigh4 errhigh5];


%
%
SEM1 = nanstd(AIC_arb_MB)/sqrt(length(AIC_arb_MB));
errhigh1 = SEM1;
errlow1  = SEM1;

SEM2 = nanstd(AIC_fw_MB)/sqrt(length(AIC_fw_MB));
errhigh2 = SEM2;
errlow2  = SEM2;

SEM3 = nanstd(AIC_mb_MB)/sqrt(length(AIC_mb_MB));
errhigh3 = SEM3;
errlow3  = SEM3;

SEM4 = nanstd(AIC_mf_MB)/sqrt(length(AIC_mf_MB));
errhigh4 = SEM4;
errlow4  = SEM4;

SEM5 = nanstd(AIC_random_MB)/sqrt(length(AIC_random_MB));
errhigh5 = SEM5;
errlow5  = SEM5;

SEM_mb = [SEM1 SEM2 SEM3 SEM4 SEM5];
errlow_mb = [errlow1 errlow2 errlow3 errlow4 errlow5];
errhigh_mb = [errhigh1 errhigh2 errhigh3 errhigh4 errhigh5];

%

SEM1 = nanstd(AIC_arb_Other)/sqrt(length(AIC_arb_Other));
errhigh1 = SEM1;
errlow1  = SEM1;

SEM2 = nanstd(AIC_fw_Other)/sqrt(length(AIC_fw_Other));
errhigh2 = SEM2;
errlow2  = SEM2;

SEM3 = nanstd(AIC_mb_Other)/sqrt(length(AIC_mb_Other));
errhigh3 = SEM3;
errlow3  = SEM3;

SEM4 = nanstd(AIC_mf_Other)/sqrt(length(AIC_mf_Other));
errhigh4 = SEM4;
errlow4  = SEM4;

SEM5 = nanstd(AIC_random_Other)/sqrt(length(AIC_random_Other));
errhigh5 = SEM5;
errlow5  = SEM5;

SEM_other = [SEM1 SEM2 SEM3 SEM4 SEM5];
errlow_other = [errlow1 errlow2 errlow3 errlow4 errlow5];
errhigh_other = [errhigh1 errhigh2 errhigh3 errhigh4 errhigh5];


a=[errlow_mixture; errlow_mb; errlow_mf; errlow_other];
b=[errhigh_mixture; errhigh_mb; errhigh_mf; errhigh_other];

AIC_groups = [mixture_group;mb_group;mf_group;other_group];

close all

figure(1)
types=["Mixture Group"; "MB Group"; "MF Group"; "Other Group"];


h=bar(AIC_groups,'EdgeColor', 'none');
hold on
[ngroups,nbars] = size(AIC_groups);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = h(i).XEndPoints;
end
errorbar(x',AIC_groups,a,'k','linestyle','none');
%f = errorbar(x,BIC_avg,errlow,errhigh);    
%f.Color = [0 0 0];                            
%f.LineStyle = 'none';
ylabel('AIC Score')
title('Model Comparisons: Sub-Groups')
set(gca,'xticklabel',types);
set(gca,'fontSize',20);
set(gca, 'TickLength', [0 0]);
legend({'Arbitration mixture model';'Fixed-weight mixture model';'MB model'; 'MF model'; 'Random model'},'Location','northeast')




% Plot MB group
mb_group = [mean(AIC_arb_MB) mean(AIC_fw_MB) mean(AIC_mb_MB) mean(AIC_rac_MB) mean(AIC_hmm_MB) mean(AIC_mf_MB) mean(AIC_random_MB)];

SEM1 = nanstd(AIC_arb_MB)/sqrt(length(AIC_arb_MB));
errhigh1 = SEM1;
errlow1  = SEM1;

SEM2 = nanstd(AIC_fw_MB)/sqrt(length(AIC_fw_MB));
errhigh2 = SEM2;
errlow2  = SEM2;

SEM3 = nanstd(AIC_mb_MB)/sqrt(length(AIC_mb_MB));
errhigh3 = SEM3;
errlow3  = SEM3;

SEM4 = nanstd(AIC_rac_MB)/sqrt(length(AIC_rac_MB));
errhigh4 = SEM4;
errlow4  = SEM4;

SEM5 = nanstd(AIC_hmm_MB)/sqrt(length(AIC_hmm_MB));
errhigh5 = SEM5;
errlow5  = SEM5;

SEM6 = nanstd(AIC_mf_MB)/sqrt(length(AIC_mf_MB));
errhigh6 = SEM6;
errlow6  = SEM6;

SEM7 = nanstd(AIC_random_MB)/sqrt(length(AIC_random_MB));
errhigh7 = SEM7;
errlow7  = SEM7;

SEM_mb = [SEM1 SEM2 SEM3 SEM4 SEM5 SEM6 SEM7];
errlow_mb = [errlow1 errlow2 errlow3 errlow4 errlow5 errlow6 errlow7];
errhigh_mb = [errhigh1 errhigh2 errhigh3 errhigh4 errhigh5 errhigh6 errhigh7];



a=errlow_mb;
AIC_groups = mb_group;

close all
clear h

figure(1)

hold on
[ngroups,nbars] = size(AIC_groups);
% Get the x coordinate of the bars
for i = 1:nbars
    h(i)=bar(i,AIC_groups(i),'FaceColor', new_colors(i,:),'EdgeColor', 'none');
    %h(i)=bar(i,AIC_groups(i),'EdgeColor', 'none');
    
    errorbar(i,AIC_groups(i),a(i),'k','linestyle','none');
end

%f = errorbar(x,BIC_avg,errlow,errhigh);    
%f.Color = [0 0 0];                            
%f.LineStyle = 'none';
title('MB Group')
ylabel('AIC Score')
xlabel('Models')
set(gca,'xticklabel',{})
%xlabel('MB Group')
set(gca,'fontSize',20);
set(gca, 'TickLength', [0 0]);
legend(h,{'Arbitration mixture model';'Fixed-weight mixture model';'MB model'; 'Reward-as-cue model';'Latent-state model';'MF model'; 'Random model'},'Location','northeast')

for i = 1:nbars
    colors(i,:) = h(i).FaceColor;
end

new_colors(1,:) = colors(1,:);
new_colors(2,:) =colors(5,:);
new_colors(3,:) =colors(2,:);
new_colors(4,:) =colors(4,:);
new_colors(5,:) =colors(7,:);
new_colors(6,:) =colors(6,:);
new_colors(7,:) =colors(3,:);

