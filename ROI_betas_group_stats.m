%% plot out the specificity of MB regions: betas in MB, Mixture and MF group
clear 
close all

% value in vmPFC
matName_MB_mfUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_MB_MFDU_updated.mat'];
matName_Mixture_mfUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_Mixture_MFDU_updated.mat'];
matName_MF_mfUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_MF_MFDU_updated.mat'];
matName_Other_mfUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_Other_MFDU_updated.mat'];

matName_MB_mbUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_MB_MBDU_updated.mat'];
matName_Mixture_mbUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_Mixture_MBDU_updated.mat'];
matName_MF_mbUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_MF_MBDU_updated.mat'];
matName_Other_mbUtil =['ROI_betas/Value_ROI_betas/vmPFC_bartra_Other_MBDU_updated.mat'];

% value in amygdala
% matName_MB_mbUtil =['ROI_betas/Value_ROI_betas/amygdala_HO_MB_MBDU.mat'];
% matName_Mixture_mbUtil =['ROI_betas/Value_ROI_betas/amygdala_HO_Mixture_MBDU.mat'];
% matName_MF_mbUtil =['ROI_betas/Value_ROI_betas/amygdala_HO_MF_MBDU.mat'];
% matName_Other_mbUtil =['ROI_betas/Value_ROI_betas/amygdala_HO_Other_MBDU.mat'];


% Load and obtain betas for MF Value
load(matName_MB_mfUtil)
y=ROI_data;
MB_betas_mfUtil = mean(y,1);
avg_betas_MBGroup_mfUtil = mean(y,2);

load(matName_Mixture_mfUtil)
y=ROI_data;
Mixture_betas_mfUtil = mean(y,1);
avg_betas_MixtureGroup_mfUtil = mean(y,2);

load(matName_MF_mfUtil)
y=ROI_data;
MF_betas_mfUtil = mean(y,1);
avg_betas_MFGroup_mfUtil = mean(y,2);

load(matName_Other_mfUtil)
y=ROI_data;
Other_betas_mfUtil = mean(y,1);
avg_betas_OtherGroup_mfUtil = mean(y,2);

% Load and obtain betas for MB Value
load(matName_MB_mbUtil)
y=ROI_data;
MB_betas_mbVar = mean(y,1);
avg_betas_MBGroup_mbUtil = mean(y,2);


load(matName_Mixture_mbUtil)
y=ROI_data;
Mixture_betas_mbVar = mean(y,1);
avg_betas_MixtureGroup_mbUtil = mean(y,2);

load(matName_MF_mbUtil)
y=ROI_data;
MF_betas_mbUtil = mean(y,1);
avg_betas_MFGroup_mbUtil = mean(y,2);

load(matName_Other_mbUtil)
y=ROI_data;
Other_betas_mbUtil = mean(y,1);
avg_betas_OtherGroup_mbUtil = mean(y,2);

% average MF Value
avg_betas_mfUtil_3=[mean(avg_betas_MBGroup_mfUtil);mean(avg_betas_MixtureGroup_mfUtil);mean(avg_betas_MFGroup_mfUtil)];

avg_betas_mfUtil_4=[nanmean(avg_betas_MBGroup_mfUtil); nanmean(avg_betas_MixtureGroup_mfUtil); nanmean(avg_betas_MFGroup_mfUtil); nanmean(avg_betas_OtherGroup_mfUtil)];

sem_mb_mfUtil = nanstd(avg_betas_MBGroup_mfUtil)/sqrt(length(avg_betas_MBGroup_mfUtil));
errlow_mb =sem_mb_mfUtil;
errhigh_mb =sem_mb_mfUtil;


sem_mixture_mfUtil = nanstd(avg_betas_MixtureGroup_mfUtil)/sqrt(length(avg_betas_MixtureGroup_mfUtil));
errlow_mixture =sem_mixture_mfUtil;
errhigh_mixture =sem_mixture_mfUtil;


sem_mf_mfUtil = nanstd(avg_betas_MFGroup_mfUtil)/sqrt(length(avg_betas_MFGroup_mfUtil));
errlow_mf =sem_mf_mfUtil;
errhigh_mf =sem_mf_mfUtil;

