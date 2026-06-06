function [negLLE, fitData] = generateData_random_agent(data)

% conditional flags for low/high RPE
RPE_LOW     = 2;
RPE_HIGH    = 1;
% conditional flags for low/high SPE
SPE_LOW     = 2;
SPE_HIGH    = 1;
% conditional flags for stimulus/state reward contingency
REW_STIM   = 0;
REW_STATE  = 1;

% store computational variables
fitData = struct();
%fitData.choice = data.resp1;
dataTID = data.trialID;


for tI = 1:size(dataTID,1)
    
    choice_1 = randi([1,2],1,1);
    
    
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
    %fitData.pChoice(tI,1)     = fitData.pOption(tI, choice_1);
    
    
end


fitData.pChoice     = 0.5*ones(size(dataTID,1), 1 );


% determin which trials should be included in the fit
isValidTrial = ~isnan(fitData.resp1);
n = sum(isValidTrial);
k = 0;
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