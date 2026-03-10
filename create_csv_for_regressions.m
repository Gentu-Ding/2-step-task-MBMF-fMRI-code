%% Write fMRI data

clear;
close all
RandStream.setGlobalStream(RandStream('mt19937ar','Seed', 'shuffle'));
%addpath('parsed_data')

%allFiles=dir('../MBMF_csv_sf/*.csv');
allFiles=dir('generated_dataset/hmm_model_mbGroup/sub*.csv');

id=0;
all_df=[];

for sI=1:size(allFiles,1)
    
        
    ID = allFiles(sI).name(4:7);
    %TF = contains(subjectIDs_138,ID);

    name = allFiles(sI).name;
    
    name_sf = [name(1:7) name(end-7:end-4)];
   
    %TF1 = ismember(str2double(ID), group_subs);
    %TF2 = contains(ID,subjectIDs_50);
    %TF1 = ismember(group_subs,str2double(ID));
     
    TF1=1;
    TF2=1;
    
    if TF2 ==1 %&& include_MRI(sI,1)==1
    
    %if str2double(ID)<47 || str2double(ID)>115
    
    % point to the director with data we want to fit
    %allData = readtable(fullfile('~', 'Documents', 'Research', 'TwoStep_OCD', 'Analysis', 'allData_K.csv'));
    
    
    allData = readtable(['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/Control_csv_sf/' name]);
    %allData = readtable(['generated_dataset/hmm_model_mbGroup/' name]);
    
    numT = size(allData,1);
    
    
    
    id=id+1;
    
    
    
    subData = allData;
    
    
    isStay = [nan [subData.Resp1(1:end-1) == subData.Resp1(2:end)]']';
    isPrevRare = [nan subData.doRareTrans(1:end-1)']';
    isPrevWin = [nan subData.outcomeBin(1:end-1)']';
    
        
    
    
    data = struct('trialID',subData.trialID,'doRareTrans',subData.doRareTrans, ...
        'resp1', subData.Resp1, 'outcome1', subData.outcome1, ...
        'outcome2', subData.outcome2, 'outcomeMag', subData.outcomeMag,...
        'outcomeBin', subData.outcomeBin, 'condReward', subData.condReward,...
        'condState', subData.condState,'condContingency', subData.condContingent,...
        'isPost_ContState', subData.isPost_ContState,'isPost_RewHigh', subData.isPost_RewHigh,...
        'isPost_StateLow', subData.isPost_StateLow, 'runID', subData.runID);
    
%     
%     nameMat = ['/Users/olab/Weilun/R01_MBMF_Habits_Behaviors/Behaviors_Modeling_fMRI/lap_subjects_sfMRI/lap_control_mbmf_wsls_MB/lap_' name_sf '.mat' ];
%     load(nameMat)
%     params = cbm.output.parameters;
%     
%     
 
    %[negLLE, fitData] =comp_getLLE_mbRPE_mfRPE_SPE_lr_rewMag_WSLS(params, data);
  
    
    
    %isLeft = fitData.pOption(:,1);
    isLeft = subData.Resp1==1;
    isLeft_t1 = [nan [subData.Resp1(1:end-1) ==1]']';
    isLeft_t2 = [nan nan [subData.Resp1(1:end-2) ==1]']';
    isLeft_t3 = [nan nan nan [subData.Resp1(1:end-3) ==1]']';
    isLeft_t4 = [nan nan nan nan [subData.Resp1(1:end-4) ==1]']';
    isLeft_t5 = [nan nan nan nan nan [subData.Resp1(1:end-5) ==1]']';
    isLeft_t6 = [nan nan nan nan nan nan [subData.Resp1(1:end-6) ==1]']';  
    isLeft_t7 = [nan nan nan nan nan nan nan [subData.Resp1(1:end-7) ==1]']';
    isLeft_t8 = [nan nan nan nan nan nan nan nan [subData.Resp1(1:end-8) ==1]']';
    isLeft_t9 = [nan nan nan nan nan nan nan nan nan [subData.Resp1(1:end-9) ==1]']';
    isLeft_t10= [nan nan nan nan nan nan nan nan nan nan [subData.Resp1(1:end-10) ==1]']';
    
    
    isStay_t1 = [nan [subData.Resp1(1:end-1) == subData.Resp1(2:end)]']';
    isStay_t2 = [nan nan [subData.Resp1(1:end-2) == subData.Resp1(3:end)]']';  
    isStay_t3 = [nan nan nan [subData.Resp1(1:end-3) == subData.Resp1(4:end)]']';
    isStay_t4 = [nan nan nan nan [subData.Resp1(1:end-4) == subData.Resp1(5:end)]']'; 
    isStay_t5 = [nan nan nan nan nan [subData.Resp1(1:end-5) == subData.Resp1(6:end)]']';
    isStay_t6 = [nan nan nan nan nan nan [subData.Resp1(1:end-6) == subData.Resp1(7:end)]']';
    isStay_t7 = [nan nan nan nan nan nan nan [subData.Resp1(1:end-7) == subData.Resp1(8:end)]']';
    isStay_t8 = [nan nan nan nan nan nan nan nan [subData.Resp1(1:end-8) == subData.Resp1(9:end)]']';
    isStay_t9 = [nan nan nan nan nan nan nan nan nan [subData.Resp1(1:end-9) == subData.Resp1(10:end)]']';
    isStay_t10= [nan nan nan nan nan nan nan nan nan nan [subData.Resp1(1:end-10) == subData.Resp1(11:end)]']';
    
    isRare_t1 = [nan subData.doRareTrans(1:end-1)']';
    isWin_t1  = [nan subData.outcomeBin(1:end-1)']';
    RewMag_t1 = [nan subData.outcomeMag(1:end-1)']';
    
    isRare_t2 = [nan nan subData.doRareTrans(1:end-2)']';
    isWin_t2  = [nan nan subData.outcomeBin(1:end-2)']';
    RewMag_t2 = [nan nan subData.outcomeMag(1:end-2)']';
    
    isRare_t3 = [nan nan nan subData.doRareTrans(1:end-3)']';
    isWin_t3  = [nan nan nan subData.outcomeBin(1:end-3)']';
    RewMag_t3 = [nan nan nan subData.outcomeMag(1:end-3)']';
    
    isRare_t4 = [nan nan nan nan subData.doRareTrans(1:end-4)']';
    isWin_t4  = [nan nan nan nan subData.outcomeBin(1:end-4)']';
    RewMag_t4 = [nan nan nan nan subData.outcomeMag(1:end-4)']';
    
    isRare_t5 = [nan nan nan nan nan subData.doRareTrans(1:end-5)']';
    isWin_t5  = [nan nan nan nan nan subData.outcomeBin(1:end-5)']';
    RewMag_t5 = [nan nan nan nan nan subData.outcomeMag(1:end-5)']';
    
    isRare_t6 = [nan nan nan nan nan nan subData.doRareTrans(1:end-6)']';
    isWin_t6  = [nan nan nan nan nan nan subData.outcomeBin(1:end-6)']';
    RewMag_t6 = [nan nan nan nan nan nan subData.outcomeMag(1:end-6)']';
    
    isRare_t7 = [nan nan nan nan nan nan nan subData.doRareTrans(1:end-7)']';
    isWin_t7  = [nan nan nan nan nan nan nan subData.outcomeBin(1:end-7)']';
    RewMag_t7 = [nan nan nan nan nan nan nan subData.outcomeMag(1:end-7)']';
    
    isRare_t8 = [nan nan nan nan nan nan nan nan subData.doRareTrans(1:end-8)']';
    isWin_t8  = [nan nan nan nan nan nan nan nan subData.outcomeBin(1:end-8)']';
    RewMag_t8 = [nan nan nan nan nan nan nan nan subData.outcomeMag(1:end-8)']';
    
    isRare_t9 = [nan nan nan nan nan nan nan nan nan subData.doRareTrans(1:end-9)']';
    isWin_t9  = [nan nan nan nan nan nan nan nan nan subData.outcomeBin(1:end-9)']';
    RewMag_t9 = [nan nan nan nan nan nan nan nan nan subData.outcomeMag(1:end-9)']';
    
    isRare_t10 = [nan nan nan nan nan nan nan nan nan nan subData.doRareTrans(1:end-10)']';
    isWin_t10  = [nan nan nan nan nan nan nan nan nan nan subData.outcomeBin(1:end-10)']';
    RewMag_t10 = [nan nan nan nan nan nan nan nan nan nan subData.outcomeMag(1:end-10)']';
    
    
    
    
    PrevRT = [nan subData.RT1(1:end-1)']';
    % Previous reward magnitude
    PrevRewMag = [nan subData.outcomeMag(1:end-1)']';
    
    RT = subData.RT1;
    
    trialID = subData.trialID;
    trialID_total = [1:numT]';
    
    sess_type = subData.sess_type;
    sess_idx = contains(sess_type,'functional');
    
    sess_switch_trial = sess_idx(1:end-1)==sess_idx(2:end);
    
    idx=find(sess_switch_trial==0,1);
    
    sessID = zeros(numT,1);
    sessID(1:idx)=1;
    sessID(idx+1:end)=2;
    
    % Number of previous repeated actions
    
    condContingent = [nan (subData.condContingent(1:end-1)==2)']';
    condRPE = [nan (subData.condReward(1:end-1)==1)']';
    condSPE = [nan (subData.condState(1:end-1)==2)']';
      
    
    
    
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
            
            condRPE(tI,1)=nan;
            condSPE(tI,1)=nan;
            condContingent(tI,1)=nan;
            
            PrevRewMag(tI,1) = nan;
            PrevRT(tI,1) = nan;
              
            isLeft_t1(tI,1)=nan;
            isLeft_t2(tI:tI+1,1)=nan;
            isLeft_t3(tI:tI+2,1)=nan;
            isLeft_t4(tI:tI+3,1)=nan;
            isLeft_t5(tI:tI+4,1)=nan;
            isLeft_t6(tI:tI+5,1)=nan;
            isLeft_t7(tI:tI+6,1)=nan;
            isLeft_t8(tI:tI+7,1)=nan;
            isLeft_t9(tI:tI+8,1)=nan;
            isLeft_t10(tI:tI+9,1)=nan;
            
                       
            isStay_t1(tI,1)=nan;
            isStay_t2(tI:tI+1,1)=nan;
            isStay_t3(tI:tI+2,1)=nan;
            isStay_t4(tI:tI+3,1)=nan;
            isStay_t5(tI:tI+4,1)=nan;
            isStay_t6(tI:tI+5,1)=nan;
            isStay_t7(tI:tI+6,1)=nan;
            isStay_t8(tI:tI+7,1)=nan;
            isStay_t9(tI:tI+8,1)=nan;
            isStay_t10(tI:tI+9,1)=nan;
            
                        
            isRare_t1(tI,1)=nan;
            isRare_t2(tI:tI+1,1)=nan;
            isRare_t3(tI:tI+2,1)=nan;
            isRare_t4(tI:tI+3,1)=nan;
            isRare_t5(tI:tI+4,1)=nan;
            isRare_t6(tI:tI+5,1)=nan;
            isRare_t7(tI:tI+6,1)=nan;
            isRare_t8(tI:tI+7,1)=nan;
            isRare_t9(tI:tI+8,1)=nan;
            isRare_t10(tI:tI+9,1)=nan;
            
            RewMag_t1(tI,1)=nan;
            RewMag_t2(tI:tI+1,1)=nan;
            RewMag_t3(tI:tI+2,1)=nan;
            RewMag_t4(tI:tI+3,1)=nan;
            RewMag_t5(tI:tI+4,1)=nan;
            RewMag_t6(tI:tI+5,1)=nan;
            RewMag_t7(tI:tI+6,1)=nan;
            RewMag_t8(tI:tI+7,1)=nan;
            RewMag_t9(tI:tI+8,1)=nan;
            RewMag_t10(tI:tI+9,1)=nan;
             
            isWin_t1(tI,1)=nan;
            isWin_t2(tI:tI+1,1)=nan;
            isWin_t3(tI:tI+2,1)=nan;
            isWin_t4(tI:tI+3,1)=nan;
            isWin_t5(tI:tI+4,1)=nan;
            isWin_t6(tI:tI+5,1)=nan;
            isWin_t7(tI:tI+6,1)=nan;
            isWin_t8(tI:tI+7,1)=nan;
            isWin_t9(tI:tI+8,1)=nan;
            isWin_t10(tI:tI+9,1)=nan;
            
            
            
            
            
            
            
        end
    end
    

    
    
    
    subdata.isStay = isStay;
    subdata.isPrevRare = isPrevRare;
    subdata.isPrevWin = isPrevWin;
    
    subdata.trialID = trialID;
    subdata.trialID_total = trialID_total;
    subdata.isFunctional = sess_idx;
    
    subdata.isLeft = isLeft;
    subdata.isLeft_t1 = isLeft_t1;
    subdata.isLeft_t2 = isLeft_t2;
    subdata.isLeft_t3 = isLeft_t3;
    subdata.isLeft_t4 = isLeft_t4;
    subdata.isLeft_t5 = isLeft_t5;
    subdata.isLeft_t6 = isLeft_t6;
    subdata.isLeft_t7 = isLeft_t7;
    subdata.isLeft_t8 = isLeft_t8;
    subdata.isLeft_t9 = isLeft_t9;
    subdata.isLeft_t10 = isLeft_t10;

    subdata.isStay_t1 = isStay_t1;
    subdata.isStay_t2 = isStay_t2;
    subdata.isStay_t3 = isStay_t3;
    subdata.isStay_t4 = isStay_t4;
    subdata.isStay_t5 = isStay_t5;
    subdata.isStay_t6 = isStay_t6;
    subdata.isStay_t7 = isStay_t7;
    subdata.isStay_t8 = isStay_t8;
    subdata.isStay_t9 = isStay_t9;
    subdata.isStay_t10 = isStay_t10;
    

    subdata.isRare_t1 = isRare_t1;
    subdata.isRare_t2 = isRare_t2;
    subdata.isRare_t3 = isRare_t3;
    subdata.isRare_t4 = isRare_t4;
    subdata.isRare_t5 = isRare_t5;
    subdata.isRare_t6 = isRare_t6;
    subdata.isRare_t7 = isRare_t7;
    subdata.isRare_t8 = isRare_t8;
    subdata.isRare_t9 = isRare_t9;
    subdata.isRare_t10 = isRare_t10;

    subdata.isWin_t1 = isWin_t1;
    subdata.isWin_t2 = isWin_t2;
    subdata.isWin_t3 = isWin_t3;
    subdata.isWin_t4 = isWin_t4;
    subdata.isWin_t5 = isWin_t5;
    subdata.isWin_t6 = isWin_t6;
    subdata.isWin_t7 = isWin_t7;
    subdata.isWin_t8 = isWin_t8;
    subdata.isWin_t9 = isWin_t9;
    subdata.isWin_t10 = isWin_t10;
    

    subdata.RewMag_t1 = RewMag_t1;
    subdata.RewMag_t2 = RewMag_t2;
    subdata.RewMag_t3 = RewMag_t3;
    subdata.RewMag_t4 = RewMag_t4;
    subdata.RewMag_t5 = RewMag_t5;
    subdata.RewMag_t6 = RewMag_t6;
    subdata.RewMag_t7 = RewMag_t7;
    subdata.RewMag_t8 = RewMag_t8;
    subdata.RewMag_t9 = RewMag_t9;
    subdata.RewMag_t10 = RewMag_t10;
    

    
    subdata.runID = subData.runID;
    subdata.sessID = sessID;
    % subdata.PrevRT = PrevRT(trials_include);
    
    subdata.PrevRewMag = PrevRewMag;
    
    
    subdata.condContingent = condContingent;
    subdata.condState = condSPE;
    subdata.condReward = condRPE;
    

    subdata.PrevRT = PrevRT;
    subdata.RT = RT;
    
    
    %groupID = group_IDs(TF1) * ones(numT,1);
    %subdata.groupID = groupID;
    
    sID = id * ones(numT,1);
    subID =sID;
    
    index =  ID;
    C    = cell(numT, 1);
    C(:) = {name(4:7)};
    
    subdata.subID = subID;
    subdata.subIndex = C;
    
    allID = sI * ones(numT,1);
    subdata.allID = allID;

    cont_order= subData.condContingent(1);
    
    subdata.cont_order =  cont_order * ones(numT,1);
    
    
    cbf=str2double(name(end-4))==2;
    subdata.func_first = cbf * ones(numT,1);
    
    df = struct2table(subdata);
    
    all_df=[all_df;df];
    
    
    %cont_order(sI,1) = subData.condContingent(1);
    
    end
    
end

fname = ['reg_control_sf_all_10_trials_updated.csv'];
writetable(all_df, fname);

