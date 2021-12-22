% test av sync, frame control 
% simple beep sound 
% square only, tar interval change 
function [RT,Resp,keyIsDown,vbl,figframe] = present_outCyc(vbl,flipOnset,w,xy,tstart,paBG,fixbars,linewidth,white,f3,clr,tarIntv,ifi,paFG,Resp,RT,j,quit,Apresent,syncTest,fgStart) 
   if Apresent || syncTest == 1
       
%        PsychPortAudio('UseSchedule', paFG, 3)
        pre_silience = fgStart(j,1)-1;
        PsychPortAudio('Start', paFG,1,vbl+pre_silience*3*ifi++0.01955);%+0.01955
%         PsychPortAudio('Start', paFG,0,vbl+(60+30)*ifi);
    end
    figframe = [];
    for iframe = 1:f3
        
        intv = round((iframe+1)/3);

        Screen('DrawLines', w, fixbars, linewidth,white*0.5);
        Screen('DrawLines', w, xy, linewidth,clr(:,:,intv));
        
        if any(intv == tarIntv) && syncTest == 1
            
            Screen('FillRect', w, white, [0 0 200 200]);

        end
         
        [vbl,flipOnset] = Screen('Flip',w,vbl+ifi-ifi/2);
%         if any(iframe == (tarIntv+async)*3-2) && (Apresent ==1 || syncTest ==1)
% %             intv
% 
%             PsychPortAudio('Start',paFG,1);
% 
%         end
        
       
        

    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown   
        KbReleaseWait;
        if find(keyCode) == quit
            sca;
%                 PsychPortAudio('Stop',paMaster);
            PsychPortAudio('Close',[])
            ShowCursor;
             ListenChar;
             RestrictKeysForKbCheck([]);
            break
        elseif find(keyCode) ~= quit
            Resp(j) = find(keyCode);
            RT(j) = secs - tstart;
           
            PsychPortAudio('Stop',paBG);
            if Apresent ==1
                PsychPortAudio('Stop',paFG);
               
            end
            
            break
        end
    elseif ~keyIsDown && iframe== f3

       break
    end

    end
return