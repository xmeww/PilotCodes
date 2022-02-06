%% inpput parameters
monitor = 'lab1'; %lab1,mac
monitorMode =  'plain';%'palin','small','trasnparent','screen-short'
trOrd = 0; % 1 order, 0 random
intv_type_pre = [1 1 2 2 3 3];
preCyc_int = sum(intv_type_pre);


% condRep = 48*2; % 12*4*2, 16*3*2 each condition repeats 96(location x orientation x common divisor)
% rep1 = condRep/(length(tarOri_type)*tarLoc_level(1));
% rep2 = condRep/(length(tarOri_type)*tarLoc_level(2));
rep1 = 4;
rep2 = 3;
nItem_levels = [12,16];
 
% condRep = 30*2; % 12*4*2, 16*3*2 each condition repeats 96(location x orientation x common divisor)
% nItem_levels = [10,16];


coh_levels = [10];

% AVsync_levels = [0,50,150,-50,-150]./50;% n intervals 
AVsync_levels = [0];

ncycle = 10;
tilt = 18;% 15; 20
clr1 = [255 0 0];%
clr2 = [0 255*0.7 0];%

% clr1 = [5 50 63];% blue
% clr2 = [5 61 5]; % green
% [85 38 5] red
nchords_fig=3;
nfig = 4; % pre-determined figure

%% generate stimuli using M_*.m files
% 
% [ntrials,AVasync,figOnly,figPresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = ...
%     M_cond(condRep,trOrd,nItem_levels,coh_levels,AVsync_levels);

% [ntrials,AVasync,figOnly,figPresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = ...
%     M_cond_SFG(condRep,trOrd,nItem_levels,coh_levels,AVsync_levels);


% [ntrials,AVasync,figOnly,figPresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = ...
%     M_cond_SFGfigOnly(condRep,trOrd,nItem_levels,coh_levels,AVsync_levels);
[ntrials,AVasync,figOnly,figPresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = ...
    M_cond_SFGfigOnly(rep1,rep2,trOrd,nItem_levels,coh_levels,AVsync_levels);

Tr.ntrials = ntrials;
Tr.AVasync = AVasync;
Tr.figOnly = figOnly;
Tr.figPresent = figPresent;
Tr.nItems = nItems;
Tr.Coh = Coh;
Tr.tarOris = tarOris;
Tr.tarLocs = tarLocs;
Tr.condTable = condTable;
Tr.balTable = balTable;
Tr.FGth = FGth;
Tr.ncycle = ncycle;

save cond_Tr.mat Tr coh_levels rep1 rep2 AVsync_levels tilt preCyc_int



[XY,disOri,Ori,tarCenter,fixbars,tarMarker]=M_coordinate(monitor,monitorMode,tarOris,tarLocs,tilt,ntrials,nItems);
% tarCenter [x;y], target center
save coordinate.mat XY disOri Ori tarCenter fixbars tarMarker

% tintv = 3*ifi; % duration of one interval
nTslot_c = 9; % 9 timing slots/cycle
nintvs = 180;
[tarIntv_tr, nchg, item_intv, fgStart,nintvSlot_tr]  = M_interval_150(ntrials,tarLocs,nItems,ncycle,nTslot_c,AVasync,figPresent,preCyc_int,intv_type_pre,nintvs);
% check closeTar==1(tar-tar share tpw), chkItemhg==0 (nchg not match item_intv)
save intv.mat tarIntv_tr nchg  item_intv  fgStart nintvSlot_tr

[clrCodes,clr_trs]= M_color(nItems,ntrials,nintvs,item_intv,clr1,clr2,preCyc_int);
save color.mat  clrCodes clr_trs 
%% sound

ntrials = Tr.ntrials;%
[Ffg,Fbg]=M_selectF_noSeg(coh_levels,nchords_fig,nfig,ntrials,Coh,figPresent,FGth,fgStart,preCyc_int,figOnly);
save selectF.mat Ffg Fbg 

n_c_max =20;
ramp_t =5; %5 ms ramp-on/off
dur_burst = 50;%50ms each chord
nFigChord = 3;
% ntrials =4;

% [FGsounds,BGsounds] = M_sounds(nintv_tr,n_c_max,ramp_t,FfgL,FfgH,Fbg,nfig,coh_levels,ntrials,nFigChord,figOnly,preCyc_int);
cond = 1:Tr.ntrials;
[FGsounds,BGsounds] = M_sounds_s(nintvs,n_c_max,ramp_t,Ffg,Fbg,nfig,coh_levels,ntrials,nFigChord,figOnly,preCyc_int,cond);

save('sounds.mat','FGsounds','BGsounds','-v7.3')

% save working.mat Ffg6 Ffg10 Fbg Fpre FGsounds BGsounds Presounds...
%     tarIntv_c tarIntv_tr tar_dist nchg disLocs item_intv fgStart item_intvPre...
%     XY disOri Ori tarCenter fixbars Tr...
%     clrCodes clr_trs PreclrCodes Preclr_trs

%     BGSounds = cat(2,BGsounds,Presounds);%(chn,sample,trial)
%     tarIntv_Tr = 10+tarIntv_tr;
%     FGStart = fgStart+10;
%     for j = 1:Tr.ntrials
%         Clr{j} = cat(3,Preclr_trs{j}, clr_trs{j});
%     end


%% generate new sets of stimuli, if participants have't respond within 9s, read this new sets of stimuli 
% actually in pilot3, same stimuli re-presented again after 9s if
% participants haven't responded

% tintv = 3*ifi; % duration of one interval
% nintv_tr = 180*3; % 0.9/0.05*10
% nintv_c = 18; %  0.9/0.05
% [~, tarIntv_out, ~, ~, ~, item_intv_out, fgStart_out] = M_interval(ntrials,tarLocs,nItems,ncycle,nintv_tr,nintv_c,AVasync,Apresent,preCyc_int);
% save intv_out.mat item_intv_out  fgStart_out 
% 
% [clrCodes_out,clr_trs_out]= M_color_Out(nItems,ntrials,nintv_tr,item_intv_out,clr1,clr2,clrCodes);
% save color_out.mat  clrCodes_out clr_trs_out 
% 
% ntrials = 500;
% [Fbg_out]=M_selectF_Out(ntrials,Apresent,Coh,Ffg6,FGth,Ffg10,fgStart_out,Fbg);
% save selectF_out.mat Fbg_out
% 
% n_c_max =20;
% ramp_t =5; %5 ms ramp-on/off
% dur_burst = 50;%50ms each chord
% % ntrials =4;
% [BGsounds_out] = M_sounds_Out(nintv_tr,n_c_max,ramp_t,Fbg_out,dur_burst,ntrials);
% save('sounds_out.mat','BGsounds_out', '-v7.3')
