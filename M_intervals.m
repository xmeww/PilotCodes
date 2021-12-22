%% input
% ntrial,ncycle,nIntv 
%% temporal 
% output 
% ��tarIntv��(ntrial,ncycle),target changes color at ith cicle
% ��tarIntv_trialwise��(ntrial,ncycle*nIntv), target changes color at ith interval
% |=> input for color.mat
% (out of nintvs(9)*ncycle(10) intervals) in each trial 
% ��tIntvs_cyclewise��(ncycle,nIntv,ntrial)
% ��tIntvs_trialwise��(ntrial,nIntv*ncycle), duration of each interval, conform to
% termoral organisation described in Burg,2009
% ��tflipIntv��(ntrial,nIntv*ncycle+1), time interval after last flip time, reshape tIntvs into
% ntrial,ncycle*nintiv, insert 1st column of 1s fixation time
% |=> input for 'Flip',[,when]

%% temporal change of in intervals 
% The displays changed continuously in randomly generated cycles of nine intervals each. 
% The length of each interval varied randomly among 50, 100, or 150 ms, 
% with the constraint that all intervals occurred equally often within each cycle and that 
% the target change was always preceded by a 150-ms interval and followed by a 100-ms interval.
% At the start of each interval, a randomly determined number of search items changed color 
% (from red to green or vice versa), within the following constraints: When set size was 24, 
% the number of items that changed was 1, 2, or 3. When set size was 36, 1, 3, or 5 items changed, 
% and when it was 48, 1, 4, or 7 items changed. 
% Furthermore, the target always changed alone and could change only once per cycle, 
% so that the average frequency was 1.11 Hz. 
% The target could not change during the first 500 ms of the very first cycle of each trial. 
% For each trial, 10 different cycles were generated, which were then repeated after the 10th cycle 
% if the participant had not yet responded.
function [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,firstchg,tarDur] = M_intervals(ntrial,ncycle,nIntv,t_preTarpost)
% ntrial =1;
% ncycle = 10;
% nIntv = 9;
% t_preTarpost= [6 0 9];
% 'tarIntvs_trialwise','tIntvs_trialwise','tflipIntv' -> sound
% tarIntvs_trialwise -> color
% 'tflipIntv','tarIntvs_trialwise' -> present
%  clear all
fIntvs_cyclewise = nan(ncycle,nIntv,ntrial);
firstchg = nan(ntrial,1);
tarDur = nan(ntrial,ncycle);
% AcycIntv = nan(ntrial,ncycle);
for j = 1:ntrial
    for c = 1: ncycle
%         j = 1; 
%         c = 1;
        tarIntv = randi([2,8]);
        restIntv = [3*ones(1,3) 6*ones(1,3) 9*ones(1,3)];
        restIntv(find(restIntv == t_preTarpost(1),1))=[];
        restIntv(find(restIntv == t_preTarpost(2),1))=[];
        restIntv(find(restIntv == t_preTarpost(3),1))=[];

        fIntvs_cyclewise(c,tarIntv-1,j) = t_preTarpost(1);
        fIntvs_cyclewise(c,tarIntv+1,j) = t_preTarpost(3);
        restInd = randperm(length(restIntv)); %randermized 7 integral index
        restIntv = restIntv(restInd);
        fIntvs_cyclewise(c,1:tarIntv-2,j) = restIntv(1:tarIntv-2);
        if t_preTarpost(2) == 0
           fIntvs_cyclewise(c,tarIntv,j) = restIntv(tarIntv-1); 
           
           fIntvs_cyclewise(c,tarIntv+2:end,j) = restIntv(tarIntv:end);
        else
           fIntvs_cyclewise(c,tarIntv,j) = t_preTarpost(2); 
           fIntvs_cyclewise(c,tarIntv+2:end,j) = restIntv(tarIntv-1:end);
        end
        tarIntvs_cyclewise(j,c) = tarIntv;
        tarDur(j,c) =  fIntvs_cyclewise(c,tarIntv,j);
    end
    % check duration of 1st cicle of each trial
    % The target could not change during the first 500 ms of the very first cycle of each trial. 
    first = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));
%     while ~( 20 < first && first < 30)
    while first < 30
        % if ,0.5, repeat above steps all over again but just for 1st circle 
        tarIntv = randi([2,8]);
        restIntv = [3*ones(1,3) 6*ones(1,3) 9*ones(1,3)];
        restIntv(find(restIntv == t_preTarpost(1),1))=[];
        restIntv(find(restIntv == t_preTarpost(2),1))=[];
        restIntv(find(restIntv == t_preTarpost(3),1))=[];
        fIntvs_cyclewise(1,tarIntv-1,j) = t_preTarpost(1);
        fIntvs_cyclewise(1,tarIntv+1,j) = t_preTarpost(3);
        restInd = randperm(length(restIntv)); %randermized 7 integral index
        restIntv = restIntv(restInd);
        fIntvs_cyclewise(1,1:tarIntv-2,j) = restIntv(1:tarIntv-2);
        if t_preTarpost(2) == 0
           fIntvs_cyclewise(1,tarIntv,j) = restIntv(tarIntv-1); 
           fIntvs_cyclewise(1,tarIntv+2:end,j) = restIntv(tarIntv:end);
        else
           fIntvs_cyclewise(1,tarIntv,j) = t_preTarpost(2); 
           fIntvs_cyclewise(1,tarIntv+2:end,j) = restIntv(tarIntv-1:end);
        end
        tarIntvs_cyclewise(j,1) = tarIntv;
        first = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));
    end
    firstchg(j) = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));
    %AcycIntv(j,:) =;
end

% target changes color at ith interval(out of nintvs(9)*ncycle(10) intervals) in each trial 
for c= 1:ncycle
    tarIntvs_trialwise(:,c) = tarIntvs_cyclewise(:,c) +(c-1)*9;
    % column: 1-9,10-18,19-27,28-36,37-45,46-54,55-63,64-72,73-81,82-90
    % tar:    2-8,11-17,18-26,29-35,38-44,47-55,56-64,65-71,74-80,81-89
end
%tIntvs_cyclewise = nan(ncycle,nIntv,ntrial);
fflipIntv = zeros(ntrial,nIntv*ncycle+1);
fIntvs_trialwise = reshape(permute(fIntvs_cyclewise,[2,1,3]),[nIntv*ncycle,ntrial,1]); % [ncycle nintv ntrial] -> [nintv ncycle ntrial] -> [nintv*ncycle ntrial]
fIntvs_trialwise =fIntvs_trialwise'; % -> [6 90] intervals each trial
fflipIntv(:,2:end) = fIntvs_trialwise;
fflipIntv(:,1) = 60; % fixation 1s
% save tarIntvs_trialwise.mat tarIntvs_trialwise
% save tIntvs.mat tIntvs
% save tflipIntv.mat tflipIntv

% save('workingdir/intervals.mat','tarIntvs_trialwise','tIntvs_cyclewise','tIntvs_trialwise','tflipIntv')
% m_intervals.tarIntvs_trialwise = tarIntvs_trialwise;
% m_intervals.tIntvs_trialwise = tIntvs_trialwise;
% m_intervals.tIntvs_cyclewise = tIntvs_cyclewise;
% m_intervals.tflipIntv = tflipIntv ;
end