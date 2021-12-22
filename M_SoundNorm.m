function [sound] = M_SoundNorm(all_comp,tsample,normMethod,n_c_max)
% tsample = A.tsample;
% normMethod = A.normMethod;
% n_c_max = A.n_c_max;
sig = [];
% if nbg == 0
%     for m = 1:length(all_comp)
%         temp = sin(2*pi*tsample*all_comp(m));
%         sig = [sig; temp];
%     end
%     sound= sum(sig,1);
%     sound = sound./max(abs(sound));
if strcmp('sound_max',normMethod)  % pointed norm strategy or only target without noise (no value of bg number)
    for m = 1:length(all_comp)
        temp = sin(2*pi*tsample*all_comp(m));
        sig = [sig; temp];
    end
    sound= sum(sig,1);
    sound = sound./max(abs(sound));
elseif strcmp('nbg_max',normMethod) 
%     for m=1:length(all_comp) %one freq one time, 5~15+0~8, all frequencies, component (base+fig) 
%         sig2=[sig2;(0.2/n_c_max)*sin(2*pi*all_comp(m)*t)]; % normalized here,sclared+ramp? every preq in all freq, 0.2/15*sin(wt)
%     end
    for m = 1:length(all_comp)
        temp = (0.2/n_c_max)*sin(2*pi*tsample*all_comp(m));
        sig = [sig; temp];
    end
    sound= sum(sig,1);
end

