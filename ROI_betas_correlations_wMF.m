clear 
close all

% extract the betas across all

folderLocation =['/Users/olab/tolmanRM/home/wding/analysis_SPM/Models_2nd_fitData_no_conditions_all_stc2_Controls_no_other_filtered_wMF_r21c_updated'];


% extract for each sub-groups

groupID = 'Other';
folderLocation =['/Users/olab/tolmanRM/home/wding/analysis_SPM/Models_2nd_fitData_no_conditions_all_stc2_group' groupID '_r21c_updated'];


% MF-RPE
clear SPM

contrastID = [folderLocation '/con_0006/SPM.mat'];

load(contrastID)

Contrast_mfRPE = SPM.xY.P;

%MB-RPE
clear SPM
contrastID = [folderLocation '/con_0007/SPM.mat'];

load(contrastID)

Contrast_mbRPE = SPM.xY.P;


%SPE
clear SPM
contrastID = [folderLocation '/con_0005/SPM.mat'];

load(contrastID)

Contrast_SPE = SPM.xY.P;



% MF Value
clear SPM
contrastID = [folderLocation '/con_0008/SPM.mat'];

load(contrastID)

Contrast_MFDU = SPM.xY.P;


% MB Value
clear SPM
contrastID = [folderLocation '/con_0009/SPM.mat'];

load(contrastID)

Contrast_MBDU = SPM.xY.P;


sf_table = readtable(['R01_control_clusterID_wMF_formal_updated.csv']);

allIDs = sf_table.ID; %(sf_table.clusterID~=4);

wMF_overall = sf_table.wMF_overall_sf; %(sf_table.clusterID~=4);

j=0;
for i=1:size(Contrast_mfRPE,1)

    Contrast_ID = str2double(Contrast_mfRPE{i,1}(end-30:end-27));
   
    idx= ismember(allIDs,Contrast_ID);
   
    
    if sum(idx)==1 
        j=j+1;
       
        subIDs(j,1)=Contrast_ID;
               
        Contrast_paths_mfRPE{j,1}=['/Users/olab/tolmanRM' Contrast_mfRPE{i,1}];
        
        Contrast_paths_mbRPE{j,1}=['/Users/olab/tolmanRM' Contrast_mbRPE{i,1}];
        
        Contrast_paths_SPE{j,1}=['/Users/olab/tolmanRM' Contrast_SPE{i,1}];
        
        Contrast_paths_MFDU{j,1}=['/Users/olab/tolmanRM' Contrast_MFDU{i,1}];
        
        Contrast_paths_MBDU{j,1}=['/Users/olab/tolmanRM' Contrast_MBDU{i,1}];
        
        wMF_filtered(j,1) = wMF_overall(idx);
        
        
    end
    
end
% 


clear xyz
load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/vmPFC_XYZ_bartra.mat')

ROI_MFDU_beta = spm_get_data(Contrast_paths_MFDU,xyz);
m_beta_MFDU = mean(ROI_MFDU_beta,2);

ROI_MBDU_beta = spm_get_data(Contrast_paths_MBDU,xyz);
m_beta_MBDU = mean(ROI_MBDU_beta,2);


[h,p]=ttest(m_beta_MBDU)

[h,p]=ttest(m_beta_MFDU)


[h,p]=corr(m_beta_MBDU, wMF_filtered,'type', 'Spearman')

[h,p]=corr(m_beta_MFDU, wMF_filtered,'type', 'Spearman')



% save MF DV and MB DV betas for group_stats

clear xyz
load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/vmPFC_XYZ_bartra.mat')
%load('/Users/olab/tolmanRM/home/wding/putamen_wolfgang_cit.mat')

ROI_data = spm_get_data(Contrast_paths_MBDU, xyz);
filename = ['ROI_betas/Value_ROI_betas/vmPFC_bartra_' groupID '_MBDU_updated.mat'];
save(filename,'ROI_data')

ROI_data = spm_get_data(Contrast_paths_MFDU, xyz);
filename = ['ROI_betas/Value_ROI_betas/vmPFC_bartra_' groupID '_MFDU_updated.mat'];
save(filename,'ROI_data')


% save SPE betas for group stats

clear xyz
load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/dlPFC_glascher.mat')
%load('/Users/olab/tolmanRM/home/wding/putamen_wolfgang_cit.mat')

ROI_data = spm_get_data(Contrast_paths_SPE, xyz);
filename = ['ROI_betas/SPE_ROI_betas/dlPFC_glascher_' groupID '_SPE_updated.mat'];
save(filename,'ROI_data')


clear xyz
load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/IPS_glascher.mat')

