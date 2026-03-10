function [negLLE, fitData] = comp_getLLE_mbRPE_mfRPE_SPE_lr_rewMag_WSLS(params, data)

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


    
    fitData.transParams(3) = 1./(1+ exp(-params(3)));
    rl_MB             = fitData.transParams(3);
    % MF eligibility trace
    eD              = 1;
    % SPE learning rate
            
%     fitData.transParams(4) = 1./(1+ exp(-params(4)));
%     aSPE1           = fitData.transParams(4);
%     
    
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
%     fitData.transParams(10) =  params(10);
%     arb_mbRPE       = fitData.transParams(10);
%     fitData.transParams(11) =  params(11);
%     arb_mfRPE       = fitData.transParams(11);
%     fitData.transParams(12) =  params(12);
%     arb_SPE         = fitData.transParams(12);
%     
    
    
    
    
    
    % mf values for spaceships
    mfQ1  = zeros(1,2);
    % mf values for planets
    mfQ2  = zeros(1,2);
    % mf values for landing pads
    mfQ3  = zeros(1,4);
    
    % mb values for spaceships 
    mbQ1 = zeros(1,2);
    % mb values for planets
    mbQ2 = zeros(1,2);
    % mb values for landing pads
    mbQ3  = zeros(1,4);
    
    % known transition probabilities for 1st stage choice
    pTrans_1 = [0.7,0.3, 0.3,0.7];
    % learned transisitions for each of the 2nd stage states
    pTrans_2 = zeros(1,4) + 0.5;
    
    dataTID = data.trialID;
    % track learned MF values
    fitData.mfQ1        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.mfQ2        = nan(size(dataTID,1), size(mfQ2,2));
    fitData.mfQ3        = nan(size(dataTID,1), size(mfQ3,2));
    
    fitData.mfQ1_alternative       = nan(size(dataTID,1), size(mfQ1,2));
    
    fitData.chosen_mfQ1        = nan(size(dataTID,1), 1);
    fitData.chosen_mfQ2        = nan(size(dataTID,1), 1);
    fitData.chosen_mfQ3        = nan(size(dataTID,1), 1);
        
   
    fitData.wMF_trial        = nan(size(dataTID,1), 1);
    fitData.wMB_trial        = nan(size(dataTID,1), 1);
        
    fitData.wMF_trial_CONT        = nan(size(dataTID,1), 1);
    fitData.wMB_trial_CONT        = nan(size(dataTID,1), 1);
    
    fitData.wMF_trial_RPE        = nan(size(dataTID,1), 1);
    fitData.wMB_trial_RPE        = nan(size(dataTID,1), 1);
    
    fitData.wMF_trial_SPE        = nan(size(dataTID,1), 1);
    fitData.wMB_trial_SPE        = nan(size(dataTID,1), 1);
    
    fitData.weighted_mfQ1        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.weighted_mbQ1        = nan(size(dataTID,1), size(mfQ1,2));
            
    fitData.mfUtility        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.mbUtility        = nan(size(dataTID,1), size(mfQ1,2));
    
    fitData.weighted_mfUtility        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.weighted_mbUtility        = nan(size(dataTID,1), size(mfQ1,2));
    
    fitData.CONT_weighted_mfUtility        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.CONT_weighted_mbUtility        = nan(size(dataTID,1), size(mfQ1,2));
    
    fitData.RPE_weighted_mfUtility        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.RPE_weighted_mbUtility        = nan(size(dataTID,1), size(mfQ1,2));
    
    fitData.SPE_weighted_mfUtility        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.SPE_weighted_mbUtility        = nan(size(dataTID,1), size(mfQ1,2));
    

    
    % track learned MB values
    fitData.mbQ1        = nan(size(dataTID,1), size(mfQ1,2));
    fitData.mbQ2        = nan(size(dataTID,1), size(mfQ2,2));
    fitData.mbQ3        = nan(size(dataTID,1), size(mfQ3,2));
    
    fitData.mb_padValue        = nan(size(dataTID,1), size(mfQ3,2));
    
    fitData.chosen_mbQ1        = nan(size(dataTID,1), 1);
    fitData.chosen_mbQ2        = nan(size(dataTID,1), 1);
    fitData.chosen_mbQ3        = nan(size(dataTID,1), 1);
    fitData.chosen_padValue    = nan(size(dataTID,1), 1);
    % learned state transition probabilities
        
    fitData.pTrans_1   = nan(size(dataTID,1),4);
    fitData.pTrans_2    = nan(size(dataTID,1), 4);
    
    
    % track prediction errors
    
    fitData.mfRPE1      = nan( size(dataTID,1), 1 );
    fitData.mfRPE2      = nan( size(dataTID,1), 1 );
    fitData.mfRPE3      = nan( size(dataTID,1), 1 );
    fitData.mfRPE4      = nan( size(dataTID,1), 1 );

        
    fitData.weighted_mfRPE1      = nan( size(dataTID,1), 1 );
    fitData.weighted_mfRPE2      = nan( size(dataTID,1), 1 );
    fitData.weighted_mfRPE3      = nan( size(dataTID,1), 1 );
    fitData.weighted_mfRPE4      = nan( size(dataTID,1), 1 );
    
    fitData.mbRPE1      = nan( size(dataTID,1), 1 );
    fitData.mbRPE2      = nan( size(dataTID,1), 1 );
    fitData.mbRPE3      = nan( size(dataTID,1), 1 );
    fitData.mbRPE4      = nan( size(dataTID,1), 1 );
    
    fitData.weighted_mbRPE1      = nan( size(dataTID,1), 1 );
    fitData.weighted_mbRPE2      = nan( size(dataTID,1), 1 );
    fitData.weighted_mbRPE3      = nan( size(dataTID,1), 1 );
    fitData.weighted_mbRPE4      = nan( size(dataTID,1), 1 );
    
    fitData.SPE1         = nan( size(dataTID,1), 1 );
    fitData.SPE2         = nan( size(dataTID,1), 1 );
    
    fitData.fastMFRPE    = nan( size(dataTID,1),1);
    fitData.fastMBRPE    = nan( size(dataTID,1),1);
    
    
    fitData.magActRPE    = nan(size(dataTID,1),1);
    fitData.magPlanetRPE = nan(size(dataTID,1),1);
    fitData.magPadRPE    = nan(size(dataTID,1),1);
    
    
    
    
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
            
            mfQ1_alternative(:) = 0;
            
            pTrans_1         = [0.7,0.3,0.3,0.7];
            pTrans_2(:)         = 0.5;
