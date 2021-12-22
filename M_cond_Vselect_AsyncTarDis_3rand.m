function [ntrials,nblocks,syncVTar,Vpresent,nItems,Apresent,Coh,tarOris,tarLocs,disLocs,nItemsChg,condsTable] = M_cond_Vselect_AsyncTarDis_3rand(nIntv,ncycle,nitemChg_type,condRep,trOrd,nItem_levels,coh_levels,blockRep,pC)
rng('shuffle');
%% function check 
% nIntv = 9;
% ncycle = 10;
% nitemChg_type = [1,2,3;1,2,3;1,2,3];
% condRep = 56;
% trOrd = 1-1;
% nItem_levels = [8 12];
% coh_levels = [6 10];
% blockRep = 1;
% pC = 14;
%% 
syncVTar_type = [1;-1]; % 1 syncTar 0 sync dis
Vpres_type = [1;0];
Apres_type = [1;0];
tarOri_type = [0;1];
nblocks = blockRep;

ncond = length(coh_levels)*length(nItem_levels)*length(syncVTar_type);

nT = round(condRep*(1-pC/100));
nC = ceil(condRep*pC/100);

[Coh_1,nItems_1,syncVTar_1,tarOris_1] = BalanceFactors(condRep/2,0,coh_levels,nItem_levels,syncVTar_type,tarOri_type);
Vpresent_1 = [ones(ncond*nT,1);zeros(ncond*nC,1)];
Apresent_1 = ones(condRep*ncond,1);
tarOris_1(find(Vpresent_1 == 0)) = nan;
syncVTar_1(find(Apresent_1 == 0)) = nan;
syncVTar_1(find(Vpresent_1 == 0 & syncVTar_1 == 1)) = 0;
% tarOris_1 = repmat([1;0],condRep*ncond/2,1);


nItems_2 = [nItem_levels(1)*ones(condRep,1);nItem_levels(2)*ones(condRep,1)];
Coh_2 = zeros(condRep*2,1);
syncVTar_2 = nan(condRep*2,1); % no coh 
Vpresent_2 = repmat([ones(nT,1);zeros(nC,1)],2,1);
Apresent_2 = zeros(condRep*2,1);
tarOris_2 = repmat([1;0],(condRep/2)*2,1);
tarOris_2(find(Vpresent_2 == 0)) = nan;
syncVTar_2(find(Apresent_2 == 0)) = nan;
syncVTar_2(find(Vpresent_2 == 0 & syncVTar_2 == 1)) = 0;



cond_Apre = [Coh_1,nItems_1,syncVTar_1,tarOris_1,Vpresent_1,Apresent_1];
cond_Aabs = [Coh_2,nItems_2,syncVTar_2,tarOris_2,Vpresent_2,Apresent_2];
    
% nItems = [nItems_1;nItems_2];
% Coh = [Coh_1;Coh_2];
% syncVTar = [syncVTar_1;syncVTar_2];
% Vpresent = [Vpresent_1;Vpresent_2];
% tarOris = [tarOris_1;tarOris_2];
% Apresent = [Apresent_1;Apresent_2];


cond = [cond_Apre;cond_Aabs];
for b = 1:nblocks
    if trOrd == 0
        conds = cond;
    elseif trOrd == 1
        ind = randperm(length(cond));
        conds = cond(ind,:);
    end
    [Coh(:,b),nItems(:,b),syncVTar(:,b),tarOris(:,b),Vpresent(:,b),Apresent(:,b)] = matsplit(conds,1);
    condsTable(b) = {table(conds(:,1),conds(:,2),conds(:,3),conds(:,4),conds(:,5),conds(:,6),'VariableNames',{'Coh','nItems','syncVTar','tarOris','Vpresent','Apresent'})};
end
ntrials = length(cond);% height(cond);
% condTable =table(cond,'VariableNames',{'nItems','Coh','tarOris','Vpresent','Apresent'});



% for i = 1:length(nItem_type)
%     nitem = nItem_type(i);
%     randAll = randperm(floor(ntrials/nitem)*nitem)';
%     randRemain = randsample(nitem,mod(ntrials,nitem),false);
%      [randAll ;randRemain];
% end
% tarOris = randi([0,1],size(Coh));
while 1 
    tarLocs = nan(ntrials,nblocks);
    disLocs =  nan(ntrials,nblocks);
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
    for b = 1:nblocks
        for i = 1:length(nItem_levels)
            nitem = nItem_levels(i);
           
            nInd = find(nItems(:,b) == nitem);
            for n = 1:length(nInd)
                l = 1:nitem;
               
                l(tarLocs(nInd(n),b))=[];
                ind = randperm(nitem-1);
                l = l(ind);
               
                disLocs(nInd(n),b) = l(5);
                
            end
        end
    end
    d = diff([reshape(tarLocs,[],1) reshape(disLocs,[],1)],1,2);
 if length(find(abs(d) ==1)) < 90
    break
 end
end
        

        % for i = 1:length(nItem_type)
        %     subplot(1,length(nItem_type),i)
        %     nitem = nItem_type(i);
        %     histogram(tarLocs(find((nItems== nitem))))
        % end

         %Target orientation was balanced and randomly mixed within blocks of ntrials each
    
%     for b = 1:nblocks
%         for i = 1:length(nItem_levels)
%     %         b =1;
%     %         i =1;
%             nitem = nItem_levels(i);
%             n = length(find(nItems(:,b) == nitem));
%             randInt = arrayfun(@(x)randperm(nitem),(1:floor(n/nitem))','UniformOutput',0);
%             randRemain = randsample(nitem,mod(n,nitem),false);
%             disLocs(find((nItems(:,b)== nitem)),b) =  [[randInt{:}]' ;randRemain];
%         end
%     
%     end
%     display('calced')
%     sum(diff([reshape(tarLocs,[],1) reshape(disLocs,[],1)],1,2))
%      if all(diff([reshape(tarLocs,[],1) reshape(disLocs,[],1)],1,2) ~= 0)
%          break
%      end
     
% end
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
    
    

