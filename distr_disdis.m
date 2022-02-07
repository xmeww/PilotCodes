intv = 1;
   

    
disLocs = 1:nItems(j);
disLocs(disLocs==tarLocs(j))=[];




for ichg = 1:size(nintvSlot_tr,2)
    intv = intv + nintvSlot_tr(j,ichg); 
end
nchg(j,end) = 0;
item_intv{j,end} = [];

cnt_j=[];
chg_intv=[];
chg_distr_j=[];
for i = 1:length(disLocs)
    loc = disLocs(i);
    cnt=0;
    chg_intv = [13];
    for intv = 13:size(item_intv,2)
        
%         KbWait;
%         sprintf('\ntrial %d,loc %d, intv change %d',i,loc,item_intv{j,intv});
        if any(item_intv{j,intv}==loc)
           cnt = cnt+1;
           chg_intv = [chg_intv intv];
        end
        
    end
    chg_distr_j=[chg_distr_j diff(chg_intv).*50];
    cnt_j=[cnt_j cnt];
end


Chg_distr_ntrials = [];
for j = 1:2
    cnt_j=[];
    chg_intv=[];
    chg_distr_j=[];
    for l = 1:length(disLocs)
        loc = disLocs(l);
        cnt=0;
        chg_intv = [13];
        for intv = 13:size(item_intv,2)

    %         KbWait;
    %         sprintf('\ntrial %d,loc %d, intv change %d',i,loc,item_intv{j,intv});
            if any(item_intv{j,intv}==loc)
               cnt = cnt+1;
               chg_intv = [chg_intv intv];
            end

        end
        chg_distr_j=[chg_distr_j diff(chg_intv).*50];
        cnt_j=[cnt_j cnt];
    end
    Chg_distr_ntrials = [Chg_distr_ntrials chg_distr_j];
    KbWait;
    Chg_distr_ntrials 
end
d= Chg_distr_ntrials;