sem_other_mfUtil = nanstd(avg_betas_OtherGroup_mfUtil)/sqrt(length(avg_betas_OtherGroup_mfUtil));
errlow_other =sem_other_mfUtil;
errhigh_other =sem_other_mfUtil;

SEM_3=[sem_mb_mfUtil;sem_mixture_mfUtil;sem_mf_mfUtil ];
errlow_mfUtil_3=[errlow_mb;errlow_mixture;errlow_mf];
errhigh_mfUtil_3=[errhigh_mb;errhigh_mixture;errhigh_mf];

SEM_4=[sem_mb_mfUtil;sem_mixture_mfUtil;sem_mf_mfUtil;sem_other_mfUtil];
errlow_mfUtil_4=[errlow_mb;errlow_mixture;errlow_mf;errlow_other];
errhigh_mfUtil_4=[errhigh_mb;errhigh_mixture;errhigh_mf;errhigh_other];

% average MB Value
avg_betas_mbUtil_3=[mean(avg_betas_MBGroup_mbUtil);mean(avg_betas_MixtureGroup_mbUtil);mean(avg_betas_MFGroup_mbUtil)];

avg_betas_mbUtil_4=[nanmean(avg_betas_MBGroup_mbUtil);nanmean(avg_betas_MixtureGroup_mbUtil); nanmean(avg_betas_MFGroup_mbUtil); nanmean(avg_betas_OtherGroup_mbUtil)];

sem_mb_mbUtil = nanstd(avg_betas_MBGroup_mbUtil)/sqrt(length(avg_betas_MBGroup_mbUtil));
errlow_mb =sem_mb_mbUtil;
errhigh_mb =sem_mb_mbUtil;


sem_mixture_mbUtil = nanstd(avg_betas_MixtureGroup_mbUtil)/sqrt(length(avg_betas_MixtureGroup_mbUtil));
errlow_mixture =sem_mixture_mbUtil;
errhigh_mixture =sem_mixture_mbUtil;

sem_mf_mbUtil = nanstd(avg_betas_MFGroup_mbUtil)/sqrt(length(avg_betas_MFGroup_mbUtil));
errlow_mf =sem_mf_mbUtil;
errhigh_mf =sem_mf_mbUtil;

sem_other_mbUtil = nanstd(avg_betas_OtherGroup_mbUtil)/sqrt(length(avg_betas_OtherGroup_mbUtil));
errlow_other =sem_other_mbUtil;
errhigh_other =sem_other_mbUtil;

SEM_3=[sem_mb_mbUtil;sem_mixture_mbUtil;sem_mf_mbUtil];
errlow_mbUtil_3=[errlow_mb;errlow_mixture;errlow_mf];
errhigh_mbUtil_3=[errhigh_mb;errhigh_mixture;errhigh_mf];

SEM_4=[sem_mb_mbUtil;sem_mixture_mbUtil;sem_mf_mbUtil;sem_other_mbUtil ];
errlow_mbUtil_4=[errlow_mb;errlow_mixture;errlow_mf;errlow_other];
errhigh_mbUtil_4=[errhigh_mb;errhigh_mixture;errhigh_mf;errhigh_other];


% Plot out MB/MF Value
close all
x=1:4;
types = {'MB','Mixture', 'MF', 'Other'};
hold on
% specify MB/MF Value variable
h(1)= bar([0.1, 0.22, 0.34, 0.46],avg_betas_mfUtil_4,'b','BarWidth',0.5,'EdgeColor','None');
hold on
% specify MB/MF Value variable
f=errorbar([0.1, 0.22, 0.34, 0.46],avg_betas_mfUtil_4,errlow_mfUtil_4,errhigh_mfUtil_4);
f.Color=[0 0 0];
f.LineStyle='None';
xlim([0 0.52])
xticks([0.1 0.22 0.34, 0.46])
hold on 
%ylim([-0.05 0.2]);
ylim([-0.3 0.7]);

hold on 

ylabel('Betas (arbitrary units)')

legend([h(1)],{'MF Value'})
set(gca,'xticklabels',types);
set(gca,'FontSize',22);


% Plot MB DV and MF DV across four groups

close all
x=1:4;

