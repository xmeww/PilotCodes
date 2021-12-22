function [figsound_seg,allsound_seg]=bgn0_coherence_gen(n_c_max,n_chords,tsample,srate,coh_comp,durRamp)

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

for j=1:n_chords % no. chords in certain segment, dur
    allsound_chord = [];
    for m=1:length(coh_comp) %one freq one time, 5~15+0~8, all frequencies, component (base+fig) 
        allsound_chord=[allsound_chord;(0.2/n_c_max)*sin(2*pi*coh_comp(m)*tsample)]; % normalized here,sclared+ramp? every preq in all freq, 0.2/15*sin(wt)
    end
    % one freq, one chord(50ms),list 2206 time point
    allsound_unwind=sum(allsound_chord,1);
    allsound_wind=Teki_wind(srate,durRamp,allsound_unwind);
    
    allsound_seg=[allsound_seg allsound_wind];
    
   
    figsound_seg = allsound_seg;
end

