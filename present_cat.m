%% temporal change of in intervals 
%
% The displays changed continuously in randomly generated cycles of nine intervals each. 
% The length of each interval varied randomly among 50, 100, or 150 ms, 
% with the constraint that all intervals occurred equally often within each cycle and that 
% the target change was always preceded by a 150-ms interval and followed by a 100-ms interval.
% At the start of each interval, a randomly determined number of search items changed color 
% (from red to green or vice versa), within the following constraints: When set size was 24, 
% the number of items that changed was 1, 2, or 3. When set size was 36, 1, 3, or 5 items changed, 
% and when it was 48, 1, 4, or 7 items changed. Furthermore, the target always changed alone and 
% could change only once per cycle, so that the average frequency was 1.11 Hz. The target could 
% not change during the first 500 ms of the very first cycle of each trial. For each trial, 
% 10 different cycles were generated, which were then repeated after the 10th cycle 
% if the participant had not yet responded.


%%
%function present_HV_loc
% function present(XY,testcircle,fixbars,Wtestcircle,clr_trialwise,tflipIntv,tarIntvs_trialwise,chords_trial)
try
    
%     clear all;clc;
    sca;
    PsychPortAudio('Close',[]);
    PsychPortAudio('Close',[]);
    
    [answer] = M_InputPresent;    
    monitor = answer.monitor;
    syncTest = answer.syncTest; % draw black-white transition square, mark target bar with a circle
    monitorMode = answer.monitorMode;
    collectRes = answer.collectRes;
    startBlock = answer.startBlock;
    nBlock = answer.nBlock;
    ntrialTest = answer.ntrialTest;
    
    startTr = answer.startTr;
    loadstim = answer.loadstim;
    loadData = answer.loadData;
    [~,file,~] = fileparts(loadstim);
    load(loadstim);
    Tr.presentAnswer = answer;
    % file = Replace(file,'stim','data');
    savedir = [pwd,'/datasave/',Tr.paradigm];
    if ~exist(savedir)
        mkdir(savedir)
    end
    savefile = fullfile(savedir,file);
    
    D = 0; % This number consists of 2 parts: the first part is
    % based on an AV-sync measurement with the photodiode attached to the
    % left upper corner of the screen, and testing this function, after
    % uncommenting the Screen('FillRect',...) line. The
    % second part is to be obtained by computing the difference between the
    % Fliptimestamp and VBLtimestamp when the particular Screen is flipped.
    % The number should correspond to half this difference.
    
%% to get low-latency and high timing-precision
    % Initialize the screen etc.
    AssertOpenGL;

    %  Screen('Preference', 'SkipSyncTests', 1); 
    PsychDefaultSetup(2);
    % InitializePsychSound([reallyneedlowlatency=0]), On MacOS/X and GNU/Linux, the PsychPortAudio driver will just work with
    % low latency and highest timing precision after this initialization.
    InitializePsychSound(1);
    
    % Force GetSecs and WaitSecs into memory to avoid latency later on: (according to PPAtimingtest)
    GetSecs;
    WaitSecs(0.1);
 %% keyboard
    rng('shuffle'); 

    
    ListenChar(0);
    
    KbName('UnifyKeyNames');
    quit = KbName('q');
    warm =  KbName('l');
    if strcmp(answer.task,'ori disc')
        keyH=KbName('z');    
        keyV=KbName('m');
%     keyv=KbName('v');
        RestrictKeysForKbCheck([keyH keyV quit warm]);
    else strcmp(answer.task,'identify tar')
      keyYes = KbName('y');
      
      RestrictKeysForKbCheck([keyYes quit warm]);
    end

 
    %% input 

    
    % ---------input parameters--------
    ncycle = Tr.ncycle;
    nIntv = Tr.nIntv;
%     tcycle = Tr.tcycle;
    % tarOris = Tr.tarOris ; %0->H,1->V
    % blocks = Tr.blocks; % 
    if ntrialTest ==0; ntrialTest = Tr.ntrials - startTr + 1; end
    nblocks = Tr.nblocks;
    nItems = Tr.nItems;
    Coh = Tr.Coh;
    Vpresent = Tr.Vpresent;
    
    Apresent = Tr.Apresent;
    nItems = Tr.nItems;
    lineWidth = 2.5; %V.lineWidth;
    fixbars = V.fixbars;
    Rroute = V.Rroute;
    tarOris = Tr.tarOris;% tarOri 0-H,1-V 
    if strcmp(monitorMode,'small') %{'palin','small','trasnparent','screen-short'}
        fixbars = fixbars/2;
    end
    [~,~,data] = fileparts(loadData)
    if ~isempty(data)
        load(loadData)
    else
        [rt,acc,timeout,resp,outrecording] = deal(nan(Tr.ntrials,Tr.nblocks));
    end
    
    % Each trial began with a fixation dot presented for 1,000 ms at the center of the screen. 
    % The search display was presented until participants responded.
    %% Screen
    [w,wrect,ifi,slack,white,black] = m_openScreen(monitor,monitorMode);
    HideCursor
    %% aduio
    [pa] = m_openAudi(A.srate,A.channels);