types = {'MB Group','Mixture Group', 'MF Group', 'Other Group'};
h(1)= bar([0.06, 0.18, 0.3, 0.42],avg_betas_mbUtil_4,'b','BarWidth',0.25,'EdgeColor','None');
hold on
f=errorbar([0.06, 0.18, 0.3, 0.42],avg_betas_mbUtil_4,errlow_mbUtil_4,errhigh_mbUtil_4);
f.Color=[0 0 0];
f.LineStyle='None';
hold on
h(2)= bar([0.1, 0.22, 0.34, 0.46],avg_betas_mfUtil_4,'r','BarWidth',0.25,'EdgeColor','None');
hold on
f=errorbar([0.1, 0.22, 0.34, 0.46],avg_betas_mfUtil_4,errlow_mfUtil_4,errhigh_mfUtil_4);
f.Color=[0 0 0];
f.LineStyle='None';
xlim([0 0.52])
xticks([0.08 0.2 0.32, 0.44])
ylim([-0.4 0.9]);
yticks([-0.2:0.2:0.8])
%ylabel('Beta Coefficients (arbitraty units)')
%title('vmPFC: Chosen-Rejected Utility ')

hold on 

x = [0.06, 0.18, 0.3];
y = avg_betas_mbUtil_3;
h(3)=plot(x,y,'--bo','MarkerSize',5,'MarkerEdgeColor','b');

x = [0.1, 0.22, 0.34];
y = avg_betas_mfUtil_3;
h(4)=plot(x,y,'--ro','MarkerSize',5,'MarkerEdgeColor','r');

legend([h(1) h(2)],{'MB Decision Value';'MF Decision Value'})
%set(gca,'xticklabels',types);
set(gca,'Xticklabel',[]) 
set(gca,'FontSize',20);



[h,p]=ttest(avg_betas_OtherGroup_mbUtil) % t-test of each sub-group's betas

[h,p]=ttest2(avg_betas_MBGroup_mbUtil,avg_betas_MFGroup_mbUtil) % two-sample t-test comparing MB Value signal across MB and MF groups
[h,p]=ttest2(avg_betas_MBGroup_mfUtil,avg_betas_MFGroup_mfUtil) % two-sample t-test comparing MF Value signal across MB and MF groups

% regression test of the linearity of MB/MF value across three RL groups 
all_betas_3_groups_mfUtil = vertcat(avg_betas_MBGroup_mfUtil, avg_betas_MixtureGroup_mfUtil, avg_betas_MFGroup_mfUtil);
all_betas_3_groups_mbUtil = vertcat(avg_betas_MBGroup_mbUtil, avg_betas_MixtureGroup_mbUtil, avg_betas_MFGroup_mbUtil);


mb_indicator = ones(size(avg_betas_MBGroup_mbUtil));
mixture_indicator = 2*ones(size(avg_betas_MixtureGroup_mbUtil));
mf_indicator = 3*ones(size(avg_betas_MFGroup_mbUtil));
other_indicator = 4*ones(size(avg_betas_OtherGroup_mbUtil));

ordinal_3_groups = vertcat(mb_indicator,mixture_indicator,mf_indicator);

% Regression test of linearity of MB value across three groups 
mdl = fitglm(ordinal_3_groups,all_betas_3_groups_mbUtil);

% Regression test of linearity of MF value across three groups 
mdl = fitglm(ordinal_3_groups,all_betas_3_groups_mfUtil);


% 2-by-2 anova test comparing MB and MF value across 4 sub-groups

all_betas_2_groups_mfUtil = vertcat(avg_betas_MBGroup_mfUtil, avg_betas_MFGroup_mfUtil);

all_betas_2_groups_mbUtil = vertcat(avg_betas_MBGroup_mbUtil, avg_betas_MFGroup_mbUtil);

all_betas_2_groups = vertcat(all_betas_2_groups_mfUtil,all_betas_2_groups_mbUtil);


ordinal_2_groups = vertcat(mb_indicator,mf_indicator);

ordinal_2_groups_2 = vertcat(ordinal_2_groups,ordinal_2_groups);



mf_value_type_indicator = ones(size(all_betas_2_groups_mfUtil));

mb_value_type_indicator = 2*ones(size(all_betas_2_groups_mbUtil));

