    load('color.mat')
    load('coordinate.mat')
    load('cond_Tr.mat')
    load('intv.mat')
    load('sounds.mat')

    BGSounds = cat(2,Presounds,BGsounds);%(chn,sample,trial)
    
    tarIntv_Tr = 10+tarIntv_tr;
    FGStart = fgStart+10;
    for j = 1:Tr.ntrials
        Clr{j} = cat(3,Preclr_trs{j}, clr_trs{j});
%         if Tr.Apresent(j) ==1 
%         if syncTest == 0
%             fg = repmat(FGsounds(Tr.FGth(j),:,find([6,10]==Tr.Coh(j))),2,1);
%         elseif syncTest ==1 
%             fg = repmat(MakeBeep(randsample([200,300,500],1),0.05,44100),2,1);
%         end
%         end
%         FGbuffer(j) = PsychPortAudio('CreateBuffer', [], fg);  
    end
  





% bgdemo = BGsounds(:,:,1:10);
% predemo = Presounds(:,:,1:10);
% save soundsDemo.mat bgdemo predemo FGsounds
% 
% 
% 
% load soundsDemo.mat
% load('color.mat')
% load('coordinate.mat')
% load('cond_Tr.mat')
% load('intv.mat')
% BGSounds = cat(2,predemo,bgdemo);%(chn,sample,trial)    
% tarIntv_Tr = 10+tarIntv_tr;
% FGStart = fgStart+10;
%     for j = 1:Tr.ntrials
%         Clr{j} = cat(3,Preclr_trs{j}, clr_trs{j});
%     end
%     
%     syncTest = 0;
% for c = 1:2
%    for f = 1:4
%        if syncTest == 0
%            fgbuf(c,f) = PsychPortAudio('CreateBuffer', [], [FGsounds(f,:,c);FGsounds(f,:,c)]); 
%        elseif syncTest == 1
%            beep = MakeBeep(randsample([200,400,600],1),0.15,44100);
%            fgbuf(c,f) = PsychPortAudio('CreateBuffer', [], [beep;beep]); 
%        end
%     end
% end