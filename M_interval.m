function [tarIntv_c, tarIntv_tr, tar_dist, nchg, disLocs, item_intv, fgStart,closeTar,chkItemChg] = M_interval(ntrials,tarLocs,nItems,ncycle,nintv_tr,nintv_c,AVasync,figPresent,preCyc_int)

% ntrials = 4;%Tr.ntrials;
% tarLocs = [1 2 1 2];%Tr.tarLocs;
% nItems = [12 16 12 16];%Tr.nItems;
% ncycle = 10;
% % tintv = 3*ifi; % duration of one interval
% nintv_tr = 180; % 0.9/0.05*10
% nintv_c = 18; %  0.9/0.05
% async = [0 0 0 0];%Tr.AVasync; % 0 sync, acync -1 = Apresent 0 
% preCyc_int = 500/50;
% figPresent = [1];

visualize =0;

%% target interval

rng('shuffle')
tarIntv_c = nan(ntrials,ncycle); % target change color at ith interval in a cycle of 18 intervals
tar_dist = nan(ntrials,ncycle-1); % plot tar-tar change interval 
tarIntv_tr = nan(ntrials,ncycle);


for j = 1:ntrials
    tarIntv_c(j,:) = randsample(200/50:700/50,ncycle,1); % target change between 200~700ms in one cycle(1-18 interval)
end

