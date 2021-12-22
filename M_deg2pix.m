function pl=deg2pix(vdist,vangle,pwidth,cwidth) 
% vdist is distance from eye to screen, in cm
% vangle, visual angle
% pwidth, screen width in pixels
% cwidth, screen width in cwdith =
cl = vdist*tan(vangle*pi/180); % 0.974
pl = cl*(pwidth/cwidth);
return;