ordinal_2_value_type_groups = vertcat(mf_value_type_indicator,mb_value_type_indicator);


% anova
ordinal_group_variable = ordinal_2_groups_2 ;

C = cell(size(ordinal_group_variable,1),1);
for i = 1:size(ordinal_group_variable,1)
    if ordinal_group_variable(i,1)==1
        C{i,1} ='MB';
    elseif ordinal_group_variable(i,1)==2
        C{i,1} ='Mixture';
    elseif ordinal_group_variable(i,1)==3
        C{i,1} ='MF';
    else 
        C{i,1} ='Other';
    end
     
    
end

value_type_variable = ordinal_2_value_type_groups;

V = cell(size(value_type_variable,1),1);
for i = 1:size(value_type_variable,1)
    if value_type_variable(i,1)==1
        V{i,1} ='MFV';
    else 
        V{i,1} ='MBV';
    end
     
    
end

p = anovan(all_betas_2_groups,{C V},'model',2,'varnames',{'group_type','value_type'});







   

%% SPE ROI analysis for each sub-groups

clear 
close all
% ROI betas in dlPFC
matName_MB_SPE =['ROI_betas/SPE_ROI_betas/dlPFC_glascher_MB_SPE_updated.mat'];
matName_Mixture_SPE =['ROI_betas/SPE_ROI_betas/dlPFC_glascher_Mixture_SPE_updated.mat'];
matName_MF_SPE =['ROI_betas/SPE_ROI_betas/dlPFC_glascher_MF_SPE_updated.mat'];
matName_Other_SPE =['ROI_betas/SPE_ROI_betas/dlPFC_glascher_Other_SPE_updated.mat'];

% ROI betas in IPS
matName_MB_SPE =['ROI_betas/SPE_ROI_betas/IPS_glascher_MB_SPE_updated.mat'];
matName_Mixture_SPE =['ROI_betas/SPE_ROI_betas/IPS_glascher_Mixture_SPE_updated.mat'];
matName_MF_SPE =['ROI_betas/SPE_ROI_betas/IPS_glascher_MF_SPE_updated.mat'];
matName_Other_SPE =['ROI_betas/SPE_ROI_betas/IPS_glascher_Other_SPE_updated.mat'];

% Load and obtain betas for SPE
load(matName_MB_SPE)
y=ROI_data;
MB_betas_SPE = mean(y,1);
avg_betas_MBGroup_SPE = mean(y,2);


load(matName_Mixture_SPE)
y=ROI_data;
Mixture_betas_SPE = mean(y,1);
avg_betas_MixtureGroup_SPE = mean(y,2);

load(matName_MF_SPE)
y=ROI_data;
MF_betas_SPE = mean(y,1);
avg_betas_MFGroup_SPE = mean(y,2);

load(matName_Other_SPE)
y=ROI_data;
Other_betas_SPE = mean(y,1);
avg_betas_OtherGroup_SPE = mean(y,2);


% average SPE
avg_betas_SPE_3=[mean(avg_betas_MBGroup_SPE);mean(avg_betas_MixtureGroup_SPE);mean(avg_betas_MFGroup_SPE)];

avg_betas_SPE_4=[nanmean(avg_betas_MBGroup_SPE);nanmean(avg_betas_MixtureGroup_SPE); nanmean(avg_betas_MFGroup_SPE); nanmean(avg_betas_OtherGroup_SPE)];

sem_mb_SPE = nanstd(avg_betas_MBGroup_SPE)/sqrt(length(avg_betas_MBGroup_SPE));
errlow_mb =sem_mb_SPE;
errhigh_mb =sem_mb_SPE;


sem_mixture_SPE = nanstd(avg_betas_MixtureGroup_SPE)/sqrt(length(avg_betas_MixtureGroup_SPE));
errlow_mixture =sem_mixture_SPE;
errhigh_mixture =sem_mixture_SPE;

sem_mf_SPE = nanstd(avg_betas_MFGroup_SPE)/sqrt(length(avg_betas_MFGroup_SPE));
errlow_mf =sem_mf_SPE;
errhigh_mf =sem_mf_SPE;

sem_other_SPE = nanstd(avg_betas_OtherGroup_SPE)/sqrt(length(avg_betas_OtherGroup_SPE));
errlow_other =sem_other_SPE;
errhigh_other =sem_other_SPE;

