function [negLLE, fitData] = getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, data)

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

    fitData.condState = data.condState;
    %fitData.condContingent = data.condContingent;
    fitData.condReward = data.condReward;
    fitData.doRareTrans = data.doRareTrans;
    fitData.trialID = data.trialID;
    fitData.runID = data.runID;
    
    % transform optimizer parameters into effective model parameters 

    % softmax betas for each RPE condition (which differ in reward magnitude)
    
    fitData.transParams(1) = exp(params(1));
    smB             = fitData.transParams(1);

    % learning rate
    fitData.transParams(2) = 1./(1+ exp(-params(2)));
    rl_MF             = fitData.transParams(2);
    

    
    fitData.transParams(3) = 1./(1+ exp(-params(3)));
    rl_MB             = fitData.transParams(3);
    % MF eligibility trace
    eD              = 1;
    % SPE learning rate
            
    %fitData.transParams(4) = 1./(1+ exp(-params(4)));
    %aSPE1           = fitData.transParams(4);
    
    
    aSPE2           = 0.5;
    % influence of reward magnitude
%    fitData.transParams(3) =  params(3);
%    wMagStim        = fitData.transParams(3);
    
%    fitData.transParams(4) =  params(4);
%    wMagState       = fitData.transParams(4);
    % win-stay / lose swtich
    fitData.transParams(4) =  params(4);
    wWS_MF          = fitData.transParams(4);
    
    fitData.transParams(5) =  params(5);
    wLS_MF          = fitData.transParams(5);
    
    fitData.transParams(6) =  params(6);
    wWS_MB          = fitData.transParams(6);
    
    fitData.transParams(7) =  params(7);
    wLS_MB          = fitData.transParams(7);
    % anchore MF weight
    fitData.transParams(8) =  params(8);
    wMF             = fitData.transParams(8);
    
    rlMag =1;
    
    fitData.transParams(9) =  exp(params(9));
    wMag = fitData.transParams(9);
    
    % conditional effects on the mixture weight
    fitData.transParams(10) =  params(10);
    arb_mbRPE       = fitData.transParams(10);
    
    %arb_mbRPE = 0;
    
    
    fitData.transParams(11) =  params(11);
    arb_mfRPE       = fitData.transParams(11);
    fitData.transParams(12) =  params(12);
    arb_SPE         = fitData.transParams(12);
    
    % expected values for stimuli
    %mfQ1  = zeros(1,2) + 0.5;
    mfQ1  = zeros(1,2) ;
    % expecrted value for planets

    %mfQ2  = zeros(1,2) + 0.5;
    mfQ2  = zeros(1,2) ;
    % expected value for landing pads
    % mfQ3  = zeros(1,4) + 0.5;
    mfQ3  = zeros(1,4) ;
    % model-based terminal state values
    
    
    % mb values for spaceships
    mbQ1 = zeros(1,2) + 0.5;
    % mb values for planets
    mbQ2 = zeros(1,2) + 0.5;
    %mbQ3  = zeros(1,4) + 0.5;
    mbQ3  = zeros(1,4) ;
    
    % known transition probabilities for 1st stage choice
    pTrans_1 = [0.7,0.3,0.3,0.7];
    % learned transisitions for each of the 2nd stage states
    pTrans_2 = zeros(1,4) + 0.5;
    
    dataTID = data.trialID;
    % track learned MF values
    fitData.mfQ1        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.mfQ2        = nan(size(dataTID,1), size(mfQ2,2));
    fitData.mfQ3        = nan(size(dataTID,1), size(mfQ3,2));
    
    % track learned MB values
    fitData.mbQ1        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.mbQ2        = nan(size(dataTID,1), size(mfQ2,2));
    fitData.mbQ3        = nan(size(dataTID,1), size(mfQ3,2));
    
       
    
    % learned state transition probabilities
    
    fitData.pTrans_1    = nan(size(dataTID,1), 4);
    fitData.pTrans_2    = nan(size(dataTID,1), 4);
    
    % track prediction errors
    fitData.mfRPE1      = nan( size(dataTID,1), 1 );
    fitData.mfRPE2      = nan( size(dataTID,1), 1 );
    fitData.mfRPE3      = nan( size(dataTID,1), 1 );
    fitData.mbRPE       = nan( size(dataTID,1), 1 );
    fitData.SPE1         = nan( size(dataTID,1), 1 );
    fitData.SPE2         = nan( size(dataTID,1), 1 );
    
    
    % summed utility of each action
    fitData.actUtil     = nan( size(dataTID,1), 2 );
    % probability of chosing options for each controller (level 1)
    fitData.pOption     = nan( size(dataTID,1), 2 );
    % probability of the chosen option for each controller (level 1)
    fitData.pChoice     = nan( size(dataTID,1), 1 );
    
    % previous reward magnitude 
   % prevMagStim     = zeros(1,2);
   % prevMagState    = zeros(1,2);
    % WSLS
    wWSLS_MF        = zeros(1,2);
    wWSLS_MB        = zeros(1,2);
    
    % track reward magnitude associated with action
    magAct   = zeros( 1, 2 );
    % with planet
    magPlanet  = zeros( 1, 2 );
    % with landing pad
    magPad   = zeros( 1, 4 );
    
    
    % flag noting the ID of the current session
    runID = -1;
    
    % loop through all trials
    for tI = 1 : size(dataTID,1)
        % should learned values be reset
        if data.runID(tI) ~= runID
            % update the ID
            runID = data.runID(tI);
            
            % update learned expectations
            mfQ1(:)             = 0;
            mfQ2(:)             = 0;
            mfQ3(:)             = 0;
            mbQ1(:)             = 0;
            mbQ2(:)             = 0;
            mbQ3(:)             = 0;
            pTrans_1 = [0.7,0.3,0.3,0.7];
            pTrans_2(:)         = 0.5;            
    %        prevMagStim(:)      = 0;
    %        prevMagState(:)     = 0;
            wWSLS_MF(:)         = 0;
            wWSLS_MB(:)         = 0;
            
            % learned reward magnitudes
            magAct(:)           = 0;
            magPlanet(:)        = 0;
            magPad(:)           = 0;
            
        end
        
  
        % was a respons made
       % if ~isnan(data.resp1(tI))
            % extract MF value for 1st level options

            
            fitData.mfQ1(tI,:) = mfQ1;
            fitData.mfQ2(tI,:) = mfQ2;
            fitData.mfQ3(tI,:) = mfQ3;
            fitData.mbQ1(tI,:) = mbQ1;
            fitData.mbQ2(tI,:) = mbQ2;
            fitData.mbQ3(tI,:) = mbQ3;
            
            % store the current state transition belief
            fitData.pTrans_1(tI,:)    = pTrans_1;
            fitData.pTrans_2(tI,:)    = pTrans_2;

            
            % derive MB action values weighted according to state transisions
            
            padValue    = mbQ3 + (wMag*magPad);
            planetVals  = [pTrans_2([1,2]) * padValue([1,2])', pTrans_2([3,4]) * padValue([3,4])'];
            mbQ1        = [pTrans_1([1,2]) * planetVals', pTrans_1([3,4]) * planetVals'];
            
       
            
            % define reward contingency shift
            if data.isPost_ContState(tI) == 1
                
                wMF_mbRPE = -arb_mbRPE;
            else
                wMF_mbRPE= arb_mbRPE;
            end
            
            % define reward reliability shift
            if data.isPost_RewHigh(tI) == 1
                wMF_mfRPE = -arb_mfRPE;
            else
                wMF_mfRPE = arb_mfRPE;
            end
            
            
            % define state reliability shift
            if data.isPost_StateLow(tI) == 1
                wMF_SPE = -arb_SPE;
            else
                wMF_SPE = arb_SPE;
            end

            % combine conditional shift on controller mixture
            wMF_trial = 1./(1+exp(-1*(wMF + wMF_mbRPE + wMF_mfRPE + wMF_SPE)));
            
            % computer controller action differences
            qMF_diff        = mfQ1(1) - mfQ1(2);
            qMB_diff        = mbQ1(1) - mbQ1(2);
     %       magStateDiff    = wMagState * (prevMagState(1) - prevMagState(2));
     %       magStimDiff     = wMagStim * (prevMagStim(1) - prevMagStim(2));
            MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
            MB_WSLS         = wWSLS_MB(1) - wWSLS_MB(2);
            
            
            
            % linear combination of value
            qDiff = wMF_trial*(qMF_diff + MF_WSLS) + (1-wMF_trial)*(qMB_diff + MB_WSLS);

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
            
            mf_reward = mb_reward;
            
            
            fitData.outcomeBin (tI,1) = mb_reward;
            fitData.outcome2(tI,1) = outcomeState;
            fitData.outcome1(tI,1) = (outcomeState>2) +1;
            
            
            fitData.chosen_mfQ1(tI,1) = mfQ1(fitData.resp1(tI));
            fitData.chosen_mfQ2(tI,1) = mfQ2(fitData.outcome1(tI));
            fitData.chosen_mfQ3(tI,1) = mfQ3(fitData.outcome2(tI));
            
            
            fitData.chosen_mbQ1(tI,1) = mbQ1(fitData.resp1(tI));
            fitData.chosen_mbQ2(tI,1) = mbQ2(fitData.outcome1(tI));
            fitData.chosen_mbQ3(tI,1) = mbQ3(fitData.outcome2(tI));
            
            fitData.outcomeMag(tI,1) = 100 * mb_reward * data.rewMagnitude(tI);
            
            % track probability of chosen response
            fitData.pChoice(tI,1)     = fitData.pOption(tI, choice_1);
            
            
            % MF RPE associted with reward magnitude delivery at the landing pad
            fitData.mfRPE3(tI,1)      = (fitData.outcomeMag(tI)/100) - mfQ3(fitData.outcome2(tI));
            % RPE associated with transition from planet to landing pad
            fitData.mfRPE2(tI,1)      = mfQ3(fitData.outcome2(tI)) - mfQ2(fitData.outcome1(tI));
            % RPE associated with the transition from choice to planet
            fitData.mfRPE1(tI,1)      = mfQ2(fitData.outcome1(tI)) - mfQ1(fitData.resp1(tI));
            
            % chosen option --> reward outcome
            fitData.mfRPE4(tI,1)      = (fitData.outcomeMag(tI)/100) - mfQ1(fitData.resp1(tI));
            
            
           
            
            % MB RPE associted with reward valence (win/loss) delivery at the landing pad
            fitData.mbRPE3(tI,1)       = (fitData.outcomeBin(tI)) - mbQ3(fitData.outcome2(tI));
            
            % planet to pad RPE
            fitData.mbRPE2(tI,1) = padValue(fitData.outcome2(tI)) - planetVals(fitData.outcome1(tI));
            % stim --> planet RPE
            fitData.mbRPE1(tI,1) = planetVals(fitData.outcome1(tI)) - mbQ1(fitData.resp1(tI));
            
             % chosen option --> reward outcome
            fitData.mbRPE4(tI,1) = fitData.outcomeBin(tI) - mbQ1(fitData.resp1(tI));

             % update MF stimulus value according to the chosen option/outcome RPE
