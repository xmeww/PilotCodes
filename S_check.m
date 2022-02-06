
%% checked

% interval
% target 200-700ms
% tar-tar distributionm, ave 900ms when ntirlas =500
% distractor-200ms-target-200ms-distractor



%% still need check
% nchg 00010001000, target-200ms-target
% M_cond 

%% suspicious in last exp
cond cohn is indeed cohn
presound-sound no repeat
figure time, less number of bg component (scrip&time)

%% to do
present when figOnly==1
8 fig sounds like?


reqLatencyClass =2;
srate =44100;
channel =2;
paMaster = PsychPortAudio('Open',[],1+8,reqLatencyClass,srate,...
       channel,[]);

paBG = PsychPortAudio('OpenSlave',paMaster,[],2);  
paFG = PsychPortAudio('OpenSlave',paMaster,[],2); 
%     PsychPortAudio('LatencyBias',paMaster,-0.005);

for i = 1:4
    fg = repmat(FGsounds(i,:,:),2,1);
    PsychPortAudio('FillBuffer',paFG,fg);
    PsychPortAudio('Start',paFG); 
    KbWait
    
end
