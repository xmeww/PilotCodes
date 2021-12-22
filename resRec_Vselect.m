dataRec_Aselect(keyisdown,keyCode,quit,rt,acc,)

if keyisdown && ~keyCode(quit) 
    rt(j,b) = when - startTime ;
    if (find(keyCode) == keyH) && (tarOris(j,b) == 0)
        rt(j,b) = 1;
    elseif (find(keyCode) == keyV) && (tarOris(j,b) == 1)
        rt(j,b) = 1;
    % false
    elseif (find(keyCode) == keyH) && (tarOris(j,b) ==1)
        rt(j,b) = 0;
    elseif (find(keyCode) == keyV) && (tarOris(j,b) == 0)
        rt(j,b) = 0;
   end
    PsychPortAudio('Stop',pa);

    break
elseif keyisdown && keyCode(quit)

    PsychPortAudio('Stop',pa);

    ShowCursor;
    ListenChar(0);

    sca;
elseif ~keyisdown
    rt(j,b) = GetSecs - startTime ;
    timeout(j,b) = 1;
end
