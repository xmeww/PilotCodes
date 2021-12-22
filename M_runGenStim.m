clc;clear;sca;

load('ifi.mat')
%%
[answer,paradigm] = M_InputGenStim;

monitor = answer.monitor;
% paradigm = answer.paradigm;
condRep = answer.condRep;
ncycle = answer.ncycle;
nitemChg_type = answer.nitemChg_type;
if nitemChg_type ~= 0;nitemChg_type = reshape(nitemChg_type,3,3)';end
blockRep= answer.blockRep;
t_preTpost = answer.t_preTpost;
clr1 = answer.clr1;
clr2 = answer.clr2;
nItem_levels = answer.nItem_levels;
bgType = answer.bgType;
nbg_levels = answer.nbg_levels;
coh_levels = answer.coh_levels;
ifi_chord = answer.ifi_chord;
durRamp = answer.durRamp;
n_c_max = answer.n_c_max;
normMethod = answer.normMethod;
sample_meth = answer.sample_meth;
savefile = answer.savefile;
trOrd = answer.trOrd-1;


%%
nIntv = 9;
% 'Aselect_01_singleV','Aselect_01_multiV','Vselect_1_multiA','Vselect_01_multiA','AVredundant'
if ( strcmp(paradigm,'Aselect01_multiV01_Time')  || strcmp(paradigm,'Aselect01_multiV01_Ori') || strcmp(paradigm,'Vselect01_multiA01') || strcmp(paradigm,'AVredundant') )
    
    [ntrials,nblocks,Vpresent,nItems,Apresent,Coh,condTable,tarOris,tarLocs,nItemsChg] = M_cond_A01_V01(nIntv,ncycle,nitemChg_type,condRep,trOrd,nItem_levels,coh_levels,blockRep);
elseif strcmp(paradigm,'Aselect01_singleV01')
    [ntrials,tarOris,Vpresent,Apresent,Coh,condTable,nblocks] = M_cond_Aselect01_Vsingle01(condRep,trOrd,coh_levels,blockRep);
elseif strcmp(paradigm,'Vselect1_multiA01')
    [ntrials,nblocks,Vpresent,Apresent,Coh,nItems,condTable,tarOris,tarLocs,nItemsChg] = M_cond_Vselect1_Amulti01(blockRep,condRep,trOrd,nItem_levels,coh_levels,nIntv,ncycle,nitemChg_type);
elseif strcmp(paradigm,'Vselect1_singleA01')
    [ntrials,nblocks,Vpresent,Apresent,Coh,nItems,condTable,tarOris,tarLocs,nItemsChg,syncVTar] = M_cond_Vselect1_singleA01(blockRep,condRep,trOrd,nItem_levels,coh_levels,nIntv,ncycle,nitemChg_type);
elseif strcmp(paradigm,'Vselect_AsyncTarDis')
    [ntrials,nblocks,syncVTar,Vpresent,nItems,Apresent,Coh,tarOris,tarLocs,disLocs,nItemsChg,condsTable] = M_cond_Vselect_AsyncTarDis_3rand(nIntv,ncycle,nitemChg_type,condRep,trOrd,nItem_levels,coh_levels,blockRep,answer.pC);
end
    
[V] = m_setV(monitor,ifi,clr1,clr2);
[A] = m_setA(answer,ifi);

%%

for b = 1:nblocks
    if strcmp(paradigm,'Aselect01_singleV01')
        nItem = 1;tarLoc = [];nItemChange = [];
        [tarOri,vpresent,apresent,coh] = deal(tarOris(:,b),Vpresent(:,b),Apresent(:,b),Coh(:,b));   
    
    else
        [nItem,tarLoc,tarOri,nItemChange,vpresent,apresent,coh] = deal(nItems(:,b),tarLocs(:,b),tarOris(:,b),nItemsChg(:,:,b),Vpresent(:,b),Apresent(:,b),Coh(:,b));
        
    end
    % tarIntvs_trialwise(ntrial,ncycle)
    % fIntvs_trialwise(ntrial,ncycle*nIntv)
    % fIntvs_cyclewise(ncycle,nIntv,ntrial)
%     [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,firstchg,tarDur] = M_intervals_new(ntrials,ncycle,nIntv);
% %     [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,firstchg,tarDur] = M_intervals_new(ntrials,ncycle,nIntv,t_preTpost);
% % ---------------- ----------------timing ---------------------------------
% 
%     intervals.tarIntvs_cyclewise = tarIntvs_cyclewise;
%     intervals.tarIntvs_trialwise = tarIntvs_trialwise;
%     intervals.fIntvs_trialwise = fIntvs_trialwise;
%     intervals.fIntvs_cyclewise = fIntvs_cyclewise;
%     intervals.fflipIntv = fflipIntv ;
%     intervals.firstchg= firstchg;
%     intervals.tarDur = tarDur;
% %    intervals.AcycIntv = AcycIntv;
%     S(b).intervals = intervals;
    [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,disIntvs_trialwise] = M_intervals_TarDisAll(ntrials,ncycle,nIntv);

