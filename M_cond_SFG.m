function [ntrials,AVasync,figOnly,figPresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = M_cond_SFG(condRep,trOrd,nItem_levels,coh_levels,AVsync_levels)
%% check func
% condRep = 48*2;% 24*2;
% trOrd = 1; % 1 order, 0 random
% nItem_levels = [12,16];
% coh_levels = [6,10];
% AVsync_levels = [0,50,150,-50,-150]./50;

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
nconds = length(nItem_levels)*length(coh_levels)*length(AVsync_levels)+length(nItem_levels);  
nfig = 4;
%%
rep1 = condRep/(length(tarOri_type)*tarLoc_level(1)); % 4*12 = 48
rep2 = condRep/(length(tarOri_type)*tarLoc_level(2)); % 3*16

[nitem1,coh1,avsync1,tarOris1, tarLocs1] = BalanceFactors(rep1,0,nItem_levels(1),coh_levels,...
    AVsync_levels,tarOri_type,1:tarLoc_level(1));

[nitem2,coh2,avsync2,tarOris2, tarLocs2] = BalanceFactors(rep2,0,nItem_levels(2),coh_levels,...
    AVsync_levels,tarOri_type,1:tarLoc_level(2));
% additional 
[nitem3,coh3,avsync3,tarOris3, tarLocs3] = BalanceFactors(rep1,0,nItem_levels(1),0,nan,tarOri_type,1:tarLoc_level(1));
[nitem4,coh4,avsync4,tarOris4, tarLocs4] = BalanceFactors(rep2,0,nItem_levels(2),0,nan,tarOri_type,1:tarLoc_level(2));


figOnly_ord = [zeros(size([nitem1;nitem2]));zeros(size([nitem3;nitem4]))];
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
%% 
L = [length(nitem1),length(nitem2)];
rep = [rep1 rep2];
fgth = [];%nan(nconds-2,length(fig_ord));

for i = 1:length(rep)
    fig_ord = repelem(1:nfig,L(i)/(rep(i)*2)/length(AVsync_levels)/nfig);

    for n = 1:length(AVsync_levels)*rep(i)*2
        fgth = [fgth; fig_ord(randperm(length(fig_ord)))'];
    end

end


fgth = [fgth;zeros(size([nitem3;nitem4]))];

balTable_ord = array2table([cat(1,[tarOris1, tarLocs1],[tarOris2, tarLocs2],...
    [tarOris3, tarLocs3],[tarOris4, tarLocs4]),fgth],...
'VariableNames',{'tarOris','tarLocs','FGth'});

condTable = condTable_ord(trOrdInd,:);
balTable = balTable_ord(trOrdInd,:);

[nItems,Coh,AVasync,figPresent,figOnly] = matsplit(table2array(condTable),1);
[tarOris,tarLocs,FGth] = matsplit(table2array(balTable),1);


% writetable(cheatT,'cheatTable.xlsx','sheet','SFG')