SEM_3=[sem_mb_SPE;sem_mixture_SPE;sem_mf_SPE];
errlow_SPE_3=[errlow_mb;errlow_mixture;errlow_mf];
errhigh_SPE_3=[errhigh_mb;errhigh_mixture;errhigh_mf];

SEM_4=[sem_mb_SPE;sem_mixture_SPE;sem_mf_SPE;sem_other_SPE];
errlow_SPE_4=[errlow_mb;errlow_mixture;errlow_mf;errlow_other];
errhigh_SPE_4=[errhigh_mb;errhigh_mixture;errhigh_mf;errhigh_other];


% Plot out SPE
close all
x=1:4;
types = {'MB','Mixture', 'MF', 'Other'};
hold on

h(1)= bar([0.1, 0.22, 0.34, 0.46],avg_betas_SPE_4,'b','BarWidth',0.5,'EdgeColor','None');
hold on

f=errorbar([0.1, 0.22, 0.34, 0.46],avg_betas_SPE_4,errlow_SPE_4,errhigh_SPE_4);
f.Color=[0 0 0];
f.LineStyle='None';
xlim([0 0.52])
xticks([0.1 0.22 0.34, 0.46])
hold on 
ylim([-0.05 0.2]);


hold on 

%ylabel('Betas (arbitrary units)')

legend([h(1)],{'SPE'})
set(gca,'xticklabels',{});
set(gca,'FontSize',22);



[h,p]=ttest(avg_betas_OtherGroup_SPE) % t-test of each sub-group's betas

all_betas_3_groups_SPE = vertcat(avg_betas_MBGroup_SPE, avg_betas_MixtureGroup_SPE, avg_betas_MFGroup_SPE);

mb_indicator = ones(size(avg_betas_MBGroup_SPE));
mixture_indicator = 2*ones(size(avg_betas_MixtureGroup_SPE));
mf_indicator = 3*ones(size(avg_betas_MFGroup_SPE));
other_indicator = 4*ones(size(avg_betas_OtherGroup_SPE));

ordinal_3_groups = vertcat(mb_indicator,mixture_indicator,mf_indicator);

% Regression test of linearity of SPE across three groups 
mdl = fitglm(ordinal_3_groups,all_betas_3_groups_SPE);




%% plot out SPE encoding in MB Group vs. MF Group

clear all
close all

matName_ROI1_mfVar =['ROI_betas/SPE_ROI_betas/dlPFC_glascher_MF_SPE_updated.mat'];
matName_ROI2_mfVar =['ROI_betas/SPE_ROI_betas/IPS_glascher_MF_SPE_updated.mat'];

matName_ROI1_mbVar =['ROI_betas/SPE_ROI_betas/dlPFC_glascher_MB_SPE_updated.mat'];
matName_ROI2_mbVar =['ROI_betas/SPE_ROI_betas/IPS_glascher_MB_SPE_updated.mat'];

% 1st-2nd stage MF/MB RPE (post-hoc) analysis


% Load and obtain betas for MF Var
load(matName_ROI1_mfVar)
y=ROI_data;
ROI1_betas_mfVar = nanmean(y,1);
avg_betas_ROI1_mfVar = nanmean(y,2);

load(matName_ROI2_mfVar)
y=ROI_data;
ROI2_betas_mfVar = nanmean(y,1);
avg_betas_ROI2_mfVar  = nanmean(y,2);


% Load and obtain betas for MB Var
load(matName_ROI1_mbVar)
y=ROI_data;
ROI1_betas_mbVar = nanmean(y,1);
avg_betas_ROI1_mbVar = nanmean(y,2);


load(matName_ROI2_mbVar)
y=ROI_data;
ROI2_betas_mbVar = nanmean(y,1);
avg_betas_ROI2_mbVar = nanmean(y,2);



% average MF RPE

avg_betas_mfVar_4=[mean(avg_betas_ROI1_mfVar); mean(avg_betas_ROI2_mfVar)];

sem_ROI1_mfVar = nanstd(avg_betas_ROI1_mfVar)/sqrt(length(avg_betas_ROI1_mfVar));
errlow_ROI1 =sem_ROI1_mfVar;
errhigh_ROI1 =sem_ROI1_mfVar;


