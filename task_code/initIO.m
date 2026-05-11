function ioStruct = initIO(wPtr)
    % hide input to prevent participant from over-writing into the script
    HideCursor(); ListenChar(2);
    Screen('Preference', 'SkipSyncTests', 1);
    KbName('UnifyKeyNames');
%     Screen('Preference', 'ConserveVRAM', 64); % for use on Linux system
    
    % set up the screen
    ioStruct = struct();
    ioStruct.bgColor = [0 0 0];
    ioStruct.textColor = [200 200 200];
    if isempty(wPtr)
        debugRect = [0,0,1000,800];
        fullRect = [];
        allScreens = Screen('Screens');
        [ioStruct.wPtr, ioStruct.wPtrRect] = Screen('OpenWindow', allScreens(end), ioStruct.bgColor, fullRect);
    else
        % use the already open window
        ioStruct.wPtr = wPtr;
        ioStruct.wPtrRect = Screen('Rect', ioStruct.wPtr);
    end
    % activate for alpha blending
    Screen('BlendFunction', ioStruct.wPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    % Measure the vertical refresh rate of the monitor
    ioStruct.centerX = round(ioStruct.wPtrRect(3)/2);
    ioStruct.centerY = round(ioStruct.wPtrRect(4)/2);
    
    % show loading prompt
    Screen('TextFont', ioStruct.wPtr, 'Courier');
    % show the loading screen
    Screen('TextSize', ioStruct.wPtr, 45);
    Screen('TextColor', ioStruct.wPtr, ioStruct.textColor);
    DrawFormattedText(ioStruct.wPtr, 'Loading...', 'center', 'center', [], 70, false, false, 1.1);
    Screen(ioStruct.wPtr, 'Flip');
    
    % stimulus durations
    ioStruct.SLOW = -1;
    ioStruct.MAX_RT = 2;
    ioStruct.BREAK_ITI = 5*60;
    ioStruct.BREAK_DURATION = 15;
    ioStruct.CHOICE_FB_DURATION = 1;
    ioStruct.REW_BIN_DURATION = 0;
    ioStruct.REW_DURATION = 1.5;
    ioStruct.BLOCK_START_WAIT = 3;
    ioStruct.BLOCK_END_WAIT = 4;
    
    % response keys
    ioStruct.LEFT = 1;
    ioStruct.RIGHT = 2;
    ioStruct.respKey_1 = [ KbName('F'),  KbName('1'), KbName('1!') ];
    ioStruct.respKey_2 = [ KbName('J'),  KbName('4'), KbName('4$') ];
    
    % task control keys
    ioStruct.respKey_Quit = KbName('Q');
    ioStruct.respKeyName_Quit = 'Q';
    ioStruct.respKey_Proceed = KbName('P');
    ioStruct.respKeyName_Proceed = 'P';
    
    % pulse signal
    ioStruct.pulseKey = [ KbName('5') KbName('5%') ];
    
    
    %%%%%%%%%%%%%%%%%
    %
    % 2nd stage planet
    width = 400; height = 400;
    rect = [0, 0, width, height];
    % center planet between landing pads
    leftX = ioStruct.centerX - round(width/2);
    topY = ioStruct.centerY - round(height/2);
    ioStruct.rectState2Planet = rect + [leftX, topY, leftX, topY];
    
    % landing pads above and below
    width = 250; height = 250;
    rect = [0, 0, width, height];
    % define north pad
    leftX = ioStruct.centerX - round(width/2);
    topY = ioStruct.rectState2Planet(2) - height + 75;
    ioStruct.rectState2(ioStruct.LEFT,:) = rect + [leftX, topY, leftX, topY];
    % define south pad
    leftX = ioStruct.centerX - round(width/2);
    topY = ioStruct.rectState2Planet(4) - 75;
    ioStruct.rectState2(ioStruct.RIGHT,:) = rect + [leftX, topY, leftX, topY];
    
    % 1st stage choice option rects (ships)
    width = 200; height = 200; gap = 30;
    rect = [0, 0, width, height];
    % define left ship
    leftX = ioStruct.centerX - gap - width;
    topY = ioStruct.centerY - round(height/2);
    ioStruct.rectShip(ioStruct.LEFT,:) = rect + [leftX, topY, leftX, topY];
    % define the right ship
    leftX = ioStruct.centerX + gap;
    topY = ioStruct.centerY - round(height/2);
    ioStruct.rectShip(ioStruct.RIGHT,:) = rect + [leftX, topY, leftX, topY];
    
    
    % reward outcome rects
    width = round(175*0.5); height = round(240*0.5);
    rect = [0, 0, width, height];
    % left reward
    centerBoundX = ioStruct.rectState2(ioStruct.LEFT,1) + (ioStruct.rectState2(ioStruct.LEFT,3) - ioStruct.rectState2(ioStruct.LEFT,1))/2;
    centerBoundY = ioStruct.rectState2(ioStruct.LEFT,2) + (ioStruct.rectState2(ioStruct.LEFT,4) - ioStruct.rectState2(ioStruct.LEFT,2))/2;
    leftX = centerBoundX - round(width/2);
    topY = centerBoundY - round(height/2);
    ioStruct.rectReward(ioStruct.LEFT,:) = rect + [leftX, topY, leftX, topY];
    % right reward
    centerBoundX = ioStruct.rectState2(ioStruct.RIGHT,1) + (ioStruct.rectState2(ioStruct.RIGHT,3) - ioStruct.rectState2(ioStruct.RIGHT,1))/2;
    centerBoundY = ioStruct.rectState2(ioStruct.RIGHT,2) + (ioStruct.rectState2(ioStruct.RIGHT,4) - ioStruct.rectState2(ioStruct.RIGHT,2))/2;
    leftX = centerBoundX - round(width/2);
    topY = centerBoundY - round(height/2);
    ioStruct.rectReward(ioStruct.RIGHT,:) = rect + [leftX, topY, leftX, topY];

    % load the state stimuli (lunar surfaces)
    imageDir = fullfile('.', 'images');
    [img, ~, alpha] = imread(fullfile(imageDir, 'redPad1.png'));
    img(:,:,4) = alpha;
    ioStruct.imgState(1) = Screen('MakeTexture', ioStruct.wPtr, img);
    [img, ~, alpha] = imread(fullfile(imageDir, 'redPad2.png'));
    img(:,:,4) = alpha;
    ioStruct.imgState(2) = Screen('MakeTexture', ioStruct.wPtr, img);
    
    [img, ~, alpha] = imread(fullfile(imageDir, 'greenPad1.png'));
    img(:,:,4) = alpha;
    ioStruct.imgState(3) = Screen('MakeTexture', ioStruct.wPtr, img);
    [img, ~, alpha] = imread(fullfile(imageDir, 'greenPad2.png'));
    img(:,:,4) = alpha;
    ioStruct.imgState(4) = Screen('MakeTexture', ioStruct.wPtr, img);
    
    % the moon images
    [img, ~, alpha] = imread(fullfile(imageDir, 'moon_red.png'));
    img(:,:,4) = alpha;
    ioStruct.imgMoon(1) = Screen('MakeTexture', ioStruct.wPtr, img);
    [img, ~, alpha] = imread(fullfile(imageDir, 'moon_green.png'));
    img(:,:,4) = alpha;
    ioStruct.imgMoon(2) = Screen('MakeTexture', ioStruct.wPtr, img);
    
    % spaceships
    [img, ~, alpha] = imread(fullfile(imageDir, 'yellowShip.png'));
    img(:,:,4) = alpha;
    ioStruct.spaceShip(1) = Screen('MakeTexture', ioStruct.wPtr, img);
    [img, ~, alpha] = imread(fullfile(imageDir, 'blueShip.png'));
    img(:,:,4) = alpha;
    ioStruct.spaceShip(2) = Screen('MakeTexture', ioStruct.wPtr, img);
    % ships prepped for takeoff
    [img, ~, alpha] = imread(fullfile(imageDir, 'yellowShip_takeOff.png'));
    img(:,:,4) = alpha;
    ioStruct.spaceShipSelect(1) = Screen('MakeTexture', ioStruct.wPtr, img);
    [img, ~, alpha] = imread(fullfile(imageDir, 'blueShip_takeOff.png'));
    img(:,:,4) = alpha;
    ioStruct.spaceShipSelect(2) = Screen('MakeTexture', ioStruct.wPtr, img);
    
    % load the outcome images
    [img, ~, alpha] = imread(fullfile(imageDir, 'spaceGem4.png'));
    img(:,:,4) = alpha;
    ioStruct.imgGem = Screen('MakeTexture', ioStruct.wPtr, img);
    % load the loss image
    [img, ~, alpha] = imread(fullfile(imageDir, 'spaceBoulder2.png'));
    img(:,:,4) = alpha;
    ioStruct.imgRubble = Screen('MakeTexture', ioStruct.wPtr, img);
end