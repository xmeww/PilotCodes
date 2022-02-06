
ind0 = find(Tr.condTable.figPresent ==0);
ind10 = find(Tr.condTable.Coh ==10);
ind6 = find(Tr.condTable.Coh ==6);
l = length(ind0);

cond = [ind10(1:l/2);ind6(1:l/2);ind0];
ind = randperm(length(cond));
cond = cond(ind);
save condSelected.mat cond ind0 ind10 ind6

%% when apply M_cond_SFG
% 2(nitem) x 3(coh: 6,10,0), coh = 0, backgournd noise only
inda0nl = find(Tr.condTable.Coh ==0 & Tr.condTable.nItems ==12);
ind016 = find(Tr.condTable.Coh ==0 & Tr.condTable.nItems ==16);
indl12 = find(Tr.condTable.Coh ==coh_levels(1) & Tr.condTable.nItems ==12);
indl16 = find(Tr.condTable.Coh ==coh_levels(1) & Tr.condTable.nItems ==16);
indh12 = find(Tr.condTable.Coh ==coh_levels(2)& Tr.condTable.nItems ==12);
indh16 = find(Tr.condTable.Coh ==coh_levels(2) & Tr.condTable.nItems ==16);
l = 50; % each coh repeat 100 times
cond = [inda0nl(1:l);ind016(1:l);indl12(1:l);indl16(1:l);indh12(1:l);indh16(1:l)];
ind = randperm(length(cond));
cond = cond(ind);
save condSelected.mat cond

%% when apply M_cond_SFGfigOnly
% 2(nitem) x 2(coh: 6,10,0)x2(figOnly.fig+bg)+2(bgOnly,nitem), coh = 0, backgournd noise only
% ----------- noise
ind1 = find(Tr.condTable.figPresent == 0 & Tr.condTable.nItems == 12);
ind2 = find(Tr.condTable.figPresent == 0 & Tr.condTable.nItems == 16);

% -------- noise + beep
ind3 = find(Tr.condTable.Coh ==coh_levels(1) & Tr.condTable.figOnly ==0 & Tr.condTable.nItems ==12);
ind4 = find(Tr.condTable.Coh ==coh_levels(1) & Tr.condTable.figOnly ==0 & Tr.condTable.nItems ==16);
ind5 = find(Tr.condTable.Coh ==coh_levels(2) & Tr.condTable.figOnly ==0 & Tr.condTable.nItems ==12);
ind6 = find(Tr.condTable.Coh ==coh_levels(2) & Tr.condTable.figOnly ==0 & Tr.condTable.nItems ==16);

% ---- figOnly
ind7 = find(Tr.condTable.Coh ==coh_levels(1) & Tr.condTable.figOnly ==1 & Tr.condTable.nItems ==12);
ind8 = find(Tr.condTable.Coh ==coh_levels(1) & Tr.condTable.figOnly ==1 & Tr.condTable.nItems ==16);
ind9 = find(Tr.condTable.Coh ==coh_levels(2) & Tr.condTable.figOnly ==1 & Tr.condTable.nItems ==12);
ind10 = find(Tr.condTable.Coh ==coh_levels(2) & Tr.condTable.figOnly ==1 & Tr.condTable.nItems ==16);

l = 21; % each coh repeat 100 times

rng('shuffle')

cond1= ind1(randperm(length(ind1),l));
cond2= ind2(randperm(length(ind2),l));
cond3= ind3(randperm(length(ind3),l));
cond4= ind4(randperm(length(ind4),l));
cond5= ind5(randperm(length(ind5),l));
cond6= ind6(randperm(length(ind6),l));
cond7= ind7(randperm(length(ind7),l));
cond8= ind8(randperm(length(ind8),l));
cond9= ind9(randperm(length(ind9),l));
cond10= ind10(randperm(length(ind10),l));

cond_ord = [cond1;cond2;cond3;cond4;cond5;cond6;cond7;cond8;cond9;cond10];

%  cond_ord = [ind1(randperm(l));ind2(randperm(l));ind3(randperm(l));ind4(randperm(l));ind5(randperm(l));ind6(randperm(l))];


ind = randperm(length(cond_ord));
cond = cond_ord(ind);

save condSelected.mat cond_ord cond ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 ind10 ...
    cond1 cond2 cond3 cond4 cond5 cond6 cond7 cond8 cond9 cond10

cond = 1:Tr.ntrials;
save condSelected.mat cond
%