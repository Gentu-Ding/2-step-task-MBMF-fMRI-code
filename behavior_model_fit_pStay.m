%% behaviors

clear all
close all
tic;
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));


clear pStayStats

allFiles1 = readtable('ID_list.csv');

Sub_list = readtable('R01_control_clusterID_wMF_formal_updated.csv');

group_subs = Sub_list.ID;%(Sub_list.clusterID==4); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other

id=0;

for sI= 1:size(allFiles1,1)
    
    name = allFiles1.name{sI};
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
    if TF1==1
        
        id=id+1;
        allData = readtable(['Control_csv_sf/' name_sf '.csv' ]);
        %allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/supplementary_files_codes/generated_dataset/random_model/' name_sf '.csv' ]);
        
        
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
        
        
        
        pStayStats(id,1) = nanmean(isStay(isPrevRare == 0 & isPrevWin == 1 ));
        pStayStats(id,2) = nanmean(isStay(isPrevRare == 1 & isPrevWin == 1 ));
        pStayStats(id,3) = nanmean(isStay(isPrevRare == 0 & isPrevWin == 0 ));
        pStayStats(id,4) = nanmean(isStay(isPrevRare == 1 & isPrevWin == 0 ));
        
        
        sub_name{id,1}=name;
        
        
    end
    % end
    
    
end


commonWin = pStayStats(:,1);
commonLoss = pStayStats(:,3);
rareWin = pStayStats(:,2);
rareLoss = pStayStats(:,4);

SEM1 = nanstd(commonLoss)/sqrt(length(commonLoss));
errhigh1 = SEM1;
errlow1  = SEM1;

SEM2 = nanstd(commonWin)/sqrt(length(commonWin));
errhigh2 = SEM2;
errlow2  = SEM2;

SEM3 = nanstd(rareLoss)/sqrt(length(rareLoss));
errhigh3 = SEM3;
errlow3  = SEM3;

SEM4 = nanstd(rareWin)/sqrt(length(rareWin));
errhigh4 = SEM4;
errlow4  = SEM4;


% barplot
avg = nanmean(pStayStats,1);

SEM1 = nanstd(pStayStats)./sqrt(length(pStayStats));
errhigh1=SEM1;
errlow1=SEM1;

close all
figure(1)
types = {'Rewarded','Unrewarded'};

%types = {'Low','Medium','High'};
x=[1.05 1.95 3.05 3.95];
a=[avg(1),nan,avg(3),nan];
%a=[avg];
h1=bar(x,a,0.7,'b','EdgeColor', 'k');
hold on
%xticks([2 4])
a=[nan,avg(2),nan,avg(4)];
%a=[avg];
h2=bar(x,a,0.7,'r','EdgeColor', 'k');
hold on

%legend(h(1:2),'# of rewards >2','# of rewards <=2');
hold on

f = errorbar(x,avg,errlow1,errhigh1);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';

ylim([0 1]);

ylabel('Probability of Stay');
%title('Simulation: Random Agent');
xticks([1.5,3.5]);
set(gca,'xticklabel',types);
legend([h1, h2],'Common','Rare');
set(gca,'FontSize',20);


%lineplot


close all
figure(1)
subplot(1,2,1)
x = 1:2;
y = [nanmean(commonLoss) nanmean(commonWin)];

plot(x, y, '-ok','MarkerFaceColor','k')

hold on;

errlow = [errlow1 errlow2];
errhigh = [errhigh1 errhigh2];
%err = ones(size(x));
f = errorbar(x,y,errlow,errhigh);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
hold on;


xlim([0 3]);
ylim([0 1]);
%errorbar(x, y, err, 'LineStyle','none');
xticklabels({'','No-R','R',''})
title('Common')
ylabel('Probability of Stay')

set(gca,'FontSize',20);

subplot(1,2,2)

x = 1:2;
y = [nanmean(rareLoss) nanmean(rareWin)];

a1=plot(x, y, '-ok','MarkerFaceColor','k');

hold on;

errlow = [errlow3 errlow4];
errhigh = [errhigh3 errhigh4];
%err = ones(size(x));
f = errorbar(x,y,errlow,errhigh);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
hold on; 
xlim([0 3]);
ylim([0 1]);

 
xticklabels({'','No-R','R',''})
title('Rare')
set(gca,'FontSize',20);
%legend ([a1,a2],{'high mbRPE';'low mbRPE'})
legend (a1,{'Behavior'},'Location', 'northeast')
%legend ([a1,a2],{'high SPE';'low SPE'})





