% generate single 
function [figsound_seg,bgsound_seg,allsound_seg,coh_comp,bg_comp]=Teki_coherence_gen_rand(n_c_min,n_c_max,n_chords,coh,tsample,srate,F,durRamp,normMethod)

allsound_seg=[];
figsound_seg = [];
bgsound_seg = [];
bg_comp = {};
for j=1:n_chords
 
    ran=randperm(length(F));
    coh_comp=F(ran(1:coh)) ; 

    comp_rest=F(ran(coh+1:end));
    n_c= n_c_min+round(rand*(n_c_max-n_c_min));  % random between n_c_min and n_c_max
    t1=randperm(length(comp_rest));
    noncoh_comp=comp_rest(t1(1:n_c));
    bg_comp{j} = noncoh_comp;
    all_comp=[coh_comp noncoh_comp];
    
    allsound_chord=[];
    figsound_chord=[];
    bgsound_chord = [];
    if strcmp('nbg_max',normMethod)
        for m=1:length(all_comp) %one freq one time, 5~15+0~8, all frequencies, component (base+fig) 
            allsound_chord=[allsound_chord;(0.2/n_c_max)*sin(2*pi*all_comp(m)*tsample)]; % normalized here,sclared+ramp? every preq in all freq, 0.2/15*sin(wt)
        end
        for n = 1:length(coh_comp)
            figsound_chord=[figsound_chord;(0.2/n_c_max)*sin(2*pi*coh_comp(n)*tsample)];
        end
        for l = 1:length(noncoh_comp)
            bgsound_chord=[bgsound_chord;(0.2/n_c_max)*sin(2*pi*noncoh_comp(l)*tsample)];
        end
        if coh ~= 0
            figsound_unwind = sum(figsound_chord,1);
            figsound_wind=Teki_wind(srate,durRamp,figsound_unwind);
    %         Snd('Play',figsound_unwind);
    %         Snd('Wait');
    %         Snd('Quiet'); 
    %         KbStrokeWait;
            figsound_seg = [figsound_seg figsound_wind];
    %         Snd('Play',figsound_wind);
    %         Snd('Wait');
    %         Snd('Quiet'); 
    %         KbStrokeWait;
        else
            figsound_seg = [figsound_seg zeros(1,length(tsample))];
        end
        allsound_unwind=sum(allsound_chord,1);
        allsound_wind=Teki_wind(srate,durRamp,allsound_unwind);
        allsound_seg=[allsound_seg allsound_wind];

        bgsound_unwind = sum(bgsound_chord,1);
        bgsound_wind=Teki_wind(srate,durRamp,bgsound_unwind);
        bgsound_seg = [bgsound_seg bgsound_wind];
    
    elseif strcmp('sound_max',normMethod) 
        for m=1:length(all_comp) %one freq one time, 5~15+0~8, all frequencies, component (base+fig) 
        allsound_chord=[allsound_chord;sin(2*pi*all_comp(m)*tsample)]; % normalized here,sclared+ramp? every preq in all freq, 0.2/15*sin(wt)
        end
        for n = 1:length(coh_comp)
            figsound_chord=[figsound_chord;sin(2*pi*coh_comp(n)*tsample)];
        end
        for l = 1:length(noncoh_comp)
            bgsound_chord=[bgsound_chord;sin(2*pi*noncoh_comp(l)*tsample)];
        end
        if coh ~= 0
            figsound_unwind = sum(figsound_chord,1)./max(abs(sum(figsound_chord,1)));
            figsound_wind=Teki_wind(srate,durRamp,figsound_unwind);
    %         Snd('Play',figsound_unwind);
    %         Snd('Wait');
    %         Snd('Quiet'); 
    %         KbStrokeWait;
            figsound_seg = [figsound_seg figsound_wind];
    %         Snd('Play',figsound_wind);
    %         Snd('Wait');
    %         Snd('Quiet'); 
    %         KbStrokeWait;
        else
            figsound_seg = [figsound_seg zeros(1,length(tsample))];
        end
        allsound_unwind=sum(allsound_chord,1)./max(abs(sum(allsound_chord,1)));
        allsound_wind=Teki_wind(srate,durRamp,allsound_unwind);
        allsound_seg=[allsound_seg allsound_wind];

        bgsound_unwind = sum(bgsound_chord,1)./max(abs(sum(bgsound_chord,1)));
        bgsound_wind=Teki_wind(srate,durRamp,bgsound_unwind);
        bgsound_seg = [bgsound_seg bgsound_wind];
    end
    
end
%     if coh ~= 0
%     Snd('Play',figsound_seg);
%     Snd('Wait');
%     Snd('Quiet'); 
%     KbStrokeWait;
%     end
%     Snd('Play',allsound_seg);
%     Snd('Wait');
%     Snd('Quiet'); 
%     KbStrokeWait;



    

