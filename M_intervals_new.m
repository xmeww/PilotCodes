
function [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,firstchg,tarDur] = M_intervals_new(ntrials,ncycle,nIntv)
% ntrials =2;
% ncycle = 10;
% nIntv = 9;

fIntvs_cyclewise = nan(ncycle,nIntv,ntrials);
firstchg = nan(ntrials,1);
tarDur = nan(ntrials,ncycle);
tarIntvs_trialwise = nan(ntrials,ncycle);
for j = 1:ntrials
%     j=1;
    for c = 1: ncycle

%         c = 2;
        tarIntv = randi([2,nIntv]);
        fIntvs_cyclewise(c,tarIntv-1,j) = 6 + (9-6)*(rand()>.5);
        fIntvs_cyclewise(c,tarIntv,j) = 9;%6 + (9-6)*(rand()>.5);
        restIntv = [3*ones(1,3) 6*ones(1,3) 9*ones(1,3)];
        restIntv(find(restIntv == fIntvs_cyclewise(c,tarIntv-1,j),1))=[];
        restIntv(find(restIntv == fIntvs_cyclewise(c,tarIntv,j),1))=[];
        restInd = randperm(length(restIntv)); %randermized 7 integral index
        restIntv = restIntv(restInd);
        fIntvs_cyclewise(c,1:tarIntv-2,j) = restIntv(1:tarIntv-2);
        fIntvs_cyclewise(c,tarIntv+1:end,j) = restIntv(tarIntv-1:end);
        tarIntvs_cyclewise(j,c) = tarIntv;
        
    end
    first = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));

    while first < 30
        
        tarIntv = randi([2,nIntv]);
        fIntvs_cyclewise(1,tarIntv-1,j) = 6 + (9-6)*(rand()>.5);
        fIntvs_cyclewise(1,tarIntv,j) = 6 + (9-6)*(rand()>.5);
        restIntv = [3*ones(1,3) 6*ones(1,3) 9*ones(1,3)];
        restIntv(find(restIntv == fIntvs_cyclewise(1,tarIntv-1,j),1))=[];
        restIntv(find(restIntv == fIntvs_cyclewise(1,tarIntv,j),1))=[];
        restInd = randperm(length(restIntv)); %randermized 7 integral index
        restIntv = restIntv(restInd);
        fIntvs_cyclewise(1,1:tarIntv-2,j) = restIntv(1:tarIntv-2);
        fIntvs_cyclewise(1,tarIntv+1:end,j) = restIntv(tarIntv-1:end);
        tarIntvs_cyclewise(j,1) = tarIntv;
        first = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));
    end
    tarDur(j,c) =  fIntvs_cyclewise(c,tarIntv,j);
    firstchg(j) = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));
    for c= 1:ncycle
        tarIntvs_trialwise(j,c) = tarIntvs_cyclewise(j,c) +(c-1)*9;
    % column: 1-9,10-18,19-27,28-36,37-45,46-54,55-63,64-72,73-81,82-90
    % tar:    2-8,11-17,18-26,29-35,38-44,47-55,56-64,65-71,74-80,81-89
    end
    %tIntvs_cyclewise = nan(ncycle,nIntv,ntrial);
    fflipIntv = zeros(ntrials,nIntv*ncycle+1);
    fIntvs_trialwise = reshape(permute(fIntvs_cyclewise,[2,1,3]),[nIntv*ncycle,ntrials,1]); % [ncycle nintv ntrial] -> [nintv ncycle ntrial] -> [nintv*ncycle ntrial]
    fIntvs_trialwise =fIntvs_trialwise'; % -> [6 90] intervals each trial
    fflipIntv(:,2:end) = fIntvs_trialwise;
    fflipIntv(:,1) = 60;
end