%% model predictions

id=0;

clear pStayStats_model

% Use quickly-derived stay probability
for sI=1:size(allFiles1,1)
    
    
    
    name = allFiles1.name{sI};
    
    
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];
    
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
    if TF1==1
    
        
        allData = readtable(['Control_csv_sf/' name_sf '.csv' ]);
              

        id=id+1;
        subData = allData;
        
        
        
        data = struct('trialID',subData.trialID, 'doRareTrans', subData.doRareTrans, ...
            'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
            'outcome2', subData.outcome2 , 'outcomeMag', subData.outcomeMag,...
            'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
            'condState', subData.condState,'condContingency', subData.condContingent,...
            'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
            'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);

        
        nameMat = ['lap_subjects_sfMRI/lap_control_mbmf_wsls_arb_magMF_binMB_mbRPE_mfRPE_SPE/lap_' name_sf '.mat' ];

        
        load(nameMat)
        
        
        params = cbm.output.parameters;
        
              
        clear negLLE
        
        [negLLE, fitData] = comp_getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, data);


        pOption = fitData.pOption(2:end,:);
        isStay = nan(size(subData,1),1);
        
        for j = 1:size(pOption,1)
            if ~isnan(fitData.choice(j))
                isStay(j,1) = pOption(j,fitData.choice(j));
            end
        end
        
        pStay = [nan isStay(1:end-1)']';
        

        %isStay = [nan [fitData.resp1(1:end-1) == fitData.resp1(2:end)]']';
        isPrevRare = [nan subData.doRareTrans(1:end-1)']';
        isPrevWin = [nan subData.outcomeBin(1:end-1)']';
        
         
        dataTID = subData.trialID;
        
        runID=-1;
        % loop through all trials
        for tI = 1 : size(dataTID,1)
            % should learned values be reset
            if subData.runID(tI) ~= runID
                % update the ID
                runID= subData.runID(tI);
                
                isStay(tI,1)=nan;
                isPrevRare(tI,1)=nan;
                isPrevWin(tI,1)=nan;
                
            end
        end
        

        pStayStats_model(id,1) = nanmean(pStay(isPrevRare == 0 & isPrevWin == 1 ));
        pStayStats_model(id,2) = nanmean(pStay(isPrevRare == 1 & isPrevWin == 1 ));
        pStayStats_model(id,3) = nanmean(pStay(isPrevRare == 0 & isPrevWin == 0 ));
        pStayStats_model(id,4) = nanmean(pStay(isPrevRare == 1 & isPrevWin == 0 ));
        
     
        
        sub_name{id,1}=name;
        
    end
    
    
    
end


commonWin_model = pStayStats_model(:,1);
commonLoss_model = pStayStats_model(:,3);
rareWin_model = pStayStats_model(:,2);
rareLoss_model = pStayStats_model(:,4);



% Overall SEM
SEM1 = nanstd(commonLoss_model)/sqrt(length(commonLoss_model));
errhigh1_model = SEM1;
errlow1_model  = SEM1;

SEM2 = nanstd(commonWin_model)/sqrt(length(commonWin_model));
errhigh2_model = SEM2;
errlow2_model  = SEM2;

SEM3 = nanstd(rareLoss_model)/sqrt(length(rareLoss_model));
errhigh3_model = SEM3;
errlow3_model  = SEM3;

SEM4 = nanstd(rareWin_model)/sqrt(length(rareWin_model));
errhigh4_model = SEM4;
errlow4_model  = SEM4;



% lineplot
close all
subplot(1,2,1)
x = 1:2;
y = [nanmean(commonLoss) nanmean(commonWin)];

plot(x, y, '-ok','MarkerFaceColor','k')

hold on;

errlow = [errlow1 errlow2];
errhigh = [errhigh1 errhigh2];
%err = ones(size(x));
f = errorbar(x,y,errlow,errhigh);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
hold on;

x = 1:2; xm1 = x;
y = [nanmean(commonLoss_model) nanmean(commonWin_model)];

plot(xm1, y, '--ok')

hold on;

errlow = [errlow1_model errlow2_model];
errhigh = [errhigh1_model errhigh2_model];
%err = ones(size(x));
f = errorbar(x,y,errlow,errhigh);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
hold on;

xlim([0 3]);
ylim([0 1]);
%errorbar(x, y, err, 'LineStyle','none');
xticklabels({'','No-R','R',''})
title('Common','FontWeight', 'normal')
ylabel('Probability of Stay')

set(gca,'FontSize',18);

subplot(1,2,2)

x = 1:2;
y = [nanmean(rareLoss) nanmean(rareWin)];

a1=plot(x, y, '-ok','MarkerFaceColor','k');

hold on;

errlow = [errlow3 errlow4];
errhigh = [errhigh3 errhigh4];
%err = ones(size(x));
f = errorbar(x,y,errlow,errhigh);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
hold on;

x = 1:2; xm1 = x;
y = [nanmean(rareLoss_model) nanmean(rareWin_model)];
a2=plot(xm1, y, '--ok');
hold on;
%err = ones(size(x));
errlow = [errlow3_model errlow4_model];
errhigh = [errhigh3_model errhigh4_model];
f = errorbar(x,y,errlow,errhigh);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';

hold on 
xlim([0 3]);
ylim([0 1]);
  
xticklabels({'','No-R','R',''})
title('Rare','FontWeight', 'normal')
set(gca,'FontSize',18);
%legend ([a1,a2],{'high mbRPE';'low mbRPE'})
legend ([a1,a2],{'Behavior';'Model'},'Location', 'southeast')
%legend ([a1,a2],{'high SPE';'low SPE'})



%
avg = nanmean(pStayStats,1);

SEM1 = nanstd(pStayStats)./sqrt(length(pStayStats));
errhigh1=SEM1;
errlow1=SEM1;

avg_model = nanmean(pStayStats_model,1);

SEM1_model = nanstd(pStayStats_model)./sqrt(length(pStayStats_model));
errhigh1_model=SEM1_model;
errlow1_model=SEM1_model;


close all
figure(1)

%set(gcf, 'Units','inches', 'Position', figPos);

types = {'Rewarded';'Unrewarded'};

%types = {'Low','Medium','High'};
x=[1.05 1.95 3.05 3.95];
b1=[avg(1),nan,avg(3),nan];
%a=[avg];
blue = [0 0 1];
red  = [1 0 0];

hb1=bar(x,b1,0.7,'FaceColor', blue,'EdgeColor', 'k');
hold on
%xticks([2 4])

b2=[nan,avg(2),nan,avg(4)];
%a=[avg];

hb2=bar(x,b2,0.7,'FaceColor', red,'EdgeColor', 'k');
hold on

f = errorbar(x,avg,errlow1,errhigh1);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
hold on

% model
%x=[1 2 3 4];
%a=[avg];

xm1 = x(1:2)+0.1;

hm1=plot(xm1,avg_model(1:2),'--ok',...
    'LineWidth',2,...
    'MarkerSize',8);
hold on

f = errorbar(xm1,avg_model(1:2),errlow1_model(1:2),errhigh1_model(1:2));    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
%xticks([2 4])
hold on

xm2 = x(3:4)+0.1;

hm2=plot(xm2,avg_model(3:4),'--ok',...
    'LineWidth',2,...
    'MarkerSize',8);
hold on

f = errorbar(xm2,avg_model(3:4),errlow1_model(3:4),errhigh1_model(3:4));    
f.Color = [0 0 0];                            
f.LineStyle = 'none';
XL=xlim();
%xticks([2 4])
hold on

c1 = patch(NaN,NaN,[0 0 1],'EdgeColor', 'none');
c2 = patch(NaN,NaN,[1 0 0],'EdgeColor', 'none');
p1 = patch(NaN,NaN,[1 1 1]);

hold on

ylim([0 1.3]);
yticks([0 0.2 0.4 0.6 0.8 1])
%xlim([XL(1) XL(2)+0.5])
ylabel('Probability of Stay');
%title('Mixture Group');
xticks([1.5,3.5]);
%xlim([1 5])
%xticks([1 2 3 4]);
set(gca,'xticklabel',types);
%title('Mixture Group')

ax1 = gca;
l1=legend(ax1, [c1 c2], {'Common','Rare'},'Location','Northeast');
%l1.Box = 'off';
set(gca,'FontSize',20);

ax2 = axes('Position', ax1.Position, 'Visible', 'off', 'HitTest', 'off');

% Second legend on the invisible axes
l2 = legend(ax2, [p1 hm1], {'Behavior','Model'}, 'Location', 'Northwest');
set(gca,'FontSize',20);


