PsychPortAudio('Close',[])
condTable = Tr.condTable(cond,:);

m = find(condTable.Coh ~=0 & condTable.figOnly ==0);

reqLatencyClass =2;
srate =44100;
channel =2;
paMaster = PsychPortAudio('Open',[],1+8,reqLatencyClass,srate,...
       channel,[]);

%     PsychPortAudio('LatencyBias',paMaster,-0.005);
PsychPortAudio('Start',paMaster,0,0,1); 

paBG = PsychPortAudio('OpenSlave',paMaster,[],2);  
paFG = PsychPortAudio('OpenSlave',paMaster,[],2); 

rep = 1; % 1rep=150ms

for n = 1:length(m)
    j = cond(m(n));
    PsychPortAudio('FillBuffer',paBG,BGsounds(:,:,j));
    
    
    fprintf('fig %dth, coh %d\n',[Tr.FGth(j),Tr.Coh(j)])
    fg = repmat(FGsounds(Tr.FGth(j),:,find(coh_levels==Tr.Coh(j))),2,1);
    PsychPortAudio('FillBuffer',paFG,fg);    
    
  
    startTime = PsychPortAudio('Start', paBG);
    PsychPortAudio('Start', paFG,rep,startTime+1);
    WaitSecs(1.5)
    PsychPortAudio('Stop', paBG)
    KbStrokeWait;
%         PsychPortAudio('Start', paFG,0,vbl+(60+30)*ifi);

end


%%
ifi = 1/59;
PsychPortAudio('FillBuffer',paBG,BGsounds(:,:,j));

PsychPortAudio('UseSchedule', paFG,2)

fg = repmat(FGsounds(Tr.FGth(j),:,find(coh_levels==Tr.Coh(j))),2,1);

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

  
    

t=PsychPortAudio('Start', paBG);


pre_silience = fgStart(j,1)-1;
PsychPortAudio('Start', paFG,0,t+(60+30+pre_silience*3)*ifi);
%         PsychPortAudio('Start', paFG,0,vbl+(60+30)*ifi);
