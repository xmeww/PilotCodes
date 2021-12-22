%% color
%% input 
% tarLoc, load('coordinate.mat.mat')
% nitemChglist, 
% tarIntvs_trialwise,load('intervals.mat'),target changes color at ith interval in a trial(nintv*ncycle)
% ntrial,ncycle,nIntv,nItem
% darkGr,lightGr 
%% OUTPUT
% -nItemsChg- (ntrial,nintv*ncycle) n items change color at each interval
% in each trial
% -clrCodes_cyclewise- {(nintv*ncycle,nItem)};
% -clrCodes_trialwise- ceil(1,ntrial); in case have conditions with different items
% -clr_cyclewise- (3,2*nitem,ncycle*nIntv)
% -clr_trialwise-  ceil(1,ntrial);in case have conditions with different items
% ----color for 'DrawLines'----
% "colors" is either a single global color argument for all lines, or an
% array of rgb or rgba color values for each line, where each column corresponds
% to the color of the corresponding line start or endpoint in the xy position
% argument. If you specify different colors for the start- and endpoint of a line
% segment, PTB will generate a smooth transition of colors along the line via
% linear interpolation. The default color is white if colors is omitted. "smooth"
% is a flag that determines whether lines should be smoothed: 0 (default) no
% smoothing, 1 smoothing (with anti-aliasing), 2 = high quality smoothing. If you
% use smoothing, you'll also need to set a proper blending mode with
% Screen('BlendFunction').
% color(3,nitem*2,nintv*ncycle,ntrial)
%
% ---- Burg 2009----
% At the start of each interval, a randomly determined number of search items changed color 
% (from red to green or vice versa), 
% within the following constraints: 
% When set size was 24, the number of items that changed was 1, 2, or 3. 
% When set size was 36, 1, 3, or 5 items changed, 
% and when it was 48, 1, 4, or 7 items changed. 
% Furthermore, the target always changed alone and 
% could change only once per cycle, so that the average frequency was 1.11 Hz. 
%% input variable
function [clr_cyclewise,clr_trialwise, clrCodes_trialwise] = M_color(tarLoc,tarIntvs_trialwise,ntrials,ncycle,nIntv,nItem,nItemsChg,clr1,clr2,vpresent)
%  clear all
rng('shuffle'); 
% load('intervals.mat','tarIntvs_trialwise'); % load var:tarIntv_trialwise(ntrial,ncycle), 
% load('coordinate.mat','tarLoc'); % target location index out of nitems
% target changes color at ith interval (out of nintvs(9)*ncycle(10) intervals) in each trial 
% load('tarLoc.mat')
% nitemChglist = [1,2,3];
% ntrial = 10;
% ncycle = 10;
% nIntv = 9;
% nItem = 10;
 
%% built-in variable/paramter
% darkGr = [0,0.5,0]'; []
% lightGr = [0.4660, 0.6740, 0.1880]';
%% output

% -----n item change color in each interval---


%-------- determine color for each item in all intervals ----
clrCodes_trialwise = cell(1,ntrials);
clr_trialwise = cell(1,ntrials);
clr_cyclewise = cell(1,ntrials);

if all(nItem == 1) && all(vpresent == 1)
    for j = 1:ntrials
        
        %-------- generate color codes 1,-1 ------
       
        clr_cyclewise = nan(3,2,ncycle*nIntv);
        clrCodes_cyclewise = nan(nIntv*ncycle,1);
        for intv = 1:ncycle*nIntv
            tarIntv = tarIntvs_trialwise(j,ceil(intv/9));%tarIntvs_trialwise(ntrial,ncycle)

            % at start of each trial, re-define all items' color
            if intv == 1
                
                    clrCode = (rand()>.5)*2-1; % 1 or -1
                    clrCodes_cyclewise(intv) = clrCode;
              

            elseif intv == tarIntv
                % target change alone
                % fprintf(' tarintv %d change at %d',tarIntv,tarInd);
                clrCodes_cyclewise(intv) = -clrCodes_cyclewise(intv-1);
            else
                clrCodes_cyclewise(intv) = clrCodes_cyclewise(intv-1);
            end
            if clrCodes_cyclewise(intv) == 1
                clr = clr2';
            elseif clrCodes_cyclewise(intv) == -1
                clr = clr1';
            end
            clr_cyclewise(:,:,intv) = [clr clr]; 
        end
         clrCodes_trialwise(j) = {clrCodes_cyclewise};

         clr_trialwise(1,j) ={clr_cyclewise};
    end
