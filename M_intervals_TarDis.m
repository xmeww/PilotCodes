
function [tarIntvs_cyclewise,tarIntvs_trialwise,fIntvs_trialwise,fIntvs_cyclewise,fflipIntv,disIntvs_trialwise] = M_intervals_TarDis(ntrials,ncycle,nIntv,syncVTar)

%%   check function 
% ntrials =4;
% ncycle = 10;
% nIntv = 9;
% syncVTar = [1 0 -1 nan]';
%%



fIntvs_cyclewise = nan(ncycle,nIntv,ntrials);
firstTarChg = nan(ntrials,1);
tarDur = nan(ntrials,ncycle);
disDur = nan(ntrials,ncycle);
tarIntvs_trialwise = nan(ntrials,ncycle);
disIntvs_trialwise = nan(ntrials,ncycle);

for j = 1:ntrials
%      j =2
    if syncVTar(j) == 0  % sync nothing,no v target, has special dis timing, not sync dis
        for c = 1: ncycle
%             c = 1;
            while 1

                disIntv = randi([2,nIntv]);



                fIntvs_cyclewise(c,disIntv-1,j) = 6 + (9-6)*(rand()>.5);
                fIntvs_cyclewise(c,disIntv,j) = 9;%6 + (9-6)*(rand()>.5);

                restIntv = [3*ones(1,3) 6*ones(1,3) 9*ones(1,2)];
                restIntv(find(restIntv == fIntvs_cyclewise(c,disIntv-1,j),1))=[];
                

                restInd = randperm(length(restIntv)); %randermized 7 integral index
                restIntv = restIntv(restInd);
                fIntvs_cyclewise(c,find(isnan(fIntvs_cyclewise(c,:,j))),j) = restIntv;
                disIntvs_cyclewise(j,c) = disIntv;   
                firstDisDur = sum(fIntvs_cyclewise(1,1:disIntvs_cyclewise(j,1)-1,j));


                    if firstDisDur >= 30
                        break
                    else
                        fIntvs_cyclewise(1,:,j) = nan(size(fIntvs_cyclewise(1,:,j)));
                    end

            end

        end

        

    elseif (syncVTar(j) == 1 || syncVTar(j) == -1 || isnan(syncVTar(j))) % sync with tar or dis, no matter, always 2 special timing lines
        % syncV(j)==nan ,no coh to sync, but two special still here 
                    
      
        for c = 1: ncycle
           
            while 1
                while 1
                    tarIntv = randi([2,nIntv]);
                    disIntv = randi([2,nIntv]);
                    if  (tarIntv ~= disIntv)
                        break
                    end
                end
                fIntvs_cyclewise(c,disIntv,j) = 9;%6 + (9-6)*(rand()>.5);
                fIntvs_cyclewise(c,tarIntv,j) = 9;%6 + (9-6)*(rand()>.5);
                restIntv = [3*ones(1,3) 6*ones(1,3) 9];
                
                
                if tarIntv - disIntv == -1 % tar - dis
                    fIntvs_cyclewise(c,tarIntv-1,j) = 6 + (9-6)*(rand()>.5);
                    restIntv(find(restIntv == fIntvs_cyclewise(c,tarIntv-1,j),1))=[];
                elseif disIntv - tarIntv == -1 % dis - tar
                    fIntvs_cyclewise(c,disIntv-1,j) = 6 + (9-6)*(rand()>.5);
                    restIntv(find(restIntv == fIntvs_cyclewise(c,disIntv-1,j),1))=[];
                else
                    while 1 
                    fIntvs_cyclewise(c,tarIntv-1,j) = 6 + (9-6)*(rand()>.5);
                    fIntvs_cyclewise(c,disIntv-1,j) = 6 + (9-6)*(rand()>.5);
                        if ~all([fIntvs_cyclewise(c,tarIntv-1,j),fIntvs_cyclewise(c,disIntv-1,j)]==9)
                            break
                        end
                    end
                    restIntv(find(restIntv == fIntvs_cyclewise(c,tarIntv-1,j),1))=[];
                    restIntv(find(restIntv == fIntvs_cyclewise(c,disIntv-1,j),1))=[];
                    
                end
              
                restInd = randperm(length(restIntv)); %randermized 7 integral index
                restIntv = restIntv(restInd);
                fIntvs_cyclewise(c,find(isnan(fIntvs_cyclewise(c,:,j))),j) = restIntv;
                tarIntvs_cyclewise(j,c) = tarIntv;   
                firstTarDur = sum(fIntvs_cyclewise(1,1:tarIntvs_cyclewise(j,1)-1,j));                           
                disIntvs_cyclewise(j,c) = disIntv;   
                firstDisDur = sum(fIntvs_cyclewise(1,1:disIntvs_cyclewise(j,1)-1,j));
                if (firstTarDur >= 30) && (firstDisDur >= 30)
                     break
                else
                    fIntvs_cyclewise(1,:,j) = nan(size(fIntvs_cyclewise(1,:,j)));
                end
            end
        end
      
       
   
         % column: 1-9,10-18,19-27,28-36,37-45,46-54,55-63,64-72,73-81,82-90
        % tar:    2-8,11-17,18-26,29-35,38-44,47-55,56-64,65-71,74-80,81-89
        
     

    end
    
    for c = 1:ncycle
        
        if syncVTar(j) == 0
            disIntvs_trialwise(j,c) = disIntvs_cyclewise(j,c) +(c-1)*9;
        else
            tarIntvs_trialwise(j,c) = tarIntvs_cyclewise(j,c) +(c-1)*9;
            disIntvs_trialwise(j,c) = disIntvs_cyclewise(j,c) +(c-1)*9;
        end
    end
    
    %tIntvs_cyclewise = nan(ncycle,nIntv,ntrial);
    fflipIntv = zeros(ntrials,nIntv*ncycle+1);
    fIntvs_trialwise = reshape(permute(fIntvs_cyclewise,[2,1,3]),[nIntv*ncycle,ntrials,1]); % [ncycle nintv ntrial] -> [nintv ncycle ntrial] -> [nintv*ncycle ntrial]
    fIntvs_trialwise =fIntvs_trialwise'; % -> [6 90] intervals each trial
    fflipIntv(:,2:end) = fIntvs_trialwise;
    fflipIntv(:,1) = 60;
end