function [figCycle,soundCycle,fig,sounds,nchords_segtrial] = M_sounds(ntrial,ncycle,A,Coh,Nbg,tarIntvs_trialwise,fIntvs_trialwise)
% clear all;
% load('workingdir/parameters.mat'); % parameters,mat includes A Tr S
% nbg = A.nbg;
% nbg = nbg(2);
% tarIntvs_trialwise = S.m_intervals.tarIntvs_trialwise;
% tIntvs_trialwise = S.m_intervals.tIntvs_trialwise;
% tarIntvs_trialwise =S(1).m_intervals.tarIntvs_trialwise;
% tIntvs_trialwise = S(1).m_intervals.tIntvs_trialwise;
% ntrial = 1;
% ncycl = 10;

totsample = A.totsample;



F = A.F;
srate= A.srate;
ifi_chord = A.ifi_chord;
% dur_chord = A.dur_chord; 
nchords_fig = A.nFigchords;% n ifi


tsample = A.tsample;
nseg_max = ncycle*2+1;% maximal fig+bg seg
nchords_segtrial=nan(ntrial,nseg_max); % not sure about the number of seg

% length(tsample)*(tcycle*ncycle/dur_chord); % 396900
sounds= nan(2,totsample,ntrial);
fig = nan(2,totsample,ntrial);
soundCycle = nan(2,totsample/ncycle,ncycle,ntrial);
figCycle = nan(2,totsample/ncycle,ncycle,ntrial);
for j = 1: ntrial
%% compute seg
    % j = 1;
    coh = Coh(j);
    nbg = Nbg(j);
    ran = randperm(length(F));
    figFreq = F(ran(1:coh));
    restFreq = F(ran(coh+1:end));
    
    
    sound_trial = [];
    fig_trial = [];
    nchords_segs_pertrial = []; % number of chords in each seg(fig seg,bg seg) in jth trial,[3 11 3...]
    tarIntvs =  tarIntvs_trialwise(j,:); % (ntrial,ncycle),target interval, target change color at ith interval(out of ncycle*nintv)  in a trial
    fIntvs = fIntvs_trialwise(j,:); % duration of all intvs, (ntrial, ncycle*nintv)

    %for chord = 1:nchords_pertrial % 180chords in one trial
    nchords_InitBg = sum(fIntvs(1:tarIntvs(1)-1))/ifi_chord; % number of chords <- time before tarintv in 1st cycle(>500ms) 
    nchords_segs_pertrial = [nchords_InitBg ]; % nchords_fig
    for seg = 1:ncycle-1
        % seg = 9;
        nchords_MidBg = (sum(fIntvs(tarIntvs(seg):tarIntvs(seg+1)-1))/ifi_chord)-nchords_fig;
        nchords_segs_pertrial =[nchords_segs_pertrial nchords_fig nchords_MidBg ];
    end
    if (sum(fIntvs(tarIntvs(ncycle):end))/ifi_chord)-nchords_fig < 0
        warning('seg has non-integral chord!')
        return
    elseif (sum(fIntvs(tarIntvs(ncycle):end))/ifi_chord)-nchords_fig == 0
        nchords_FinBg = [];
        warning('trial ends with last target chord')
    elseif (sum(fIntvs(tarIntvs(ncycle):end))/ifi_chord)-nchords_fig > 0
        nchords_FinBg=(sum(fIntvs(tarIntvs(ncycle):end))/ifi_chord)-nchords_fig;
    end
    nchords_segs_pertrial =[nchords_segs_pertrial nchords_fig nchords_FinBg];
    nchords_segtrial(j,1:length(nchords_segs_pertrial)) = nchords_segs_pertrial;
    % nchords_segs_pertrial = round(nchords_segs_pertrial); % float to int, can't use init16, would drop number 
     % sum(nchords_segtrial)=180   
 
 %% generate sound  
    for seg = 1:length(nchords_segs_pertrial)
%         display(seg);
%         display(n_chords);
        n_chords= nchords_segs_pertrial(seg);   
        
        if mod(seg,2) ==1 && nbg == 0 % bg seg
           segsound = zeros(1,n_chords*length(tsample));
           segfig = zeros(1,n_chords*length(tsample));
%            display(n_chords)
%            display(length(segsound)/length(tsample))
        elseif mod(seg,2) ==1 && nbg ~= 0
            [~,segsound] = M_SoundSeg(A,n_chords,[],nbg,F);
            segfig = zeros(1,n_chords*length(tsample));
%             display(n_chords)
            %display(length(segsound)/length(tsample))
        elseif mod(seg,2) == 0  
            [segfig,segsound] = M_SoundSeg(A,n_chords,figFreq,nbg,restFreq); 
%             display(n_chords)
            
        end
        
        sound_trial = [sound_trial segsound];
        
        fig_trial = [fig_trial segfig];
%         n_bgCoh = [n_bgCoh bgCoh_seg]  ; 
    end
    disp(length(sound_trial))
    
    soundcycle = reshape(sound_trial,[1,totsample/ncycle,ncycle]);
    soundCycle(:,:,:,j) = [soundcycle;soundcycle]; %  nan(2,totsample/ncycle,ncycle,ntrial);
    sounds(:,:,j) = [sound_trial;sound_trial];
    
    if coh ~= 0
        fig(:,:,j) = [fig_trial;fig_trial];
        figcycle = reshape(fig_trial,[1,totsample/ncycle,ncycle]);
        figCycle(:,:,:,j) = [figcycle;figcycle];
    end
end