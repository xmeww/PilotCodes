function [ntrials,AVasync,figOnly,figPresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = M_cond_SFGfigOnly(rep1,rep2,trOrd,nItem_levels,coh_levels,AVsync_levels)
%% check func
% condRep = 48*2;% 24*2;
% trOrd = 1; % 1 order, 0 random
% nItem_levels = [12,16];
% coh_levels = [10];
% Apresent_levels = [1,0];
% rep1 = 4;
% rep2 = 3;
% AVsync_levels = [0];

% 2x2x5 + 2
% 2 coh levels
% 2 nitem levels
% 5 AV (Vtar-Afig) temporal relationship: 
%   level            | code
%   sync             |  0
%   50ms Vleanding   |  1
%   150ms Vleanding  |  3
%   50ms Aleanding   |  -1
%   150ms Aleanding  |  -3
%   no Afig,BG only  |  nan
% 2 V_Tar_Dis+A_Dis levels, 2 V nitem
%% built in 
tarOri_type = [0,1];
tarLoc_level = nItem_levels;

%% 
% nconds = length(nItem_levels)*length(Apresent_levels);  
nfig = 4;

% tar   locs
% 0     1-12
% 1     1-12

% 0     1-12
% 1     1-12

% 0     1-12
% 1     1-12

% 0     1-12
% 1     1-12

% 0     1-16
% 1     1-16
% 3 times each tar ori (totally  6 times 1-16)

[nitem1,coh1,avsync1,tarOris1, tarLocs1] = BalanceFactors(rep1,0,nItem_levels(1),coh_levels,...
    AVsync_levels,tarOri_type,1:tarLoc_level(1));

[nitem2,coh2,avsync2,tarOris2, tarLocs2] = BalanceFactors(rep2,0,nItem_levels(2),coh_levels,...
    AVsync_levels,tarOri_type,1:tarLoc_level(2));
% additional, figrure present =0
[nitem3,coh3,avsync3,tarOris3, tarLocs3] = BalanceFactors(rep1,0,nItem_levels(1),nan,nan,tarOri_type,1:tarLoc_level(1));
[nitem4,coh4,avsync4,tarOris4, tarLocs4] = BalanceFactors(rep2,0,nItem_levels(2),nan,nan,tarOri_type,1:tarLoc_level(2));

figOnly_ord = [ones(size([nitem1;nitem2]));zeros(size([nitem3;nitem4]))];
figpresent_ord = [ones(size([nitem1;nitem2]));zeros(size([nitem3;nitem4]))];


%%
condTable_ord = array2table([cat(1,[nitem1,coh1,avsync1],[nitem2,coh2,avsync2],...
    [nitem3,coh3,avsync3],[nitem4,coh4,avsync4]),figpresent_ord,figOnly_ord],...
    'VariableNames',{'nItems','Coh','AVasync','figPresent','figOnly'});

ntrials = height(condTable_ord);
if trOrd == 1
    trOrdInd = 1:ntrials;
else 
    trOrdInd = randperm(ntrials);
end

%% assign 4 figures to 96 trials randomly for each condition(2 nitem levels)
% tar   locs  fgth
% 0     1-12  1-4 rand
% 1     1-12  1-4 rand
% 4 times
% 0     1-16  1-4 rand
% 1     1-16  1-4 rand
% 3 times
rep = [rep1 rep2];
fgth = [];
for i = 1:length(tarLoc_level)
    n =1;
    fgth_order = repelem(1:nfig,tarLoc_level(i)/nfig);
    while n<rep(i)*length(tarOri_type)+1
        
        fgth= [fgth; fgth_order(randperm(length(fgth_order)))'];
        n = n+1;
    end
%     length(fgth)
end

fgth = [fgth;zeros(size([nitem3;nitem4]))];

balTable_ord = array2table([cat(1,[tarOris1, tarLocs1],[tarOris2, tarLocs2],...
[tarOris3, tarLocs3],[tarOris4, tarLocs4]),fgth],...
'VariableNames',{'tarOris','tarLocs','FGth'});
% check 
% [condTable_ord balTable_ord]
condTable = condTable_ord(trOrdInd,:);
balTable = balTable_ord(trOrdInd,:);

[nItems,Coh,AVasync,figPresent,figOnly] = matsplit(table2array(condTable),1);
[tarOris,tarLocs,FGth] = matsplit(table2array(balTable),1);