%             prevMagStim(:)      = 0.5;
%             prevMagState(:)     = 0.5;
            wWSLS_MF(:)         = 0;
            wWSLS_MB(:)         = 0;
            
            
            % learned reward magnitudes
            magAct(:)           = 0;
            magPlanet(:)        = 0;
            magPad(:)           = 0;
            
            
           
        end
        
        % was a response made
        if ~isnan(data.resp1(tI)) % && data.TOI(tI)~=0
            % extract MF value for 1st level options
            fitData.mfQ1(tI,:) = mfQ1;
            fitData.mfQ2(tI,:) = mfQ2;
            fitData.mfQ3(tI,:) = mfQ3;
            fitData.mbQ1(tI,:) = mbQ1;
            fitData.mbQ2(tI,:) = mbQ2;
            fitData.mbQ3(tI,:) = mbQ3;
            
            fitData.mfQ1_alternative(tI,:) = mfQ1_alternative;
            
            padValue    = mbQ3 + (wMag*magPad);
            fitData.mb_padValue(tI,:) = padValue;
            
            fitData.chosen_mfQ1(tI) = mfQ1(data.resp1(tI));
            fitData.chosen_mfQ2(tI) = mfQ2(data.outcome1(tI));
            fitData.chosen_mfQ3(tI) = mfQ3(data.outcome2(tI));
            
                        
            fitData.chosen_mbQ1(tI) = mbQ1(data.resp1(tI));
            fitData.chosen_mbQ2(tI) = mbQ2(data.outcome1(tI));
            fitData.chosen_mbQ3(tI) = mbQ3(data.outcome2(tI));
            
            fitData.chosen_padValue(tI) = padValue(data.outcome2(tI));
            
            % store the current state transition belief
            fitData.pTrans_1(tI,:)    = pTrans_1;
            fitData.pTrans_2(tI,:)    = pTrans_2;
            
            arb_mbRPE = 0;
            arb_mfRPE = 0;
            arb_SPE = 0;
            % define reward contingency shift
            if data.isPost_ContState(tI) == 1
                
                wMF_mbRPE = -arb_mbRPE;
            else
                wMF_mbRPE = arb_mbRPE;
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
            
            wMF_trial_CONT = 1./(1+exp(-1*(wMF + wMF_mbRPE)));
            
            wMF_trial_RPE = 1./(1+exp(-1*(wMF + wMF_mfRPE )));
            
            wMF_trial_SPE = 1./(1+exp(-1*(wMF + wMF_SPE)));
            
            fitData.wMF_trial(tI) = wMF_trial;
            fitData.wMB_trial(tI) = 1-wMF_trial;
            
            fitData.wMF_trial_CONT(tI) = wMF_trial_CONT;
            fitData.wMB_trial_CONT(tI) = 1-wMF_trial_CONT;
            
            fitData.wMF_trial_RPE(tI) = wMF_trial_RPE;
            fitData.wMB_trial_RPE(tI) = 1-wMF_trial_RPE;
            
            fitData.wMF_trial_SPE(tI) = wMF_trial_SPE;
            fitData.wMB_trial_SPE(tI) = 1-wMF_trial_SPE;
            
            
            fitData.weighted_mfQ1(tI,:) = wMF_trial*mfQ1;
            fitData.weighted_mbQ1(tI,:) = (1-wMF_trial)*mbQ1;
            
                        
            fitData.mfUtility(tI,:) = mfQ1 + wWSLS_MF;
            fitData.mbUtility(tI,:) = mbQ1 + wWSLS_MB;
            
            fitData.weighted_mfUtility(tI,:) = wMF_trial*(mfQ1 + wWSLS_MF);
            fitData.weighted_mbUtility(tI,:) = (1-wMF_trial)*(mbQ1 + wWSLS_MB);
            
            fitData.CONT_weighted_mfUtility(tI,:) = wMF_trial_CONT*(mfQ1 + wWSLS_MF);
            fitData.CONT_weighted_mbUtility(tI,:) = (1-wMF_trial_CONT)*(mbQ1 + wWSLS_MB);
            
            fitData.RPE_weighted_mfUtility(tI,:) = wMF_trial_RPE*(mfQ1 + wWSLS_MF);
            fitData.RPE_weighted_mbUtility(tI,:) = (1-wMF_trial_RPE)*(mbQ1 + wWSLS_MB);
            
            fitData.SPE_weighted_mfUtility(tI,:) = wMF_trial_SPE*(mfQ1 + wWSLS_MF);
            fitData.SPE_weighted_mbUtility(tI,:) = (1-wMF_trial_SPE)*(mbQ1 + wWSLS_MB);
            
            
            % computer controller action differences
            qMF_diff        = mfQ1(1) - mfQ1(2);
            qMB_diff        = mbQ1(1) - mbQ1(2);
