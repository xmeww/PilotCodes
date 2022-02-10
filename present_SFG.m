% test av sync, frame control 
% simple beep sound 
% square only, tar interval change 
try  
    ListenChar(-1);
    
    syncTest = 0;
    printInf = 0;
    markTar = 0;
    
    monitor = 'lab1';
    monitorMode = 'plain';% small plain transparent
    
    PsychPortAudio('Close',[])
    Screen('Preference', 'SkipSyncTests', 0)
    linewidth = 3;

 %%   
    AssertOpenGL;  
    PsychDefaultSetup(2);   
    InitializePsychSound(1); 
    % Force GetSecs and WaitSecs into memory to avoid latency later on: (according to PPAtimingtest)
    GetSecs;
    WaitSecs(0.1);
    rng('shuffle'); 
 %% keyboard
    
    
    
    KbName('UnifyKeyNames');
    quit = KbName('q');
    keyH=KbName('m');    
    keyV=KbName('z');
%      keyH=KbName('z');    
%     keyV=KbName('m');
%     keyspace=KbName('space');
    RestrictKeysForKbCheck([keyH keyV quit]);
%     otherkeys = 
%     DisableKeysForKbCheck(find(keyCode))
%% input 
 %% Screen
    [w,wrect,ifi,white,black] = m_openScreen(monitor,monitorMode);
    
    HideCursor;
    
    %% aduio
    reqLatencyClass =2;
    srate =44100;
    channel =2;
    paMaster = PsychPortAudio('Open',[],1+8,reqLatencyClass,srate,...
           channel,[]);
    
%     PsychPortAudio('LatencyBias',paMaster,-0.005);
    PsychPortAudio('Start',paMaster,0,0,1); 
    
    paBG = PsychPortAudio('OpenSlave',paMaster,[],2);  
    paFG = PsychPortAudio('OpenSlave',paMaster,[],2); 
    
%%
    topPriorityLevel = MaxPriority(w);
    Priority(topPriorityLevel);

    %% instruction screen
    Screen('Flip',w);
    txt = sprintf('Press Horizontal or Vertical Key to Start');
    bRect= Screen('TextBounds', w,txt);
    Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
    Screen('Flip',w);
    [~,key,~] = KbStrokeWait;
    if find(key)==quit
        
        ShowCursor;
        ListenChar();
        RestrictKeysForKbCheck([])
        sca;
    end
    %% trial start
 
    f1 = round(1/ifi);
    f2 = (500/50)*3;
    f3 = (9000/50)*3;
    numFrames =f1+f2+f3;  %f1+f2+tarIntv_tr(j,1)*3+9; %  %1s+500ms+9s
    waitframes = 1; 
   
    soundframe = [];
    framechk = [];
    RT = nan(Tr.ntrials,1);
    Resp = nan(Tr.ntrials,1);
    key = [];
    tarVbl = nan(4,10);%mean(mean(diff(tarVbl,[],2)))
    tstart = nan(Tr.ntrials,1);
%     intv = nan(4,f1+f2+f3+1);

for n = 1:length(cond)
   % ---------------------------------------------------------
    % ---------------------------------------------------------
    j = cond(n);
    if Tr.figOnly(j) == 0 % bg+fg, 
        PsychPortAudio('FillBuffer',paBG,BGsounds(:,:,j));
    end
    PsychPortAudio('UseSchedule', paFG,2)
    if Tr.figPresent(j) ==1 
        if syncTest == 0
            fg = repmat(FGsounds(Tr.FGth(j),:,find(coh_levels==Tr.Coh(j))),2,1);
        elseif syncTest ==1 
            fg = repmat(MakeBeep(randsample([200,300,500],1),0.05,44100),2,1);
        end
        
        
        FGbuffer(j) = PsychPortAudio('CreateBuffer', [], fg);
        PsychPortAudio('UseSchedule', paFG, 1, 20); 
        cmdCode = 1 + 16;
        
        t_postSilence = diff(fgStart(j,:));
        for c = 1:10
           
            PsychPortAudio('AddToSchedule', paFG, FGbuffer(j), [], [], [], [], 1);
            if c<10
               PsychPortAudio('AddToSchedule', paFG, -cmdCode, t_postSilence(c)*3*ifi, [], [], [], 1);
            end
        end
   
    end
    
    if  printInf ==1
%         txt = sprintf('n = %d,key %d\n cond: %d, %d, %d,%d',n,Tr.tarOris(j),Tr.figPresent(j),Tr.figOnly(j),Tr.Coh(j),Tr.nItems(j));
%         txt = sprintf('n %d,nitem %d, tarOris %d,tarLoc %d', n,Tr.nItems(j),Tr.tarOris(j),Tr.tarLocs(j));%
        if Tr.figOnly(j)==1
            txt = sprintf('beep');
        elseif Tr.figPresent(j)==0
            txt = sprintf('noise');
        elseif Tr.figPresent(j)==1 && Tr.Coh(j) ~=0
            txt = sprintf('noise + beep');
        end
