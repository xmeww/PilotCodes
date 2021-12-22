function [tarIntv_c, tarIntv_tr, tar_dist, nchg, disLocs, item_intv, fgStart,item_intvPre] = M_interval(ntrials,tarLocs,nItems,ncycle,nintv_tr,nintv_c,async,Apresent,preCyc_int)
% ntrials = Tr.ntrials;
% tarLocs = Tr.tarLocs;
% nItems = Tr.nItems;
% ncycle = 10;
% % tintv = 3*ifi; % duration of one interval
% nintv_tr = 180; % 0.9/0.05*10
% nintv_c = 18; %  0.9/0.05
% async = Tr.AVasync; % 0 sync, acync -1 = Apresent 0 
visualize =0;

%% target interval

rng('shuffle')
tarIntv_c = nan(ntrials,ncycle); % target change color at ith interval in a cycle of 18 intervals
tar_dist = nan(ntrials,ncycle-1); % plot tar-tar change interval 
tarIntv_tr = nan(ntrials,ncycle);
preCycle_intv = (500/50)*ones(ntrials,1); % pre_t/intv_t = 0.5s/0.05s = 10intvs, for each trial


for j = 1:ntrials
    tarIntv_c(j,:) = randsample(200/50:700/50,ncycle,1);
end

tarIntv_tr = cell2mat(arrayfun(@(c) tarIntv_c(:,c)+18*(c-1),1:10,'UniformOutput',0));
%%
if visualize ==1
    figure
    d = tarIntv_c(:).*0.05;
    h = histogram(d);
    h.BinEdges = [min(d)-0.05/2:0.05:max(d)+0.05/2];
    h.Normalization = 'probability';
    set(gca,'FontSize',20,'FontWeight','bold')
    % xticks([min(h.BinEdges)+0.05/2:0.05:max(h.BinEdges)-0.05/2])
    xlim([0,0.9])
    xticks([0:0.05:0.9])
    yt = get(gca,'YTick');
    yticklabels(strsplit(num2str(yt*100)))
    grid on
%     saveas(gcf,'h_tarDisinCyc')
%     saveas(gcf,'h_tarDisinCyc.png')
end

%%
tar_dist = diff(tarIntv_tr,[],2);
if visualize ==1
% close all
    figure('Name','target-target distribution')
    d = tar_dist(:).*0.05;

    h = histogram(d);
    % h = histogram(reshape(dist.*(3/60),1,[]))
    h.BinEdges = [min(d)-0.05/2:0.05:max(d)+0.05/2];
    h.Normalization = 'probability';
    % h.BinWidth = 3/60;
    % xlim([0,max(h.BinEdges+0.05)])
    % xticks(h.BinEdges(1:end-1)+0.05/2)
    set(gca,'FontSize',20)
    xticks([min(h.BinEdges)+0.05/2 ,h.BinEdges(find(h.Values == max(h.Values)))+0.05/2,  max(h.BinEdges)-0.05/2])
    yt = [round(linspace(min(h.Values),max(h.Values),5),3)];
    yticks(yt)
    yticklabels(strsplit(num2str(yt*100)))
    grid on
    % h.Normalization = 'probability';
    title('target-target change interval distribution','FontSize',20)
    ylabel('Time Distribution(%)','FontSize',20)
    ax = gca;
    ax.XAxis.MajorTickChild.LineWidth = 2;

%     saveas(gcf,'h_tar-tar.png')
%     saveas(gcf,'h_tar-tar')
end
    %% distractor interval
    % --------------------- nitem change in each interval -------------

nchg_type = 0:3;
nchg = nan(ntrials,nintv_tr);
% nchg(:,1) = zeros(ntrials,1);
% nchg(:,2:end) = randi(length(nchg_type),[ntrials,nintv_tr-1])-1;
nchg = randi(length(nchg_type),[ntrials,nintv_tr])-1;
for j = 1:ntrials
    nchg(j,tarIntv_tr(j,:)) =1;
end
tarchgPercent = length(tarIntv_tr(:))/length(find(nchg)==1);

