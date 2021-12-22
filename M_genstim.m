% savefolder = [pwd 'workingdir'];
% % if not(exist(savefolder)); mkdir(savefolder);end
% 
% savefile = [savefolder '/' screenfile{screen} '_' tempDesfile{tempDes} '.mat'];
rng('shuffle'); 
Vpres_type = [1;2;0];
Apres_type = [0;1];
tarOri_type = [0;1];

% [Vpresent,nItems,Apressent,Coh] = BalanceFactors(condRep,1,Vpres_type,nItem_type,Apres_type,coh_type);
[Vpresent,nItems,Coh] = BalanceFactors(condRep,trOrd,Vpres_type,nItem_type,coh_type);
Vpresent(Vpresent == 2) =1;

if length(nbg_type) == 1
    Nbg = nbg_type*ones(size(nItems));
else
    Nbg = randsample(nbg_type,length(nItems),true);
end

% cond = table(Vpresent,nItems,Apressent,Coh,Nbg,'VariableNames',{'vis_present','nItems','aud_present','coh','nbg'});
cond = table(Vpresent,nItems,Coh,Nbg,'VariableNames',{'vis_present','nItems','coh','nbg'});

nIntv = 9;
ntrials = size(nItems,1);
nvRep = length(Vpres_type)*length(Apres_type)*length(coh_type);

[tarOris tarLocs]=deal(nan(size(nItems)));

tarOris = randsample(tarOri_type,length(nItems),true);
for i = 1:length(nItem_type)
    tarLocs(find((nItems==nItem_type(i)))) = randsample(nItem_type(i),length(find(nItems==nItem_type(i))),true);
    while range(histcounts(tarLocs(find((nItems==nItem_type(i))))))>2
        tarLocs(find((nItems==nItem_type(i)))) = randsample(nItem_type(i),length(find(nItems==nItem_type(i))),true);
    end
end
% for i = 1:length(nv_type)
% subplot(2,3,i)
% histogram(tarLocs(find((nItems==nv_type(i)))))
% subplot(2,3,i+3)
% 
% end


nItemsChg = nan(ntrials,nIntv*ncycle,nblocks); % (ntrial,Intv*ncycle,nblocks), number of items change at each interval in each trial
for b = 1:nblocks
    for i = 1:length(nItem_type)
        N = length(find((nItems==nItem_type(i))));
        mat=randsample(nitemChg_type(i,:),nIntv*ncycle*N,true);% without replication, otherwise error: 3< ntrial
        nItemsChg(find((nItems==nItem_type(i))),:,nblocks) = reshape(mat,N,nIntv*ncycle);
    end
end

%% VISUAL parameters
% --------------------------------VISUAL------------------------------
% --------------------screen and visual stimuli size----------
screenNumber = max(Screen('Screens'));
if screenAns == 1
   res = Screen('Resolution',screenNumber);
   res = [0,0,res.width,res.height]; 
elseif screenAns == 2
   res = get(0,'ScreenSize');
   res = [0 0 res(3:4)];
   
end
xpixels = res(3);
ypixels = res(4);

% get(ScreenNumber,'ScreenSize');
xCenter = xpixels/2;
yCenter = ypixels/2;


vdist = 58;  % test distance from monitor
cwidth = 53.4; % screen display width in cm    % 57.2
VARcircle = 9; % diameter
VAbar = 1.6; % diameter
VAfix = 1.6;  


lineWidth = 6;
tilt = 15;

Lfix = M_deg2pix(vdist,VAfix,xpixels,cwidth);
fixangle = (90-tilt)/180; %(90-tilt)/180;tilt/180;<<========= put into M if determined
fixbars = [xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle),xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle);...
           yCenter-Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter-Lfix/2*cos(fixangle)]; % center -/+ fixation/2

% for test, add circle around target
VARtestcircle = 0.4;
VAWtestcircle = 0.5;
V.lineWidth = lineWidth;
V.vdist = vdist;
V.cwidth =cwidth;
V.VARcircle = VARcircle;
V.VAbar = VAbar;
V.VAfix = VAfix;
V.fixbars= fixbars;
V.ifi = ifi;
% ------------------------------color-----------------
% Each trial began with a fixation dot presented for 1,000 ms at the center of the screen. 
% The search display was presented until participants responded.

clr1 = (answer.clr1)';
clr2 = (answer.clr2)';
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

%% AUDITORY parameters
% --------------------------------basic------------------------------
A.srate = 44100;
A.F = 440 * 2 .^((-31:97)/24); 
A.channels = 2;
% sundeep ramp-in 10ms, ramp-out 10ms, burg 5-ms fade-in and fade-out to