sem_ROI2_mfVar = nanstd(avg_betas_ROI2_mfVar)/sqrt(length(avg_betas_ROI2_mfVar));
errlow_ROI2 =sem_ROI2_mfVar;
errhigh_ROI2 =sem_ROI2_mfVar;

SEM_4=[sem_ROI1_mfVar;sem_ROI2_mfVar];
errlow_mfVar_4=[errlow_ROI1;errlow_ROI2];
errhigh_mfVar_4=[errhigh_ROI1;errhigh_ROI2];

% average MB RPE

avg_betas_mbVar_4=[mean(avg_betas_ROI1_mbVar);mean(avg_betas_ROI2_mbVar)];

sem_ROI1_mbVar = nanstd(avg_betas_ROI1_mbVar)/sqrt(length(avg_betas_ROI1_mbVar));
errlow_ROI1 =sem_ROI1_mbVar;
errhigh_ROI1 =sem_ROI1_mbVar;


sem_ROI2_mbVar = nanstd(avg_betas_ROI2_mbVar)/sqrt(length(avg_betas_ROI2_mbVar));
errlow_ROI2 =sem_ROI2_mbVar;
errhigh_ROI2 =sem_ROI2_mbVar;


SEM_4=[sem_ROI1_mbVar;sem_ROI2_mbVar];
errlow_mbVar_4=[errlow_ROI1;errlow_ROI2];
errhigh_mbVar_4=[errhigh_ROI1;errhigh_ROI2];


% Plot
close all
x=1:2;

types = {'dlPFC','IPS'};
h(1)= bar([0.06, 0.18],avg_betas_mbVar_4,'b','BarWidth',0.25,'EdgeColor','None');
hold on
f=errorbar([0.06, 0.18],avg_betas_mbVar_4,errlow_mbVar_4,errhigh_mbVar_4);
f.Color=[0 0 0];
f.LineStyle='None';
hold on
h(2)= bar([0.1, 0.22],avg_betas_mfVar_4,'r','BarWidth',0.25,'EdgeColor','None');
hold on
f=errorbar([0.1, 0.22],avg_betas_mfVar_4,errlow_mfVar_4,errhigh_mfVar_4);
f.Color=[0 0 0];
f.LineStyle='None';
xlim([0 0.28])
xticks([0.08 0.2])
%yticks([-0.02 0 0.02 0.04 0.06])
ylim([0 0.18]);
ylabel('Betas (arbitrary units)')
title('Across-Group ROI Comparison: SPE ')
legend([h(1) h(2)],{'MB Group';'MF Group'})
set(gca,'xticklabels',types);

%set(gca,'xticklabels',[]);
set(gca,'FontSize',20);

[h,p] = ttest2(avg_betas_mbVar_4,avg_betas_mfVar_4)


all_betas_SPE = vertcat(avg_betas_ROI1_mbVar, avg_betas_ROI2_mbVar,avg_betas_ROI1_mfVar, avg_betas_ROI2_mfVar);

mb_indicator = ones(size(avg_betas_ROI1_mbVar));
mf_indicator = 0*ones(size(avg_betas_ROI1_mfVar));

r1_mb_indicator = ones(size(avg_betas_ROI1_mbVar));
r2_mb_indicator = 2*ones(size(avg_betas_ROI2_mbVar));
r1_mf_indicator = ones(size(avg_betas_ROI1_mfVar));
r2_mf_indicator = 2*ones(size(avg_betas_ROI2_mfVar));

categorical_2_regions = categorical(vertcat(r1_mb_indicator,r2_mb_indicator,r1_mf_indicator,r2_mf_indicator));


ordinal_2_groups = vertcat(mb_indicator,mb_indicator,mf_indicator,mf_indicator);

tbl = table(all_betas_SPE,ordinal_2_groups,categorical_2_regions);
% Regression test of linearity of SPE across three groups 
mdl = fitglm(tbl, 'all_betas_SPE ~ ordinal_2_groups*categorical_2_regions');



ordinal_group_variable = ordinal_2_groups ;

