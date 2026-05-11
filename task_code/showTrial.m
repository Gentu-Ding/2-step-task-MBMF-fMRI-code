function trialSpec = showTrial(taskStruct, ioStruct, trialSpec)
    % only allow relevant keys
    RestrictKeysForKbCheck( [ioStruct.respKey_1, ioStruct.respKey_2] );
    
    % task stimulus placeholders
    Screen('TextSize', ioStruct.wPtr, 60); Screen('TextColor', ioStruct.wPtr, ioStruct.textColor);  
    % show fixation
    DrawFormattedText(ioStruct.wPtr, '+', 'center', 'center');
    [~, trialSpec.tStart] = Screen(ioStruct.wPtr, 'Flip');
    
    % show ship options after ITI has expired
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.spaceShip(1), [], ioStruct.rectShip(ioStruct.LEFT,:));
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.spaceShip(2), [], ioStruct.rectShip(ioStruct.RIGHT,:));
    [~, trialSpec.tStim1On] = Screen(ioStruct.wPtr, 'Flip', trialSpec.tStart + trialSpec.jitterITI, 1);
    
    % wait for response and store RT
    [trialSpec.tResp1, keyCode] = KbWait(-3, 2, trialSpec.tStim1On + ioStruct.MAX_RT);
    trialSpec.RT1 = trialSpec.tResp1 - trialSpec.tStim1On;
    pressedKey = find(keyCode);
           
    % was a valid response captured
    if isempty(pressedKey)
        % no valid response - show too slow error
        trialSpec = showTooSlow(ioStruct, trialSpec);
        return;
    end
    
    % store response
    if ismember(pressedKey(end), ioStruct.respKey_1)
        trialSpec.resp1 = ioStruct.LEFT;
    elseif ismember(pressedKey(end), ioStruct.respKey_2)
        trialSpec.resp1 = ioStruct.RIGHT;
    end
    % track state transitioned into for the given action
    trialSpec.outcome1 = trialSpec.state2(trialSpec.resp1);
    
    % move the selected ship toward the center, and dim the rejected option
    flipPause = 0.02;
    flipTimes = [0:flipPause:(trialSpec.jitterResp1)-0.5] + GetSecs();
    % track the current ship location
    selectedLocation = ioStruct.rectShip(trialSpec.resp1,:);
    rejectedLocation = ioStruct.rectShip(trialSpec.resp1 ~= [ioStruct.LEFT, ioStruct.RIGHT],:);
    % step through widths and heights for shrinking ship
    shipWidth = selectedLocation(3) - selectedLocation(1);
    shipHeight = selectedLocation(4) - selectedLocation(2);
    % adjtement to the ship size at each step
    stepWidth = linspace(0, 0.25*shipWidth, length(flipTimes));
    stepHeight = linspace(0, 0.25*shipHeight, length(flipTimes));
    % step through [x,y] corrdinates for moving the ship
    stepX = linspace(0, 0, length(flipTimes));
    stepY = linspace(0, 50, length(flipTimes));
    
    alphaDimSel = logspace(0, log10(255), length(flipTimes));
    alphaDimRej = 255 - logspace(log10(255), 0, length(flipTimes));
    % dim the rejected ship to visualize the jitter
    for fI = 1 : length(flipTimes)
        % dim the rejected ship
        Screen('FillRect', ioStruct.wPtr, [ioStruct.bgColor alphaDimRej(fI)], rejectedLocation);
        % cover the chosen ship
        % show the selected ship as taking off
        Screen('FillRect', ioStruct.wPtr, ioStruct.bgColor, selectedLocation);
        % draw ship in new location
        sizeAdjust = [stepWidth(fI), stepHeight(fI), -stepWidth(fI), -stepHeight(fI)];
        locAdjust = [stepX(fI), -stepY(fI), stepX(fI), -stepY(fI)];
        newLocation = selectedLocation + sizeAdjust + locAdjust;
        Screen('DrawTexture', ioStruct.wPtr, ioStruct.spaceShipSelect(trialSpec.resp1), [], newLocation);  
        Screen('FillRect', ioStruct.wPtr, [ioStruct.bgColor alphaDimSel(fI)], newLocation);
        Screen(ioStruct.wPtr, 'Flip', flipTimes(fI), 1);
    end
    % clear the screen before showing the planet
    Screen(ioStruct.wPtr, 'Flip');
    
    % show the 2nd state planet
    if ismember(trialSpec.outcome1, [1 2])
        moonImg = ioStruct.imgMoon(1);
    else
        moonImg = ioStruct.imgMoon(2);
    end
    Screen('DrawTexture', ioStruct.wPtr, moonImg, [], ioStruct.rectState2Planet);    
    % show the planet frame
    [~, trialSpec.tState2On] = Screen(ioStruct.wPtr, 'Flip', trialSpec.tResp1 + trialSpec.jitterResp1, 1);
    

    % progressively dim the planet
    flipPause = 0.02;
    flipTimes = [0:flipPause:(trialSpec.jitterState)-0.5] + trialSpec.tState2On;
    dimAlpha = linspace(0, 200, length(flipTimes));
    for fI = 1 : length(flipTimes)
        newLocation = ioStruct.rectState2Planet;
        Screen('DrawTexture', ioStruct.wPtr, moonImg, [], newLocation);
        Screen('fillOval', ioStruct.wPtr, [ioStruct.bgColor dimAlpha(fI)], newLocation);
        Screen(ioStruct.wPtr, 'Flip', flipTimes(fI), 1);
    end

    % show landing pad (terminal state)
    if ismember(trialSpec.state2(trialSpec.resp1), [1 3])
        stateLocation = ioStruct.LEFT;
    else
        stateLocation = ioStruct.RIGHT;
    end
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.imgState(trialSpec.state2(trialSpec.resp1)), [], ioStruct.rectState2(stateLocation,:));
    [~, trialSpec.tTerminalState2On] = Screen(ioStruct.wPtr, 'Flip', trialSpec.tState2On + trialSpec.jitterState, 1);
    
    % compute outcome according to reward contingency mapping (stimulus or state)
    if trialSpec.condContingent == taskStruct.CONT_STATE
        % draw reward according to outcome state
        trialSpec.outcomeBin = trialSpec.rewBinary(trialSpec.outcome1);
        trialSpec.outcomeMag = round(trialSpec.rewBinary(trialSpec.outcome1) * trialSpec.rewMagnitude * 100);
    else
        % use selected stimulus to compute reward
        if trialSpec.resp1 == ioStruct.LEFT
            % draw reward from planet 1
            trialSpec.outcomeBin = trialSpec.rewBinary(1);
            trialSpec.outcomeMag = round(trialSpec.outcomeBin * trialSpec.rewMagnitude * 100);
        else
            % draw reward from planet 2
            trialSpec.outcomeBin = trialSpec.rewBinary(3);
            trialSpec.outcomeMag = round(trialSpec.outcomeBin * trialSpec.rewMagnitude * 100);
        end
    end
    % structure reward output images
    if trialSpec.outcomeBin == 1
        rewardString = sprintf('%+2d', trialSpec.outcomeMag);
        rewImage = ioStruct.imgGem;
    else
        rewardString = '0';
        rewImage = ioStruct.imgRubble;
    end
    
    % show the outcome (win/loss) and reward magnitude 
    Screen('TextSize', ioStruct.wPtr, 60); Screen('TextColor', ioStruct.wPtr, [255 255 255]);
    Screen('DrawTexture', ioStruct.wPtr, rewImage, [], ioStruct.rectReward(stateLocation,:));
    DrawFormattedText(ioStruct.wPtr, rewardString, 'center', 'center', [], [], [], [], [], [], ioStruct.rectReward(stateLocation,:) );
    [~, trialSpec.tFBOn_Bin] = Screen(ioStruct.wPtr, 'Flip', trialSpec.tTerminalState2On + trialSpec.jitterFB, 1);
    trialSpec.tFBOn_Mag = trialSpec.tFBOn_Bin;
    % show the reward magnitude
    
