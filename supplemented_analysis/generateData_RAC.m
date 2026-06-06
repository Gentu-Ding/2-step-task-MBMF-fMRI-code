function [negLLE, fitData] = generateData_RAC(params, data)

% conditional flags for low/high RPE
RPE_LOW     = 2;
RPE_HIGH    = 1;
% conditional flags for low/high SPE
SPE_LOW     = 2;
SPE_HIGH    = 1;
% conditional flags for stimulus/state reward contingency
REW_STIM   = 1;
REW_STATE  = 2;

% store computational variables
fitData = struct();
%fitData.choice = data.resp1;
% transform optimizer parameters into effective model parameters
fitData.condState = data.condState;
%fitData.condContingent = data.condContingent;
fitData.condReward = data.condReward;
fitData.doRareTrans = data.doRareTrans;
fitData.trialID = data.trialID;
% softmax betas for each RPE condition (which differ in reward magnitude)


% store computational variables

% transform optimizer parameters into effective model parameters

% softmax betas for each RPE condition (which differ in reward magnitude)

fitData.transParams(1) = exp(params(1));
smB             = fitData.transParams(1);

% learning rate
fitData.transParams(2) = 1./(1+ exp(-params(2)));
rl_MF             = fitData.transParams(2);


%    fitData.transParams(3) =  params(3);
%    wMagStim        = fitData.transParams(3);

%    fitData.transParams(4) =  params(4);
%    wMagState       = fitData.transParams(4);
% win-stay / lose swtich
%fitData.transParams(3) =  params(3);
%wWS_MF          = fitData.transParams(3);
wWS_MF =0;
%fitData.transParams(4) =  params(4);
%wLS_MF          = fitData.transParams(4);
wLS_MF =0;


% mf values for spaceships
mfQ1_red_win  = zeros(1,2);

mfQ1_green_win = zeros(1,2);

mfQ1_red_loss = zeros(1,2);

mfQ1_green_loss = zeros(1,2);



dataTID = data.trialID;
% track learned MF values
fitData.mfQ1_red_win        = nan(size(dataTID,1), size(mfQ1_red_win,2));
fitData.mfQ1_green_win        = nan(size(dataTID,1), size(mfQ1_green_win,2));
fitData.mfQ1_red_loss        = nan(size(dataTID,1), size(mfQ1_red_loss,2));
fitData.mfQ1_green_loss        = nan(size(dataTID,1), size(mfQ1_green_loss,2));





fitData.wMF_trial        = nan(size(dataTID,1), 1);
fitData.wMB_trial        = nan(size(dataTID,1), 1);



%    fitData.mfUtility        = nan(size(dataTID,1), size(mfQ1,2));

% track learned MB values


% track prediction errors


fitData.mfRPE4      = nan( size(dataTID,1), 1 );


% summed utility of each action

fitData.Q_Net       = nan( size(dataTID,1), 2 );
fitData.Q_Net_Diff  = nan( size(dataTID,1), 1 );
fitData.actUtil     = nan( size(dataTID,1), 2 );
% summed utility difference between the two options
fitData.qDiff       = nan( size(dataTID,1), 1 );
% probability of chosing options for each controller (level 1)
fitData.pOption     = nan( size(dataTID,1), 2 );
% probability of the chosen option for each controller (level 1)
fitData.pChoice     = nan( size(dataTID,1), 1 );

% previous reward magnitude
%     prevMagStim     = zeros(1,2);
%     prevMagState    = zeros(1,2);
% WSLS
wWSLS_MF        = zeros(1,2);


% flag noting the ID of the current session
runID = -1;

