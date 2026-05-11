    function [task_MBMF_preScan, ioStruct] = run_SpaceMarket_preScan(subID, orderID, wPtr)
    % graft in task run information
    if nargin < 1, subID = input('Participant number :\n','s'); end
    if nargin < 2, orderID = input('Task ordering (1=Two-step first; 2=Two-step second):\n','s'); end
    if nargin < 3, wPtr = []; end
    
    % path to where data will be saved
    outputFolder = fullfile('..', 'data');
    if exist(outputFolder, 'dir') == 0
        % folder does not exist - create it
        mkdir( outputFolder );
    end
    
    % initialize task variables
    task_MBMF_preScan = initTask();
    task_MBMF_preScan.subID = subID;
    task_MBMF_preScan.orderID = orderID;
    task_MBMF_preScan.outputFolder = outputFolder;
    task_MBMF_preScan.fileName = ['subID_' subID '_ordID_' orderID '_MBMF_preScan_' datestr(now, 'mm-dd-yyyy_HH-MM-SS')];
    
    % initialize the IO for the task
    ioStruct = initIO(wPtr);
    
    %% show task instrutions
    run_instructions(ioStruct, fullfile('.', 'images', 'instructions_preScan'), @buildInstRespMap_preScan)
    
    %% Run practice trials
    
    % number of trials in each pre-scan practice block (each trial is approx 7 seconds)
    numRuns = 1;
    numBlocks = 3;
    trialBlocks = cell(numBlocks,1); 
    % A pair of short block to get familiar with the game strucutre
    trialBlocks{1} = buildTrials_blocked(task_MBMF_preScan, 1, 15, task_MBMF_preScan.STATE_LOW, task_MBMF_preScan.REWARD_HIGH, task_MBMF_preScan.CONT_STATE);
    % randomize across high/low reward and state volatility with reward conditioned on outcome state
    trialBlocks{2} = buildTrials_blocked(task_MBMF_preScan, 2, 50, task_MBMF_preScan.STATE_LOW, task_MBMF_preScan.REWARD_HIGH, task_MBMF_preScan.CONT_STATE);
    trialBlocks{3} = buildTrials_blocked(task_MBMF_preScan, 3, 50, task_MBMF_preScan.STATE_HIGH, task_MBMF_preScan.REWARD_LOW, task_MBMF_preScan.CONT_STIM);
    % randomize the order, flatten, and pull all trials into a single run
    blockToRandomize = [2 3];
    trialBlocks(blockToRandomize) = trialBlocks( randsample(blockToRandomize, 2) );
    task_MBMF_preScan.trials = vertcat(trialBlocks{:});
    task_MBMF_preScan.trials.runID = ones(size(task_MBMF_preScan.trials,1), 1);
    
    % jitters between events (response, state 1 display, feedback, ITI)
    % ensure jitters are balanced across runs
    jitters = [1 1.5; 1 1.25; 1 1.5; 0.75 0.75];
    % add in event tracking and event jitters for each run of trials
    trialEvents = [];
    for rI = 1 : numRuns
        trialEvents = [trialEvents; defineEventTracking(sum(task_MBMF_preScan.trials.runID == rI), jitters)];
    end
    task_MBMF_preScan.trials = [task_MBMF_preScan.trials, trialEvents];
        
    % run though all practice trials
    runTrials = 1:size(task_MBMF_preScan.trials, 1);
    task_MBMF_preScan.startTime = GetSecs();
    % run the pre-scan trials - giving a break every 4 minues
    task_MBMF_preScan = startSpaceMarketRun(task_MBMF_preScan, ioStruct, runTrials, 4*60, false);
    task_MBMF_preScan.endTime = GetSecs();
    save(fullfile(task_MBMF_preScan.outputFolder, task_MBMF_preScan.fileName));
    
    % wait for user to initiate
    Screen(ioStruct.wPtr, 'Flip');
    Screen('TextSize', ioStruct.wPtr, 30); Screen('TextColor', ioStruct.wPtr, [255 255 255]); Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    DrawFormattedText(ioStruct.wPtr, 'We''re done with practice.\n\n Please let the experimenter know that you''re done.', 'center', 'center');
    RestrictKeysForKbCheck( ioStruct.respKey_Quit );
    Screen(ioStruct.wPtr, 'Flip');
    KbWait(-3, 2);
    
    ListenChar(1); ShowCursor(); Screen('Close');
    
    % only the window if we weren't passed a shared window
    if isempty(wPtr)
        Screen('CloseAll');
    end
end
