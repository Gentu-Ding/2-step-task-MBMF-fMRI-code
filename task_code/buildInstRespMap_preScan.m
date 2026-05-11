function [backKeys, nextKeys] = buildInstRespMap_preScan(ioStruct, numInstructions)
    % define forward/back keys for each screne (default to arrow keys)
    backKeys = repmat({[KbName('2'), KbName('2@'), KbName('leftarrow')]}, numInstructions, 1);
    nextKeys = repmat({[KbName('3'), KbName('3#'), KbName('rightarrow')]}, numInstructions, 1);
    
    % define response keys the move them forward
    nextKeys{5} = ioStruct.respKey_1;
    nextKeys{17} = [KbName('F')];
    nextKeys{19} = [KbName('F')];
    nextKeys{21} = [KbName('F')];
    nextKeys{23} = [KbName('J')];
    nextKeys{25} = [KbName('F')];
    nextKeys{27} = [KbName('J')];
    nextKeys{end} = [KbName('1'), KbName('1!') KbName('space')];
end