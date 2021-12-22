function [ntrials,nblocks,syncVTar,Vpresent,nItems,Apresent,Coh,condTable,tarOris,tarLocs,disLocs,nItemsChg] = M_cond_Vselect_AsyncTarDis(nIntv,ncycle,nitemChg_type,condRep,trOrd,nItem_levels,coh_levels,blockRep)
rng('shuffle');
%% function check 
% nIntv = 9;
% ncycle = 10;
% nitemChg_type = [1,2,3;1,2,3;1,2,3];
% condRep = 3;
% trOrd = 1-1;
% nItem_levels = 8:4:16;
% coh_levels = [6 10];
% blockRep = 2;
%% 
syncVTar_type = [1;0]; % 1 syncTar 0 sync dis
Vpres_type = [1];
Apres_type = [1];
tarOri_type = [0;1];


block_design = fullfact(length(syncVTar_type));
block_design = repmat(block_design,blockRep,1);
indx = randperm(length(block_design));
block_design = block_design(indx,:)';

nblocks = length(block_design);

for b = 1:nblocks
    [Vpresent(:,b),nItems(:,b),Apresent(:,b),Coh(:,b),tarOris(:,b)] = BalanceFactors(condRep,trOrd,Vpres_type,nItem_levels,Apres_type,coh_levels,tarOri_type);
    
end

ntrials = size(nItems,1);% height(cond);
syncVTar = repmat(block_design-1,ntrials,1);
condTable =table(reshape(syncVTar,[],1),reshape(Vpresent,[],1),reshape(nItems,[],1),reshape(Apresent,[],1),reshape(Coh,[],1),'VariableNames',{'VsyncTar','Vtar_present','nItems','Atar_present','coh'});
% for i = 1:length(nItem_type)
%     nitem = nItem_type(i);
%     randAll = randperm(floor(ntrials/nitem)*nitem)';
%     randRemain = randsample(nitem,mod(ntrials,nitem),false);
%      [randAll ;randRemain];
% end
% tarOris = randi([0,1],size(Coh));
while 1 
    tarLocs = nan(size(tarOris));
    disLocs =  nan(size(tarOris));
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
    disLocs = nan(size(tarOris));
    for b = 1:nblocks

        for i = 1:length(nItem_levels)
    %         b =1;
    %         i =1;
            nitem = nItem_levels(i);
            n = length(find(nItems(:,b) == nitem));
            randInt = arrayfun(@(x)randperm(nitem),(1:floor(n/nitem))','UniformOutput',0);
            randRemain = randsample(nitem,mod(n,nitem),false);
            disLocs(find((nItems(:,b)== nitem)),b) =  [[randInt{:}]' ;randRemain];



        end
    %         [tarOris(:,b)] = BalanceFactors(ntrials/length(tarOri_type),1,tarOri_type); 
    end

     if any(diff([reshape(tarLocs,[],1) reshape(disLocs,[],1)],1,2) ~= 0) 
         break
     end
     
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
    
    

