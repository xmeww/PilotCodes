function [clrCodes,clr_trs]= M_color(nItems,ntrials,nintv_tr,item_intv,clr1,clr2,preCyc_int)
% nItems = Tr.nItems;
% ntrials = Tr.ntrials;
% 
% nintv_tr = 180;
% tarLocs = Tr.tarLocs;

%%
clrCodes = cell(1,ntrials);
clr_trs = cell(1,ntrials);
for j = 1:ntrials
% --------------------- determine color code (as -1 or 1)  of each item in each interval-----------------------
    nitem = nItems(j);
    
    clrcodes = nan(nitem,preCyc_int+nintv_tr); % (12,190) or (16, 190)
    
    % at begining of each trial(1st intv), all randomly determined 
    clrcodes(:,1) = randsample([-1,1],nitem,1)';
    
    for intv = 2:size(item_intv,2) %2-190

        clrcodes(:,intv) = clrcodes(:,intv-1);
        clrcodes(item_intv{j,intv},intv)= -clrcodes(item_intv{j,intv},intv); % which item change at intv-th interval
    end
    clrCodes{j} = clrcodes; 
    
 % --------------------- turn code(1,-1) to RGB (in a stupid way) 
    clr_tr = nan(3,nitem*2,preCyc_int+nintv_tr); % according to drawlines required data format: nan(3,nitem*2,190)
    for intv = 1:preCyc_int+nintv_tr
        
        for item = 1:nitem
            if clrcodes(item,intv) == 1
                c = clr2';
            elseif clrcodes(item,intv) == -1
                c = clr1';
            end
            % each column corresponds
            % to the color of the corresponding line start or endpoint in the xy position
            % argument.
            ind = item*2-1;
            clr_tr(:,ind:ind+1,intv) = [c c]; %clr_cyclewise(3,2*nitem,ncycle*nIntv)
            clr_trs{j} = clr_tr;
        end
    end
end

%% check auto-manually 
% j=5;
% intv =2;
% clr_tr = clr_trs{j};
% chgItems_double = find(clr_tr(1,:,intv)-clr_tr(1,:,intv-1));
% chgind = find(mod(find(clr_tr(1,:,intv)-clr_tr(1,:,intv-1)),2)==0);
% chgItems = chgItems_double(chgind)/2;
% chgItems == item_intv{j,intv}
% tarIntv_tr(j,:)+10
