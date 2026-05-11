function [task_MBMF_structMRI, ioStruct] = run_SpaceMarket_structuralMRI(subID, orderID, wPtr)
    % graft in task run information
    if nargin < 1, subID = input('Participant number :\n','s'); end
    if nargin < 2, orderID = input('Task ordering:\n','s'); end
    if nargin < 3, wPtr = []; end
    
    % path to where data will be saved
    outputFolder = fullfile('..', 'data');
    if exist(outputFolder, 'dir') == 0
        % folder does not exist - create it
        mkdir( outputFolder );
    end
    
    % initialize task variables
    task_MBMF_structMRI = initTask();
    task_MBMF_structMRI.subID = subID;
    task_MBMF_structMRI.orderID = orderID;
    task_MBMF_structMRI.outputFolder = outputFolder;
    task_MBMF_structMRI.fileName = ['subID_' subID '_sesID_' orderID '_MBMF_structureMRI_' datestr(now, 'mm-dd-yyyy_HH-MM-SS')];
    
    % initialize the IO for the task
    ioStruct = initIO(wPtr);
    
    %% show task instrutions
    run_instructions(ioStruct, fullfile('.', 'images', 'instructions_fMRI'), @buildInstRespMap_fMRI)
    
    
    %% run main task
    
%     % number of trials in each pre-scan practice block (each trial is approx 7 seconds)
%     numTrials = 50;
%     numRuns = 1;
%     trialBlocks = cell(numRuns,1); 
%     % randomize across high/low reward and state volatility with reward conditioned on outcome state
%     trialBlocks{1} = buildTrials_blocked(task_MBMF_structMRI, 1, numTrials, task_MBMF_structMRI.STATE_LOW, task_MBMF_structMRI.REWARD_HIGH, task_MBMF_structMRI.CONT_STATE);
%     trialBlocks{2} = buildTrials_blocked(task_MBMF_structMRI, 2, numTrials, task_MBMF_structMRI.STATE_HIGH, task_MBMF_structMRI.REWARD_LOW, task_MBMF_structMRI.CONT_STIM);
%     % randomize the order, flatten, and pull all trials into a single run
%     trialBlocks = trialBlocks( randperm(numel(trialBlocks)) );
%     task_MBMF_structMRI.trials = vertcat(trialBlocks{:});
%     task_MBMF_structMRI.trials.runID = ones(size(task_MBMF_structMRI.trials,1), 1);
%     
%     % jitters between events (response, state 1 display, feedback, ITI)
%     % ensure jitters are balanced across runs
%     jitters = [0.75 1.25; 0.75 1.25; 0.75 1.25; 0.75 1.25];
%     % add in event tracking and event jitters for each run of trials
%     trialEvents = [];
%     for rI = 1 : numRuns
%         trialEvents = [trialEvents; defineEventTracking(sum(task_MBMF_structMRI.trials.runID == rI), jitters)];
%     end
%     task_MBMF_structMRI.trials = [task_MBMF_structMRI.trials, trialEvents];
    
    % define task trials
    numRuns = 1;
    % each trial takes approximately 7 second
    numBlockTrials = 105;
    % build a set of trials to cross all blocks
    trials = buildTrials_dynamic(task_MBMF_structMRI, numBlockTrials);
    % parcel trials into required number of runs
    trials.runID = repelem(1:numRuns, numBlockTrials)';
    
    % jitters between events (response, state 1 display, feedback, ITI)
    % ensure jitters are balanced across runs
%     jitters = [0.75 1.25; 0.75 1.25; 0.75 1.25; 0.75 0.75];
    jitters = [1 1.5; 1 1.25; 1 1.5; 0.75 0.75];
   % jitters = [0.75 0.75; 0.75 0.75; 0.75 0.75; 0.75 0.75];
    % add in event tracking and event jitters for each run of trials
    trialEvents = [];
    for rI = 1 : numRuns
        trialEvents = [trialEvents; defineEventTracking(sum(trials.runID == rI), jitters)];
    end
    task_MBMF_structMRI.trials = [trials, trialEvents];
    
    
    
    % pass through each run
    for rI = unique(task_MBMF_structMRI.trials.runID)'
        % initiate prep-wait
        Screen(ioStruct.wPtr, 'Flip');
        % show inter-block information
        Screen('TextSize', ioStruct.wPtr, 30); Screen('TextColor', ioStruct.wPtr, [255 255 255]); Screen('TextFont', ioStruct.wPtr, 'Helvetica');
        DrawFormattedText(ioStruct.wPtr, 'Waiting for technician to mark ready status.', 'center', 'center');
        RestrictKeysForKbCheck( KbName('p') );
        Screen(ioStruct.wPtr, 'Flip');
        KbWait(-3,2);
        
        % extract the trials for this run and go
        runTrials = find(task_MBMF_structMRI.trials.runID == rI);
        task_MBMF_structMRI.tRunStart(rI) = GetSecs();
        % run the block of trials
        task_MBMF_structMRI = startSpaceMarketRun(task_MBMF_structMRI, ioStruct, runTrials, Inf, false);
        % store finish time and save the data
        task_MBMF_structMRI.tRunEnd(rI) = GetSecs();
        % save data to file
        save(fullfile(task_MBMF_structMRI.outputFolder, task_MBMF_structMRI.fileName));
    end
    
    % the block
    Screen(ioStruct.wPtr, 'Flip');
    % show inter-block information
    Screen('TextSize', ioStruct.wPtr, 30); Screen('TextColor', ioStruct.wPtr, [255 255 255]); Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    DrawFormattedText(ioStruct.wPtr, 'Time for a break.\n\n Please remain still, and the experimenter will be with you shortly.', 'center', 'center');
    Screen(ioStruct.wPtr, 'Flip');
    RestrictKeysForKbCheck( KbName('space'));
    KbWait(-3,2);

    RestrictKeysForKbCheck( [] );
    ListenChar(1); ShowCursor(); Screen('Close');
    % only the window if we weren't passed a shared window
    if isempty(wPtr)
        Screen('CloseAll');
    end
end

% waits for the initial key-code as initial pulse from scanner
function secs = waitForScannerPulse(ioStruct)
    % clear the screen
    Screen(ioStruct.wPtr, 'Flip');
    % wait for the scanner to send the initial pulse signal
    Screen('TextSize', ioStruct.wPtr, 30); Screen('TextColor', ioStruct.wPtr, [255 255 255]); Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    DrawFormattedText(ioStruct.wPtr, 'Waiting for initiation signal from scanner.', 'center', 'center');
    RestrictKeysForKbCheck( ioStruct.pulseKey ); 
    Screen(ioStruct.wPtr, 'Flip');
    % track the initial start time
    secs = KbWait(-3, 2);
    RestrictKeysForKbCheck([]);
end
