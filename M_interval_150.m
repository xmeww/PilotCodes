function [tarIntv_tr, nchg, item_intv, fgStart,nintvSlot_tr]  = M_interval_150(ntrials,tarLocs,nItems,ncycle,nTslot_c,AVasync,figPresent,preCyc_int,intv_type_pre,nintvs)

% ntrials = 2;%Tr.ntrials;
% tarLocs = [1 2];%Tr.tarLocs;
% nItems = [12 16];%Tr.nItems;
% ncycle = 10;
% nTloc_c=9;
% % tintv = 3*ifi; % duration of one interval
% AVasync = [0 0];%Tr.AVasync; % 0 sync, acync -1 = Apresent 0 
% nintvs = 180;
% figPresent = [1 1];
% 
intv_type_pre = [];%[1 1 2 2 3 3];
preCyc_int = sum(intv_type_pre);

visualize =0;
%%

rng('shuffle')





% e.g. nintv_c = [2 3 1 1 2 2 3 3 1], number of intervals, 1 intv = 50ms
intv_type_c = [1 1 1 2 2 3 3];% intervals in each cycle after excluding interval slot pre/after target change 
% nintvSlot_tr = nan(ntrials,ncycle*nTslot_c+length(intv_type_pre));% 6+10*9, number of intervals(50ms) in each slot(9 slots/cycle)
nintvSlot_tr = nan(ntrials,ncycle*nTslot_c);
tar_tSlot = nan(ntrials,ncycle);
tarIntv_tr = nan(ntrials,ncycle);
for j = 1:ntrials
    tar_tSlot(j,:) = randsample(1:9,ncycle,1);
%     nintv_pre = intv_type_pre(randperm(length(intv_type_pre)));

    intv_C = [];
    for c = 1:ncycle
        intv_c = nan(1,nTslot_c);
        intv_c(tar_tSlot(j,c)) = 3; % target change - 150ms -distractor change
        intv_c(tar_tSlot(j,c)-1) = 2; % distractor - 150ms -target
        ind = randperm(nTslot_c-2);
        intv_c(1:tar_tSlot(j,c)-2) = intv_type_c(ind(1:tar_tSlot(j,c)-2)); %  distractor changes before TPW
        intv_c(tar_tSlot(j,c)+1:end) = intv_type_c(ind(tar_tSlot(j,c)-1:end));% after TPW
        tarIntv_c = sum(intv_c(1:tar_tSlot(j,c)-1));
        tarIntv_tr(j,c) = tarIntv_c+(c-1)*18+1; % target changes at start of x-th interval
        
        intv_C = [intv_C intv_c];
    end
    
%     nintvSlot_tr(j,:) = [nintv_pre intv_C];
    nintvSlot_tr(j,:) = intv_C;
end
% tar_tloc_tr = nan(size(tar_tSlot));
% for c = 1:10
%  tar_tloc_tr(:,c) = tar_tSlot(:,c)+(c-1)*9+6;
% end
% check
if visualize ==1
    d= diff(tarIntv_tr,1,2).*50;
    d = d(:);
    % -------------------- tar-tar distr
    
    h = histogram(d,'Normalization','probability','BinWidth',50,'BinEdges',[min(d)-25:50:max(d)+25]);
    set(gca,'XTick',[min(d),900,max(d)],'FontSize',15,'FontWeight','bold')
    title('Distribution over intervals of target changes')
    ylabel('Distribution Probability')
    
    % -------------------- target changes time
    
    ifi = 1/59;
    t = (tarIntv_tr-1).*3*ifi+sum(preCyc_int)*3*ifi;
    boxplot(t)
    set(gca,'FontSize',15,'FontWeight','bold')
    title('Time of Target Change at Each Cycle')
    
    % -------------------- dis-dis

    % dis-dis distr
    d = nintvSlot_tr(:).*50;
    h = histogram(d,'Normalization','probability','BinWidth',50,'BinEdges',[min(d)-25:50:max(d)+25]);
    set(gca,'XTick',[50 100 150],'FontSize',15,'FontWeight','bold')
    title('Distribution over Intervals of All Visual Events')
    ylabel('Distribution Probability')
end

% --- which items change in each intv, value is which item, include tdisLocs = cell(ntrials,1);
nItems = 48.*ones(1,size(nintvSlot_tr,1));
tarLocs  = nItems;

nchg = zeros(ntrials,nintvs+preCyc_int);
item_intv = {};

for j = 1:size(nintvSlot_tr,1)
 
    intv = 1;
   
   
    disLocs = 1:nItems(j);
    disLocs(disLocs==tarLocs(j))=[];


    for ichg = 1:size(nintvSlot_tr,2) % timing slot item change
         intv = intv + nintvSlot_tr(j,ichg); % ith display change,  n-interval duration
        if any(intv == tarIntv_tr(j,:)+preCyc_int)
            nchg(j,intv) = 1; 
            item_intv{j,intv} = tarLocs(j);
        else
            nchg(j,intv) = randi(3,1); % 1~3 items change at each time
            item_intv{j,intv} = sort(randsample(disLocs,nchg(j,intv),0));
        end
        
    end
    nchg(j,end) = 0;
    item_intv{j,end} = [];

end
%% ---------  plot each distractor change timing 

Chg_distr_ntrials = []; % distractor change timing distribution
Cnt = [];
for j = 1:size(nintvSlot_tr,1)
    
    disLocs = 1:nItems(j);
    disLocs(disLocs==tarLocs(j))=[];
    
    cnt_j=[];
    chg_intv=[];
    chg_distr_j=[];
    for l = 1:length(disLocs)
        loc = disLocs(l);
        cnt=0;
        chg_intv = [13];
        for intv = 14:size(item_intv,2)

    %         KbWait;
    %         sprintf('\ntrial %d,loc %d, intv change %d',i,loc,item_intv{j,intv});
            if any(item_intv{j,intv}==loc)
               cnt = cnt+1;
               chg_intv = [chg_intv intv];
            end

        end
% %         sprintf('location %d',l)
% %         chg_intv
% %         KbWait;
        if length(chg_intv)==1
            chg_distr_j=[chg_distr_j 0];
             cnt_j=[cnt_j cnt];
        else
            chg_distr_j=[chg_distr_j diff(chg_intv).*50];
            cnt_j=[cnt_j cnt];
        end
    end
    Cnt = [Cnt cnt_j];
    Chg_distr_ntrials = [Chg_distr_ntrials chg_distr_j];
end
figure
d = Chg_distr_ntrials;
h = histogram(d,'Normalization','probability','BinWidth',50,'BinEdges',[min(d)-25:50:max(d)+25]);
set(gca,'XTick',[min(d),900,max(d)],'FontSize',15,'FontWeight','bold')
title(sprintf('Distribution over Intervals of Distractor Changes: %d Distractors',nItems(j)-1))
ylabel('Distribution Probability')


%%

fgStart = nan(ntrials,ncycle);
for j = 1:ntrials
    if figPresent(j) ==1
    fgStart(j,:) = tarIntv_tr(j,:)+AVasync(j); % ± n intv
    end
end
