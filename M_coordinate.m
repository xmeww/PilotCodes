function [XY,disOri,Ori,tarCenter,fixbars ]=M_coordinate(monitor,monitorMode,tarOris,tarLocs,tilt,ntrials,nItems)
%%
% monitor = 'lab1'; %lab1,mac
% monitorMode =  'plain';%'palin','small','trasnparent','screen-short'
% tarOris =  Tr.tarOris;
% tarLocs = Tr.tarLocs;
% tilt = 15;
% ntrials = Tr.ntrials;
% nItems = Tr.nItems;

% monitor = 'lab1';
% monitorMode = 'plain';
% tarOris = ones(10,1);
% tarLocs = [1:10]';
% tilt = 15;
% ntrials = 10;
% nItems = repmat([12,16]',5,1);

disOri_type = [tilt 90-tilt 90+tilt 360-tilt];
visualize =0;
%%
disOri = cell(ntrials,1);
for j = 1:ntrials
    randInt = arrayfun(@(x)randperm(length(disOri_type)),1:floor((nItems(j)-1)/length(disOri_type)),'UniformOutput',0);
    randRemain = randsample(length(disOri_type),mod((nItems(j)-1),length(disOri_type)),false)';
    disOri{j,:} = disOri_type([[randInt{:}],randRemain]);
end
Ori = cell(ntrials,1);
for j = 1:ntrials
    disori = disOri{j};
    Ori{j} = [disori(1:tarLocs(j)-1) tarOris(j).*90 disori(tarLocs(j):end)];
end

%%
screenNumber = max(Screen('Screens'));

if strcmp(monitor,'lab1')
   res = Screen('Resolution',screenNumber);
   res = [0,0,res.width,res.height]; 
elseif strcmp(monitor,'mac')
   res = get(0,'ScreenSize');
   res = [0 0 res(3:4)];
   
end

xpixels = res(3);
ypixels = res(4);
xCenter = xpixels/2;
yCenter = ypixels/2;
%%
vdist = 80;
VARcircle = 5;
VAbar = 0.7;
% linewidth = 3;
if strcmp(monitor,'lab1')
    cwidth =  53.4;% lab1 53.4, Mac 28.6
elseif strcmp(monitor,'mac')
   cwidth = 28.6; 
end
Rroute= M_deg2pix(vdist,VARcircle,xpixels,cwidth);
Lbar= M_deg2pix(vdist,VAbar,xpixels,cwidth); 
%% ---------  ( *・ω・)✄ soul ------------
Lfix = Lbar;
fixangle = (90-tilt)/180; %(90-tilt)/180;tilt/180;<<========= put into M if determined
fixbars = [xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle),xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle);...
           yCenter-Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter-Lfix/2*cos(fixangle)]; % center -/+ fixation/2

% ---------------------   location ---------------------
% centerx=    xCenter +  Rroute*sin((([1:nItems(j)+4]+0.5)/(nItems(j)+4)) * 2 *pi); % 
% centery=    yCenter +  Rroute*cos((([1:nItems(j)+4]+0.5)/(nItems(j)+4)) * 2 *pi);
% centerxPlus = centerx;
% centeryPlus = centery;
% [~,indBpt] = sort(centery,'descend');
% 
% [~,ind] = sort(centery,'ascend');
% indBot = ind(1:2);
% indTop = ind(end-1:end);
% centery([indBot indTop]) = [];
% centerx([indBot indTop]) = [];

XY = {};
tarCenter = nan(2,ntrials);
% ---------------------   orientation ---------------------
for j = 1:ntrials
    x = [];
    y = [];
    centerx =[];
    centery=[];
%     j =1;
    ori = Ori{j}; 
    % all location x,y center
    centerx=    xCenter +  Rroute*sin((([1:nItems(j)+4]+0.5)/(nItems(j)+4)) * 2 *pi); % 
    centery=    yCenter +  Rroute*cos((([1:nItems(j)+4]+0.5)/(nItems(j)+4)) * 2 *pi);
    centerxPlus = centerx;
    centeryPlus = centery;
    [~,indBpt] = sort(centery,'descend');

    [~,ind] = sort(centery,'ascend');
    indBot = ind(1:2);
    indTop = ind(end-1:end);
    centery([indBot indTop]) = [];
    centerx([indBot indTop]) = [];
    % assign direction 
    for i = 1:nItems(j)
            ind = 2*i-1;
                x(ind) = centerx(i) + (Lbar/2)*cos(ori(i)*pi/180); % cos(0)=1 
                x(ind+1) =centerx(i) - (Lbar/2)*cos(ori(i)*pi/180);
                y(ind) = centery(i) + (Lbar/2)*sin(ori(i)*pi/180); % sin(0)=0
                y(ind+1) = centery(i) - (Lbar/2)*sin(ori(i)*pi/180);
%             if i == tarLoc(j) % 0->H (1,0) 1->V(0,1)
                % x(1,nitem*2), y(1,nitem*2) % (1,20)
%                 x(ind) = centerx(i) + (Lbar/2)*cos(tarOri(j)*pi/2); % cos(0)=1 
%                 x(ind+1) =centerx(i) - (Lbar/2)*cos(tarOri(j)*pi/2);
%                 y(ind) = centery(i) + (Lbar/2)*sin(tarOri(j)*pi/2); % sin(0)=0
%                 y(ind+1) = centery(i) - (Lbar/2)*sin(tarOri(j)*pi/2);
%                 x(ind) = centerx(i) + (Lbar/2)*cos(tarOri(j)*pi/180); % cos(0)=1 
%                 x(ind+1) =centerx(i) - (Lbar/2)*cos(tarOri(j)*pi/180);
%                 y(ind) = centery(i) + (Lbar/2)*sin(tarOri(j)*pi/180); % sin(0)=0
%                 y(ind+1) = centery(i) - (Lbar/2)*sin(tarOri(j)*pi/180);
%             else
% %                 templine1 = rand()>.5; % 1-V,o-H
% %                 templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
%                 x(ind) = centerx(i) + Lbar/2*sin(pi*disori(i)/180);
%                 x(ind+1) = centerx(i) - Lbar/2*sin(pi*disori(i)/180);
%                 y(ind) = centery(i) + Lbar/2*cos(pi*disori(i)/180);
%                 y(ind+1) = centery(i) - Lbar/2*cos(pi*disori(i)/180);
%             end
    
    
    end
    tarCenter(:,j) = [centerx(tarLocs(j));centery(tarLocs(j))];
    XY(:,:,j) = {[x;y]};
end

%%     
% testcircle(j,:) = [tarCenterX - sqrt(2)*Lbar/2, tarCenterY - sqrt(2)*Lbar/2,tarCenterX + sqrt(2)*Lbar/2,tarCenterY + sqrt(2)*Lbar/2];
%     tarHemi(j) = (tarCenterX>xCenter);
%% =====================         present     =====================
% open window
% draw & flip

% -------------------- open window --------------------
if visualize ==1
    q
    xy = XY{j};
    for i = 1:length(xy)/2
        Screen('DrawText', w, num2str(i), centerx(i), centery(i), [255 0 0])
        Screen('Flip',w,[],1)
    end
    Screen('DrawLines',w,[0 xCenter*2 xCenter xCenter; yCenter yCenter 0 yCenter*2],[],[255 255 255]'./2)
    Screen('Flip',w,[],1)


    % Screen('DrawDots', w, [centerx;centery], 10,[0 255 0]')
    % Screen('Flip',w,[],1)

    while 1
        a = randsample(disOri_type,7,1);
        if length(unique(a))==4% && sum(diff(a)
            break
        end
    end
end