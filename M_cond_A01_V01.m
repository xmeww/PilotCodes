function [ntrials,nblocks,Vpresent,nItems,Apresent,Coh,condTable,tarOris,tarLocs,nItemsChg] = M_cond_A01_V01(nIntv,ncycle,nitemChg_type,condRep,trOrd,nItem_levels,coh_levels,blockRep)
rng('shuffle');
%% function check 
% nIntv = 9;
% ncycle = 10;
% nitemChg_type = [1,2,3;1,3,4;1,4,5];
% condRep = 3;
% trOrd = 1-1;
% nItem_levels = [16 20 24];
% coh_levels = [2 4 6];
% blockRep = 2;
%% 
Vpres_type = [1;0];
Apres_type = [1;0];
tarOri_type = [0;1];
nblocks = blockRep;
for b = 1:nblocks
    [Vpresent(:,b),nItems(:,b),Apresent(:,b),Coh(:,b)] = BalanceFactors(condRep,trOrd,Vpres_type,nItem_levels,Apres_type,coh_levels);
    
end
condTable =table(reshape(Vpresent,[],1),reshape(nItems,[],1),reshape(Apresent,[],1),reshape(Coh,[],1),'VariableNames',{'Vtar_present','nItems','Atar_present','coh'});
ntrials = size(nItems,1);% height(cond);


% for i = 1:length(nItem_type)
%     nitem = nItem_type(i);
%     randAll = randperm(floor(ntrials/nitem)*nitem)';
%     randRemain = randsample(nitem,mod(ntrials,nitem),false);
%      [randAll ;randRemain];
% end
tarOris = randi([0,1],size(Coh));
tarLocs = nan(size(tarOris));
for b = 1:nblocks

    for i = 1:length(nItem_levels)
%         b =1;
%         i =1;
        nitem = nItem_levels(i);
        n = length(find(nItems(:,b) == nitem));
        randInt = arrayfun(@(x)randperm(nitem),(1:floor(n/nitem))','UniformOutput',0);
        randRemain = randsample(nitem,mod(n,nitem),false);
        tarLocs(find((nItems(:,b)== nitem)),b) =  [[randInt{:}]' ;randRemain];
       
      

    end
%         [tarOris(:,b)] = BalanceFactors(ntrials/length(tarOri_type),1,tarOri_type); 
end

    % for i = 1:length(nItem_type)
    %     subplot(1,length(nItem_type),i)
    %     nitem = nItem_type(i);
    %     histogram(tarLocs(find((nItems== nitem))))
    % end

     %Target orientation was balanced and randomly mixed within blocks of ntrials each


nItemsChg = nan(ntrials,nIntv*ncycle,nblocks); % (ntrial,Intv*ncycle,nblocks), number of items change at each interval in each trial
for b = 1:nblocks
    for i = 1:length(nItem_levels)
%         b =1;
%         i = 1;
        N = length(find((nItems(:,b)==nItem_levels(i))));
        mat=randsample(nitemChg_type(i,:),nIntv*ncycle*N,true);% without replication, otherwise error: 3< ntrial
        nItemsChg(find((nItems(:,b)==nItem_levels(i))),:,b) = reshape(mat,N,nIntv*ncycle);
    end
end
    
    

