function [negLLE, fitData] = comp_getLLE_random_agent(data)

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
    fitData.choice = data.resp1;
    dataTID = data.trialID;
    
    fitData.pChoice     = 0.5*ones(size(dataTID,1), 1 );
    
    
    
    % determin which trials should be included in the fit
    isValidTrial = ~isnan(data.resp1);
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
    
    fitData.AIC = 2*k-2*fitData.negLLE;
    fitData.BIC = k*log(n)-2*fitData.negLLE;
    
    
    
    
    
  
    
    
end