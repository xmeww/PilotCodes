%% AUDITORY parameters
% --------------------------------basic------------------------------
function [A] = m_setA(answer,ifi)
A.srate = 44100;
F = 440 * 2 .^((-31:97)/24); 
A.F = F(F>400);
A.channels = 2;
% sundeep ramp-in 10ms, ramp-out 10ms, burg 5-ms fade-in and fade-out to


% ----------------------------  EXP changable ------------------------
A.ifi_chord = answer.ifi_chord;
dur_chord = answer.ifi_chord*ifi;
A.dur_chord = dur_chord;% var ifi loaded from ifi.mat
A.coh_levels = answer.coh_levels;
A.nFigchords = answer.tardur/answer.ifi_chord;% blocks, sundeep 1~, burg 1
A.nbg_levels = answer.nbg_levels; %blocks;
A.normMethod = answer.normMethod;
A.durRamp = answer.durRamp;
A.sample_meth = answer.sample_meth;
% A.tsample = 0:1/A.srate:A.dur_chord; % 2206 2210
% A.tRamp = 0:1/A.srate:A.durRamp; % 2206
% A.tsample =(0:A.dur_chord*A.srate)/A.srate; % 2206
switch A.sample_meth{:}
    case 'makebeep'
        
    A.tsample = (0:A.dur_chord*A.srate-1)/A.srate;
    A.tRamp = (0:A.durRamp*A.srate-1)/A.srate;
    
    case 'Teki'
    A.tsample = 0:1/A.srate:A.dur_chord;
    A.tRamp = 0:1/A.srate:A.durRamp; 
end

A.totsample = length(A.tsample)*(round(0.05/dur_chord)+round(0.1/dur_chord)+round(0.15/dur_chord))*3*answer.ncycle;
A.n_c_max = answer.n_c_max;
fprintf('chord durtion: %f, sampling points per chord: %f', dur_chord,length(A.tsample))
% linspace(0,dur_chord,srate*dur_chord); % 2205
% A.octave = 5/24; % <<======================================