%            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            
%             
            % update stimulus value according to the first choice/planet prediction error
            mfQ1(fitData.resp1(tI))    = mfQ1(fitData.resp1(tI)) + rl_MF * fitData.mfRPE1(tI);
            % propagate the 2nd RPE through
            mfQ2(fitData.outcome1(tI)) = mfQ2(fitData.outcome1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
            mfQ1(fitData.resp1(tI))    = mfQ1(fitData.resp1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
            % propagate the 3rd RPE through
            mfQ3(fitData.outcome2(tI)) = mfQ3(fitData.outcome2(tI)) + rl_MF * fitData.mfRPE3(tI);
            mfQ2(fitData.outcome1(tI)) = mfQ2(fitData.outcome1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            mfQ1(fitData.resp1(tI))    = mfQ1(fitData.resp1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            
              
            % update MB terminal state values according to the binary value
            mbQ3(fitData.outcome2(tI)) = mbQ3(fitData.outcome2(tI)) + rl_MB * fitData.mbRPE3(tI);
            
            % stimulus-mapped win-stay/lose-switch
            wWSLS_MF(:) = 0;
            if fitData.outcomeBin(tI) == 1
                wWSLS_MF(fitData.resp1(tI)) = wWS_MF;
            else
                wWSLS_MF(fitData.resp1(tI)) = -wLS_MF;
            end

            % transition-mapped win-stay/lose-switch
            wWSLS_MB(:) = 0;
            if (data.doRareTrans(tI) == 0 && fitData.outcomeBin(tI) == 1) || (data.doRareTrans(tI) == 1 && fitData.outcomeBin(tI) == 0)
                wWSLS_MB(fitData.resp1(tI)) = wWS_MB;
            else
                wWSLS_MB(fitData.resp1(tI)) = -wLS_MB;
            end


                        
%             % compute the 1st level state prediction error
%             if  data.resp1(tI)==1
%                 fitData.SPE1(tI) = 1 - pTrans_1(data.outcome1(tI));
%                 pTrans_1(data.outcome1(tI)) = pTrans_1(data.outcome1(tI)) + aSPE1 * fitData.SPE1(tI);
%                 altStateIndex = 3-data.outcome1(tI);  
%             else
%                 fitData.SPE1(tI) = 1 - pTrans_1(data.outcome1(tI)+2);
%                 pTrans_1(data.outcome1(tI)+2) = pTrans_1(data.outcome1(tI)+2) + aSPE1 * fitData.SPE1(tI);
%                 altStateIndex = 5-data.outcome1(tI);
%             end
%             
%             pTrans_1(altStateIndex) = pTrans_1(altStateIndex) * (1-aSPE1);
            
                        
            % compute the 2nd level state prediction error
            fitData.SPE2(tI,1) = 1 - pTrans_2(fitData.outcome2(tI));
            % update the transition taken
            pTrans_2(fitData.outcome2(tI)) = pTrans_2(fitData.outcome2(tI)) + aSPE2 * fitData.SPE2(tI);
            if fitData.outcome2(tI) == 1 || fitData.outcome2(tI) == 3
                altStateIndex = fitData.outcome2(tI) + 1;
            else
                altStateIndex = fitData.outcome2(tI) - 1;
            end
            pTrans_2(altStateIndex) = pTrans_2(altStateIndex) * (1-aSPE2);
            
           
 	        % magnitude prediction errors
            if fitData.outcomeMag(tI) > 0
                fitData.magActRPE(tI,1) = (fitData.outcomeMag(tI)/100) - magAct(fitData.resp1(tI));
                magAct(fitData.resp1(tI)) = magAct(fitData.resp1(tI)) + rlMag * (fitData.magActRPE(tI));
                % for the planet
                fitData.magPlanetRPE(tI,1) = (fitData.outcomeMag(tI)/100) - magPlanet(fitData.outcome1(tI));
                magPlanet(fitData.outcome1(tI)) = magPlanet(fitData.outcome1(tI)) + rlMag * (fitData.magPlanetRPE(tI));
                % for the pad
                fitData.magPadRPE(tI,1) = (fitData.outcomeMag(tI)/100) - magPad(fitData.outcome2(tI));
                magPad(fitData.outcome2(tI)) = magPad(fitData.outcome2(tI)) + rlMag * (fitData.magPadRPE(tI));
            end
           


 
            % track previous reward magniude
           % prevMagStim(:)                     = 0;
           % prevMagState(:)                    = 0;
           % prevMagStim(data.resp1(tI))        = data.outcomeMag(tI)/100;
           % prevMagState(data.outcome1(tI))    = data.outcomeMag(tI)/100;
       % end % if valid response
    end % for each trial
    
    % determin which trials should be included in the fit
    isValidTrial = ~isnan(fitData.resp1);
    % adjust 0 probability trials
    fitData.pChoice(fitData.pChoice < eps | isnan(fitData.pChoice) | isinf(fitData.pChoice)) = eps;
    % compute null model negLLE
    fitData.null_negLLE = sum(isValidTrial) * log(0.5);
    fitData.negLLE = sum(log(fitData.pChoice(isValidTrial)));
    fitData.pseudoR = 1 - (fitData.negLLE/fitData.null_negLLE);
    % compute the negative log-like
    negLLE = fitData.negLLE;
end


function transParams = transformParams(params,fitOpts)
    defaults = fitOpts.defParamVals;
    doFit = fitOpts.doFit;
    
    % holds the transformed/raw parameters
    transParams = defaults;
    rawParams   = defaults;
    % graft offered parameters into place to map parameter indices
    transParams(doFit)  = params;
    rawParams(doFit)  = params;
    
    % softmax beta
    if doFit(1)
        transParams(1) = exp(rawParams(1));
    else
        transParams(1) = defaults(1);
    end
    
    % learning rate [0 --> 1] for stay
    if doFit(2)
        transParams(2) = 1./(1+exp(-rawParams(2)));
    else
        transParams(2) = defaults(2);
    end

    % reward magnitude influence on stimulus
    if doFit(3)
        transParams(3) = rawParams(3);
    else
        transParams(3) = defaults(3);
    end
    
    % reward magnitude influence on state
    if doFit(4)
        transParams(4) = rawParams(4);
    elseif doFit(3)
        transParams(4) = transParams(3);
    else
        transParams(4) = defaults(4);
    end

    % MF win-stay/ lose-switch
    if doFit(5)
        transParams(5) = rawParams(5);
    else
        transParams(5) = defaults(5);
    end
    if doFit(6)
        transParams(6) = rawParams(6);
    elseif doFit(5)
        transParams(6) = transParams(5);
    else
        transParams(6) = defaults(6);
    end

    % MB win-stay/ lose-switch
    if doFit(7)
        transParams(7) = rawParams(7);
    elseif doFit(5)
        % 5 map onto MF weights
        transParams(7) = rawParams(5);
    else
        transParams(7) = defaults(7);
    end
    if doFit(8)
        transParams(8) = rawParams(8);
    elseif doFit(7)
        transParams(8) = transParams(7);
    elseif doFit(6)
        % map onto MF weights
        transParams(8) = rawParams(6);
    else
        transParams(8) = defaults(8);
    end

    % base mixture
    if doFit(9)
        transParams(9) = rawParams(9);
    else
        transParams(9) = defaults(9);
    end

    % reward contingency adjustment
    if doFit(10)
        transParams(10) = rawParams(10);
    else
        transParams(10) = defaults(10);
    end

    % reward reliabiltiy adjustment
    if doFit(11)
        transParams(11) = rawParams(11);
    else
        transParams(11) = defaults(11);
    end

    % transition reliabiltiy adjustment
    if doFit(12)
        transParams(12) = rawParams(12);
    else
        transParams(12) = defaults(12);
    end
end % function