%         txt = [txt,num2str(Tr.tarOris(j))];
%           txt = sprintf('async %d',Tr.AVasync(j));
%       txt = sprintf('n = %d,key %d\n cond:figpresent %d,figOnly  %d,coh %d, nitem %d',n,Tr.tarOris(j),Tr.figPresent(j),Tr.figOnly(j),Tr.Coh(j),Tr.nItems(j));

        bRect= Screen('TextBounds', w,txt);
        Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
        Screen('Flip',w);
        [~,key,~] = KbStrokeWait;
        if find(key)==quit

            ShowCursor;
            ListenChar();
            RestrictKeysForKbCheck([]);
            sca;
        end
    end
    

%     
   clr = clr_trs{j};
   
    paBG_out = paBG;
    
    clr_out = clr(:,:,11:end);
    tarIntv_out = tarIntv_tr;
    
    [vbl,flipOnset] = Screen('Flip', w,GetSecs+ifi/2);
    if syncTest == 0 && Tr.figOnly(j) == 0
%     if Tr.figOnly(j) == 0
        PsychPortAudio('Start', paBG,0,vbl+60*ifi);
    end
    if Tr.figPresent(j)==1 || syncTest == 1
        pre_silience = fgStart(j,1)-1;
        PsychPortAudio('Start', paFG,0,vbl+(60+30+pre_silience*3)*ifi+0.0195);
%         PsychPortAudio('Start', paFG,0,vbl+(60+30)*ifi);
    end
%     PsychPortAudio('Start',paFG,1,flipOnset+(f1+f2+tarIntv_tr(j,1)*3-2)*ifi); 

    for iframe = 1: numFrames+1
 

        if iframe < f1+1 % ≤60, <60+1
        
            Screen('DrawLines', w, fixbars, linewidth,white*0.5,[],1,1);
            [vbl,flipOnset] = Screen('Flip',w,vbl+ifi-ifi/2);

        elseif (f1 < iframe) && (iframe < f1 + f2 + f3 +1) % 61≤frame≤60+30, 60<frame<91
            
            intv = round((iframe-f1+1)/3); % 1-190
            
            if iframe == f1+1 
                tstart(j) = GetSecs;
            end

            if markTar ==1
                Screen('FrameOval',w,white*0.5,tarMarker(j,:),2);
            end
            Screen('DrawLines', w, fixbars, linewidth,white*0.5,[],1,1);
            Screen('DrawLines', w, XY{j}, linewidth,clr(:,:,intv),[],1,1);
            if any(intv == tarIntv_Tr(j,:)) && syncTest == 1
                Screen('FillRect', w, white, [0 0 200 200]);
            end
            
            [vbl,flipOnset] = Screen('Flip',w,vbl+ifi-ifi/2);%  

        end
        %% loop in frame, check response after every frame
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            KbReleaseWait;
            if find(keyCode) == quit
%                     save data.mat RT Resp
                sca;
%                 PsychPortAudio('Stop',paMaster);
                PsychPortAudio('Close',[])
                ShowCursor;
                 ListenChar();
                 RestrictKeysForKbCheck([]);
                break
            elseif find(keyCode) ~= quit
                
                Resp(j) = find(keyCode);
                RT(j) = secs - tstart(j);
                if Tr.figOnly(j) ==0
                    PsychPortAudio('Stop',paBG); 
                end
                if Tr.figPresent(j) ==1
                    PsychPortAudio('Stop',paFG);  
                end
                break                    
            end
        elseif ~keyIsDown && iframe== numFrames
                KbReleaseWait;
           while ~keyIsDown
               % paBG_out,clr_out,tarIntv_out
               %[RT,Resp,keyIsDown,vbl,figframe] = present_outCyc(vbl,flipOnset,w,xy,tstart,paBG,fixbars,linewidth,white,f3,clr,tarIntv,ifi,paFG,Resp,RT,j,quit,figPresent,syncTest,fgStart) 

               [RT,Resp,keyIsDown,vbl,figframe] = present_outCyc(vbl,flipOnset,w,XY{j},tstart(j),paBG,...
                   fixbars,linewidth,white,f3,clr_out,tarIntv_tr(j,:),ifi,paFG,Resp,RT,j,quit,Tr.figPresent(j),syncTest,fgStart,Tr.figOnly(j));
           end
           break
        end
          
    end
    Screen('Flip',w);

   

    if mod(n,30) == 0 
        if any(n == [210,420])
            txt = sprintf('Long Break');
        elseif n == 630
            txt = sprintf('Finished! Thank You!');
        else
            txt = sprintf('Take a Break,Press Horizontal or Vertical Key to Start');
        end
%     else
%         txt = sprintf('Take a Break?');
%     end
        bRect= Screen('TextBounds', w,txt);
        Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
        Screen('Flip',w);
        [~,key,~] = KbStrokeWait;
        if find(key)==quit

            ShowCursor;
            ListenChar(0);
            RestrictKeysForKbCheck([]);
            sca;
        end
    end
end
    save(['data-',datestr(now,'mm_dd_HH_MM'),'.mat'],'RT', 'Resp','cond', 'keyH', 'keyV','ifi','n')
    sca;
    PsychPortAudio('Close',[])
    ShowCursor;
    ListenChar(0);
    RestrictKeysForKbCheck([]);
catch
    psychrethrow(psychlasterror); 
    Priority(0);
    sca
    PsychPortAudio('Close',[])
    ShowCursor;
    ListenChar(0);
    RestrictKeysForKbCheck([]);
    
end 