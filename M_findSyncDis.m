
function [disIntv,disLocs,disNtime] = M_findSyncDis(ntrials,nItems,tarLocs,clrCodes_trialwise)
%% check function
% ntrials = Tr.ntrials;
% nItems = Tr.nItems(:,1);
% tarLocs = Tr.tarLocs(:,1);
% clrCodes_trialwise = S(1).color.clrCodes_trialwise;
%%
disLocs = nan(ntrials,1);
disIntv = {};
for j = 1:ntrials
%     j = 1;
    disLocs(j) = randi(nItems(j));
    while disLocs == tarLocs(j)
    disLocs(j) = randi(nItems(j));
    end

    clrCodes_allItems = clrCodes_trialwise{j}; % (nIntv*ncycle,n)
    clrCodes = clrCodes_allItems(:,disLocs(j));

    disIntv(j) = {find(diff(clrCodes)~=0) + 1};
    disNtime(j) = length(disIntv(j));
    
    while disNtime 
end
