function [negLLE, fitData] = getLLE_magMF_binMB_mbRPE_mfRPE_SPE_rewMag_WSLS(params, data)

    
    % store computational variables
    fitData = struct();
    
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
            mbQ3(:)             = 0;
            pTrans_1 = [0.7,0.3,0.3,0.7];
            pTrans_2(:)         = 0.5;            

            wWSLS_MF(:)         = 0;
            wWSLS_MB(:)         = 0;
            
            % learned reward magnitudes
            magAct(:)           = 0;
            magPlanet(:)        = 0;
            magPad(:)           = 0;
            
        end
        
        % was a respons made
        if ~isnan(data.resp1(tI))
            % extract MF value for 1st level options
            fitData.mfQ1(tI,:) = mfQ1;
            fitData.mfQ2(tI,:) = mfQ2;
            fitData.mfQ3(tI,:) = mfQ3;
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
            MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
            MB_WSLS         = wWSLS_MB(1) - wWSLS_MB(2);
            
            
            
            % linear combination of value
            qDiff = wMF_trial*(qMF_diff + MF_WSLS) + (1-wMF_trial)*(qMB_diff + MB_WSLS);

            % derive choice probability
            fitData.pOption(tI,1) = 1 ./ (1 + exp(-smB * qDiff ));
            fitData.pOption(tI,2) = 1-fitData.pOption(tI,1);
            
            % track probabiilty of chosen response
            fitData.pChoice(tI)     = fitData.pOption(tI, data.resp1(tI));
            
            % MF RPE associted with reward magnitude delivery at the landing pad
            fitData.mfRPE3(tI)      = (data.outcomeMag(tI)/100) - mfQ3(data.outcome2(tI));
            % RPE associated with transition from planet to landing pad
            fitData.mfRPE2(tI)      = mfQ3(data.outcome2(tI)) - mfQ2(data.outcome1(tI));
            % RPE associated with the transition from choice to planet
            fitData.mfRPE1(tI)      = mfQ2(data.outcome1(tI)) - mfQ1(data.resp1(tI));
            
            % chosen option --> reward outcome
            fitData.mfRPE4(tI)      = (data.outcomeMag(tI)/100) - mfQ1(data.resp1(tI));
            
            
           
            
            % MB RPE associted with reward valence (win/loss) delivery at the landing pad
            fitData.mbRPE3(tI)       = (data.outcomeBin(tI)) - mbQ3(data.outcome2(tI));
            
            % planet to pad RPE
            fitData.mbRPE2(tI) = padValue(data.outcome2(tI)) - planetVals(data.outcome1(tI));
            % stim --> planet RPE
            fitData.mbRPE1(tI) = planetVals(data.outcome1(tI)) - mbQ1(data.resp1(tI));
            
             % chosen option --> reward outcome
            fitData.mbRPE4(tI) = data.outcomeBin(tI) - mbQ1(data.resp1(tI));

             % update MF stimulus value according to the chosen option/outcome RPE
%            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            
%             
            % update stimulus value according to the first choice/planet prediction error
            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + rl_MF * fitData.mfRPE1(tI);
            % propagate the 2nd RPE through
            mfQ2(data.outcome1(tI)) = mfQ2(data.outcome1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
            % propagate the 3rd RPE through
            mfQ3(data.outcome2(tI)) = mfQ3(data.outcome2(tI)) + rl_MF * fitData.mfRPE3(tI);
            mfQ2(data.outcome1(tI)) = mfQ2(data.outcome1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            
              
            % update MB terminal state values according to the binary value
            mbQ3(data.outcome2(tI)) = mbQ3(data.outcome2(tI)) + rl_MB * fitData.mbRPE3(tI);
            
            % stimulus-mapped win-stay/lose-switch
            wWSLS_MF(:) = 0;
            if data.outcomeBin(tI) == 1
                wWSLS_MF(data.resp1(tI)) = wWS_MF;
            else
                wWSLS_MF(data.resp1(tI)) = -wLS_MF;
            end

            % transition-mapped win-stay/lose-switch
            wWSLS_MB(:) = 0;
            if (data.doRareTrans(tI) == 0 && data.outcomeBin(tI) == 1) || (data.doRareTrans(tI) == 1 && data.outcomeBin(tI) == 0)
                wWSLS_MB(data.resp1(tI)) = wWS_MB;
            else
                wWSLS_MB(data.resp1(tI)) = -wLS_MB;
            end


                        
            % compute the 2nd level state prediction error
            fitData.SPE2(tI) = 1 - pTrans_2(data.outcome2(tI));
            % update the transition taken
            pTrans_2(data.outcome2(tI)) = pTrans_2(data.outcome2(tI)) + aSPE2 * fitData.SPE2(tI);
            if data.outcome2(tI) == 1 || data.outcome2(tI) == 3
                altStateIndex = data.outcome2(tI) + 1;
            else
                altStateIndex = data.outcome2(tI) - 1;
            end
            pTrans_2(altStateIndex) = pTrans_2(altStateIndex) * (1-aSPE2);
            
           
 	        % magnitude prediction errors
            if data.outcomeMag(tI) > 0
                fitData.magActRPE(tI) = (data.outcomeMag(tI)/100) - magAct(data.resp1(tI));
                magAct(data.resp1(tI)) = magAct(data.resp1(tI)) + rlMag * (fitData.magActRPE(tI));
                % for the planet
                fitData.magPlanetRPE(tI) = (data.outcomeMag(tI)/100) - magPlanet(data.outcome1(tI));
                magPlanet(data.outcome1(tI)) = magPlanet(data.outcome1(tI)) + rlMag * (fitData.magPlanetRPE(tI));
                % for the pad
                fitData.magPadRPE(tI) = (data.outcomeMag(tI)/100) - magPad(data.outcome2(tI));
                magPad(data.outcome2(tI)) = magPad(data.outcome2(tI)) + rlMag * (fitData.magPadRPE(tI));
            end
           

        end % if valid response
    end % for each trial
    
    % determin which trials should be included in the fit
    isValidTrial = ~isnan(data.resp1);
    % adjust 0 probability trials
    fitData.pChoice(fitData.pChoice < eps | isnan(fitData.pChoice) | isinf(fitData.pChoice)) = eps;
    % compute null model negLLE
    fitData.null_negLLE = sum(isValidTrial) * log(0.5);
    fitData.negLLE = sum(log(fitData.pChoice(isValidTrial)));
    fitData.pseudoR = 1 - (fitData.negLLE/fitData.null_negLLE);
    % compute the negative log-like
    negLLE = fitData.negLLE;
end

