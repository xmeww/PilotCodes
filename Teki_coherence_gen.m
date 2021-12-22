function [figsound_seg,bgsound_seg,allsound_seg,bg_comp]=Teki_coherence_gen(n_c_min,n_c_max,n_chords,tsample,srate,coh_comp,comp_rest,durRamp,normMethod)

% n_c_min 5 
% n_c_max 15
% n_bursts = n_bursts(k)= initL or midL or finL %ground-figure-ground number of burst(# of chords, duration)
% 15~20, 2~7, 25-
% dur_bursts = dur_burst(k) = 50 or 50 or 50 % duration of each chord
% 
% pc_coh=pc_coh(k) % ground-figure-ground,Percentage coherence in each
% chord/segment [0 1~8 0]

% srate=44100;                    % sampling rate
% F = 440 * 2 .^((-31:97)/24);    % Component frequencies were randomly drawn from a set of 129
                                % values equally spaced on a logarithmic scale between 179 and 7246 Hz
                                % Successive frequencies are separated by 1/24th an octave
                                % 2^(1/24) = 1.0293 

% t=[0:1/srate:dur_burst/1000];   % time vector, 1s sample 44100 times, 0.05s sample  2205+1 times

% ran=randperm(length(F));        % create random list of numbers from 1-129
% coh_comp=F(ran(1:coh));       % coherent frequency pool
% comp_rest=F(ran(coh+1:end));  % non-coherent frequency pool

allsound_seg=[];
figsound_seg = [];
bgsound_seg = [];
bg_comp = {};
for j=1:n_chords % no. chords in certain segment, dur
    n_c= n_c_min+round(rand*(n_c_max-n_c_min));     % no. of components in a chord��5~15
    t1=randperm(length(comp_rest));                 % randomise list of
    noncoh_comp=comp_rest(t1(1:n_c));               % ��ʣ�µ�freq�������ȡ5��15��,ÿ��bust��ô��һ��
    bg_comp{j} = noncoh_comp;
    all_comp=[coh_comp noncoh_comp];                % com_freq noncoh_freq
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
        % one freq, one chord(50ms),list 2206 time point
        allsound_unwind=sum(allsound_chord,1);

        allsound_wind=Teki_wind(srate,durRamp,allsound_unwind);
        allsound_seg=[allsound_seg allsound_wind];
        bgsound_unwind = sum(bgsound_chord,1);
        bgsound_wind=Teki_wind(srate,durRamp,bgsound_unwind);
        bgsound_seg = [bgsound_seg bgsound_wind];
        if ~isempty(coh_comp) 
            figsound_unwind = sum(figsound_chord,1);
            figsound_wind=Teki_wind(srate,durRamp,figsound_unwind);
            figsound_seg = [figsound_seg figsound_wind];
        else
            figsound_seg = [];
        end
    
    
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
        % one freq, one chord(50ms),list 2206 time point
        allsound_unwind=sum(allsound_chord,1)./max(abs(sum(allsound_chord,1)));
        allsound_wind=Teki_wind(srate,durRamp,allsound_unwind);
        allsound_seg=[allsound_seg allsound_wind];

        bgsound_unwind = sum(bgsound_chord,1)./max(abs(sum(bgsound_chord,1)));
        bgsound_wind=Teki_wind(srate,durRamp,bgsound_unwind);
        bgsound_seg = [bgsound_seg bgsound_wind];

        if ~isempty(coh_comp) 
            figsound_unwind = sum(figsound_chord,1)./max(abs(sum(figsound_chord,1)));
            figsound_wind=Teki_wind(srate,durRamp,figsound_unwind);
            figsound_seg = [figsound_seg figsound_wind];
        else
            figsound_seg = [];
        end
    end

end

