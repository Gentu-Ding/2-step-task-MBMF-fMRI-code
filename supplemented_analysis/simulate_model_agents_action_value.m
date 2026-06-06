clear all
close all
tic;
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));

%task_MBMF_sim = initTask();

%allFiles1=dir('/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/sub*.csv');

allFiles1 = readtable('../ID_list.csv');

Sub_list = readtable('../R01_control_clusterID_wMF_formal_updated.csv');

group_subs = Sub_list.ID(Sub_list.clusterID==2); % dictionary: 1-Mixture, 2-MF, 3-MB, 4-Other


clear pStayStats_model
clear params
id=0;
% Simulate data from scratch
for sI=1:size(allFiles1,1)
    
    
      
    name = allFiles1.name{sI};
    
    name_f = [name(1:7) name(end-5:end-4)];
    
    name_sf = [name(1:7) name(end-7:end-4)];
    
    ID = str2double(name(4:7));
    
    TF1 = ismember(ID,group_subs);
    
   
    
    if TF1==1
    
  
        id=id+1;
        % point to the director with data we want to fit
        %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
        
        allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/' name_sf]);
        
        %allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/supplementary_files_codes_v1/designs_7/designs_7/set' num2str(id) '.csv']);
        
        %sI=1;
        subData = allData;
        
               
        Exist_Column = strcmp('runID',subData.Properties.VariableNames);
        if sum(Exist_Column)==0
            runID1 = ones(size(subData,1)/2,1);
            runID2 = 2*ones(size(subData,1)/2,1);
            
            subData.runID = vertcat(runID1,runID2);
        end
        
    
        
        subData.isPost_ContState = ones(size(subData,1),1);
        
        subData.isPost_StateLow = ones(size(subData,1),1);
        
        subData.isPost_RewHigh = ones(size(subData,1),1);
        

        % Model without WSLS component
        
        clear params fitData
        nameMat = ['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/lap_subjects_sfMRI/lap_control_mbmf_magMF_binMB_MF/lap_' name_sf '.mat' ];
        


        load(nameMat)
        params = cbm.output.parameters;
        
       
       
        [negLLE, fitData] = generateData_magMF_binMB_MF_rewMag(params, subData);
        
        isCurrWin = fitData.outcomeBin;
        
        isCurrRare = fitData.doRareTrans;
        
        qDiff_CU = fitData.qDiff_ChosenUnchosen;
        
        wWSLS = fitData.wWSLS;
        
        Chosen_wsls = fitData.Chosen_wsls;
        
        Unchosen_wsls = fitData.Unchosen_wsls;
        
        ChosenV = fitData.ChosenV;
        UnchosenV = fitData.UnchosenV;
        
        vDiff = fitData.pChosenV - fitData.pUnchosenV; % value difference post current-trial update
        
                
        ChosenQ = fitData.ChosenQ;
        UnchosenQ = fitData.UnchosenQ;
        
        qDiff  = ChosenQ - UnchosenQ;
        
        
        value_update = fitData.value_update;
        
        %WSLS_update = fitData.WSLS_update;

 
       
        % isStay = nan(size(subData,1),1);
        

        isStay = [nan; fitData.resp1(1:end-1)==fitData.resp1(2:end)];
        
     
        
        %isStay = [nan [fitData.resp1(1:end-1) == fitData.resp1(2:end)]']';
        isPrevRare = [nan fitData.doRareTrans(1:end-1)']';
        isPrevWin = [nan fitData.outcomeBin(1:end-1)']';
        

        
        condReward = [nan subData.condReward(1:end-1)']';
        condState = [nan subData.condState(1:end-1)']';
        condCont = [nan subData.condContingent(1:end-1)']';
        
        
        %numLag = 10;
        %stateNan = nan(numLag,1)';
        %condState1 = [stateNan subData.condState(1:end-numLag)']';
        
        
        %condCont1 = [nan condContingency1(1:end-1)']';
        %isStay(fitData.trialID==1,1)=nan;
        dataTID = subData.trialID;
        runID = -1;
        
        % loop through all trials
        for tI = 1 : size(dataTID,1)
            % should learned values be reset
            if subData.runID(tI) ~= runID
                % update the ID
                runID = subData.runID(tI);
                
                isStay(tI,1)=nan;
                isPrevRare(tI,1)=nan;
                isPrevWin(tI,1)=nan;
                
                condReward(tI,1)=nan;
                condState(tI,1)=nan;
                condCont(tI,1)=nan;
                
                
            end
        end
        
        
        pStayStats_model(id,1) = nanmean(isStay(isPrevRare == 0 & isPrevWin == 1 ));
        pStayStats_model(id,2) = nanmean(isStay(isPrevRare == 1 & isPrevWin == 1 ));
        pStayStats_model(id,3) = nanmean(isStay(isPrevRare == 0 & isPrevWin == 0 ));
        pStayStats_model(id,4) = nanmean(isStay(isPrevRare == 1 & isPrevWin == 0 ));
        
                
        vDiff_ChosenUnchosen_model(id,1) = nanmean(vDiff(isCurrRare == 0 & isCurrWin == 1 ));
        vDiff_ChosenUnchosen_model(id,2) = nanmean(vDiff(isCurrRare == 1 & isCurrWin == 1 ));
        vDiff_ChosenUnchosen_model(id,3) = nanmean(vDiff(isCurrRare == 0 & isCurrWin == 0 ));
        vDiff_ChosenUnchosen_model(id,4) = nanmean(vDiff(isCurrRare == 1 & isCurrWin == 0 ));
        
        
               
        qDiff_ChosenUnchosen_model(id,1) = nanmean(qDiff_CU(isCurrRare == 0 & isCurrWin == 1 ));
        qDiff_ChosenUnchosen_model(id,2) = nanmean(qDiff_CU(isCurrRare == 1 & isCurrWin == 1 ));
        qDiff_ChosenUnchosen_model(id,3) = nanmean(qDiff_CU(isCurrRare == 0 & isCurrWin == 0 ));
        qDiff_ChosenUnchosen_model(id,4) = nanmean(qDiff_CU(isCurrRare == 1 & isCurrWin == 0 ));
        
                
        qDiff_model(id,1) = nanmean(qDiff(isCurrRare == 0 & isCurrWin == 1 ));
        qDiff_model(id,2) = nanmean(qDiff(isCurrRare == 1 & isCurrWin == 1 ));
        qDiff_model(id,3) = nanmean(qDiff(isCurrRare == 0 & isCurrWin == 0 ));
        qDiff_model(id,4) = nanmean(qDiff(isCurrRare == 1 & isCurrWin == 0 ));
        
        
        wWSLS_model(id,1) = nanmean(wWSLS(isCurrRare == 0 & isCurrWin == 1 ));
        wWSLS_model(id,2) = nanmean(wWSLS(isCurrRare == 1 & isCurrWin == 1 ));
        wWSLS_model(id,3) = nanmean(wWSLS(isCurrRare == 0 & isCurrWin == 0 ));
        wWSLS_model(id,4) = nanmean(wWSLS(isCurrRare == 1 & isCurrWin == 0 ));
                
        ChosenV_model(id,1) = nanmean(ChosenV(isCurrRare == 0 & isCurrWin == 1 ));
        ChosenV_model(id,2) = nanmean(ChosenV(isCurrRare == 1 & isCurrWin == 1 ));
        ChosenV_model(id,3) = nanmean(ChosenV(isCurrRare == 0 & isCurrWin == 0 ));
        ChosenV_model(id,4) = nanmean(ChosenV(isCurrRare == 1 & isCurrWin == 0 ));
        
                        
        UnchosenV_model(id,1) = nanmean(UnchosenV(isCurrRare == 0 & isCurrWin == 1 ));
        UnchosenV_model(id,2) = nanmean(UnchosenV(isCurrRare == 1 & isCurrWin == 1 ));
        UnchosenV_model(id,3) = nanmean(UnchosenV(isCurrRare == 0 & isCurrWin == 0 ));
        UnchosenV_model(id,4) = nanmean(UnchosenV(isCurrRare == 1 & isCurrWin == 0 ));
        
                
        ChosenQ_model(id,1) = nanmean(ChosenQ(isCurrRare == 0 & isCurrWin == 1 ));
        ChosenQ_model(id,2) = nanmean(ChosenQ(isCurrRare == 1 & isCurrWin == 1 ));
        ChosenQ_model(id,3) = nanmean(ChosenQ(isCurrRare == 0 & isCurrWin == 0 ));
        ChosenQ_model(id,4) = nanmean(ChosenQ(isCurrRare == 1 & isCurrWin == 0 ));
        
                        
        UnchosenQ_model(id,1) = nanmean(UnchosenQ(isCurrRare == 0 & isCurrWin == 1 ));
        UnchosenQ_model(id,2) = nanmean(UnchosenQ(isCurrRare == 1 & isCurrWin == 1 ));
        UnchosenQ_model(id,3) = nanmean(UnchosenQ(isCurrRare == 0 & isCurrWin == 0 ));
        UnchosenQ_model(id,4) = nanmean(UnchosenQ(isCurrRare == 1 & isCurrWin == 0 ));
        
                
        Chosen_wsls_model(id,1) = nanmean(Chosen_wsls(isCurrRare == 0 & isCurrWin == 1 ));
        Chosen_wsls_model(id,2) = nanmean(Chosen_wsls(isCurrRare == 1 & isCurrWin == 1 ));
        Chosen_wsls_model(id,3) = nanmean(Chosen_wsls(isCurrRare == 0 & isCurrWin == 0 ));
        Chosen_wsls_model(id,4) = nanmean(Chosen_wsls(isCurrRare == 1 & isCurrWin == 0 ));
        
                        
        Unchosen_wsls_model(id,1) = nanmean(Unchosen_wsls(isCurrRare == 0 & isCurrWin == 1 ));
        Unchosen_wsls_model(id,2) = nanmean(Unchosen_wsls(isCurrRare == 1 & isCurrWin == 1 ));
        Unchosen_wsls_model(id,3) = nanmean(Unchosen_wsls(isCurrRare == 0 & isCurrWin == 0 ));
        Unchosen_wsls_model(id,4) = nanmean(Unchosen_wsls(isCurrRare == 1 & isCurrWin == 0 ));
        
                
        value_update_model(id,1) = nanmean(value_update(isCurrRare == 0 & isCurrWin == 1 ));
        value_update_model(id,2) = nanmean(value_update(isCurrRare == 1 & isCurrWin == 1 ));
        value_update_model(id,3) = nanmean(value_update(isCurrRare == 0 & isCurrWin == 0 ));
        value_update_model(id,4) = nanmean(value_update(isCurrRare == 1 & isCurrWin == 0 ));
        

        
        
        % Model with WSLS component
        
        clear params fitData
        nameMat = ['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/lap_subjects_sfMRI/lap_control_mbmf_wsls_magMF_binMB_MF/lap_' name_sf '.mat' ];
        
        load(nameMat)
        params = cbm.output.parameters;
        

        [negLLE, fitData] = generateData_magMF_binMB_MF_rewMag_WSLS(params, subData);
        
        isCurrWin = fitData.outcomeBin;
        
        isCurrRare = fitData.doRareTrans;
             
        
        vDiff = fitData.pChosenV - fitData.pUnchosenV; % value difference post current-trial update
        
        
        isStay = [nan; fitData.resp1(1:end-1)==fitData.resp1(2:end)];
        

        isPrevRare = [nan fitData.doRareTrans(1:end-1)']';
        isPrevWin = [nan fitData.outcomeBin(1:end-1)']';
        

        
        condReward = [nan subData.condReward(1:end-1)']';
        condState = [nan subData.condState(1:end-1)']';
        condCont = [nan subData.condContingent(1:end-1)']';
        
        
        %numLag = 10;
        %stateNan = nan(numLag,1)';
        %condState1 = [stateNan subData.condState(1:end-numLag)']';
        
        
        %condCont1 = [nan condContingency1(1:end-1)']';
        %isStay(fitData.trialID==1,1)=nan;
        dataTID = subData.trialID;
        runID = -1;
        
        % loop through all trials
        for tI = 1 : size(dataTID,1)
            % should learned values be reset
            if subData.runID(tI) ~= runID
                % update the ID
                runID = subData.runID(tI);
                
                isStay(tI,1)=nan;
                isPrevRare(tI,1)=nan;
                isPrevWin(tI,1)=nan;
                
                condReward(tI,1)=nan;
                condState(tI,1)=nan;
                condCont(tI,1)=nan;
                
                
            end
        end
                
                
        vDiff_ChosenUnchosen_wsls_model(id,1) = nanmean(vDiff(isCurrRare == 0 & isCurrWin == 1 ));
        vDiff_ChosenUnchosen_wsls_model(id,2) = nanmean(vDiff(isCurrRare == 1 & isCurrWin == 1 ));
        vDiff_ChosenUnchosen_wsls_model(id,3) = nanmean(vDiff(isCurrRare == 0 & isCurrWin == 0 ));
        vDiff_ChosenUnchosen_wsls_model(id,4) = nanmean(vDiff(isCurrRare == 1 & isCurrWin == 0 ));
        
        
        %
        sub_name{id,1}=name;
        
    end
    
    
    
end


% Starting Action value difference plot


var1 = ChosenV_model;
var2 = UnchosenV_model;

data = horzcat(mean(var1)', mean(var2)');

SEM1 = nanstd(var1)./sqrt(length(var1));
SEM2 = nanstd(var2)./sqrt(length(var2));


err = horzcat(SEM1', SEM2');

%close all
figure(1)
b = bar(data,'grouped');

b(1).FaceColor = [0.2 0.6 0.8];   % left bars
b(2).FaceColor = [0.8 0.4 0.4];   % right bars

hold on
[ngroups, nbars] = size(data);

groupwidth = min(0.8, nbars/(nbars+1.5));

for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, data(:,i), err(:,i), ...
        'k', 'linestyle','none','linewidth',1.5);
end

xticks(1:4)
xticklabels({'CR','RR','CU','RU'})
xlabel('Current Trial Event')
ylabel('Action Value')
title('Starting Action Value of the Current Trial');
ylim([0 0.7])

legend({'Chosen Action Value','Unchosen Action Value'})
set(gca,'FontSize',20);


% plot of value difference after current trial update : with or without
% WSLS component in the model
 
var1 = vDiff_ChosenUnchosen_model;  
var2 = vDiff_ChosenUnchosen_wsls_model;

variable = var2;  % var1 or var2

avg = nanmean(variable,1);

SEM1 = nanstd(variable)./sqrt(length(variable));
errhigh1=SEM1;
errlow1=SEM1;

close all

figure(2)
%types = {'Win','Win','No-Win','No-Win'};
types = {'Rewarded','Unrewarded'};

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

x=1:4;

f = errorbar(x,avg,errlow1,errhigh1);    
f.Color = [0 0 0];                            
f.LineStyle = 'none';

x = h.XEndPoints;

% Compute midpoints between bar 1–2 and bar 3–4
mid1 = mean(x(1:2));
mid2 = mean(x(3:4));

% Set custom ticks and labels
xticks([mid1 mid2])
xticklabels({'Rewarded','Unrewarded'})

%legend(h(1:2),'# of rewards >2','# of rewards <=2');
hold on

%ylim([0 0.5]);
xlabel('Current Trial Event');
ylabel('V(Chosen) - V(Unchosen)');
%title('Post Current-Trial Update: without WSLS');
legend([h(1), h(2)],'Common','Rare');
set(gca,'FontSize',20);





