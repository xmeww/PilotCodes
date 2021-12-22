%% coordinate 
% all trials has fix and positions <--- if nitem is fixed
% each trial, target location is fix, ntrials contains n 
% other position just change orientation (x,y start and end coordinate) 

% =====input:===== 
% for fixation:xCenter, yCenter, Rfix,
% for bars: ntrial,nitem(displayed,exluded most lr),Rroute, Rbar
% for target: tarOri => 1 x ntrial, target orientation, = triallist(:,2)
% for test circle: VARtestcircle,VAWtestcircle, radius/diameter and width of test cielce 

% ========output: =====
% - XY {2,nitems*2,ntrial}  1st row x, 2nd row y, col: start,end ...
% - fixbars(4,4) , x/y start/end coordinate of fixation cross
% - tarCoord (2,ntrial),  1st row target x, 2nd row target y
% - tarHemi(ntrial,1), 1-r,0-l

% -----XY for 'DrawLines'----
% "xy" is a two-row vector containing the x and y coordinates of the line
% segments: Pairs of consecutive columns define (x,y) positions of the starts and
% ends of line segments. 
% All positions are relative to "center" (default center is [0 0]). 
% -XY contains each bar start&end coordiantes in each
% trial(center coordinate is fixed, start/end point change across trials)

%% input parameters
% clear all;
function [XY,tarCenterXY,tarHemi,testcircle] = M_coordinate_0(Rroute,Lbar,xpixels,ypixels,tilt,Vpresent,ntrials,nItem,tarLoc,tarOri,paradigm)
%[tarLoc,XY,fixbars,hemiTar,testcircle,Wtestcircle] = M_coordinate(ntrial,nitems,xpixels,ypixels,vdist,cwidth,tarLoc,tarOri_trials,VAbar,...
%    tilt,VARroute,VAWtestcircle,fixangle)
% 'centerx','centery'
% tarLoc -> color, sound
% 
rng('shuffle'); 
%% built-in parameter 
% visual angle to pixel size 

xCenter = xpixels/2;
yCenter = ypixels/2;
% % for test, add circle around target

%% output
% fixbars = [xCenter-Rbar/2*cos(fixangle),xCenter+Rbar/2*cos(fixangle),xCenter-Rbar/2*cos(fixangle),xCenter+Rbar/2*cos(fixangle);...
%            yCenter-Rbar/2*sin(fixangle),yCenter+Rbar/2*sin(fixangle),yCenter+Rbar/2*sin(fixangle),yCenter-Rbar/2*sin(fixangle)]; % center -/+ fixation/2
% fixbars = [xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle),xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle);...
%            yCenter-Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter-Lfix/2*cos(fixangle)]; % center -/+ fixation/2

tarHemi= nan(ntrials,1);
tarCenterXY = nan(2,ntrials);
testcircle = nan(ntrials,4);
discircle = nan(ntrials,4);
XY = {};
if strcmp(paradigm,'Aselect01_singleV01')
    tarCenterXY = [xCenter,yCenter];
% % for test, add circle around target
    [tarHemi,testcircle]= deal([]);
%% output
% fixbars = [xCenter-Rbar/2*cos(fixangle),xCenter+Rbar/2*cos(fixangle),xCenter-Rbar/2*cos(fixangle),xCenter+Rbar/2*cos(fixangle);...
%            yCenter-Rbar/2*sin(fixangle),yCenter+Rbar/2*sin(fixangle),yCenter+Rbar/2*sin(fixangle),yCenter-Rbar/2*sin(fixangle)]; % center -/+ fixation/2
% fixbars = [xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle),xCenter-Lfix/2*sin(fixangle),xCenter+Lfix/2*sin(fixangle);...
%            yCenter-Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter+Lfix/2*cos(fixangle),yCenter-Lfix/2*cos(fixangle)]; % center -/+ fixation/2
    for j = 1:ntrials
        tarori = tarOri(j);
    
    
        x = nan(1,2);
        y = nan(1,2);
        % tarOri 0-H,1-V 
        x(1,1) = xCenter + (Lbar/2)*cos(tarori*pi/2); % cos(0)=1,cos(pi/2)=0 
        x(1,2) = xCenter - (Lbar/2)*cos(tarori*pi/2);
        y(1,1) = yCenter + (Lbar/2)*sin(tarori*pi/2); % sin(0)=0
        y(1,2) = yCenter - (Lbar/2)*sin(tarori*pi/2);

        XY(:,:,j) = {[x;y]};
    end
elseif strcmp(paradigm,'Aselect01_multiV01_Time')
    for j = 1:ntrials
        vpresent = Vpresent(j);
        x = [];
        y = [];
        nitem = nItem(j);


        [centerx,centery] = deal(nan(1,nitem)); % all bar on circle including most left and right ones

        centerx=    xCenter +  Rroute*sin((([1:nitem]+0.5)/nitem) * 2 *pi); % 
        centery=    yCenter +  Rroute*cos((([1:nitem]+0.5)/nitem) * 2 *pi);
        
        if vpresent ==1
            tarloc = tarLoc(j);
            tarCenterX = centerx(tarloc);
            tarCenterY = centery(tarloc);
            tarCenterXY(:,j) = [tarCenterX;tarCenterY];
            testcircle(j,:) = [tarCenterX - sqrt(2)*Lbar/2, tarCenterY - sqrt(2)*Lbar/2,tarCenterX + sqrt(2)*Lbar/2,tarCenterY + sqrt(2)*Lbar/2];

        end
        for i = 1:nitem
            ind = 2*i-1;

            templine1 = rand()>.5;
            templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
            x(ind) = centerx(i) + Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
            x(ind+1) = centerx(i) - Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
            y(ind) = centery(i) + Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
            y(ind+1) = centery(i) - Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
            
            