%             magStateDiff    = wMagState * (prevMagState(1) - prevMagState(2));
%             magStimDiff     = wMagStim * (prevMagStim(1) - prevMagStim(2));
            MF_WSLS         = wWSLS_MF(1) - wWSLS_MF(2);
            MB_WSLS         = wWSLS_MB(1) - wWSLS_MB(2);
            
            % linear combination of value
                       
            Q_Net =  wMF_trial*mfQ1 + (1-wMF_trial)*mbQ1;
            fitData.Q_Net(tI,:) = Q_Net;
            
            Q_Net_Diff = wMF_trial*qMF_diff +  (1-wMF_trial)*qMB_diff;
            fitData.Q_Net_Diff(tI) = Q_Net_Diff;
            
            actUtil = wMF_trial*(mfQ1 + wWSLS_MF) + (1-wMF_trial)*(mbQ1 + wWSLS_MB);
            fitData.actUtil(tI,:) = actUtil;
            
            qDiff = wMF_trial*(qMF_diff + MF_WSLS) + (1-wMF_trial)*(qMB_diff + MB_WSLS);
            fitData.qDiff(tI) =qDiff;
            
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
            
            fitData.mfRPE4(tI)      = (data.outcomeMag(tI)/100) - mfQ1(data.resp1(tI));
            
            