tarIntv_tr = cell2mat(arrayfun(@(c) tarIntv_c(:,c)+18*(c-1),1:10,'UniformOutput',0)); % interval 1-180,10 cycle in one trial
% --- check 
checklist(:,1) = repmat([1:nintv_c]',ncycle,1);
checklist(:,2) = 1:nintv_c*ncycle;
for j =1:ntrials
    for c = 1:ncycle
        checkTarIntv(j,c) = (tarIntv_tr(j,c) == checklist(18*(c-1)+tarIntv_c(j,c),2));
    end
end

if any(checkTarIntv)~=1
    error('tarintv_c ~= tarint_tr');
end

% -------------------------------- visualize: draw tar-tar distribution 
if visualize ==1
    d = diff(tarIntv_tr,1,2).*50;
    h = histogram(d(:));
%     h.BinWidth = 50;
    h.BinEdges = min(d(:))-50/2:50:max(d(:))+50/2;
    
    h.Normalization='probability';
    grid on
    xticks([min(h.BinEdges)+50/2,900,max(h.BinEdges)-50/2])
%     xticklabels({num2str(min(h.BinEdges+0.5)*50),'900',num2str(max(h.BinEdges-0.5)*50)})
    set(gca,'FontSize',15,'FontWeight','bold')
end
%% fig start interval

fgStart = nan(ntrials,ncycle);
for j = 1:ntrials
    if figPresent(j) ==1
    fgStart(j,:) = tarIntv_tr(j,:)+AVasync(j); % ± n intv
    end
end

% tarIntv_Tr = 10+tarIntv_tr;
%% how many items change (distractors+target) at begining of each interval
    
nchg_type = 0:3;
nchg = nan(ntrials,preCyc_int+nintv_tr);
% nchg(:,1) = zeros(ntrials,1);
% nchg(:,2:end) = randi(length(nchg_type),[ntrials,nintv_tr-1])-1;

% ------------------- 200-Tar-200 -------------------
tpw = 200; % temporal protected window, in ms
closeTar = zeros(ntrials,ncycle);
for j = 1:ntrials
    nchg(j,preCyc_int+tarIntv_tr(j,:)) =1;
    for n = 1:tpw/50-1
        nchg(j,preCyc_int+tarIntv_tr(j,:)-n) =0;
        nchg(j,preCyc_int+tarIntv_tr(j,:)+n) =0;
         
    end
    for c= 1:ncycle
       % guarantee distractor change very next window before/after tpw  
        if nchg(j,preCyc_int+tarIntv_tr(j,c)+tpw/50) ~= 1 % when two target changes are so close that they share tpw 
           nchg(j,preCyc_int+tarIntv_tr(j,c)+tpw/50) = randi(3);
           if nchg(j,preCyc_int+tarIntv_tr(j,c)-tpw/50) ~=1
           nchg(j,preCyc_int+tarIntv_tr(j,c)-tpw/50) = randi(3);
           end
        elseif nchg(j,preCyc_int+tarIntv_tr(j,c)+tpw/50+1) ==1
            nchg(j,preCyc_int+tarIntv_tr(j,c)-tpw/50) = randi(3);
            closeTar(j,c) =1;
        end
    end
end

nchg(find(isnan(nchg))) = randi(length(nchg_type),size(find(isnan(nchg))))-1;% 0~3 distr change 

tarchgPercent = length(tarIntv_tr(:))/length(find(nchg)==1);

% -------------------------------visualize: nitem changes(0-3) distribution
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

%% --------------------- which item changes at begining of each interval  -------------

disLocs = cell(ntrials,1);
for j = 1:ntrials
    
    disLocs{j} = 1:nItems(j);
    disLocs{j}(disLocs{j}==tarLocs(j))=[];
end

% which items change in each intv, value is which item, include target
item_intv = {};
for j = 1:size(nchg,1)
    for intv = 1:size(nchg,2) %10+180
        if any(intv == preCyc_int+tarIntv_tr(j,:))
            item_intv{j,intv} = tarLocs(j);
        else
            item_intv{j,intv} = sort(randsample(disLocs{j},nchg(j,intv),0));
        end
    end
end

% check item_intv matchs nchg, auto-manually
for j = 1:size(nchg,2)
    for intv = 1:size(nchg,2)
        chkItemChg(j,intv) = (length(item_intv{j,intv}) == nchg(j,intv));
    end
end
% save intv.mat tarIntv_c tarIntv_tr tar_dist nchg disLocs item_intv fgStart


%% ----------------------- σ( *・ω・)σ plot picutres for PPT presentation--------------------
if visualize ==1
    % ----------------------- 2 cycles -----------------------
    j = 1;
    ncyc_pre = 4;
    close all 
    figure('Name','temporal organization: 2cycles')
    
    % ----------------------------  visual 
    for i = 1:nItems(j)
        yline(i)
    end
    % for c = 1:ncycle
    %       xline(c)
    % end  
    hold on
    
    for intv = 1:preCyc_int+nintv_c*ncyc_pre
        
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
    xticks([1:(500/50)+nintv_c*ncyc_pre]) % intv tick
    %  xticks([2,nintv_c:18:18*ncyc_p]) % cycle tick
    xlim([0,(500/50)+nintv_c*ncyc_pre+1])
    %% ----------------------------  AV temporal organisation: 2 cycles
    ncyc_pre = 2;
    ntrials = Tr.ntrials;
    tarLocs = Tr.tarLocs;
    nItems = Tr.nItems;

    j = 73;
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
    for intv = 1:preCyc_int+nintv_c*ncyc_pre

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
    xticks([1:nintv_c*ncyc_pre]) % intv tick
    %  xticks([2,nintv_c:nintv_c:nintv_c*ncyc_p]) % cycle tick
    xlim([1,nintv_c*ncyc_pre+1])
    xticklabels({''})
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)
    ylabel('Visual Items')

    % ----------------------------  auditory
    subplot(2,1,2)
    ncyc_pre =1;
    %bg
    figure('Name','BG only')
    figure('Name','FG+BG')
    for intv = 1:nintv_c*ncyc_pre
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
    xlim([1,nintv_c*ncyc_pre+1])
    xticks([1:nintv_c*ncyc_pre]) % intv tick
    % xticklabels({''})
    xlabel('Chords(=50ms)')
    set(gca,'FontSize',20,'FontWeight','bold','LineWidth',2)

    saveas(gcf,'bgonly_18intv')
    saveas(gcf,'bgonly_18intv.png')
    % fg
    hold on 
    figure('Name','FigOnly')

    for intv = 1:tarIntv_c(2,1:ncyc_pre)
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
    xlim([1,nintv_c*ncyc_pre+1])
    xticks([1:nintv_c*ncyc_pre]) % intv tick
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
    for intv = 1:nintv_c*ncyc_pre

        x = repmat([intv;intv+0.9],1,length(Fbg{intv}));
        y = [Fbg{intv};Fbg{intv}];
        plot(x,y,'LineWidth',2,'Color','k')

    end
    % fg
    for intv = tarIntv_c(j,1:ncyc_pre)+AVasync
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
    xlim([1,nintv_c*ncyc_pre+1])
    xticks([1:nintv_c*ncyc_pre]) % intv tick
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
