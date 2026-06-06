function [negLLE, fitData] = comp_getLLE_RAC_WSLS(params, data)

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
fitData.choice = data.resp1;
% transform optimizer parameters into effective model parameters

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
    if ~isnan(data.resp1(tI)) % && data.TOI(tI)~=0
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
        
        
        % computer controller action differences
        if tI==1 || isnan(data.resp1(tI-1))
            qMF_diff = 0;
            
            MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
            
            
            % linear combination of value
            
            
            qDiff = wMF_trial*(qMF_diff + MF_WSLS);
            fitData.qDiff(tI) =qDiff;
            
            % derive choice probability
            fitData.pOption(tI,1) = 1 ./ (1 + exp(-smB * qDiff ));
            fitData.pOption(tI,2) = 1-fitData.pOption(tI,1);
            
            % track probabiilty of chosen response
            fitData.pChoice(tI)     = fitData.pOption(tI, data.resp1(tI));
            
            
            
        end
        
        if tI>1 && ~isnan(data.resp1(tI-1))
            if data.outcome1(tI-1)==1 && data.outcomeBin(tI-1)==1
                
                qMF_diff        = mfQ1_red_win(1) - mfQ1_red_win(2);
                
            elseif  data.outcome1(tI-1)==1 && data.outcomeBin(tI-1)==0
                
                qMF_diff        = mfQ1_red_loss(1) - mfQ1_red_loss(2);
                
            elseif  data.outcome1(tI-1)==2 && data.outcomeBin(tI-1)==0
                
                qMF_diff        = mfQ1_green_loss(1) - mfQ1_green_loss(2);
                
            elseif data.outcome1(tI-1)==2 && data.outcomeBin(tI-1)==1
                
                qMF_diff        = mfQ1_green_win(1) - mfQ1_green_win(2);
                
            end
            
            

            MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
            
            
            % linear combination of value
            
            
            qDiff = wMF_trial*(qMF_diff + MF_WSLS);
            fitData.qDiff(tI) =qDiff;
            
            % derive choice probability
            fitData.pOption(tI,1) = 1 ./ (1 + exp(-smB * qDiff ));
            fitData.pOption(tI,2) = 1-fitData.pOption(tI,1);
            
            % track probabiilty of chosen response
            fitData.pChoice(tI)     = fitData.pOption(tI, data.resp1(tI));
            
            
            
            if data.outcome1(tI-1)==1 && data.outcomeBin(tI-1)==1
                
                fitData.mfRPE4(tI) = (data.outcomeMag(tI)/100) - mfQ1_red_win(data.resp1(tI));
                
                mfQ1_red_win(data.resp1(tI)) = mfQ1_red_win(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
                
            elseif  data.outcome1(tI-1)==1 && data.outcomeBin(tI-1)==0
                
                fitData.mfRPE4(tI) = (data.outcomeMag(tI)/100) - mfQ1_red_loss(data.resp1(tI));
                
                mfQ1_red_loss(data.resp1(tI)) = mfQ1_red_loss(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
                
            elseif  data.outcome1(tI-1)==2 && data.outcomeBin(tI-1)==0
                
                fitData.mfRPE4(tI) = (data.outcomeMag(tI)/100) - mfQ1_green_loss(data.resp1(tI));
                
                mfQ1_green_loss(data.resp1(tI)) = mfQ1_green_loss(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
                
            elseif data.outcome1(tI-1)==2 && data.outcomeBin(tI-1)==1
                
                fitData.mfRPE4(tI) = (data.outcomeMag(tI)/100) - mfQ1_green_win(data.resp1(tI));
                
                mfQ1_green_win(data.resp1(tI)) = mfQ1_green_win(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            end
            
        end
        
        
        % stimulus-mapped win-stay/lose-switch
        wWSLS_MF(:) = 0;
        if data.outcomeBin(tI) == 1
            wWSLS_MF(data.resp1(tI)) = wWS_MF;
            
        else
            wWSLS_MF(data.resp1(tI)) = -wLS_MF;
            
        end
        
        % transition-mapped win-stay/lose-switch
        
        
        %          fitData.mfUtility(tI,:) = mfQ1 + wWSLS_MF;
        
        
        
        % track previous reward magniude
        %             prevMagStim(:)                     = 0;
        %             prevMagState(:)                    = 0;
        %             prevMagStim(data.resp1(tI))        = data.outcomeMag(tI)/100;
        %             prevMagState(data.outcome1(tI))    = data.outcomeMag(tI)/100;
    end % if valid response
end % for each trial

% determin which trials should be included in the fit
isValidTrial = ~isnan(data.resp1); % & data.TOI==1;
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

fitData.AIC = 2*k-2*fitData.negLLE;
fitData.BIC = k*log(n)-2*fitData.negLLE;






end
