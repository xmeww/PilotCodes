function [pa] = m_openAudi(srate,channels)

PsychPortAudio('Close',[]);
InitializePsychSound(1);
deviceid = [];
mode = []; % default 1, sound playback only

% srate = A.srate;
% channels = A.channels;
buffersize = [];
suglat =  [];%0.093;%0.021;
rep = [];
reqlatencyclass = 2; % argument later for PPA'open'
latbias = 0; % argument later for PPA'LatencyBias'
pa = PsychPortAudio('Open', deviceid,mode,reqlatencyclass, srate, channels,...
            buffersize,suglat); 
% Tell driver about hardwares inherent latency, determined via calibration once:
prelat = PsychPortAudio('LatencyBias', pa, latbias) ;
postlat = PsychPortAudio('LatencyBias', pa) ;

