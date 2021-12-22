function [ntrials,nblocks,Vpresent,Apresent,Coh,nItems,condTable,tarOris,tarLocs,nItemsChg,syncVTar] = M_cond_Vselect1_singleA01(blockRep,condRep,trOrd,nItem_levels,coh_levels,nIntv,ncycle,nitemChg_type)
rng('shuffle');
%% function check
% blockRep = 2;
% nItem_levels = [14 16 20 ];
% coh_levels = [2 4 6];
% condRep = 3;
% trOrd =1;
% nIntv = 9;
% ncycle =10;
% nitemChg_type = [1,2,3;1,3,4;1,4,5];

%%
Vpres_type = [1];
Apres_type = [1;0];
tarOri_type = [0;1];
syncVTar_type = [1];
% block 
block_design = fullfact(length(Apres_type));
block_design = repmat(block_design,blockRep,1);
indx = randperm(length(block_design));
block_design = block_design(indx,:)';

nblocks = length(block_design);
for b = 1:nblocks 
    [nItems(:,b),Coh(:,b),tarOris(:,b),syncVTar(:,b)] = BalanceFactors(condRep,trOrd,nItem_levels,coh_levels,tarOri_type,syncVTar_type);    
end


ntrials = size(Coh,1);% height(cond);
Apresent = repmat(block_design-1,ntrials,1);
Vpresent = ones(size(Apresent));
condTable =table(reshape(nItems,[],1),reshape(Coh,[],1),reshape(Apresent,[],1),reshape(Vpresent,[],1),'VariableNames',{'nItems','coh','Atar_present','Vtar_present'});


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


% %% trial dedign
% 
% nblocks = blockRep;
% for b = 1:nblocks
%     [nItems(:,b),Apresent(:,b),Coh(:,b)] = BalanceFactors(condRep,trOrd,nItem_levels,Apres_type,coh_levels);
%     
% end
% Vpresent = ones(size(nItems));
% ntrials = size(nItems,1);% height(cond);
% condTable =table(reshape(Vpresent,[],1),reshape(nItems,[],1),reshape(Apresent,[],1),reshape(Coh,[],1),'VariableNames',{'Vtar_present','nItems','Atar_present','coh'});

%%
% for b = 1:nblocks; [tarOris(:,b)] = BalanceFactors(ntrials/length(tarOri_type),1,tarOri_type); end
% tarOris = randi([0,1],size(Coh));
% tarOris = zeros(size(Coh));
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
    

    
    

