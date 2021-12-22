function [ntrials,AVasync,Vpresent,Apresent,nItems,Coh,tarOris,tarLocs,condTable,balTable,FGth] = M_cond(condRep,trOrd,nItem_levels,coh_levels,AVsync_levels)
%% check func
% condRep = 48*2;% 24*2;
% trOrd = 0; % 1 order, 0 random
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
%% check numbers 

nItem_N = condRep*length(coh_levels)*(length(AVsync_levels)-1)*length(nItem_levels)...
    +condRep*length(nItem_levels);
coh_N = condRep*length(coh_levels)*(length(AVsync_levels)-1)*length(nItem_levels);
AVrel_N =  condRep*length(coh_levels)*length(nItem_levels)*(length(AVsync_levels)-1)...
    +condRep*length(nItem_levels);

%% 
    
[nitem1,coh1,avsync1,tarOris1, tarLocs1] = BalanceFactors(condRep/(length(tarOri_type)*tarLoc_level(1)),0,nItem_levels(1),coh_levels,...
    AVsync_levels,tarOri_type,1:tarLoc_level(1));

[nitem2,coh2,avsync2,tarOris2, tarLocs2] = BalanceFactors(condRep/(length(tarOri_type)*tarLoc_level(2)),0,nItem_levels(2),coh_levels,...
    AVsync_levels,tarOri_type,1:tarLoc_level(2));
% additional 
[nitem3,coh3,avsync3,tarOris3, tarLocs3] = BalanceFactors(condRep/(length(tarOri_type)*tarLoc_level(1)),0,nItem_levels(1),0,nan,tarOri_type,1:tarLoc_level(1));
[nitem4,coh4,avsync4,tarOris4, tarLocs4] = BalanceFactors(condRep/(length(tarOri_type)*tarLoc_level(2)),0,nItem_levels(2),0,nan,tarOri_type,1:tarLoc_level(2));


Vpresent_ord = ones(size([nitem1;nitem2;nitem3;nitem4]));
Apresent_ord = [ones(size([nitem1;nitem2]));zeros(size([nitem3;nitem4]))];

condTable_ord = array2table([cat(1,[nitem1,coh1,avsync1],[nitem2,coh2,avsync2],...
    [nitem3,coh3,avsync3],[nitem4,coh4,avsync4]),Apresent_ord,Vpresent_ord],...
    'VariableNames',{'nItems','Coh','AVasync','Apresent','Vpresent'});

balTable_ord = array2table(cat(1,[tarOris1, tarLocs1],[tarOris2, tarLocs2],...
[tarOris3, tarLocs3],[tarOris4, tarLocs4]),...
'VariableNames',{'tarOris','tarLocs'});




ntrials = height(condTable_ord);
if trOrd == 1
    trOrdInd = 1:ntrials;
else 
    trOrdInd = randperm(ntrials);
end

condTable = condTable_ord(trOrdInd,:);
balTable = balTable_ord(trOrdInd,:);

[nItems,Coh,AVasync,Apresent,Vpresent] = matsplit(table2array(condTable),1);
[tarOris,tarLocs] = matsplit(table2array(balTable),1);


FGth = repmat([1:4]',[ntrials/22/4,22]);
for i = 1:22
    FGth(:,i) = FGth(randperm(size(FGth,1)),i);
end
FGth = reshape(FGth,[],1);
%% draw 
%subplot(5,2,1)
% h(1) = histogram([nitem1;nitem2])
% title({['nitem:   ',num2str(h.Values)]})
% subplot(5,2,2)
% h(2) = histogram([nitem3;nitem4])
% title({['nitem:   ',num2str(h.Values)]})
% h = histogram([coh1;coh2])
% h.Values
% h = histogram([avsync1;avsync2])
% h.Values
% sum(h.Values)
% h = histogram([tarOris1;tarOris2])
% h.Values
% sum(h.Values)
% h = histogram([tarOris3;tarOris4])
% h.Values
% sum(h.Values)
% h1 = histogram(tarLocs1)
% figure
% h2 = histogram(tarLocs2)
% h1.Values
% h2.Values/2/5/2
% h1.Values/2/5/2
% sum(h1.Values,h2.Values)
% h1 = histogram(tarLocs3)
% figure
% h2 = histogram(tarLocs4)
% h1.Values
% h2.Values
% h1.Values/2
% h2.Values/2
% sum([h1.Values,h2.Values])
%%