%     [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,disIntvs_trialwise] = M_intervals_TarDis(ntrials,ncycle,nIntv,syncVTar(:,b));
    intervals.tarIntvs_cyclewise = tarIntvs_cyclewise;
    intervals.tarIntvs_trialwise = tarIntvs_trialwise;
    intervals.fIntvs_trialwise = fIntvs_trialwise;
    intervals.fIntvs_cyclewise = fIntvs_cyclewise;
    intervals.fflipIntv = fflipIntv ;
    intervals.disIntvs_trialwise = disIntvs_trialwise;
    S(b).intervals = intervals;
        
    if strcmp(paradigm,'Vselect_AsyncTarDis')     
        [XY,tarCenterXY,tarHemi,testcircle,discircle] = M_coordinate(V.Rroute,V.Lbar,V.xpixels,V.ypixels,V.tilt,vpresent,ntrials,nItem,tarLocs(:,b),tarOri,paradigm,disLocs(:,b));
    
        coordinate.XY = XY; % -XY {2,nitems*2,ntrial}
        coordinate.tarCenterXY = tarCenterXY; % (2,ntrial), 1st row target x, 2nd row target y
        coordinate.tarHemi = tarHemi; % - target hemisphere, (ntrial,1), 1-r,0-l
        coordinate.testcircle = testcircle;
        coordinate.discircle = discircle;
        S(b).coordinate = coordinate;
    else
        [XY,tarCenterXY,tarHemi,testcircle] = M_coordinate_0(V.Rroute,V.Lbar,V.xpixels,V.ypixels,V.tilt,vpresent,ntrials,nItem,tarLocs(:,b),tarOri,paradigm);
        coordinate.XY = XY; % -XY {2,nitems*2,ntrial}
        coordinate.tarCenterXY = tarCenterXY; % (2,ntrial), 1st row target x, 2nd row target y
        coordinate.tarHemi = tarHemi; % - target hemisphere, (ntrial,1), 1-r,0-l
        coordinate.testcircle = testcircle;
        S(b).coordinate = coordinate;
    end
        %     % ---------------- color ---------
       % 
       
    if strcmp(paradigm,'Vselect_AsyncTarDis')    
    [clr_cyclewise,clr_trialwise, clrCodes_trialwise] = M_color_syncDis(tarLocs(:,b),disLocs(:,b),tarIntvs_trialwise,disIntvs_trialwise,ntrials,ncycle,nIntv,nItem,nItemsChg,clr1,clr2,syncVTar(:,b));
    else
    [clr_cyclewise,clr_trialwise, clrCodes_trialwise] = M_color_0(tarLocs(:,b),tarIntvs_trialwise,ntrials,ncycle,nIntv,nItem,nItemChange,...
        clr1,clr2,vpresent);
    end
    color.clr_trialwise = clr_trialwise;
    color.clrCodes_trialwise = clrCodes_trialwise;
    color.clr_cyclewise = clr_cyclewise;
    S(b).color = color;
% ---------------- ---------------- sounds ---------------- ----------------
      if strcmp(paradigm,'Vselect_AsyncTarDis')  
            [soundCycle,sounds,figCycle,fig,bgCycle,bg,nchords_segtrial,coh_comp,BG_comp] = M_sounds_syncVTarDisCatch(ntrials,ncycle,A,apresent,coh,nbg_levels,tarIntvs_trialwise,disIntvs_trialwise,fIntvs_trialwise,syncVTar(:,b));
        
       else 
            [soundCycle,sounds,figCycle,fig,bgCycle,bg,nchords_segtrial,coh_comp,BG_comp] = M_sounds_Tekirandbg(ntrials,ncycle,A,apresent,coh,nbg_levels,tarIntvs_trialwise,fIntvs_trialwise);
       end
       Sounds.sounds = sounds;
        Sounds.soundCycle = soundCycle;
        Sounds.fig = fig;
        Sounds.figCycle = figCycle;
        Sounds.bg = bg;
        Sounds.bgCycle = bgCycle;
        Sounds.nchords_segtrial =nchords_segtrial;
        Sounds.coh_comp = coh_comp;
        Sounds.BG_comp = BG_comp;
        S(b).Sounds = Sounds; 

end
Tr.monitor = monitor;
Tr.paradigm = paradigm;   
Tr.nblocks = nblocks;
Tr.blockRep = blockRep;
Tr.ntrials= ntrials;
Tr.condRep = condRep;
Tr.ncycle = ncycle;
Tr.nIntv = nIntv ;
Tr.tarLocs = tarLocs;
Tr.disLocs = disLocs;
    
Tr.tarOris = tarOris;
Tr.nItems = nItems;
% Tr.tcycle = (A.dur_chord+A.dur_chord*2+A.dur_chord*3)*3;
Tr.t_preTpost = answer.t_preTpost;
Tr.inputAns = answer;
Tr.Apresent = Apresent;
Tr.Coh = Coh;
Tr.bgTYpe =bgType;
Tr.condsTable = condsTable;
Tr.trOrd = trOrd;
Tr.Vpresent = Vpresent;
Tr.coh_levels = coh_levels;
Tr.nItem_levels = nItem_levels;
Tr.syncVTar = syncVTar;
Tr.pC = answer.pC;
savedir = fileparts(savefile);
if ~exist(savedir)
    mkdir(savedir)
end
delete(savefile);
save(savefile,'Tr','A','V','S','-v7.3');
% 