% ----------------------------  EXP changable ------------------------
A.ifi_chord = ifi_chord;
dur_chord = ifi_chord*ifi;
A.dur_chord = dur_chord;% var ifi loaded from ifi.mat
A.coh_type = coh_type;
A.nFigchords = t_preTpost(2)/ifi_chord;% blocks, sundeep 1~, burg 1
% nchords_fig(nchords_fig ==0) = [];
% A.nchords_fig = nchords_fig;
A.nbg_type = nbg_type; %blocks;
% A.bg_coh_min = 0; % 5
% A.bg_coh_max = 0; %15
A.normMethod = normMethod;
A.durRamp = durRamp;
% A.tsample = 0:1/A.srate:A.dur_chord; % 2206 2210
% A.tRamp = 0:1/A.srate:A.durRamp; % 2206
% A.tsample =(0:A.dur_chord*A.srate)/A.srate; % 2206
switch sample_meth{:}
    case 'makebeep'
        
    A.tsample = (0:A.dur_chord*A.srate-1)/A.srate;
    A.tRamp = (0:durRamp*A.srate-1)/A.srate;
    
    case 'Teki'
    A.tsample = 0:1/A.srate:dur_chord;
    A.tRamp = 0:1/A.srate:durRamp; 
end

A.totsample = length(A.tsample)*6*3*ncycle;
A.n_c_max = n_c_max;
% linspace(0,dur_chord,srate*dur_chord); % 2205
% A.octave = 5/24; % <<======================================
%% save 
Tr.nblocks = nblocks;
Tr.ntrials= ntrials;
Tr.ncycle = ncycle;
Tr.nIntv = nIntv ;
Tr.nItems = nItems ;
Tr.tarLocs = tarLocs;
Tr.tarOris = tarOris;
Tr.nItemsChg = nItemsChg;
Tr.clr1 = clr1;
Tr.clr2 = clr2;
Tr.tcycle = (A.dur_chord+A.dur_chord*2+A.dur_chord*3)*3;
Tr.t_preTpost = answer.t_preTpost;
Tr.inputAns = answer;
Tr.Coh = Coh;
Tr.Nbg = Nbg;
Tr.cond = cond;
Tr.lineWidth = lineWidth;
Tr.trOrd = trOrd;
Tr.Vpresent = Vpresent;
% save(savefile,'Tr','A','V');
for b = 1: nblocks % nblock
    [nItem,tarLoc,tarOri,nItemChange] = deal(nItems(:,b),tarLocs(:,b),tarOris(:,b),nItemsChg(:,:,b));
    
    % tarIntvs_trialwise(ntrial,ncycle)
    % fIntvs_trialwise(ntrial,ncycle*nIntv)
    % fIntvs_cyclewise(ncycle,nIntv,ntrial)
    [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv] = M_intervals(ntrials,ncycle,nIntv,Tr.t_preTpost);
% ---------------- ----------------timing ---------------------------------

    intervals.tarIntvs_cyclewise = tarIntvs_cyclewise;
    intervals.tarIntvs_trialwise = tarIntvs_trialwise;
    intervals.fIntvs_trialwise = fIntvs_trialwise;
    intervals.fIntvs_cyclewise = fIntvs_cyclewise;
    intervals.fflipIntv = fflipIntv ;
%    intervals.AcycIntv = AcycIntv;
    S(b).intervals = intervals;   

    
% ---------------- ---------------- sounds ---------------- ----------------
    
        [figCycle,soundCycle,fig,sounds,nchords_segtrial] = M_sounds(Tr,A,Coh(:,b),Nbg(:,b),tarIntvs_trialwise,fIntvs_trialwise);

        Sounds.sounds = sounds;
        Sounds.fig = fig;
        Sounds.soundCycle = soundCycle;
        Sounds.figCycle = figCycle;
        Sounds.nchords_segtrial =nchords_segtrial;
        S(b).Sounds = Sounds;
    % % ---------------- coordinates ---------
        
            [XY,tarCenterXY,tarHemi,testcircle,Rroute,Lbar] = M_coordinate(Vpresent,ntrials,nItem,xpixels,ypixels,vdist,cwidth,...
                VARcircle,tarLoc,tarOri,VAbar,tilt);
            
            coordinate.tarLoc = tarLoc;
            coordinate.XY = XY; % -XY {2,nitems*2,ntrial} 
            coordinate.fixbars  = fixbars;% - fixbars(4,4) , 1st row x, 2nd row y, col: start,end,stat,end
            coordinate.tarCenterXY = tarCenterXY; % (2,ntrial), 1st row target x, 2nd row target y
            coordinate.tarHemi = tarHemi; % - target hemisphere, (ntrial,1), 1-r,0-l
            coordinate.testcircle = testcircle;

        %     % ---------------- color ---------
        % 
            [clr_cyclewise,clr_trialwise, clrCodes_trialwise] = M_color(tarLoc,tarIntvs_trialwise,ntrials,ncycle,nIntv,nItem,nItemChange,...
                clr1,clr2);
            color.clr_trialwise = clr_trialwise;
            color.clrCodes_trialwise = clrCodes_trialwise;
            color.clr_cyclewise = clr_cyclewise;

    % ---------------- saving ---------

            S(b).coordinate = coordinate;

            S(b).color = color;
end
   


V.RroutePix = Rroute;
V.LbarPix = Lbar;
% 
delete(savefile);
save(savefile,'Tr','A','S','V');
% 
% 
% 
% 
% 
% 
