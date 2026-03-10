%% Run after the script of cluster feature computations:
clear all
close all

r21_centroid_table = readtable('R21_group_centroids.csv');
mix_centroid = table2array(r21_centroid_table(1,2:end));
mf_centroid = table2array(r21_centroid_table(2,2:end));
mb_centroid = table2array(r21_centroid_table(3,2:end));
other_centroid = table2array(r21_centroid_table(4,2:end));

cluster_R01_table = readtable('R01_control_cluster_features_3Arb_logRT_without_groupID_updated.csv');

selected_ID = table2array(cluster_R01_table(:,1));

X = table2array(cluster_R01_table(:,2:end));


for i =1:size(X,1)
    
    point = X(i,:);
    
    dist_1 = (point-mix_centroid)*(point-mix_centroid)';
    dist_2 = (point-mf_centroid)*(point-mf_centroid)';
    dist_3 = (point-mb_centroid)*(point-mb_centroid)';
    dist_4 = (point-other_centroid)*(point-other_centroid)';
    
    dist_set = [dist_1 dist_2 dist_3 dist_4];
    index = find(dist_set == min(dist_set));
    
    R01_subID(i,1) = selected_ID(i);
    clusterID_R01_assigned(i,1) = index;
    
end



for i = 1:size(clusterID_R01_assigned,1)
    
    label = clusterID_R01_assigned(i,1);
    if label==1
        groupID{i,1} = 'Mixture';
    elseif label==2
        groupID{i,1} ='MF';
    elseif label==3
        groupID{i,1} ='MB';
    elseif label==4
        groupID{i,1}='Other';
    end
end

cluster_R01_table.groupID = groupID;

writetable(cluster_R01_table,'R01_control_cluster_features_3Arb_logRT_updated.csv');




%% plot outcome vs. outcome-transition with centroids from external datasets (Cockburn et al., 2024)

clear all
close all


r21_centroid_table = readtable('R21_group_centroids.csv');
mix_centroid = table2array(r21_centroid_table(1,2:end));
mf_centroid = table2array(r21_centroid_table(2,2:end));
mb_centroid = table2array(r21_centroid_table(3,2:end));
other_centroid = table2array(r21_centroid_table(4,2:end));


R01_table = readtable('R01_control_cluster_features_3Arb_logRT_updated.csv');
outcome_r01 = R01_table.outcome_CHOICE;
outcome_transition_r01 = R01_table.outcome_transition_CHOICE;

groupID = R01_table.groupID;

subID = R01_table.subID;

for i = 1:size(groupID,1)
    
    label = groupID{i};
    
    if contains(label,'Mixture') 
        id_cluster(i,1) = 1;
    elseif contains(label,'MF') 
        id_cluster(i,1) = 2;
    elseif contains(label,'MB') 
        id_cluster(i,1) = 3;
    elseif contains(label,'Other') 
        id_cluster(i,1) = 4;
    end
    
    
end
    


outcome_r21c_mb = mb_centroid(1,3);
outcome_transition_r21c_mb =mb_centroid(1,4); 

outcome_r21c_mf = mf_centroid(1,3);
outcome_transition_r21c_mf =mf_centroid(1,4); 

outcome_r21c_mix = mix_centroid(1,3);
outcome_transition_r21c_mix =mix_centroid(1,4); 

outcome_r21c_other = other_centroid(1,3);
outcome_transition_r21c_other =other_centroid(1,4); 


includeID_table = readtable('ID_list.csv');

for i = 1:size(includeID_table,1)
    
   include_IDs(i,1) = str2double(includeID_table.name{i}(4:7)); 
    
end

include_index = ismember(subID,include_IDs);


close all
figure(1)
    
sz1=80;

MFA=1;
R01_clusterID=id_cluster(include_index);

outcome_r01_179 = outcome_r01(include_index);
outcome_transition_r01_179 = outcome_transition_r01(include_index);

x=outcome_r01_179(R01_clusterID==1);
y=outcome_transition_r01_179(R01_clusterID==1);

c1=scatter(x,y,sz1,'g','MarkerFaceAlpha',MFA);

hold on

d1=scatter(outcome_r21c_mix,outcome_transition_r21c_mix,270,"d",'g','filled');

hold on
x=outcome_r01_179(R01_clusterID==2);
y=outcome_transition_r01_179(R01_clusterID==2);

c2=scatter(x,y,sz1,'r','MarkerFaceAlpha',MFA);
hold on

d2=scatter(outcome_r21c_mf,outcome_transition_r21c_mf,270,"d",'r','filled');
hold on

x=outcome_r01_179(R01_clusterID==3);
y=outcome_transition_r01_179(R01_clusterID==3);


c3=scatter(x,y,sz1,'b','MarkerFaceAlpha',MFA);
hold on
d3=scatter(outcome_r21c_mb,outcome_transition_r21c_mb,270,"d",'b','filled');
hold on


x=outcome_r01_179(R01_clusterID==4);
y=outcome_transition_r01_179(R01_clusterID==4);


c4=scatter(x,y,sz1,[.7 .7 .7], 'MarkerFaceAlpha',MFA);
hold on
d4=scatter(outcome_r21c_other,outcome_transition_r21c_other,270,[.7 .7 .7],"d",'filled');
hold on


%xlabel('Outcome Coefficient')
%ylabel('Outcome-Transition Coefficient')

set(gca,'FontSize',20);

legend([c1;c2;c3;c4],{'Mixture Group'; 'MF Group'; 'MB Group'; 'Other Group'},'Location', 'southeast')



