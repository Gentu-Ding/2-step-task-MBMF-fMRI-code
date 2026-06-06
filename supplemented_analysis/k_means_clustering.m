clear all
close all

clusterTable = readtable('../R01_control_cluster_features_3Arb_logRT_without_groupID_updated.csv');

subID = clusterTable.subID;

X = table2array(clusterTable(:,2:end));

eva = evalclusters(X, 'kmeans', 'silhouette', 'KList', 2:10);
eva.OptimalK

maxK = 10;
silh = zeros(maxK,1);

for k = 2:maxK   % silhouette undefined for k=1
    idx = kmeans(X, k, 'Replicates', 20);
    silh(k) = mean(silhouette(X, idx));
end

figure;
plot(1:maxK, silh, '-o');
xlabel('Number of clusters (k)');
ylabel('Mean silhouette value');

[idx,C] = kmeans(X,4,'emptyaction','singleton','Replicates',50);


mix_centroid = C(2,:);
mf_centroid = C(4,:);
mb_centroid = C(3,:);
other_centroid = C(1,:);


outcome_r01c_mb = mb_centroid(1,3);
outcome_transition_r01c_mb =mb_centroid(1,4); 

outcome_r01c_mf = mf_centroid(1,3);
outcome_transition_r01c_mf =mf_centroid(1,4); 

outcome_r01c_mix = mix_centroid(1,3);
outcome_transition_r01c_mix =mix_centroid(1,4); 

outcome_r01c_other = other_centroid(1,3);
outcome_transition_r01c_other =other_centroid(1,4); 

includeID_table = readtable('ID_list.csv');

for i = 1:size(includeID_table,1)
    
   include_IDs(i,1) = str2double(includeID_table.name{i}(4:7)); 
    
end

include_index = ismember(subID,include_IDs);



outcome_r01 = clusterTable.outcome_CHOICE;
outcome_transition_r01 = clusterTable.outcome_transition_CHOICE;


id_cluster(idx==1,1) =4;
id_cluster(idx==2,1) =1;
id_cluster(idx==3,1) =3;
id_cluster(idx==4,1) =2;


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

d1=scatter(outcome_r01c_mix,outcome_transition_r01c_mix,270,'g','filled');
d1.Marker = 'd';

hold on
x=outcome_r01_179(R01_clusterID==2);
y=outcome_transition_r01_179(R01_clusterID==2);

c2=scatter(x,y,sz1,'r','MarkerFaceAlpha',MFA);
hold on

d2=scatter(outcome_r01c_mf,outcome_transition_r01c_mf,270,'r','filled');
d2.Marker = 'd';
hold on

x=outcome_r01_179(R01_clusterID==3);
y=outcome_transition_r01_179(R01_clusterID==3);


c3=scatter(x,y,sz1,'b','MarkerFaceAlpha',MFA);
hold on
d3=scatter(outcome_r01c_mb,outcome_transition_r01c_mb,270,'b','filled');
d3.Marker = 'd';
hold on


x=outcome_r01_179(R01_clusterID==4);
y=outcome_transition_r01_179(R01_clusterID==4);


c4=scatter(x,y,sz1,[.7 .7 .7], 'MarkerFaceAlpha',MFA);
hold on

d4=scatter(outcome_r01c_other,outcome_transition_r01c_other,270,[.7 .7 .7],'filled');
d4.Marker = 'd';
hold on


xlabel('outcome coefficient')
ylabel('outcome-transition coefficient')

set(gca,'FontSize',20);

legend([c1;c2;c3;c4],{'Mixture'; 'MF'; 'MB'; 'Other'}, 'Location', 'southeast');



r21_clusterTable=readtable('../R01_control_clusterID_wMF_formal_updated.csv');

R21_clusterID = r21_clusterTable.clusterID(include_index);
R01_clusterID = id_cluster(include_index);



j=0;
k12=0;
k13=0;
k14=0;
k21=0;
k23=0;
k24=0;
k31=0;
k32=0;
k34=0;
k41=0;
k42=0;
k43=0;

for i =1:size(R21_clusterID,1)
    if R01_clusterID(i)~=R21_clusterID(i)
        j=j+1;
        
        if R21_clusterID(i)==1 && R01_clusterID(i)==2
            k12=k12+1;
        end
  
        if R21_clusterID(i)==1 && R01_clusterID(i)==3
            k13=k13+1;
        end
        
        if R21_clusterID(i)==1 && R01_clusterID(i)==4
            k14=k14+1;
        end
        
        
        if R21_clusterID(i)==2 && R01_clusterID(i)==1
            k21=k21+1;
        end
  
        if R21_clusterID(i)==2 && R01_clusterID(i)==3
            k23=k23+1;
        end
        
        if R21_clusterID(i)==2 && R01_clusterID(i)==4
            k24=k24+1;
        end
        
        
        if R21_clusterID(i)==3 && R01_clusterID(i)==1
            k31=k31+1;
        end
  
        if R21_clusterID(i)==3 && R01_clusterID(i)==2
            k32=k32+1;
        end
        
        if R21_clusterID(i)==3 && R01_clusterID(i)==4
            k34=k34+1;
        end
        
        
        if R21_clusterID(i)==4 && R01_clusterID(i)==1
            k41=k41+1;
        end
  
        if R21_clusterID(i)==4 && R01_clusterID(i)==2
            k42=k42+1;
        end
        
        if R21_clusterID(i)==4 && R01_clusterID(i)==3
            k43=k43+1;
        end
        
        
        
        
        
            
    end
end

close 
figure(1)
label_change=[k12 k13 k14 k21 k23 k24 k31 k32 k34 k41 k42 k43]';
bar(label_change)
xticklabels({'Mix\rightarrowMF'; 'Mix\rightarrowMB' ;'Mix\rightarrowOther'; 'MF\rightarrowMix';'MF\rightarrowMB';'MF\rightarrowOther';'MB\rightarrowMix' ;'MB\rightarrowMF';'MB\rightarrowOther';'Other\rightarrowMix';'Other\rightarrowMF';'Other\rightarrowMB'})
ax=gca;
ax.FontSize=20;
ylim([0 20])
ylabel('Participant Counts')
title('Clustering Group Change: External Sample \rightarrow Current Sample ')


r01_table = r21_clusterTable(:,1:2);

r01_table.clusterID=id_cluster;

writetable(r01_table,'R01_control_clusterID_wMF_formal_updated_insample.csv')
