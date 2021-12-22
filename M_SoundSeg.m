function [segfig,segsound,bgCoh_seg] = M_SoundSeg(A,n_chords,figFreq,nbg,restFreq)
% [segsound,bgCoh,figFreq bgFreq] = M_gensound(A)


% nbg = A.nbg; 
% bg_coh_min = A.bg_coh_min;
% bg_coh_max = A.bg_coh_max;
tsample = A.tsample;
normMethod = A.normMethod;
n_c_max = A.n_c_max;

durRamp = A.durRamp;
srate = A.srate;

bgCoh_seg = [];
segfig = [];
segsound = [];
for c = 1:n_chords % change every chords: bg(coh,nchords)
    chordfig = [];
    %bg_coh = bg_coh_min + round(rand*(bg_coh_max-bg_coh_min));
    if nbg == 0
        bgFreq = [];
    else 
        t1 = randperm(length(restFreq)); % if bg seg, restFreg = F
        bgFreq = restFreq(t1(1:nbg));% restFreq(t1(1:bg_coh));
    end
    %bgCoh_seg = [bgCoh_seg nbg];
    
    all_comp = [figFreq bgFreq];% if bg seg,figFreq =[]
    
    %disp(all_comp)
    chordsound = M_SoundNorm(all_comp,tsample,normMethod,n_c_max);
    %disp(chordsound)
     % chordsound = M_genNormSound(all_comp,A,'max');
    chordsound = M_SoundWind_Sundeep(chordsound,durRamp,srate);
    if ~isempty(figFreq)
        chordfig = M_SoundNorm(figFreq,tsample,normMethod,n_c_max);
        chordfig = M_SoundWind_Sundeep(chordfig,durRamp,srate);
    end
    %chordsound = M_SoundWind(chordsound,A);
    segsound = [segsound chordsound];
    segfig = [segfig chordfig];
end
    

