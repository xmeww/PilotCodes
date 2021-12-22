%% VISUAL parameters
% --------------------------------VISUAL------------------------------
% --------------------screen and visual stimuli size----------
function [V] = m_setV(monitor,ifi,clr1,clr2)
screenNumber = max(Screen('Screens'));
if strcmp(monitor,'Lab1')
   res = Screen('Resolution',screenNumber);
   res = [0,0,res.width,res.height]; 
elseif strcmp(monitor,'Macbook')
   res = get(0,'ScreenSize');
   res = [0 0 res(3:4)];
   
end
xpixels = res(3);
ypixels = res(4);

% get(ScreenNumber,'ScreenSize');
xCenter = xpixels/2;
yCenter = ypixels/2;


vdist = 80;%52;  % test distance from monitor  burg 80cm
cwidth =  53.4;% lab1 control 53.2; 53.4 % screen display width in cm    % 57.2
VARcircle = 5; % radius burg radius 4.9(2010) 9.58x9.58(2008)
VAbar = 0.7; % length burg length 0.7(2010) 0.57(2008)
VAfix = 0.7;  


lineWidth = 4;
tilt = 15; % 3 22.5 

Lfix = M_deg2pix(vdist,VAfix,xpixels,cwidth);
fixangle = (90-tilt)/180; %(90-tilt)/180;tilt/180;<<========= put into M if determined
fixbars = [xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle),xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle);...
           yCenter-Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter-Lfix/2*cos(fixangle)]; % center -/+ fixation/2

       
Lbar= M_deg2pix(vdist,VAbar,xpixels,cwidth); % length of bar
% Lfix = deg2pix(vdist,VAfix,xpixels,cwidth);
Rroute= M_deg2pix(vdist,VARcircle,xpixels,cwidth);

% for test, add circle around target
% VARtestcircle = 0.4;
% VAWtestcircle = 0.5;

V.screen = monitor;
V.lineWidth = lineWidth;
V.vdist = vdist;
V.cwidth =cwidth;
V.VARcircle = VARcircle;
V.VAbar = VAbar;
V.VAfix = VAfix;
V.fixbars= fixbars;
V.ifi = ifi;
V.tilt = tilt;
V.Lfix = Lfix;
V.clr_type = [clr1;clr2];
V.xpixels = xpixels;
V.ypixels = ypixels;
V.Lbar = Lbar;
V.Rroute = Rroute;

% ------------------------------color-----------------
% Each trial began with a fixation dot presented for 1,000 ms at the center of the screen. 
% The search display was presented until participants responded.

% darkGr = [0,0.5,0]';
% lightGr = [0.4660, 0.6740, 0.1880]';

%rgb2hsv(gr)= 0.3333    1.0000    1.0000
% rgb2hsv([0.4660, 0.6740, 0.1880]) = 0.2380    0.7211    0.6740
% clr1 = [1,0,0].*[255,255,255];
% clr1 = hsv2rgb(rgb2hsv([0,1,0]).*[1,1,0.8]).*[255,255,255];
% clr2 = hsv2rgb(rgb2hsv([0,1,0]).*[1,1,0.6]).*[255,255,255];
%rgb2hsv(gr)= 0.3333    1.0000    1.0000
% rgb2hsv([0.4660, 0.6740, 0.1880]) = 0.2380    0.7211    0.6740
% clr1 = [1,0,0].*[255,255,255];
% gr = [0,1,0];
% clr1 = hsv2rgb(rgb2hsv([0,1,0]).*[1,1,0.9]);
% clr2 = hsv2rgb(rgb2hsv([0,1,0]).*[1,1,0.4]);
% clr1 =clr1';
% clr2 =clr2';