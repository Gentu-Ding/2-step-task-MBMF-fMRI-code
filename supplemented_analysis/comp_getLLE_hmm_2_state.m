function [negLLE,fitData] = hmm_2_state(params, data)


a11 = 1./(1+exp(-params(1)));
a22 = a11;
pH  = 1- 1./(1+exp(-params(2)))/2;
pL  = 1-pH;
epsi = 1./(1+exp(-params(3)));

y=data.outcomeBin;
resp1 = data.resp1;
state1=data.outcome1;
    
fitData.choice = data.resp1;

% If your y is coded 1/2, convert to 0/1

T = numel(y);


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

    
    
    if isnan(resp1(t))
        fitData.pChoice(1,t)=nan;
        B(:,t)= 1;
    else
        fitData.pChoice(1,t)=fitData.pOption(resp1(t),t);
        
        if state1(t)==1
            p1=pH;
            p2=pL;
            
        elseif state1(t)==2
            p1=pL;
            p2=pH;
            
        end
        
        B(1,t) = p1.^y(t) .* (1-p1).^(1-y(t));
        B(2,t) = p2.^y(t) .* (1-p2).^(1-y(t));
    end
    
    
    
    alpha(:,t) =  b_prior(:,t) .* B(:,t);
    c(t) = sum(alpha(:,t));
    
    %   if c(t)==0, loglik=-Inf; yhat=[]; return; end
    
    alpha(:,t) = alpha(:,t) / c(t);

    
    
end


isValidTrial = ~isnan(resp1); % & data.TOI==1;
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


%sigm = @(x) 1./(1+exp(-x));

%loglik = sum(log(c));

% optional: predicted P(y=1) using filtering distribution alpha(:,t)
%yhat =pChoice;
%yhat = yhat(:);

end
