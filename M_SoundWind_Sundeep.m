function [sound] = M_SoundWind_Sundeep(sound,durRamp,srate)
% up = 0.01;
% off = 0.01;
% nwd = (up+off)*srate;
% durRamp = A.durRamp;
% srate = A.srate;
if ~isempty(sound)
    nwd = 2*durRamp*srate;
    wdt =linspace(-1/2,3/2,nwd);
    wd = sin(pi*wdt);
    wd = (wd+1)/2;
    sound(1:round(nwd/2)) = sound(1:round(nwd/2)).*wd(1:round(nwd/2));
    sound(end-round(nwd/2)+1:end) = sound(end-round(nwd/2)+1:end).*wd(end-round(nwd/2)+1:end);
else
    sound = [];
end