elseif all(nItem == 1) && all(vpresent == 0)
    for j = 1:ntrials
         clrCode = (rand()>.5)*2-1;
        if clrCode == 1
            clr = clr2';
        elseif clrCode == -1
            clr = clr1';
        end
     clr_trialwise(1,j) = {[clr clr]};
    end
else
    for j = 1:ntrials
        nitem = nItem(j);
        %-------- generate color codes 1,-1 ------
        tarloc = tarLoc(j); % each trial, target location is fixed
        clr_intvs90 = nan(3,2*nitem,ncycle*nIntv);
        clrCodes_intvs90 = nan(nIntv*ncycle,nitem);
        clr_cycle = cell(3,2*nitem,nIntv,ncycle);
        for intv = 1:ncycle*nIntv
            tarIntv = tarIntvs_trialwise(j,ceil(intv/9));%tarIntvs_trialwise(ntrial,ncycle)

            % at start of each trial, re-define all items' color
            if intv == 1
                for i = 1:nitem
                    clrCode = (rand()>.5)*2-1; % 1 or -1
                    clrCodes_intvs90(intv,i) = clrCode;
                end

            elseif intv == tarIntv
                % target change alone
                % fprintf(' tarintv %d change at %d',tarIntv,tarInd);
                clrCodes_intvs90(intv,:) = clrCodes_intvs90(intv-1,:);
                clrCodes_intvs90(intv,tarloc) = -clrCodes_intvs90(intv,tarloc);% clrCodes_cyclewise(nintv*ncycle,nItem)   

            else
                indChg = 1:nitem;
                indChg(tarloc) = [];%target won't change at non-tar intervals,indChg(find(indChg == tarloc)) = [];
                % nitemChg_trialwise(ntrial, nintv*ncycle)
                nitemChg = nItemsChg(j,intv); % item change number in this interval: how many
                indChg = indChg(randperm(length(indChg),nitemChg));%  indChg(ceil(rand(1,nitemChg)*length(indChg)))
                clrCodes_intvs90(intv,:) = clrCodes_intvs90(intv-1,:);
                clrCodes_intvs90(intv,indChg) = -clrCodes_intvs90(intv,indChg);
            end
        end
        clrCodes_trialwise(j) = {clrCodes_intvs90};
        for intv = 1:ncycle*nIntv
            for item = 1:nitem
                if clrCodes_intvs90(intv,item) == 1
                    clr = clr2';
                elseif clrCodes_intvs90(intv,item) == -1
                    clr = clr1';
                end
                % each column corresponds
                % to the color of the corresponding line start or endpoint in the xy position
                % argument.
                ind = item*2-1;
                clr_intvs90(:,ind:ind+1,intv) = [clr clr]; %clr_cyclewise(3,2*nitem,ncycle*nIntv)
            end
        end
        clr_cycle = mat2cell(clr_intvs90,3,nitem*2,nIntv*ones(1,ncycle)); % 
        clr_cycle = cat(4,clr_cycle); % cat along 4-dim,(3,nitem*2,nintv9,ncycle)
        clr_cyclewise(1,j) = {clr_cycle};
        clr_trialwise(1,j) ={clr_intvs90};
    end
    % save('workingdir/color.mat','clr_trialwise','clrCodes_trialwise')
    % m_color.clrCodes_trialwise = clrCodes_trialwise;
    % m_color.clr_trialwise = clr_trialwise;
end
