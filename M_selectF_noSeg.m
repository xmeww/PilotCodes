function [FfgL,Fbg]=M_selectF_noSeg(coh_levels,nchords_fig,nfig,ntrials,Coh,figPresent,FGth,fgStart,preCyc_int,figOnly)

% coh_levels = [6,10];
% nchords_fig = 3;
% nfig = 4; % 4 pre-determined figure
% ntrials = 4;%Tr.ntrials;
% Coh = [6 10 6 0]; %Tr.Coh;
% figOnly = [0 0 1 0];
% visualize = 1;

% Apresent = [1 1 1 0];
% FGth = [1 2 3 0];
% load('example_interval.mat','fgStart')
% preCyc_int = 10;
% 
% save example_selectF.mat Ffg6 Ffg10 Fbg

visualize =0;
F = 440 * 2 .^((-31:97)/24); 
%%                                 draw all F
if visualize ==1

    figure
    stem(F,'LineWidth',2,'Color','k','Marker','_')
    set(gca,'FontSize',20,'FontWeight','bold')

    % stem(F6);% draw all freqs for coh6

    yticks([floor(min(F)),round(max(F))]) % tick seg lower-higher
    ylabel('Frequency(Hz)')
    % xticks(find(ismember(F6,F6_seg))) % tick seg lower-higher
    xticks([1 length(F)])
    xticklabels({'1','129'})
    xlabel('Frequency (ordered)')
    title('Frequency Distribution')
    % saveas(gcf,'F_freq')
    % saveas(gcf,'F_freq.png')
end
%% select tones of pre-determined figures (4 figures x 2 coh level)
rng('shuffle')

FfgL =nan(nfig,coh_levels(1));% each row for each figure 
% FfgH =nan(nfig,coh_levels(2));

for n = 1:nfig    
    
    FfgL(n,:) = randsample(F,coh_levels(1),0);   
%     FfgH(n,:) = randsample(F,coh_levels(2),0); 
end
%% draw pre-determinned fig, an example 
if visualize ==1
    fL = figure;
    for n = 1:4
        subplot(4,1,n)
        stem(F,'LineWidth',2,'Color','k','Marker','_')
        set(gca,'FontSize',20,'FontWeight','bold')
        yticks([floor(min(F)),8000]) % tick seg lower-higher
        ylim([0,8000])
        % xticks(find(ismember(F6,F6_seg))) % tick seg lower-higher
        xticks([1 length(F)])
        xticklabels({'1','129'})
        hold on
        stem(find(ismember(F,FfgL(n,:))),sort(FfgL(n,:)),'LineWidth',2,'Color','r','Marker','_')
    end 
% han=axes(f,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Frequency(Hz)');
% xlabel(han,'Tones');
% title(han,'Randomly Selected Six Figure Tones');

% saveas(gcf,'4Ffg6')
% saveas(gcf,'4Ffg6.png')

% close all

    fH = figure;
    for n = 1:4
        subplot(4,1,n)
        stem(F,'LineWidth',2,'Color','k','Marker','_')
        set(gca,'FontSize',20,'FontWeight','bold')
        yticks([floor(min(F)),8000]) % tick seg lower-higher
        ylim([0,8000])
        % xticks(find(ismember(F6,F6_seg))) % tick seg lower-higher
        xticks([1 length(F)])
        xticklabels({'1','129'})
        hold on
        stem(find(ismember(F,FfgH(n,:))),sort(FfgH(n,:)),'LineWidth',2,'Color','r','Marker','_')
    end 
%     saveas(gcf,'4Ffg10')
%     saveas(gcf,'4Ffg10.png')
end
% -----------------------  draw rest F, an example --------------------------------
% close all
if visualize ==1
    figure 
    Frest_draw = F;

    Frest_draw(find(ismember(Frest_draw,FfgL(1,:)))) = 0;


    stem(Frest_draw,'LineWidth',2,'Color','k','Marker','_')
    hold on
    stem(find(ismember(F,FfgL(1,:))),zeros(size(FfgL(1,:))),'LineWidth',2,'Color','r','Marker','_')

    set(gca,'FontSize',20,'FontWeight','bold')

    % stem(F6);% draw all freqs for coh6

    yticks([floor(min(F)),round(max(F))]) % tick seg lower-higher
    ylabel('Frequency(Hz)')
    % xticks(find(ismember(F6,F6_seg))) % tick seg lower-higher
    xticks([1 length(F)])
    xticklabels({'1','129'})
    xlabel('Frequency (ordered)')
    title('Frequency Distribution')

%     saveas(gcf,'f6BG_pickFreq')
%     saveas(gcf,'f6BG_pickFreq.png')

end

%% select bg
Fbg = cell(ntrials,preCyc_int+180);
for j = 1:ntrials
%     j=2;
    if figOnly(j) ~= 1
        if figPresent(j) ==1
            Fthis = [];
%             if Coh(j) == coh_levels(1)
%                 fg = FfgL(FGth(j),:);
%             elseif Coh(j) == coh_levels(2)
%                 fg = FfgH(FGth(j),:);
%             end
            fg = FfgL(FGth(j),:);
            for intv = 1:preCyc_int+180
                if any(intv == preCyc_int+fgStart(j,:)) || any(intv == preCyc_int+fgStart(j,:)+1) || any(intv == preCyc_int+fgStart(j,:)+2) 
                    nbg = 20-Coh(j);
                    Frest = F(find(~(ismember(F,[Fthis,fg]))));

                else
                    nbg = 20;
                    Frest = F(find(~(ismember(F,Fthis))));

                end
                Fthis = randsample(Frest,nbg,0);
                Fbg{j,intv} = Fthis;
            end

        elseif figPresent(j) ==0
                Fthis = [];
            for intv = 1:preCyc_int+180

                nbg = 20;
                Frest = F(find(~(ismember(F,Fthis))));


                Fthis = randsample(Frest,nbg,0);
                Fbg{j,intv} = Fthis;
            end
        end
    end
end
%% check
% s = cellfun(@length,Fbg(4,:),'uni',false)
% s = [s{:}]
% find(s==10) % all(s==20)
% fgStart+10
%% background 2cycle

if visualize ==1
% close all
    figure
    hold on
    ncyc_p = 2;
    nintv_c = 18;
    j=1;
    for intv = 1:nintv_c*ncyc_p

        x = repmat([intv;intv+0.9],1,length(cell2mat(Fbg{j,intv})));
        y = [cell2mat(Fbg{j,intv});cell2mat(Fbg{j,intv})];
        plot(x,y,'LineWidth',2,'Color','k')

    end
    ylim([0,8000])
    yticks([floor(min(F)),round(max(F))])
    ylabel('Frequency(HZ)')
    % xticks(0:1:180)
    %  xticks([2,18:18:18*ncyc_p]) % cycle tick
    xlim([1,18*ncyc_p+1])
    xticks([1:18*ncyc_p]) % intv tick
    % xticklabels([])
    xlabel('Time()')
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)

    hold on 

    % figure('Name','FigOnly')

    for intv = fgStart(j,1:ncyc_p)

        hold on
        x = repmat([intv,intv+1,intv+2;...
                    intv+0.9,intv+1+0.9,intv+2+0.9],1,length(FfgL(FGth(j),:)));
        y = repmat(repelem(FfgL(FGth(j),:),nchords_fig),2,1);
        plot(x,y,'LineWidth',2,'Color','r')

    end
end

   