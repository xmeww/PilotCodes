% The onset and offset of each chord were shaped by a 10 ms raised-cosine ramp
% strate=4410Hz, wdms=10ms
function x=Teki_wind(srate,durRamp,x)
% srate in Hz, gate duration in ms, vector.
npts=size(x);
npts=npts(2); % size(x,2), sample point, 2206(50ms) one chord
if(srate==48828)
   wds= round(2*durRamp * srate);
   wds=round(wds);
else
   wds= 2*durRamp * srate; %ramp(0.1) on and off(0.1) take time point,totle 2*441 sampling rate
   wds=round(wds);
   if mod(wds,2)~=0 %����������0
       wds=wds+1;
   end
end
w=linspace(-1*(pi/2),1.5*pi,wds); % 2pi*w*t, t=linspace, sample on+off point in 2pi
w=(sin(w)+1)/2; % -1~1
% sine wave, inverted bell, half ramp on, half ramp off 
x(1:round(wds/2))=x(1:round(wds/2)).*w(1:round(wds/2)); % the begining 10ms, chord * ramp
if(srate==48828)
   x(npts-round(wds/2)+1:npts)=x(npts-round(wds/2)+1:npts).*w(round(wds/2):wds);
else
   x(npts-round(wds/2)+1:npts)=x(npts-round(wds/2)+1:npts).*w(round(wds/2)+1:wds); % the last 10ms
end


