function [ntrials,tarOris,Vpresent,Apresent,Coh,condTable,nblocks] = M_cond_Aselect01_Vsingle01(condRep,trOrd,coh_levels,blockRep)
rng('shuffle');

% nIntv = 9;


% nitemChg_type = answer.nitemChg_type;
% nitemChg_type = reshape(nitemChg_type,3,3)';
% ncycle = answer.ncycle
% condRep = answer.condRep
% trOrd = answer.trOrd
% nItem_type = answer.nItem_type
% coh_type = answer.coh_type
% nblocks = answer.nblocks

% ncycle = 10;
% nitemChg_type = [1,2,3;1,3,4;1,4,5];
% condRep = 3;
% trOrd = 1-1;
% nItem_levels = [16 20 24];
% coh_levels = [2 4 6];
% nblocks = 2;

Vpres_type = [0;1];
Apres_type = [1;0];
tarOri_type = [0;1];

block_design = fullfact(length(Vpres_type));
block_design = repmat(block_design,blockRep,1);
indx = randperm(length(block_design));
block_design = block_design(indx,:);

nblocks = length(block_design);
for b = 1:nblocks 
    [Apresent(:,b),Coh(:,b)] = BalanceFactors(condRep,trOrd,Apres_type,coh_levels);
    
end

condTable =table(reshape(Apresent,[],1),reshape(Coh,[],1),'VariableNames',{'Atar_present','coh'});
ntrials = size(Apresent,1);% height(cond);
Vpresent = repmat(block_design'-1,ntrials,1);
condTable.Vpresent = reshape(Vpresent,[],1);
% for i = 1:length(nItem_type)
%     nitem = nItem_type(i);
%     randAll = randperm(floor(ntrials/nitem)*nitem)';
%     randRemain = randsample(nitem,mod(ntrials,nitem),false);
%      [randAll ;randRemain];
% end
tarOris = randi([0,1],size(Coh));
% for b = 1:nblocks; [tarOris(:,b)] = BalanceFactors(ntrials/length(tarOri_type),1,tarOri_type); end
% end
    
    