% loop through all trials
for tI = 1 : size(dataTID,1)
    % should learned values be reset
    if data.runID(tI) ~= runID
        % update the ID
        runID = data.runID(tI);
        
        % update learned expectations
        mfQ1_red_win(:)             = 0;
        mfQ1_red_loss(:)             = 0;
        mfQ1_green_win(:)             = 0;
        mfQ1_green_loss(:)             = 0;
        
        wWSLS_MF(:)         = 0;
        
    end
    
    % was a response made
    %if ~isnan(data.resp1(tI)) % && data.TOI(tI)~=0
    % extract MF value for 1st level options
    fitData.mfQ1_red_win(tI,:) = mfQ1_red_win;
    fitData.mfQ1_red_loss(tI,:) = mfQ1_red_loss;
    fitData.mfQ1_green_win(tI,:) = mfQ1_green_win;
    fitData.mfQ1_green_loss(tI,:) = mfQ1_green_loss;
    
    % combine conditional shift on controller mixture
    %wMF_trial = 1./(1+exp(-1*(wMF + wMF_mbRPE + wMF_mfRPE + wMF_SPE)));
    wMF_trial =1;
    
    fitData.wMF_trial(tI) = wMF_trial;
    fitData.wMB_trial(tI) = 1-wMF_trial;
    
    
    % compute controller action differences
    if tI==1 || isnan(fitData.resp1(tI-1))
        
        qMF_diff = 0;
        
        MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
        
        
        % linear combination of value
        
        
        qDiff = wMF_trial*(qMF_diff + MF_WSLS);
        fitData.qDiff(tI) =qDiff;
        
        % derive choice probability
        fitData.pOption(tI,1) = 1 ./ (1 + exp(-smB * qDiff ));
        fitData.pOption(tI,2) = 1-fitData.pOption(tI,1);
        
        
        thres =rand(1);
        choice_1 = find(cumsum(fitData.pOption(tI, :)) > thres, 1);
        fitData.thres(tI,1)=thres;
        
        
        fitData.resp1(tI,1) = choice_1;
        
        
        
        % extract 2nd state
        if choice_1==1
            outcomeState = data.state2_1(tI);
            %mb_reward = data.rewBinary2_1(tI);
            %mf_reward = data.rewMag(tI) * mb_reward;
        else
            outcomeState = data.state2_2(tI);
            %mb_reward = data.rewBinary2_2(tI);
            %mf_reward = data.rewMag(tI) * mb_reward;
        end
        
        if outcomeState == 1
            mb_reward = data.rewBinary_1(tI);
            
        elseif outcomeState == 2
            mb_reward = data.rewBinary_2(tI);
            
        elseif outcomeState == 3
            mb_reward = data.rewBinary_3(tI);
            
        else
            mb_reward = data.rewBinary_4(tI);
            
        end
        
        
        fitData.outcomeBin (tI,1) = mb_reward;
        fitData.outcome2(tI,1) = outcomeState;
        fitData.outcome1(tI,1) = (outcomeState>2) +1;
        
        
        fitData.outcomeMag(tI,1) = 100 * mb_reward * data.rewMagnitude(tI);
        
        % track probability of chosen response
        fitData.pChoice(tI,1)     = fitData.pOption(tI, fitData.resp1(tI));
        
        
    end
    
    if tI>1 && ~isnan(fitData.resp1(tI-1))
        
        if fitData.outcome1(tI-1)==1 && fitData.outcomeBin(tI-1)==1
            
            qMF_diff        = mfQ1_red_win(1) - mfQ1_red_win(2);
            
        elseif  fitData.outcome1(tI-1)==1 && fitData.outcomeBin(tI-1)==0
            
            qMF_diff        = mfQ1_red_loss(1) - mfQ1_red_loss(2);
            
        elseif  fitData.outcome1(tI-1)==2 && fitData.outcomeBin(tI-1)==0
            
            qMF_diff        = mfQ1_green_loss(1) - mfQ1_green_loss(2);
            
        elseif fitData.outcome1(tI-1)==2 && fitData.outcomeBin(tI-1)==1
            
            qMF_diff        = mfQ1_green_win(1) - mfQ1_green_win(2);
            
        end
        
        
        
        MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
        
        
        % linear combination of value
        
        
        qDiff = wMF_trial*(qMF_diff + MF_WSLS);
        fitData.qDiff(tI) =qDiff;
        
        % derive choice probability
        fitData.pOption(tI,1) = 1 ./ (1 + exp(-smB * qDiff ));
        fitData.pOption(tI,2) = 1-fitData.pOption(tI,1);
        
        
        thres =rand(1);
        choice_1 = find( cumsum(fitData.pOption(tI, :)) > thres, 1);
        fitData.thres(tI,1)=thres;
        
        
        fitData.resp1(tI,1) = choice_1;
        

        % extract 2nd state
        if choice_1==1
            outcomeState = data.state2_1(tI);
            %mb_reward = data.rewBinary2_1(tI);
            %mf_reward = data.rewMag(tI) * mb_reward;
        else
            outcomeState = data.state2_2(tI);
            %mb_reward = data.rewBinary2_2(tI);
            %mf_reward = data.rewMag(tI) * mb_reward;
        end
        
        if outcomeState == 1
            mb_reward = data.rewBinary_1(tI);
            
        elseif outcomeState == 2
            mb_reward = data.rewBinary_2(tI);
            
        elseif outcomeState == 3
            mb_reward = data.rewBinary_3(tI);
            
        else
            mb_reward = data.rewBinary_4(tI);
            
        end
        
        
        fitData.outcomeBin (tI,1) = mb_reward;
        fitData.outcome2(tI,1) = outcomeState;
        fitData.outcome1(tI,1) = (outcomeState>2) +1;
        
        
        fitData.outcomeMag(tI,1) = 100 * mb_reward * data.rewMagnitude(tI);
        
        % track probability of chosen response
        fitData.pChoice(tI,1)     = fitData.pOption(tI, fitData.resp1(tI));
        
          
        if fitData.outcome1(tI-1)==1 && fitData.outcomeBin(tI-1)==1
            
            fitData.mfRPE4(tI) = (fitData.outcomeMag(tI)/100) - mfQ1_red_win(fitData.resp1(tI));
            
            mfQ1_red_win(fitData.resp1(tI)) = mfQ1_red_win(fitData.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            
        elseif  fitData.outcome1(tI-1)==1 && fitData.outcomeBin(tI-1)==0
            
            fitData.mfRPE4(tI) = (fitData.outcomeMag(tI)/100) - mfQ1_red_loss(fitData.resp1(tI));
            
            mfQ1_red_loss(fitData.resp1(tI)) = mfQ1_red_loss(fitData.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            
        elseif  fitData.outcome1(tI-1)==2 && fitData.outcomeBin(tI-1)==0
            
            fitData.mfRPE4(tI) = (fitData.outcomeMag(tI)/100) - mfQ1_green_loss(fitData.resp1(tI));
            
            mfQ1_green_loss(fitData.resp1(tI)) = mfQ1_green_loss(fitData.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            
        elseif fitData.outcome1(tI-1)==2 && fitData.outcomeBin(tI-1)==1
            
            fitData.mfRPE4(tI) = (fitData.outcomeMag(tI)/100) - mfQ1_green_win(fitData.resp1(tI));
            
            mfQ1_green_win(fitData.resp1(tI)) = mfQ1_green_win(fitData.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
        end
        
    end
    
    
    % stimulus-mapped win-stay/lose-switch
    wWSLS_MF(:) = 0;
    if fitData.outcomeBin(tI) == 1
        wWSLS_MF(fitData.resp1(tI)) = wWS_MF;
        
    else
        wWSLS_MF(fitData.resp1(tI)) = -wLS_MF;
        
    end
    
    % transition-mapped win-stay/lose-switch
    
    
    %          fitData.mfUtility(tI,:) = mfQ1 + wWSLS_MF;
    
    
    
    % track previous reward magniude
    %             prevMagStim(:)                     = 0;
    %             prevMagState(:)                    = 0;
    %             prevMagStim(data.resp1(tI))        = data.outcomeMag(tI)/100;
    %             prevMagState(data.outcome1(tI))    = data.outcomeMag(tI)/100;
    %end % if valid response
end % for each trial

% determin which trials should be included in the fit
isValidTrial = ~isnan(fitData.resp1); % & data.TOI==1;
n = sum(isValidTrial);
k = size(params,2);
% adjust 0 probability trials
fitData.pChoice(fitData.pChoice < eps | isnan(fitData.pChoice) | isinf(fitData.pChoice)) = eps;
% compute null model negLLE
fitData.null_negLLE = sum(isValidTrial) * log(0.5);
fitData.negLLE = sum(log(fitData.pChoice(isValidTrial)));
fitData.pseudoR = 1 - (fitData.negLLE/fitData.null_negLLE);
% compute the negative log-like
negLLE = fitData.negLLE;

fitData.AIC = k*log(n)-2*fitData.negLLE;
fitData.BIC = 2*k-2*fitData.negLLE;





end