C = cell(size(ordinal_group_variable,1),1);
for i = 1:size(ordinal_group_variable,1)
    if ordinal_group_variable(i,1)==1
        C{i,1} ='MB_G';
    elseif ordinal_group_variable(i,1)==0
        C{i,1} ='MF_G';

    end
     
    
end

region_variable = double(categorical_2_regions);

V = cell(size(region_variable,1),1);
for i = 1:size(region_variable,1)
    if region_variable(i,1)==1
        V{i,1} ='dlPFC';
    else 
        V{i,1} ='IPS';
    end
     
    
end

p = anovan(all_betas_SPE,{C V},'model',2,'varnames',{'group_type','region_type'});



%% plot out region-wise MF/MB RPE in the striatum
% clear all
% close all
% 
% matName_ROI1_mfVar =['ROI_betas/RPE_ROI_betas/mfRPE_caudate_pauli_updated.mat'];
% matName_ROI2_mfVar =['ROI_betas/RPE_ROI_betas/mfRPE_ventral_striatum_pauli_updated.mat'];
% 
% matName_ROI1_mbVar =['ROI_betas/RPE_ROI_betas/mbRPE_caudate_pauli_updated.mat'];
% matName_ROI2_mbVar =['ROI_betas/RPE_ROI_betas/mbRPE_ventral_striatum_pauli_updated.mat'];
% 
% % 1st-2nd stage MF/MB RPE (post-hoc) analysis
% 
% matName_ROI1_mfVar =['ROI_betas/RPE_ROI_betas/caudate_posthoc_mfRPE_1st_2nd_updated.mat'];
% matName_ROI2_mfVar =['ROI_betas/RPE_ROI_betas/VS_posthoc_mfRPE_1st_2nd_updated.mat'];
% 
% matName_ROI1_mbVar =['ROI_betas/RPE_ROI_betas/caudate_posthoc_mbRPE_1st_2nd_updated.mat'];
% matName_ROI2_mbVar =['ROI_betas/RPE_ROI_betas/VS_posthoc_mbRPE_1st_2nd_updated.mat'];
% 
% 
% 
% 
% % Load and obtain betas for MF Var
% load(matName_ROI1_mfVar)
% y=ROI_data;
% ROI1_betas_mfVar = nanmean(y,1);
% avg_betas_ROI1_mfVar = nanmean(y,2);
% 
% load(matName_ROI2_mfVar)
% y=ROI_data;
% ROI2_betas_mfVar = nanmean(y,1);
% avg_betas_ROI2_mfVar  = nanmean(y,2);
% 
% 
% % Load and obtain betas for MB Var
% load(matName_ROI1_mbVar)
% y=ROI_data;
% ROI1_betas_mbVar = nanmean(y,1);
% avg_betas_ROI1_mbVar = nanmean(y,2);
% 
% 
% load(matName_ROI2_mbVar)
% y=ROI_data;
% ROI2_betas_mbVar = nanmean(y,1);
% avg_betas_ROI2_mbVar = nanmean(y,2);
% 
% 
% 
% % average MF RPE
% 
% avg_betas_mfVar_4=[mean(avg_betas_ROI1_mfVar); mean(avg_betas_ROI2_mfVar)];
% 
% sem_ROI1_mfVar = nanstd(avg_betas_ROI1_mfVar)/sqrt(length(avg_betas_ROI1_mfVar));
% errlow_ROI1 =sem_ROI1_mfVar;
% errhigh_ROI1 =sem_ROI1_mfVar;
% 
% 
% sem_ROI2_mfVar = nanstd(avg_betas_ROI2_mfVar)/sqrt(length(avg_betas_ROI2_mfVar));
% errlow_ROI2 =sem_ROI2_mfVar;
% errhigh_ROI2 =sem_ROI2_mfVar;
% 
% SEM_4=[sem_ROI1_mfVar;sem_ROI2_mfVar];
% errlow_mfVar_4=[errlow_ROI1;errlow_ROI2];
% errhigh_mfVar_4=[errhigh_ROI1;errhigh_ROI2];
% 
% % average MB RPE
% 
% avg_betas_mbVar_4=[mean(avg_betas_ROI1_mbVar);mean(avg_betas_ROI2_mbVar)];
% 
% sem_ROI1_mbVar = nanstd(avg_betas_ROI1_mbVar)/sqrt(length(avg_betas_ROI1_mbVar));
% errlow_ROI1 =sem_ROI1_mbVar;
% errhigh_ROI1 =sem_ROI1_mbVar;
% 
% 
% sem_ROI2_mbVar = nanstd(avg_betas_ROI2_mbVar)/sqrt(length(avg_betas_ROI2_mbVar));
% errlow_ROI2 =sem_ROI2_mbVar;
% errhigh_ROI2 =sem_ROI2_mbVar;
% 
% 
% SEM_4=[sem_ROI1_mbVar;sem_ROI2_mbVar];
% errlow_mbVar_4=[errlow_ROI1;errlow_ROI2];
% errhigh_mbVar_4=[errhigh_ROI1;errhigh_ROI2];
% 
% 
% % Plot
% close all
% x=1:2;
% 
% types = {'Caudate','Ventral Striatum'};
% h(1)= bar([0.06, 0.18],avg_betas_mbVar_4,'b','BarWidth',0.25,'EdgeColor','None');
% hold on
% f=errorbar([0.06, 0.18],avg_betas_mbVar_4,errlow_mbVar_4,errhigh_mbVar_4);
% f.Color=[0 0 0];
% f.LineStyle='None';
% hold on
% h(2)= bar([0.1, 0.22],avg_betas_mfVar_4,'r','BarWidth',0.25,'EdgeColor','None');
% hold on
% f=errorbar([0.1, 0.22],avg_betas_mfVar_4,errlow_mfVar_4,errhigh_mfVar_4);
% f.Color=[0 0 0];
% f.LineStyle='None';
% xlim([0 0.28])
% xticks([0.08 0.2])
% yticks([-0.02 0 0.02 0.04 0.06])
% ylim([-0.03 0.07]);
% ylabel('Betas (arbitrary units)')
% %title('ROI analysis: RPE ')
% legend([h(1) h(2)],{'MB RPE';'MF RPE'})
% set(gca,'xticklabels',types);
% 
% %set(gca,'xticklabels',[]);
% set(gca,'FontSize',22);
% 
% [h,p]=ttest(avg_betas_ROI2_mfVar)
% 
% all_betas_2_regions_mfRPE = vertcat(avg_betas_ROI1_mfVar, avg_betas_ROI2_mfVar);
% 
% all_betas_2_regions_mbRPE = vertcat(avg_betas_ROI1_mbVar, avg_betas_ROI2_mbVar);
% 
% all_betas_2_regions = vertcat(all_betas_2_regions_mfRPE,all_betas_2_regions_mbRPE);
% 
% 
% caudate_indicator = ones(size(avg_betas_ROI1_mfVar));
% VS_indicator = 2*ones(size(avg_betas_ROI2_mfVar));
% 
% 
% ordinal_2_groups = vertcat(caudate_indicator,VS_indicator);
% 
% ordinal_2_groups_2 = vertcat(ordinal_2_groups,ordinal_2_groups);
% 
% 
% 
% mf_RPE_type_indicator = ones(size(all_betas_2_regions_mfRPE));
% 
% mb_RPE_type_indicator = 2*ones(size(all_betas_2_regions_mbRPE));
% 
% ordinal_2_RPE_type_groups = vertcat(mf_RPE_type_indicator,mb_RPE_type_indicator);
% 
% 
% 
% % anova
% ordinal_group_variable = ordinal_2_groups_2;
% 
% C = cell(size(ordinal_group_variable,1),1);
% for i = 1:size(ordinal_group_variable,1)
%     if ordinal_group_variable(i,1)==1
%         C{i,1} ='Caudate';
%     else 
%         C{i,1} ='VS';
%     end
%      
%     
% end
% 
% RPE_type_variable = ordinal_2_RPE_type_groups;
% 
% V = cell(size(RPE_type_variable,1),1);
% for i = 1:size(RPE_type_variable,1)
%     if RPE_type_variable(i,1)==1
%         V{i,1} ='MFRPE';
%     else 
%         V{i,1} ='MBRPE';
%     end
%      
%     
% end
% 
% 
% p = anovan(all_betas_2_regions,{C V},'model',2,'varnames',{'region_type','value_type'});
% 
% 
% 
% 
