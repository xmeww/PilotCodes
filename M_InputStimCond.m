function [paradigm] = M_InputStimCond
title = 'choose paradigm';
prompt(1,:) = {'paradigm :','paradigm',[]};
formats(3,3) = struct();
formats(1,1).type = 'list';
formats(1,1).style = 'radiobutton';
formats(1,1).format = 'text';
% formats(1,1).limits = [0 3];
formats(1,1).items = {'Aselect01_singleV01','Aselect01_multiV01_Time','Aselect01_multiV01_Ori';...
    'Vselect1_multiA01','Vselect01_multiA01','Vselect1_singleA01';...
    'AVredundant','Vselect_AsyncTarDis',''}';
% formats(1,1).span = [4 3];
% formats(1,2).callback = @(~,~,h,k)get(h(k),'String')
% formats.callback
% defAns(1).paradigm = 'Aselect_01_singleV';


options.CancelButton = 'on';
% Options.ApplyButton = 'on';
options.ButtonNames = {'Continue','Cancel'}; 
% options.AlignControls = 'on';
% [answer,cancelld] = inputsdlg(prompt,title,formats,defAns,options);
[answer,cancelld] = inputsdlg(prompt,title,formats,[],options);
paradigm = answer.paradigm;
