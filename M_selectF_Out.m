function [Fbg]=M_selectF_Out(ntrials,Apresent,Coh,Ffg6,FGth,Ffg10,fgStart)
F = 440 * 2 .^((-31:97)/24); 
Fbg = cell(ntrials,180);
for j = 1:ntrials
    
    if Apresent(j) ==1
        Fthis = [];
        if Coh(j) == 6
            fg = Ffg6(FGth(j),:);
        elseif Coh(j) == 10
            fg = Ffg10(FGth(j),:);
        end
        for intv = 1:180
            if any(intv == fgStart(j,:)) || any(intv == fgStart(j,:)+1) || any(intv == fgStart(j,:)+2) 
                nbg = 20-Coh(j);
                Frest = F(find(~(ismember(F,[Fthis,fg]))));

            else
                nbg = 20;
                Frest = F(find(~(ismember(F,Fthis))));

            end
            Fthis = randsample(Frest,nbg,0);
            Fbg{j,intv} = Fthis;
        end
        
    elseif Apresent(j) ==0
            Fthis = [];
        for intv = 1:180
            
            nbg = 20;
            Frest = F(find(~(ismember(F,Fthis))));

            
            Fthis = randsample(Frest,nbg,0);
            Fbg{j,intv} = Fthis;
        end
    end
end