%             templine1 = tarori;   % 1-V,0-H               
%             templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
%             x(ind) = centerx(i) + Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
%             x(ind+1) = centerx(i) - Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
%             y(ind) = centery(i) + Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
%             y(ind+1) = centery(i) - Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);

        end
        XY(:,:,j) = {[x;y]};
    end
    
    
else
    for j = 1:ntrials
        tarori = tarOri(j);
        vpresent = Vpresent(j);
        x = [];
        y = [];
        nitem = nItem(j);


        [centerx,centery] = deal(nan(1,nitem)); % all bar on circle including most left and right ones

        centerx=    xCenter +  Rroute*sin((([1:nitem]+0.5)/nitem) * 2 *pi); % 
        centery=    yCenter +  Rroute*cos((([1:nitem]+0.5)/nitem) * 2 *pi);
       
        % ith item,randi(nitem,[1,ntrial]), randperm(nitem,ntrial)
    % center coordinate of bars 
        if vpresent ==1
            tarloc = tarLoc(j);
            

            tarCenterX = centerx(tarloc);
            tarCenterY = centery(tarloc);
            
            
            
            tarCenterXY(:,j) = [tarCenterX;tarCenterY];
            testcircle(j,:) = [tarCenterX - sqrt(2)*Lbar/2, tarCenterY - sqrt(2)*Lbar/2,tarCenterX + sqrt(2)*Lbar/2,tarCenterY + sqrt(2)*Lbar/2];
        
            
            tarHemi(j) = (tarCenterX>xCenter);
        % erase extreme left and right



            for i = 1:nitem
                ind = 2*i-1;
                if i == tarloc % 0->H (1,0) 1->V(0,1)
                    % x(1,nitem*2), y(1,nitem*2) % (1,20)
                    x(ind) = centerx(i) + (Lbar/2)*cos(tarori*pi/2); % cos(0)=1 
                    x(ind+1) =centerx(i) - (Lbar/2)*cos(tarori*pi/2);
                    y(ind) = centery(i) + (Lbar/2)*sin(tarori*pi/2); % sin(0)=0
                    y(ind+1) = centery(i) - (Lbar/2)*sin(tarori*pi/2);
                else
                    templine1 = rand()>.5;
                    templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
                    x(ind) = centerx(i) + Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
                    x(ind+1) = centerx(i) - Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
                    y(ind) = centery(i) + Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
                    y(ind+1) = centery(i) - Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);


        %             templine1 = tarori;   % 1-V,0-H               
        %             templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
        %             x(ind) = centerx(i) + Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
        %             x(ind+1) = centerx(i) - Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
        %             y(ind) = centery(i) + Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
        %             y(ind+1) = centery(i) - Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
                end
            end
            XY(:,:,j) = {[x;y]}; % drawlines, "xy" is a two-row vector containing the x and y coordinates of the line
                                % segments: Pairs of consecutive columns define (x,y) positions of the starts and
                                % ends of line segments.
    elseif vpresent == 0
            
        for i = 1:nitem
            ind = 2*i-1;

            templine1 = rand()>.5;
            templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
            x(ind) = centerx(i) + Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
            x(ind+1) = centerx(i) - Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
            y(ind) = centery(i) + Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
            y(ind+1) = centery(i) - Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
            
            
%             templine1 = tarori;   % 1-V,0-H               
%             templine2 = ((rand()>.5) -0.5)*2; % 1 -add,0-minus
%             x(ind) = centerx(i) + Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
%             x(ind+1) = centerx(i) - Lbar/2*cos(templine1*pi/2+templine2*tilt/180*pi);
%             y(ind) = centery(i) + Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);
%             y(ind+1) = centery(i) - Lbar/2*sin(templine1*pi/2+templine2*tilt/180*pi);


        end
        XY(:,:,j) = {[x;y]};
    end

    % testcircle(:,1) = tarCenterX - sqrt(2)*Lbar/2 ;
    % testcircle(:,2) = tarCenterY - sqrt(2)*Lbar/2 ;
    % testcircle(:,3) = tarCenterX + sqrt(2)*Lbar/2 ;
    % testcircle(:,4) = tarCenterY +  sqrt(2)*Lbar/2 ;
    % Screen('FrameOval', windowPtr [,color] [,rect] [,penWidth] [,penHeight] [,penMode]);
    %     circXY(j,1) = tarX - Rcircle; upper left 
    %     circXY(j,2) = tarY - Rcircle;
    %     circXY(j,3) = tarX + Rcircle; lower right
    %     circXY(j,4) = tarY + Rcircle;
    % save XY.mat XY % (2,nitem*2,ntrial)
    % save fixbars.mat fixbars %(1,1)
    % save testcircle.mat testcircle % (ntrial,4)
    % save tarLoc.mat tarLoc %(1,ntrial)


    % save('workingdir/coordinate.mat','XY','fixbars','tarLoc','centerx','centery','centerTar','Wtestcircle','testcircle')
    % m_coordinate.tarLoc = tarLoc;
    % m_coordinate.XY = XY;
    % m_coordinate.fixbars  = fixbars;
    % m_coordinate.centerTar = centerTar;
    % m_coordinate.testcircle = testcircle;
    % m_coordinate.Wtestcircle = Wtestcircle;
    end
end