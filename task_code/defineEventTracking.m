function tracking = defineEventTracking(numTrials, jitters)
    % to store task events as the unfold
    outcome1 = nan(numTrials, 1);
    outcome2 = nan(numTrials, 1);
    outcomeBin = nan(numTrials, 1);
    outcomeMag = nan(numTrials, 1);
    resp1 = nan(numTrials, 1);
    resp2 = nan(numTrials, 1);
    RT1 = nan(numTrials, 1);
    RT2 = nan(numTrials, 1);
    
    % to store event times
    tStart = nan(numTrials, 1);
    tFixOn = nan(numTrials, 1);
    tStim1On = nan(numTrials, 1);
    tResp1 = nan(numTrials, 1);
    tResp2 = nan(numTrials, 1);
    tState2On = nan(numTrials, 1);
    tTerminalState2On = nan(numTrials, 1);
    tFBOn_Bin = nan(numTrials, 1);
    tFBOn_Mag = nan(numTrials, 1);
    
    % set up intertrial jitters
    %
    % time between 1st stage response and display of 2nd state
    jitterResp1 = linspace(jitters(1,1), jitters(1,2), numTrials)';
    jitterResp1 = jitterResp1(randperm(length(jitterResp1)));
    % time jitter between response to land, and display of terminal state
    jitterState = linspace(jitters(2,1), jitters(2,2), numTrials)';
    jitterState = jitterState(randperm(length(jitterState)));
    % time between 2nd stage response and outcome feedback
    jitterFB = linspace(jitters(3,1), jitters(3,2), numTrials)';
    jitterFB = jitterFB(randperm(length(jitterFB)));
    % time between trials
    jitterITI = linspace(jitters(4,1), jitters(4,2), numTrials)';
    jitterITI = jitterITI(randperm(length(jitterITI)));
    
    tracking = table(outcome1, outcome2, outcomeBin, outcomeMag, resp1, resp2, RT1, RT2, ...
        tStart, tFixOn, tStim1On, tResp1, tState2On, tResp2, tTerminalState2On, tFBOn_Bin, tFBOn_Mag,...
        jitterResp1, jitterState, jitterFB, jitterITI);
end