nchg_pre = nan(ntrials,preCyc_int);
nchg_pre(:,1) = zeros(ntrials,1);
nchg_pre(:,2:end) = randi(length(nchg_type),[ntrials,preCyc_int-1])-1;


if visualize ==1

%     close all
    figure('Name','number of items change at start of each interval')
    h = histogram(reshape(nchg,1,[]));
    set(gca,'FontSize',20);
    % h.BinWidth = 0.05
    h.Normalization = 'probability';
    title('nitems change','FontSize',20);
    ylabel('Distribution(%)','FontSize',20,'FontWeight','bold');
    xlabel('Item Change Number','FontSize',20,'FontWeight','bold');

    ax = gca;
    ax.XAxis.MajorTickChild.LineWidth = 2;
    ax.XAxis.MajorTickChild

%     saveas(gcf,'nitemChg')
%     saveas(gcf,'nitemChg.png')
end


%% fig start interval



fgStart = nan(ntrials,ncycle);
for j = 1:ntrials
    if Apresent(j) ==1
    fgStart(j,:) = tarIntv_tr(j,:)+async(j); % ± n intv
    end
end

% tarIntv_Tr = 10+tarIntv_tr;

%%  draw 
dist = diff(fgStart,[],2)-3;
if visualize ==1
% close all
    figure('Name','target-target distribution')
    d = dist(:).*0.05;

    h = histogram(d);
    % h = histogram(reshape(dist.*(3/60),1,[]))
    h.BinEdges = [min(d)-0.05/2:0.05:max(d)+0.05/2];
    h.Normalization = 'probability';
    % h.BinWidth = 3/60;
    % xlim([0,max(h.BinEdges+0.05)])
    % xticks(h.BinEdges(1:end-1)+0.05/2)
    set(gca,'FontSize',20)
    xticks([min(h.BinEdges)+0.05/2 ,h.BinEdges(find(h.Values == max(h.Values)))+0.05/2,  max(h.BinEdges)-0.05/2])
    yt = [round(linspace(min(h.Values),max(h.Values),5),3)];
    yticks(yt)
    yticklabels(strsplit(num2str(yt*100)))
    grid on
    % h.Normalization = 'probability';
    title('figure end-figure start interval distribution','FontSize',20)
    ylabel('Time Distribution(%)','FontSize',20)
    ax = gca;
    ax.XAxis.MajorTickChild.LineWidth = 2;
end
%% --------------------- draw   -------------
%  nitem change in each interval, each item change
%  each item change frequency 

disLocs = cell(ntrials,1);
for j = 1:ntrials
    
    disLocs{j} = 1:nItems(j);
    disLocs{j}(disLocs{j}==tarLocs(j))=[];
end

% which items change in each intv, value is which item, include target
for j = 1:size(nchg,1)
    for intv = 1:size(nchg,2)
        if any(intv == tarIntv_tr(j,:))
            item_intv{j,intv} = tarLocs(j);
        else
            item_intv{j,intv} = sort(randsample(disLocs{j},nchg(j,intv),0));
        end
    end
end

for j = 1:size(nchg_pre,1)
    for intv = 1:size(nchg_pre,2)
        
        item_intvPre{j,intv} = sort(randsample(disLocs{j},nchg_pre(j,intv),0));
        
    end
