clear;
n_c_min = 5;
n_chords = 20;
n_c_max = 40;
coh = 6;

durRamp = 0.005;
% tsample = (0:0.05*44100-1)/44100; % Giana
tsample = 0:1/44100:0.15; %teki
% tsample = A.tsample;
% (0:A.dur_chord*A.srate-1)/A.srate
% 0:1/A.srate:A.dur_chord
srate = 44100;
F = 440 * 2 .^((-31:97)/24); 
channels =2;
[pa] = m_openAudi(srate,channels);

[allsound,figsound] = Teki_coherence_gen(n_c_min,n_c_max,n_chords,coh,tsample,srate,F,durRamp);
PsychPortAudio('Fillbuffer',pa,[figsound;figsound]);
PsychPortAudio('Start',pa,1);
PsychPortAudio('Stop',pa,1)
WaitSecs(0.5)
PsychPortAudio('Fillbuffer',pa,[allsound;allsound]);
PsychPortAudio('Start',pa,1);


Teki_coherence_gen_rand(n_c_min,n_c_max,n_chords,coh,tsample,srate,F,durRamp)



