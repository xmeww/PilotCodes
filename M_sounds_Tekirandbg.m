function [soundCycle,sounds,figCycle,fig,bgCycle,bg,nchords_segtrial,coh_comp,BG_comp] = M_sounds_Tekirandbg(ntrials,ncycle,A,apresent,coh,nbg_levels,tarIntvs_trialwise,disIntvs_trialwise,fIntvs_trialwise,syncVTar)
        
% [figCycle,soundCycle,fig,sounds,nchords_segtrial]
% clear all;
% load('workingdir/stim_redundant_Mac.mat'); % parameters,mat includes A Tr S
% tarIntvs_trialwise =S(1).intervals.tarIntvs_trialwise;
% fIntvs_trialwise = S(1).intervals.fIntvs_trialwise;
% ntrials = 2;
% ncycle = 10;
% Apresent = Tr.Apresent;
% Apresent = Apresent(:,1);
% Coh = Tr.Coh;
% Coh = Coh(:,1);

totsample = A.totsample;
n_c_min = min(A.nbg_levels);
n_c_max = max(A.nbg_levels);
F = A.F;
durRamp = A.durRamp;
srate= A.srate;
ifi_chord = A.ifi_chord;
% dur_chord = A.dur_chord; 
nchords_fig = A.nFigchords;% n ifi
tsample = A.tsample;
nseg_max = ncycle*2+1;% maximal fig+bg seg
nchords_segtrial=nan(ntrials,nseg_max); % not sure about the number of seg
normMethod = A.normMethod;
% length(tsample)*(tcycle*ncycle/dur_chord); % 396900
sounds= nan(2,totsample,ntrials);
fig = nan(2,totsample,ntrials);
bg = nan(2,totsample,ntrials);
soundCycle = nan(2,totsample/ncycle,ncycle,ntrials);
figCycle = nan(2,totsample/ncycle,ncycle,ntrials);
bgCycle = nan(2,totsample/ncycle,ncycle,ntrials);
BG_comp = {};
for j = 1: ntrials
%% compute seg
    % j = 1;
%     coh = Coh(j);
    
    sound_trial = [];
    fig_trial = [];
    bg_trial = [];
    bg_comp_trial = [];
    nchords_segs_pertrial = []; % number of chords in each seg(fig seg,bg seg) in jth trial,[3 11 3...]
    if apresent(j) == 1
        if ((syncVTar(j) == 1) || (syncVTar(j) == 0))
            syncIntvs =  tarIntvs_trialwise(j,:); % (ntrial,ncycle),target interval, target change color at ith interval(out of ncycle*nintv)  in a trial

        elseif syncVTar(j) == -1
            syncIntvs =  disIntvs_trialwise(j,:); 
        end
        fIntvs = fIntvs_trialwise(j,:); % duration of all intvs, (ntrial, ncycle*nintv)

        %for chord = 1:nchords_pertrial % 180chords in one trial
        nchords_InitBg = sum(fIntvs(1:syncIntvs(1)-1))/ifi_chord; % number of chords <- time before tarintv in 1st cycle(>500ms) 
        nchords_segs_pertrial = [nchords_InitBg ]; % nchords_fig
        for seg = 1:ncycle-1
            % seg = 9;
            nchords_MidBg = (sum(fIntvs(syncIntvs(seg):syncIntvs(seg+1)-1))/ifi_chord)-nchords_fig;
            nchords_segs_pertrial =[nchords_segs_pertrial nchords_fig nchords_MidBg ];
        end
        if (sum(fIntvs(syncIntvs(ncycle):end))/ifi_chord)-nchords_fig < 0
            warning('seg has non-integral chord!')
            return
        elseif (sum(fIntvs(syncIntvs(ncycle):end))/ifi_chord)-nchords_fig == 0
            nchords_FinBg = [];
            warning('trial ends with last target chord')
        elseif (sum(fIntvs(syncIntvs(ncycle):end))/ifi_chord)-nchords_fig > 0
            nchords_FinBg=(sum(fIntvs(syncIntvs(ncycle):end))/ifi_chord)-nchords_fig;
        end
        nchords_segs_pertrial =[nchords_segs_pertrial nchords_fig nchords_FinBg];
        nchords_segtrial(j,1:length(nchords_segs_pertrial)) = nchords_segs_pertrial;
        % nchords_segs_pertrial = round(nchords_segs_pertrial); % float to int, can't use init16, would drop number 
         % sum(nchords_segtrial)=180   
    elseif apresent(j) == 0
        
    end
 %% generate sound  
    if apresent(j) == 1
   
%         fprintf('\nApresent %i',apresent(j))
        ran=randperm(length(F));
%        fprintf('\ncoh %i',coh(j))
        % create random list of numbers from 1-129
        coh_comp{j}=F(ran(1:coh(j)));       % coherent frequency pool
