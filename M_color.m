function[clrCodes,clr_trs,PreclrCodes,Preclr_trs]= M_color(nItems,ntrials,nintv_tr,item_intv,clr1,clr2,item_intvPre,preCyc_int)
% nItems = Tr.nItems;
% ntrials = Tr.ntrials;
% 
% nintv_tr = 180;
% tarLocs = Tr.tarLocs;

%%
PreclrCodes = cell(1,ntrials);
Preclr_trs = cell(1,ntrials);
for j = 1:ntrials
%     j = 5;
    nitem = nItems(j);
    
    Preclrcodes = nan(nitem,preCyc_int); % 8,180 or 12,180
    % initial(1st intv), all randomly determined 
    Preclrcodes(:,1) = randsample([-1,1],nitem,1)';
    
    for intv = 2:size(item_intvPre,2)
%         intv =5;
        Preclrcodes(:,intv) = Preclrcodes(:,intv-1);
        Preclrcodes(item_intvPre{j,intv},intv)= -Preclrcodes(item_intvPre{j,intv},intv);
    end
    PreclrCodes{j} = Preclrcodes; 
    
    Preclr_tr = nan(3,nitem*2,preCyc_int);
    for intv = 1:preCyc_int
        
        for item = 1:nitem
            if Preclrcodes(item,intv) == 1
                c = clr2';
            elseif Preclrcodes(item,intv) == -1
                c = clr1';
            end
            % each column corresponds
            % to the color of the corresponding line start or endpoint in the xy position
            % argument.
            ind = item*2-1;
            Preclr_tr(:,ind:ind+1,intv) = [c c]; %clr_cyclewise(3,2*nitem,ncycle*nIntv)
            Preclr_trs{j} = Preclr_tr;
        end
    end
end
%% 
clrCodes = cell(1,ntrials);
clr_trs = cell(1,ntrials);
for j = 1:ntrials
%     j = 5;
    nitem = nItems(j);
    Preclrcodes = PreclrCodes{j};
    
    clrcodes = nan(nitem,nintv_tr); % 8,180 or 12,180
    % initial(1st intv), all randomly determined 
    clrcodes(:,1) = Preclrcodes(:,end);
    clrcodes(item_intv{j,1},1) = -clrcodes(item_intv{j,1},1);
    
    for intv = 2:size(item_intv,2)
%         intv =5;
        clrcodes(:,intv) = clrcodes(:,intv-1);
        clrcodes(item_intv{j,intv},intv)= -clrcodes(item_intv{j,intv},intv);
    end
    clrCodes{j} = clrcodes; 
    
    clr_tr = nan(3,nitem*2,nintv_tr);
    for intv = 1:nintv_tr
        
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
%%check 
% j =5;
% item= tarLocs(j)*2;
% clr_tr= clr_trs{j};
%  find(diff(clr_tr(2,item,:),[],3)~=0)+1 == tarInts_tr(j,:)
