function [w,wrect,ifi,slack,white,black] = m_openScreen(monitor,monitorMode)

if strcmp(monitorMode, 'plain') %{'palin','small','trasnparent','screen-short'}
    Screen('Preference', 'SkipSyncTests',0) 
elseif strcmp(monitorMode, 'transparent')
    PsychDebugWindowConfiguration 
    Screen('Preference', 'SkipSyncTests',1) 
else 
    Screen('Preference', 'SkipSyncTests',1) 
end

screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber); % 1
black = BlackIndex(screenNumber); % 0
if strcmp(monitor,'Lab1') || strcmp(monitor,'Cubicle2')
   wrect = Screen('Resolution',screenNumber);
   wrect = [0,0,wrect.width,wrect.height]; 
elseif strcmp(monitor,'Macbook')
   wrect = get(0,'ScreenSize');
   wrect = [0 0 wrect(3) wrect(4)];
end
if strcmp(monitorMode,'small') %{'palin','small','trasnparent','screen-short'}
    wrect = wrect./2; 
end
[w, wrect] = PsychImaging('OpenWindow', screenNumber,black,wrect);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);   
%     [wx, wy] = Screen('WindowSize', w);
%     [xCenter, yCenter] = RectCenter(wrect);
ifi = Screen('GetFlipInterval',w);
Screen('TextFont',  w, 'Arial');
Screen('TextStyle', w, 0);% 0=normal, 1=bold, 2=italic, 4=underlin
slack = ifi/2;
topPriorityLevel = MaxPriority(w);
Priority(topPriorityLevel);