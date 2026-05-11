function [backKeys, nextKeys] = buildInstRespMap_fMRI(ioStruct, numInstructions)
    % define forward/back keys for each screne (default to arrow keys)
    backKeys = repmat({[KbName('2'), KbName('2@'), KbName('leftarrow')]}, numInstructions, 1);
    nextKeys = repmat({[KbName('3'), KbName('3#'), KbName('rightarrow')]}, numInstructions, 1);
    % define response keys the move them forward
    nextKeys{3} = ioStruct.respKey_1;
    nextKeys{4} = ioStruct.respKey_2;
    nextKeys{end} = [KbName('space')];
end