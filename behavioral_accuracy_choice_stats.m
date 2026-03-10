
clear all;
close all;
tic;
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));

allFiles1 = readtable('ID_list.csv');

for sI = 1:size(allFiles1,1)
    
    name = allFiles1.name{sI};
    
    ID = name(4:7);
    
    
    % point to the director with data we want to fit
    %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
    
    allData = readtable(['Control_csv_sf/' name]);
       
    %allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/supplementary_files_codes/generated_dataset/mf_model/' name ]);
        
    
    subData = allData;
    
    
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
    
    RT(sI,1) = mean(subData.RT1(~isnan(subData.outcomeBin)));
    
    
    
    
    rng(25);
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
    
    IDs_acc(sI,1) = str2num(ID);
    
    %end
    
end


[h,p,ci,stats] =ttest(acc,acc_random);

close all
figure(1)

h1 = histogram(acc_random, 'BinWidth',0.01);
%h.NumBins = 7;
xlim([0.3 0.6])
%ylim([0 8])
h1.FaceColor = [0 0.5 0.7];
h1.EdgeColor = 'b';
%xlabel('Proportion of Rewarded Trials')
%ylabel('Number of Participants')
%title('All Groups (N=179)')

hold on
h2 = histogram(acc, 'BinWidth',0.01);
%h.NumBins = 12;
%ylim([0 30])
legend({"random agent";'behavior'})
set(gca,'FontSize',18);


% Performance of sub-groups

Sub_list = readtable('R01_control_clusterID_wMF_formal_updated.csv');

group_subs = Sub_list.ID(Sub_list.clusterID==1); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other

idx = ismember(IDs_acc,group_subs);

acc_Mixture = acc(idx);

idx_random= sort(randsample(179,sum(idx)));

acc_random_Mixture = acc_random(idx_random);


group_subs = Sub_list.ID(Sub_list.clusterID==2); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other

idx = ismember(IDs_acc,group_subs);

acc_MF = acc(idx);

idx_random= sort(randsample(179,sum(idx)));

acc_random_MF = acc_random(idx_random);



group_subs = Sub_list.ID(Sub_list.clusterID==3); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other

idx = ismember(IDs_acc,group_subs);

acc_MB = acc(idx);

idx_random= sort(randsample(179,sum(idx)));

acc_random_MB = acc_random(idx_random);



group_subs = Sub_list.ID(Sub_list.clusterID==4); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other

idx = ismember(IDs_acc,group_subs);

acc_Other = acc(idx);

idx_random= sort(randsample(179,sum(idx)));

acc_random_Other = acc_random(idx_random);


[h,p]=ttest2(acc_Other, acc_random_Other)

close all
figure(1)

h = histogram(acc_MF, 'BinWidth',0.01);
h.NumBins = 7;
xlim([0.3 0.6])
%ylim([0 8])
h1.FaceColor = [0 0.5 0.7];
h1.EdgeColor = 'b';
xlabel('Proportion of Rewarded Trials')
ylabel('Number of Participants')
title('MF Group')
set(gca,'FontSize',18);


close all
figure(1)
subplot(4,1,1)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range
hold on;
histogram(acc_random_Mixture, 'NumBins', 8, 'FaceAlpha', 0.5);
hold on
histogram(acc_Mixture, 'NumBins', 8, 'FaceAlpha', 0.5);
hold off;
%xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('Mixture Group')
ylim([0 15])
xlim([0.35 0.65])
set(gca,'FontSize',18);

subplot(4,1,2)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range
hold on;
histogram(acc_random_MF, 'NumBins', 8, 'FaceAlpha', 0.5);
hold on
histogram(acc_MF, 'NumBins', 8, 'FaceAlpha', 0.5);
hold off;
%xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('MF Group')
ylim([0 15])
xlim([0.35 0.65])
set(gca,'FontSize',18);

subplot(4,1,3)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range
hold on;
histogram(acc_random_MB, 'NumBins', 8, 'FaceAlpha', 0.5);
hold on
histogram(acc_MB, 'NumBins', 8, 'FaceAlpha', 0.5);
hold off;
%xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('MB Group')
ylim([0 15])
xlim([0.35 0.65])
set(gca,'FontSize',18);

subplot(4,1,4)

%edges = linspace(min([data1]), max([data1]), 12);  % 30 bins over shared range
hold on;
histogram(acc_random_Other, 'NumBins', 8, 'FaceAlpha', 0.5);
hold on
histogram(acc_Other, 'NumBins', 8, 'FaceAlpha', 0.5);
hold off;
xlabel('Proportion of Rewarded Trials')
ylabel('# of Participants')
title('Other Group')
ylim([0 15])
xlim([0.35 0.65])
set(gca,'FontSize',18);
legend({"Random agents";'Behaviors'})


%% behavioral bar plot of stay probability


clear all
close all
tic;
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));


clear pStayStats

allFiles1 = readtable('ID_list.csv');


for sI= 1:size(allFiles1,1)
    
    name = allFiles1.name{sI};
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];
    
    ID = str2double(name(4:7));
    
    
    allData = readtable(['Control_csv_sf/' name_sf '.csv' ]);
    
    
    subData = allData; %(allData.condContingent==2,:);
    
    isStay = [nan [subData.Resp1(1:end-1) == subData.Resp1(2:end)]']';
    isPrevRare = [nan subData.doRareTrans(1:end-1)']';
    isPrevWin = [nan subData.outcomeBin(1:end-1)']';
    
    
    
    dataTID = subData.trialID;
    
    runID=-1;
    % loop through all trials
    for tI = 1 : size(dataTID,1)
        % should learned values be reset
        if subData.runID(tI,1) ~=runID
            % update the ID
            runID=subData.runID(tI);
            
            isStay(tI,1)=nan;
            isPrevRare(tI,1)=nan;
            isPrevWin(tI,1)=nan;
            
            
        end
    end
    
    
    
    
    
    pStayStats(sI,1) = nanmean(isStay(isPrevRare == 0 & isPrevWin == 1 ));
    pStayStats(sI,2) = nanmean(isStay(isPrevRare == 1 & isPrevWin == 1 ));
    pStayStats(sI,3) = nanmean(isStay(isPrevRare == 0 & isPrevWin == 0 ));
    pStayStats(sI,4) = nanmean(isStay(isPrevRare == 1 & isPrevWin == 0 ));
    
    
    sub_name{sI,1}=name;
    
    
    
    % end
    
    
end


avg = nanmean(pStayStats,1);

SEM1 = nanstd(pStayStats)./sqrt(length(pStayStats));
errhigh1=SEM1;
errlow1=SEM1;

close all
figure(1)
%types = {'rewarded','unrewarded'};

%types = {'Low','Medium','High'};
a=[avg(1),nan,avg(3),nan];
%a=[avg];
h(1)=bar(a,0.7,'b','EdgeColor', 'none');
hold on
%xticks([2 4])
a=[nan,avg(2),nan,avg(4)];
%a=[avg];
h(2)=bar(a,0.7,'r','EdgeColor', 'none');
hold on


%legend(h(1:2),'# of rewards >2','# of rewards <=2');
hold on
x=1:4;

f = errorbar(x,avg,errlow1,errhigh1);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';

ylim([0 1]);

%ylabel('Stay Probability');
%title('Overall Group-Level Behaviors');
xticks([1.5,3.5]);
set(gca,'xticklabel',{});
legend([h(1), h(2)],'Common','Rare');
set(gca,'FontSize',18);


