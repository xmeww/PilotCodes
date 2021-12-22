% if false alarm: Vpresnt > Vabsent
length(find(acc==0 & Vpresent ==1))
length(find(acc==0 & Vpresent ==0))

% if hit:  Vpresnt > Vabsent
length(find(acc==1 & Vpresent ==1))
length(find(acc==1 & Vpresent ==0))