%     m_warmup(w,wrect,quit,white,Rroute,A.srate,pa,ifi,slack,syncTest,warm)
    %% trial start 

    txt = sprintf('press key to start');%
    bRect= Screen('TextBounds', w,txt);
    Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
    Screen('Flip',w);
    [~,key,~] = KbStrokeWait;
    if find(key)==quit
        save([savefile '_' datestr(now,'HH-MM-mmmdd')],'Tr','acc','rt','j');
        ShowCursor;
        ListenChar(0);

        sca;
    end
for b =startBlock:startBlock+nBlock-1 %nblocks

       
        % centerTar_block = S(b).coordinate.centerTar;
        XY = SC(b).coordinate.XY; % {2,nitems*2,ntrial}  1st row x, 2nd row y, col: start,end ...
        testCirle = SC(b).coordinate.testcircle;
        
        disCircle = SC(b).coordinate.discircle;
       
        tarHemi = SC(b).coordinate.tarHemi; % (ntrial,1), 1-r,0-l
        clr_trialwise = SC(b).color.clr_trialwise;
%          tflipIntv = round((S(b).intervals.tflipIntv)/ifi)*ifi;
        fflipIntv = SC(b).intervals.fflipIntv;
        if strcmp(monitor,'Cubicle2') 
           fflipIntv  = fflipIntv .* 2 ;
        end
        tarIntvs_trialwise = SC(b).intervals.tarIntvs_trialwise;
        
        %tic  
        sounds = SC(b).Sounds.sounds; % 1600000000s
%         sounds = S(b).Sounds.fig;
%       tic 
%             PsychPortAudio('FillBuffer', pa,sounds(:,:,1));
%             toc

        %toc
%     
    %% run presentation
    % 

    %------------------------ instruction --------------------
        

%% run trial
     

    for j =startTr:startTr+ntrialTest-1 
%       trials = find(Vpresent(:,b) == 1);
%       for n = 1:length(trials)
%           j = trials(n);

%     for n = 1:Tr.ntrials
%         j = ind(n);
txt = sprintf('syncVTar %d, coherence %d ', Tr.syncVTar(j,b),coh);%
            bRect= Screen('TextBounds', w,txt);
            Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
            Screen('Flip',w);
            [~,key,~] = KbStrokeWait;
            if find(key)==quit
                ShowCursor;
                ListenChar(0);

                sca;
            end
        coh = Coh(j,b);

        PsychPortAudio('FillBuffer', pa,sounds(:,:,j)); % 0.1 0.5  0.4s
        
        clr_cyclewise = cell2mat(clr_trialwise(j)); %  clr_cyclewise(3,2*nitem,nintv*ncycle)
        xy = XY{:,:,j};
        if ~isempty(testCirle)
            testcirle = testCirle(j,:);
            
            discircle = disCircle(j,:);
           
        end
        
        if strcmp(monitorMode,'small') %{'palin','small','trasnparent','screen-short'}
            xy = xy./2;
        end
        % PsychPortAudio('Stop', pa);

        if mod(j,50) == 0
           txt = sprintf('rest time, press key to continue');%
           bRect= Screen('TextBounds', w,txt);
           Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
           Screen('Flip',w);
           [~,key,~] = KbStrokeWait;
           if find(key)==quit
               save([savefile '_' datestr(now,'HH-MM-mmmdd')],'Tr','acc','rt','j','ind');
               ShowCursor;
               ListenChar(0);
               sca;
           end
        end
% ----------------------------  FIXATION ----------------------------
        
        Screen('DrawLines',w,fixbars,lineWidth,white*0.6,[],1); 
        [vbl,flipOnset] = Screen('Flip',w);
       % fprintf('fixation flipOnset %d\n',flipOnset)
% ----------------------------  START SOUND ---------------------------- 
     
        PsychPortAudio('start',pa,1,flipOnset+fflipIntv(1)*ifi); % 0.16~0.5ms

