function [w,wrect,ifi,white,black] = m_openScreen(monitor,monitorMode)

screenNumber = max(Screen('Screens'));

if strcmp(monitor,'lab1')
   res = Screen('Resolution',screenNumber);
   res = [0,0,res.width,res.height]; 
elseif strcmp(monitor,'mac')
   res = get(0,'ScreenSize');
   res = [0 0 res(3:4)];
   
end

if strcmp(monitorMode, 'plain') %{'palin','small','trasnparent','screen-short'}
    clear Screen
    Screen('Preference', 'SkipSyncTests',0) 
elseif strcmp(monitorMode, 'transparent')
    PsychDebugWindowConfiguration 
    Screen('Preference', 'SkipSyncTests',1) 
else 
    Screen('Preference', 'SkipSyncTests',1) 
end

if strcmp(monitorMode,'small') %{'palin','small','trasnparent','screen-short'}
    wrect = res./2; 
    XY = XY./2;
else
    wrect = res;
end

screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber); % 1
black = BlackIndex(screenNumber); % 0
[w, wrect] = PsychImaging('OpenWindow', screenNumber,black,wrect);
Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[ifi]= Screen('GetFlipInterval', w, 100, 0.00005, 5);
Screen('TextFont', w, 'Arial');
Screen('TextSize', w, 23);
Screen('TextStyle', w, 1);