%         fprintf('\ncoh_comp %i',coh_comp{j})
        comp_rest=F(ran(coh(j)+1:end));  % non-coherent frequency pool
        
        for seg = 1:length(nchords_segs_pertrial)
    %         (seg);
    %         display(n_chords);
               n_chords= nchords_segs_pertrial(seg); 
                if isempty(nbg_levels)
                    if mod(seg,2) == 0 % fig seg
    %                     fprintf('\nseg %i',mod(seg,2) == 0)
                        [figsound_seg,allsound_seg]=bgn0_coherence_gen(15,n_chords,tsample,srate,coh_comp{j},durRamp);
                        sound_trial = [sound_trial allsound_seg];
                        fig_trial = [fig_trial figsound_seg];
                        bg_trial = [bg_trial zeros(1,n_chords*length(tsample))];
    %                     Snd('Play',figsound_seg);
    %                     Snd('Wait');
    %                     Snd('Quiet');
                    elseif mod(seg,2) == 1
    %                     fprintf('\nseg %i',mod(seg,2) == 0)
                        sound_trial = [ sound_trial zeros(1,n_chords*length(tsample))];
                        fig_trial = [fig_trial zeros(1,n_chords*length(tsample))];
                        bg_trial = [bg_trial zeros(1,n_chords*length(tsample))];
                    end
                else
                   
                    if mod(seg,2) == 0 % fig seg
    %                     fprintf('\nseg %i',mod(seg,2) == 0)
                        [figsound_seg,bgsound_seg,allsound_seg,bg_comp]=Teki_coherence_gen(n_c_min,n_c_max,n_chords,tsample,srate,coh_comp{j},comp_rest,durRamp,normMethod);
                        
                        sound_trial = [sound_trial allsound_seg];
                        fig_trial = [fig_trial figsound_seg];
                        bg_trial = [bg_trial bgsound_seg];
                        bg_comp_trial = [ bg_comp_trial bg_comp];
%                         display(1)
%                         length(bg_comp_trial)
    %                     Snd('Play',figsound_seg);
    %                     Snd('Wait');
    %                     Snd('Quiet');
                    elseif mod(seg,2) == 1
    %                     fprintf('\nseg %i',mod(seg,2) == 0)
                        [~,bgsound_seg,allsound_seg,bg_comp]=Teki_coherence_gen(n_c_min,n_c_max,n_chords,tsample,srate,[],F,durRamp,normMethod); 

                        sound_trial = [sound_trial allsound_seg];
                        fig_trial = [fig_trial zeros(size(allsound_seg))];
                        bg_trial = [bg_trial bgsound_seg];
                        bg_comp_trial = [ bg_comp_trial bg_comp];
%                           display(2)
%                         length(bg_comp_trial)
                    end
                end
        end
    elseif apresent(j) == 0
      
%          fprintf('\nApresent %i',apresent(j))
         coh_comp{j}=[];
         for seg = 1:length(nchords_segs_pertrial)  
             n_chords= nchords_segs_pertrial(seg); 
            if isempty(nbg_levels)
                sound_trial = [sound_trial zeros(1,n_chords*length(tsample))];
                fig_trial = [fig_trial zeros(1,n_chords*length(tsample))];
                bg_trial = [bg_trial zeros(1,n_chords*length(tsample))];
            else
             
                if mod(seg,2) == 0 % fig seg

%                     [figsound_seg,bgsound_seg,allsound_seg,~,~]=Teki_coherence_gen_rand(n_c_min,n_c_max,n_chords,coh(j),tsample,srate,F,durRamp);
                    [figsound_seg,bgsound_seg,allsound_seg,~,bg_comp]=Teki_coherence_gen_rand(n_c_min,n_c_max,n_chords,0,tsample,srate,F,durRamp,normMethod);

                    sound_trial = [sound_trial allsound_seg];
    %                 fig_trial = [fig_trial figsound_seg];
                    fig_trial = [fig_trial figsound_seg];
                    bg_trial = [bg_trial bgsound_seg];
    %                 Snd('Play',figsound_seg);
    %                 Snd('Wait');
    %                 Snd('Quiet');
                    bg_comp_trial = [ bg_comp_trial bg_comp];
%                       display(3)
%                         length(bg_comp_trial)
                elseif mod(seg,2) == 1
    %                 fprintf('\nseg %i',mod(seg,2))
                    [~,bgsound_seg,allsound_seg,~,bg_comp]=Teki_coherence_gen_rand(n_c_min,n_c_max,n_chords,0,tsample,srate,F,durRamp,normMethod);

                    sound_trial = [sound_trial allsound_seg];
                    fig_trial = [fig_trial zeros(size(allsound_seg))];
                    bg_trial = [bg_trial bgsound_seg];
                    bg_comp_trial = [ bg_comp_trial bg_comp];
%                       display(4)
%                         length(bg_comp_trial)
                end
            end
         end
    end
%         fig_trial = [fig_trial segfig];
%         n_bgCoh = [n_bgCoh bgCoh_seg]  ; 

    disp(length(sound_trial))
    
    soundcycle = reshape(sound_trial,[1,totsample/ncycle,ncycle]);
    soundCycle(:,:,:,j) = [soundcycle;soundcycle]; %  nan(2,totsample/ncycle,ncycle,ntrial);
    sounds(:,:,j) = [sound_trial;sound_trial];

    fig(:,:,j) = [fig_trial;fig_trial];
    figcycle = reshape(fig_trial,[1,totsample/ncycle,ncycle]);
    figCycle(:,:,:,j) = [figcycle;figcycle];

    bg(:,:,j) = [bg_trial;bg_trial];
    bgcycle = reshape(bg_trial,[1,totsample/ncycle,ncycle]);
    bgCycle(:,:,:,j) = [bgcycle;bgcycle];
    BG_comp{j} = bg_comp_trial;
end