% ----------------------------  PRESENT intervals ----------------------------
        %for f = 1:totframe
        
           

        
    for intv = 1: nIntv*ncycle % flip each interval, item dispaly changes each interval
        if Vpresent(j,b) == 0 && all(Tr.nItems(:,b) == 1)
            color = clr_cyclewise;
        else 

            color = clr_cyclewise(:,:,intv);%  clr_cyclewise(3,2*nitem,nintv*ncycle)
        end
            % Screen('DrawLines', windowPtr, xy [,width] [,colors] [,center] [,smooth][,lenient])

            Screen('DrawLines',w,xy,lineWidth,color,[],1,1);% color
            if ~all(Tr.nItems(:,b) ==1)
            Screen('DrawLines',w,fixbars,lineWidth,white*0.6,[],1,1); 
            end


            if any(cellfun(@(x) strcmp(x,'circle'),syncTest))% {'circle','square','none'}
                Screen('FrameOval',w,white*0.5,testcirle,3);
                
                Screen('FrameOval',w,white*0.5,discircle,3);
                
            end
            if any(cellfun(@(x) strcmp(x,'square'),syncTest)) && any(tarIntvs_trialwise(j,:) == intv)
                Screen('FillRect', w, white, [0 0 200 200]);
            end




           [vbl,flipOnset] = Screen('Flip',w,vbl+fflipIntv(j,intv)*ifi-slack);   % vOnset 
            if intv == 1
                startTime = flipOnset;
            end
            
             if collectRes ==1 
                tic
                while toc < fflipIntv(j,intv+1)*ifi-slack
%                     [~, keyCode,~] = KbStrokeWait;
%                     if find(keyCode) == quit
%                         sca;
%                         break
%                     else
%                     end
                    [keyisdown, when, keyCode] = KbCheck;
                    
                    if keyisdown 
                        resp(n,b) = find(keyCode ==1);
                       break
                    end
                end
                outrecording(n,b) = GetSecs - startTime;
                if keyisdown && ~keyCode(quit) 
                    
                    PsychPortAudio('Stop',pa);
                  
                   break
                elseif keyCode(quit)
                    save([savefile '_' datestr(now,'HH-MM-mmmdd')],'Tr','acc','rt','j','ind');
                    PsychPortAudio('Stop',pa);
                    
                    ShowCursor;
                    ListenChar(0);
                    
                    sca;
                end
                if keyCode(quit)
                    
                    PsychPortAudio('Stop',pa);
                    
                    ShowCursor;
                    ListenChar(0);
                    
                    sca;
                end
            end
    end
    
                
              

        if intv == nIntv*ncycle
           [vbl,flipOnset] = Screen('Flip',w,flipOnset+fflipIntv(j,intv+1)*ifi-slack); 

        else
            [vbl,flipOnset] = Screen('Flip',w);
        end
       
        if collectRes ==1

            if keyisdown
                rt(n,b) = when - startTime ;
                acc(n,b) = Vpresent(j,b);
                
            elseif ~keyisdown
                rt(n,b) = outrecording(n,b);
                timeout(n,b) = 1;
            end

        end

        if strcmp(answer.dispInfo,'after')
            txt = sprintf('syncVTar %d, coherence %d ', Tr.syncVTar(j,b),coh);%
            bRect= Screen('TextBounds', w,txt);
            Screen('DrawText',w,txt,wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
            Screen('Flip',w);
            [~,key,~] = KbStrokeWait;
            if find(key)==quit
                ShowCursor;
                ListenChar(0);

                sca;
            end
        end

    end

    bRect= Screen('TextBounds', w,'END of Block');
    
    Screen('DrawText',w,'END of Block',wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
    Screen('Flip',w);
    
    KbStrokeWait;
   
%     if collectRes ==1 
%         if isempty(data)
%             save(savefile,'rt','acc','timeout','nItems','answer');
%         else
%             save(savefile,'rt','acc','timeout','nItems','answer','-append'); 
%         end
%         Ana_prepR(rt,nItems,acc,ntrialTest,startBlock,nBlock);
%     end
    end
    
    save([savefile '_' datestr(now,'HH-MM-mmmdd')],'Tr','acc','rt','j','resp','V','A','ind');
    
    bRect= Screen('TextBounds', w,'END of EXP');
    Screen('DrawText',w,'END of EXP',wrect(3)/2-bRect(3)/2,wrect(4)/2-bRect(4)/2,white);
    Screen('Flip',w);
    
    
    KbStrokeWait;
   
    
    sca;
    
    PsychPortAudio('Stop',pa);
    PsychPortAudio('Close',pa);

   
catch
    
    Priority(0);
    sca
    
    ShowCursor;  
    rethrow(psychlasterror);
   
end 

