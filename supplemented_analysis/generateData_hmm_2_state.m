function [negLLE,fitData] = hmm_2_state(params, data)

a11 = 1./(1+exp(-params(1)));
a22 = a11;
pH  = 1- 1./(1+exp(-params(2)))/2;
pL  = 1-pH;
epsi = 1./(1+exp(-params(3)));


%y=data.outcomeBin;
%resp1 = data.resp1;

% If your y is coded 1/2, convert to 0/1

T = size(data,1);


A = [a11, 1-a11;
     1-a22, a22];

% Stationary-ish init (simple). You can also free pi as parameters.
% Solve pi = pi*A with sum(pi)=1:
% For 2-state, closed form:


B = ones(2,T);
%B(1,:) = p1.^y .* (1-p1).^(1-y);
%B(2,:) = p2.^y .* (1-p2).^(1-y);


alpha = zeros(2,T);
c = zeros(1,T); % scaling

for t = 1:T
    
    if t==1
        alpha_0(1:2,1) =0.5;
        b_prior(:,t) = A' * alpha_0(:,1);
        
    end
    
    if t>1
        b_prior(:,t) = A'* alpha(:,t-1);
    end
    


    if b_prior(1,t)>b_prior(2,t)
        fitData.pOption(1,t)=1-epsi;
        fitData.pOption(2,t)=epsi;
    elseif b_prior(1,t)<b_prior(2,t)
        fitData.pOption(1,t) =epsi;
        fitData.pOption(2,t) =1-epsi;
    elseif b_prior(1,t)==b_prior(2,t)
        fitData.pOption(1,t) = 0.5;
        fitData.pOption(2,t) = 0.5;
    end
    
        

    %fitData.pOption(:,t) = (1-epsi) * b_prior(:,t) + epsi * (1-b_prior(:,t));


    
    thres = rand(1);
    choice_1 = find( cumsum(fitData.pOption(:,t)) > thres, 1);
    fitData.thres(t,1)=thres;
    
    
    fitData.resp1(t,1) = choice_1;
    
    
    
    % extract 2nd state
    if choice_1==1
        outcomeState = data.state2_1(t);
        %mb_reward = data.rewBinary2_1(tI);
        %mf_reward = data.rewMag(tI) * mb_reward;
    else
        outcomeState = data.state2_2(t);
        %mb_reward = data.rewBinary2_2(tI);
        %mf_reward = data.rewMag(tI) * mb_reward;
    end
    
    if outcomeState == 1
        mb_reward = data.rewBinary_1(t);
        
    elseif outcomeState == 2
        mb_reward = data.rewBinary_2(t);
        
    elseif outcomeState == 3
        mb_reward = data.rewBinary_3(t);
        
    else
        mb_reward = data.rewBinary_4(t);
        
    end
    

    
    
    fitData.outcomeBin (t,1) = mb_reward;
    fitData.outcome2(t,1) = outcomeState;
    fitData.outcome1(t,1) = (outcomeState>2) +1;
    fitData.outcomeMag(t,1) = 100 * mb_reward * data.rewMagnitude(t);
    
    % track probability of chosen response
    %fitData.pChoice(t,1)     = fitData.pOption(choice_1,t);
    
    
    if isnan(choice_1)
        fitData.pChoice(1,t)=nan;
        B(:,t)= 1;
    else
        fitData.pChoice(1,t)=fitData.pOption(choice_1,t);
        
        if fitData.outcome1(t,1)==1
            p1=pH;
            p2=pL;
            
        elseif fitData.outcome1(t,1)==2
            p1=pL;
            p2=pH;
            
        end
        
        B(1,t) = p1.^fitData.outcomeBin (t,1) .* (1-p1).^(1-fitData.outcomeBin (t,1));
        B(2,t) = p2.^fitData.outcomeBin (t,1) .* (1-p2).^(1-fitData.outcomeBin (t,1));
    end
    
    
    
    alpha(:,t) =  b_prior(:,t) .* B(:,t);
    c(t) = sum(alpha(:,t));
    
    %   if c(t)==0, loglik=-Inf; yhat=[]; return; end
    
    alpha(:,t) = alpha(:,t) / c(t);
    
    
    
end

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

fitData.AIC = 2*k-2*fitData.negLLE; 
fitData.BIC = k*log(n)-2*fitData.negLLE;


end
