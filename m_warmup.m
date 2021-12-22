function m_warmup(w,wrect,quit,white,Rroute,srate,pa,ifi,slack,syncTest,warm)

% Route = V.Route;
% srate = A.srate;

[~,warmFixonset] = Screen('Flip',w);

mynoise(1,:) = 0.5 * MakeBeep(1000, 0.1, srate);
mynoise(2,:) = mynoise(1,:);

PsychPortAudio('FillBuffer', pa, mynoise);
PsychPortAudio('Start', pa,1,warmFixonset+ifi*4);% rep=1
        
        


%         txt = sprintf('press l to warm-up again, press z/m/y/n to continue');%
%             bRect= Screen('TextBounds', w,txt);
%             Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
% %         if strcmp(syncTest,'square')
% %             Screen('FillRect', w, white, [0 0 200 200]); 
% %         end
%         Screen('Flip',w,warmFixonset+ifi*4-slack);
%         PsychPortAudio('Stop', pa);
        [~, keyCode] = KbStrokeWait;
%         if keyCode(warm)
            
       
       if keyCode(quit)
            ShowCursor;
            ListenChar(0);
            PsychPortAudio('Close',[]);
            sca;
       end
%         else
%             continue
%         end
end