%             
%             % update stimulus value according to the first choice/planet prediction error
%             mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + rl_MF * fitData.mfRPE1(tI);
%             % propagate the 2nd RPE through
%             mfQ2(data.outcome1(tI)) = mfQ2(data.outcome1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
%             mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
%             % propagate the 3rd RPE through
%             mfQ3(data.outcome2(tI)) = mfQ3(data.outcome2(tI)) + rl_MF * fitData.mfRPE3(tI);
%             mfQ2(data.outcome1(tI)) = mfQ2(data.outcome1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
%             mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            
            

            % MF RPE associted with reward magnitude delivery at the landing pad         
            fitData.weighted_mfRPE3(tI)      = wMF_trial*((data.outcomeMag(tI)/100) - mfQ3(data.outcome2(tI)));
            % MF RPE associated with transition from planet to landing pad
            fitData.weighted_mfRPE2(tI)      = wMF_trial*(mfQ3(data.outcome2(tI)) - mfQ2(data.outcome1(tI)));
            % MF RPE associated with the transition from choice to planet
            fitData.weighted_mfRPE1(tI)      = wMF_trial*(mfQ2(data.outcome1(tI)) - mfQ1(data.resp1(tI)));
            
            fitData.weighted_mfRPE4(tI)      = wMF_trial*((data.outcomeMag(tI)/100) - mfQ1(data.resp1(tI)));
            
                    
            
               
            % MB RPE associted with reward valence (win/loss) delivery at the landing pad
            fitData.mbRPE3(tI)       = (data.outcomeBin(tI)) - mbQ3(data.outcome2(tI));
            
            % planet to pad RPE
            fitData.mbRPE2(tI) = padValue(data.outcome2(tI)) - mbQ2(data.outcome1(tI));
            % stim --> planet RPE
            fitData.mbRPE1(tI) = mbQ2(data.outcome1(tI)) - mbQ1(data.resp1(tI));
            
             % chosen option --> reward outcome
            fitData.mbRPE4(tI) = data.outcomeBin(tI) - mbQ1(data.resp1(tI));
            
            
                        
            % MB RPE associted with reward valence (win/loss) delivery at the landing pad
            fitData.weighted_mbRPE3(tI)       = (1-wMF_trial)*((data.outcomeMag(tI)/100) - mbQ3(data.outcome2(tI)));
            % MB RPE associated with transition from planet to landing pad
            fitData.weighted_mbRPE2(tI)       = (1-wMF_trial)*(mbQ3(data.outcome2(tI)) - mbQ2(data.outcome1(tI)));
            % MB RPE associated with transition from choice to planet
            fitData.weighted_mbRPE1(tI)       = (1-wMF_trial)*(mbQ2(data.outcome1(tI)) - mbQ1(data.resp1(tI)));
            
            fitData.weighted_mbRPE4(tI)       = (1-wMF_trial)*(data.outcomeBin(tI) - mbQ1(data.resp1(tI)));
            
            % update MF stimulus value according to the chosen option/outcome RPE
            mfQ1_alternative(data.resp1(tI)) = mfQ1(data.resp1(tI)) + rl_MF * fitData.mfRPE4(tI);
            
            
            % update stimulus value according to the first choice/planet prediction error
            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + rl_MF * fitData.mfRPE1(tI);
            % propagate the 2nd RPE through
            mfQ2(data.outcome1(tI)) = mfQ2(data.outcome1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + eD * rl_MF * fitData.mfRPE2(tI);
            % propagate the 3rd RPE through
            mfQ3(data.outcome2(tI)) = mfQ3(data.outcome2(tI)) + rl_MF * fitData.mfRPE3(tI);
            mfQ2(data.outcome1(tI)) = mfQ2(data.outcome1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            mfQ1(data.resp1(tI))    = mfQ1(data.resp1(tI)) + eD * rl_MF * fitData.mfRPE3(tI);
            
            
           
            
            % stimulus-mapped win-stay/lose-switch
            wWSLS_MF(:) = 0;
            if data.outcomeBin(tI) == 1
                wWSLS_MF(data.resp1(tI)) = wWS_MF;
                fitData.fastMFRPE(tI) = wWS_MF;
            else
                wWSLS_MF(data.resp1(tI)) = -wLS_MF;
                fitData.fastMFRPE(tI) = -wLS_MF;
            end

            % transition-mapped win-stay/lose-switch
            wWSLS_MB(:) = 0;
            if (data.doRareTrans(tI) == 0 && data.outcomeBin(tI) == 1) || (data.doRareTrans(tI) == 1 && data.outcomeBin(tI) == 0)
                wWSLS_MB(data.resp1(tI)) = wWS_MB;
                fitData.fastMBRPE(tI) = wWS_MB;
            else
                wWSLS_MB(data.resp1(tI)) = -wLS_MB;
                fitData.fastMBRPE(tI) = -wLS_MB;
            end

            % update MB terminal state values
            mbQ3(data.outcome2(tI)) = mbQ3(data.outcome2(tI)) + rl_MB * fitData.mbRPE3(tI);
            
            
                        
            % compute the 1st level state prediction error
            if  data.resp1(tI)==1
                fitData.SPE1(tI) = 1 - pTrans_1(data.outcome1(tI));
                %pTrans_1(data.outcome1(tI)) = pTrans_1(data.outcome1(tI)) + aSPE1 * fitData.SPE1(tI);
                %altStateIndex = 3-data.outcome1(tI);  
            else
                fitData.SPE1(tI) = 1 - pTrans_1(data.outcome1(tI)+2);
                %pTrans_1(data.outcome1(tI)+2) = pTrans_1(data.outcome1(tI)+2) + aSPE1 * fitData.SPE1(tI);
                %altStateIndex = 5-data.outcome1(tI);
            end
            
            %pTrans_1(altStateIndex) = pTrans_1(altStateIndex) * (1-aSPE1);
            
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
                fitData.magActRPE(tI,1) = (data.outcomeMag(tI)/100) - magAct(data.resp1(tI));
                magAct(data.resp1(tI)) = magAct(data.resp1(tI)) + rlMag * (fitData.magActRPE(tI));
                % for the planet
                fitData.magPlanetRPE(tI,1) = (data.outcomeMag(tI)/100) - magPlanet(data.outcome1(tI));
                magPlanet(data.outcome1(tI)) = magPlanet(data.outcome1(tI)) + rlMag * (fitData.magPlanetRPE(tI));
                % for the pad
                fitData.magPadRPE(tI,1) = (data.outcomeMag(tI)/100) - magPad(data.outcome2(tI));
                magPad(data.outcome2(tI)) = magPad(data.outcome2(tI)) + rlMag * (fitData.magPadRPE(tI));
            end
            
            % derive MB action values weighted according to state transitions
             
            padValue    = mbQ3 + (wMag*magPad);
            mbQ2  = [pTrans_2([1,2]) * padValue([1,2])', pTrans_2([3,4]) * padValue([3,4])'];
            mbQ1        = [pTrans_1([1,2]) * mbQ2', pTrans_1([3,4]) * mbQ2'];
                               
            
            
            
            
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
    
    fitData.AIC =  2*k-2*fitData.negLLE;
    fitData.BIC = k*log(n)-2*fitData.negLLE;
    
    fitData.wMF = wMF;
    
    fitData.arb_mbRPE = arb_mbRPE;
    fitData.arb_mfRPE = arb_mfRPE;
    fitData.arb_SPE = arb_SPE;
    
    
    
end