end
% save intv.mat tarIntv_c tarIntv_tr tar_dist nchg disLocs item_intv fgStart
%%
if visualize ==1
    v8 = find(nItems==8);
    I = [];
    for j = 1:length(v8)

        items =[item_intv{v8(j),:}];% all changed loca
        items(items==tarLocs(v8(j)))=[]; % changed dis locs
        I = [I items]; % across trials

    end

    h = histogram(I);

    h.Normalization = 'probability';



    v12 = find(nItems==12);

    figure 
    histogram([item_intv{v8,:}]);
    histogram([item_intv{1008,:}])

    item_intv{1008,tarIntv_tr(1008,:)}


    j = 73;
    close all
    figure('Name','item change time')
    % each item change n times, ntimes-itemm
    h = histogram([item_intv{j,:}]);
    xticks(tarLocs(j));
    xticklabels('Target');
    title(['times of each item change in trial' num2str(j)],'FontSize',20);
    ylabel('Change Times','FontSize',20,'FontWeight','bold');
    xlabel('Item','FontSize',20,'FontWeight','bold');
    % each item change frequency(within 9s), ntimes-itemm
    figure
    plot(h.Values/(nintv_c*ncycle*0.05),'LineWidth',3)
    grid on
    xticks(tarLocs(j));
    xticklabels('Target');
    yticks(round(unique(h.Values/nintv_c*ncycle*0.05),1));
    grid on
    ylabel('item change frequency(Hz)','FontSize',20);
    xlabel('item','FontSize',20);


    save intv.mat tarIntv tar_dist nchg disLocs item_intv nintv_c

    %% ----------------------- σ( *・ω・)σ PPT--------------------
    %  item_intv{j,intv}
    % ----------------------- one trial = 180 intv -----------------------
    % item-intv, which item change in each intv
    close all 
    figure('Name','temporal organization')
    hold on
    for i = 1:nItems(j)
        yline(i)
    end
    % for c = 1:ncycle
    %       xline(c)
    % end  
    for intv = 2:nintv_tr

    %     xline(intv,'Color',[0.5 0.5 0.5],'LineStyle','--')
        items = item_intv{j,intv} ;
        x = repmat([intv;intv],1,length(items));
        y = [items;items+0.1];
        plot(x,y,'LineWidth',2,'Color','k')

    end

    ylim([0,nItems(j)+1])
    yticks(tarLocs(j)) 
    yticklabels('Tar')
    % xticks(0:1:180)
    xticks([2,nintv_c:nintv_c:nintv_c*ncycle])
    xlim([0,nintv_c*ncycle+1])

    %% ----------------------- 2 cycles -----------------------
    ncyc_p = 2;
    close all 
    figure('Name','temporal organization: 2cycles')
    hold on
    % ----------------------------  visual 
    for i = 1:nItems(j)
        yline(i)
    end
    % for c = 1:ncycle
    %       xline(c)
    % end  
    for intv = 1:nintv_c*ncyc_p

        xline(intv,'Color',[0.5 0.5 0.5],'LineStyle','--')
        items = item_intv{j,intv} ;
        x = repmat([intv;intv],1,length(items));
        y = [items;items+0.1];
        plot(x,y,'LineWidth',2,'Color','k')

    end

    ylim([0,nItems(j)+1])
    yticks(tarLocs(j))
    yticklabels('Tar')
    % xticks(0:1:180)
    xticks([1:nintv_c*ncyc_p]) % intv tick
    %  xticks([2,nintv_c:18:18*ncyc_p]) % cycle tick
    xlim([0,nintv_c*ncyc_p+1])
    %% ----------------------------  AV temporal organisation: 2 cycles
    ncyc_p = 2;
    ntrials = Tr.ntrials;
    tarLocs = Tr.tarLocs;
    nItems = Tr.nItems;

    j = 73
    close all 
    figure('Name','temporal organization: 2cycles')

    subplot(2,1,1)
    hold on
    % ----------------------------  visual 
    for i = 1:nItems(j)
        if i == tarLocs(j)
            clr = [0.5,0,0];
        else
        clr = [0.5,0.5,0.5];
        end
        yline(i,'LineWidth',2,'Color',clr)

    end
    % for c = 1:ncycle
    %       xline(c)
    % end  
    for intv = 1:nintv_c*ncyc_p

        xline(intv,'Color',[0.5 0.5 0.5],'LineStyle','--')
        items = item_intv{j,intv} ;
        x = repmat([intv;intv],1,length(items));
        y = [items;items+0.1];
        plot(x,y,'LineWidth',2,'Color','k')

    end


    ylim([0,nItems(j)+1])
    yticks(tarLocs(j))
    yticklabels('Vtar')
    % xticks(0:1:180)
    xticks([1:nintv_c*ncyc_p]) % intv tick
    %  xticks([2,nintv_c:nintv_c:nintv_c*ncyc_p]) % cycle tick
    xlim([1,nintv_c*ncyc_p+1])
    xticklabels({''})
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)
    ylabel('Visual Items')

    % ----------------------------  auditory
    subplot(2,1,2)
    ncyc_p =1;
    %bg
    figure('Name','BG only')
    figure('Name','FG+BG')
    for intv = 1:nintv_c*ncyc_p
        hold on
        x = repmat([intv;intv+0.9],1,length(Fbg{intv}));
        y = [Fbg{intv};Fbg{intv}];
        plot(x,y,'LineWidth',2,'Color','k')

    end
    ylim([0,8000])
    yticks([floor(min(F)),round(max(F))])
    ylabel('Frequency(HZ)')
    % xticks(0:1:nintv_c*ncycle)
    %  xticks([2,nintv_c:nintv_c:nintv_c*ncyc_p]) % cycle tick
    xlim([1,nintv_c*ncyc_p+1])
    xticks([1:nintv_c*ncyc_p]) % intv tick
    % xticklabels({''})
    xlabel('Chords(=50ms)')
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)

    saveas(gcf,'bgonly_18intv')
    saveas(gcf,'bgonly_18intv.png')
    % fg
    hold on 
    figure('Name','FigOnly')

    for intv = 1:tarIntv_c(2,1:ncyc_p)
        intv =10;
        hold on
        x = repmat([intv,intv+1,intv+2;...
                    intv+0.9,intv+1+0.9,intv+2+0.9],1,length(Ffg6(1,:)));
        y = repmat(repelem(Ffg6(1,:),3),2,1);
        plot(x,y,'LineWidth',2,'Color','r')

    end

    ylim([0,8000])
    yticks([floor(min(F)),round(max(F))])
    ylabel('Frequency(HZ)')
    % xticks(0:1:nintv_c*ncycle)
    %  xticks([2,nintv_c:nintv_c:nintv_c*ncyc_p]) % cycle tick
    xlim([1,nintv_c*ncyc_p+1])
    xticks([1:nintv_c*ncyc_p]) % intv tick
    % xticklabels({''})
    xlabel('Chords(=50ms)')
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)

    saveas(gcf,'fg6only_18intv')
    saveas(gcf,'fg6only_18intv.png')

    saveas(gcf,'fg6bg_18intv')
    saveas(gcf,'fg6bg_18intv.png')


    saveas(gcf,'AVasync0')
    saveas(gcf,'AVasync0.png')

    % async A+1intv
    subplot(2,1,2,'replace')
    AVasync = 3; % auditory fig move along x-axis
    saveAsync = 'V3intv';% A3intv-Aleading 3inntv, 0, 
    %bg
    hold on
    for intv = 1:nintv_c*ncyc_p

        x = repmat([intv;intv+0.9],1,length(Fbg{intv}));
        y = [Fbg{intv};Fbg{intv}];
        plot(x,y,'LineWidth',2,'Color','k')

    end
    % fg
    for intv = tarIntv_c(j,1:ncyc_p)+AVasync
        x = repmat([intv,intv+1,intv+2;...
                    intv+0.9,intv+1+0.9,intv+2+0.9],1,length(Ffg6(1,:)));
        y = repmat(repelem(Ffg6(1,:),3),2,1);
        plot(x,y,'LineWidth',2,'Color','r')

    end

    ylim([0,8000])
    yticks([floor(min(F)),round(max(F))])
    ylabel('Frequency(HZ)')
    % xticks(0:1:nintv_c*ncycle)
    %  xticks([2,nintv_c:nintv_c:nintv_c*ncyc_p]) % cycle tick
    xlim([1,nintv_c*ncyc_p+1])
    xticks([1:nintv_c*ncyc_p]) % intv tick
    xticklabels({''})
    xlabel('Time()')
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)
    % bg +fg

    saveas(gcf,['AVasync',saveAsync])
    saveas(gcf,['AVasyncA1intv',saveAsync,'.png'])
    %% plot how any items in each intv
    close all
    j=1;
    stem(nchg(j,:),'filled')
    hold on 
    stem(tarIntv_c(j,:),nchg(j,tarIntv_c(j,:)),'Color','r')
    hold off



    % xticks(tarIntv(j,:));
    % xticklabels(repmat('T',);
end