%     DrawFormattedText(ioStruct.wPtr, rewardString, 'center', 'center' );
%     [~, trialSpec.tFBOn_Mag] = Screen(ioStruct.wPtr, 'Flip', trialSpec.tFBOn_Bin + ioStruct.REW_DURATION, 1);
    trialSpec.tFBOn_Bin = trialSpec.tFBOn_Mag;
    
    % clear the screen
    Screen(ioStruct.wPtr, 'Flip', trialSpec.tFBOn_Mag + ioStruct.REW_DURATION);
end


function trialSpec = showTooSlow(ioStruct, trialSpec)
    % clear the screen
    Screen(ioStruct.wPtr, 'Flip');
    % show error text
    slowText = ['Too Slow!\n\n Please make your choice within ' num2str(ioStruct.MAX_RT) ' seconds'];
    Screen('TextSize', ioStruct.wPtr, 30); Screen('TextColor', ioStruct.wPtr, [255 0 0]); Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    DrawFormattedText(ioStruct.wPtr, slowText, 'center', 'center');
    % show feedback for prescribed time, then clear screen
    Screen(ioStruct.wPtr, 'Flip');
    WaitSecs(trialSpec.jitterResp1 + trialSpec.jitterState + trialSpec.jitterFB + ioStruct.REW_DURATION);
    Screen(ioStruct.wPtr, 'Flip');
end

function trialSpec = showMultiResp(ioStruct, trialSpec)
    % clear the screen
    Screen(ioStruct.wPtr, 'Flip');
    % show error text
    slowText = 'Multiple responses detected!\n\n Please select only a single option';
    Screen('TextSize', ioStruct.wPtr, 30); Screen('TextColor', ioStruct.wPtr, [255 0 0]); Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    DrawFormattedText(ioStruct.wPtr, slowText, 'center', 'center');
    % show feedback for prescribed time, then clear screen
    Screen(ioStruct.wPtr, 'Flip');
    WaitSecs(ioStruct.REW_DURATION);
    Screen(ioStruct.wPtr, 'Flip');
end