ROI_data = spm_get_data(Contrast_paths_SPE, xyz);
filename = ['ROI_betas/SPE_ROI_betas/IPS_glascher_' groupID '_SPE_updated.mat'];
save(filename,'ROI_data')




% SPE


clear xyz
load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/dlPFC_glascher.mat')


ROI_SPE_beta = spm_get_data(Contrast_paths_SPE,xyz);
m_beta_SPE_dlPFC = mean(ROI_SPE_beta,2);

[h,p]=corr(m_beta_SPE_dlPFC, wMF_filtered,'type', 'Spearman')


clear xyz
load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/IPS_glascher.mat')


ROI_SPE_beta = spm_get_data(Contrast_paths_SPE,xyz);
m_beta_SPE_IPS = mean(ROI_SPE_beta,2);

[h,p]=corr(m_beta_SPE_IPS, wMF_filtered,'type', 'Spearman')


% save RPE betas for group stats

% clear xyz
% load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/VS_XYZ_pauli.mat')
% 
% 
% ROI_data = spm_get_data(Contrast_paths_mbRPE, xyz);
% filename = ['ROI_betas/RPE_ROI_betas/mbRPE_ventral_striatum_pauli_updated.mat'];
% save(filename,'ROI_data')
% 
% 
% ROI_data = spm_get_data(Contrast_paths_mfRPE, xyz);
% filename = ['ROI_betas/RPE_ROI_betas/mfRPE_ventral_striatum_pauli_updated.mat'];
% save(filename,'ROI_data')


% 
% 
% clear xyz
% load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/caudate_XYZ_mfRPE_SVC_posthoc_updated.mat')
% 
% 
% ROI_data = spm_get_data(Contrast_paths_mbRPE, xyz);
% filename = ['ROI_betas/RPE_ROI_betas/caudate_posthoc_mbRPE_1st_2nd_updated.mat'];
% save(filename,'ROI_data')
% 
% 
% ROI_data = spm_get_data(Contrast_paths_mfRPE, xyz);
% filename = ['ROI_betas/RPE_ROI_betas/caudate_posthoc_mfRPE_1st_2nd_updated.mat'];
% save(filename,'ROI_data')
% 
% 
% clear xyz
% load('ROI_masks/mask_voxel_locations_vmPFC_dlPFC_IPS/VS_XYZ_mbRPE_SVC_posthoc_updated.mat')
% 
% 
% ROI_data = spm_get_data(Contrast_paths_mbRPE, xyz);
% filename = ['ROI_betas/RPE_ROI_betas/VS_posthoc_mbRPE_1st_2nd_updated'];
% save(filename,'ROI_data')
% 
% 
% ROI_data = spm_get_data(Contrast_paths_mfRPE, xyz);
% filename = ['ROI_betas/RPE_ROI_betas/VS_posthoc_mfRPE_1st_2nd_updated'];
% save(filename,'ROI_data')


% plot the correlation figure for MF Value
close all
figure(1)
scatter(wMF_filtered, m_beta_MFDU,55,'filled')
%xlabel('MF Weight')
%ylabel('Betas of MF DV (a.u.)')
%title('Correlations in vmPFC')
%set(gca,'Xticklabel',[]) 
ylim([-1.7 1.7])
set(gca,'FontSize',22)
h=lsline;
h.LineWidth = 3;


% plot the correlation figure for MB Value
close all
figure(1)
scatter(wMF_filtered, m_beta_MBDU,55,'filled')
%xlabel('MF Weight')
%ylabel('Betas of MB Value (a.u.)')
%title('Correlations in vmPFC')
%set(gca,'Xticklabel',[]) 
ylim([-3 3])
set(gca,'FontSize',22)
h=lsline;
h.LineWidth = 3;


% plot the correlation figure for SPE in dlPFC
close all
figure(1)
scatter(wMF_filtered, m_beta_SPE_dlPFC,55,'filled')
%xlabel('MF Weight')
%ylabel('Betas of SPE (a.u.)')
%title('Correlations in dlPFC')
%set(gca,'Xticklabel',[]) 
ylim([-0.4 0.6])
set(gca,'FontSize',22)
h=lsline;
h.LineWidth = 3;

% plot the correlation figure for SPE in IPS

figure(2)
scatter(wMF_filtered, m_beta_SPE_IPS,55,'filled')
%xlabel('MF Weight')
%ylabel('Betas of SPE (a.u.)')
%title('Correlations in IPS')
%set(gca,'Xticklabel',[]) 
ylim([-0.2 0.5])
set(gca,'FontSize',22)
h=lsline;
h.LineWidth = 3;


