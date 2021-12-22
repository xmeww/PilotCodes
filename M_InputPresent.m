function [answer] = M_InputPresent
title = 'input infor';
prompt = {};
formats = {};
defAns = struct([]);

prompt(1,:) = {'Existed Data File','loadData',[]};
formats(1,1).type = 'edit';
formats(1,1).format = 'file';
formats(1,1).size = [-1 0];
formats(1,1).span = [1 3];  % item is 1 field x 3 fields
defAns(1).loadData = [pwd '/datasave'];
% {'*.bio','Biography File (*.bio)';'*.*','All Files'};
if ~exist([pwd '/datasave'])
    mkdir([pwd '/datasave'])
end

prompt(end+1,:) = {'Display Monitor :','monitor',[]};
formats(2,1).type = 'list';
formats(2,1).format = 'text';
formats(2,1).style = 'togglebutton';
formats(2,1).items = {'Lab1','Macbook','Cubicle2'};
defAns.monitor = 'Lab1';

prompt(end+1,:) = {'SyncTest Square','syncTest',[]};
formats(2,2).type = 'list';
formats(2,2).format = 'text';
formats(2,2).style = 'listbox';
formats(2,2).items = {'circle','square','none'};
formats(2,2).size = [100 50];
formats(2,2).limits = [0 3];
defAns.syncTest = {'circle','square'};

prompt(end+1,:) = {'Monitor Mode :','monitorMode',[]};
formats(2,3).type = 'list';
formats(2,3).format = 'text';
formats(2,3).style = 'popupmenu';
formats(2,3).items = {'plain','small','transparent','screen-short'};
formats(2,3).limits = [4 1];
defAns.monitorMode = 'plain';

prompt(end+1,:) = {'Collect Resp','collectRes',[]};
formats(2,4).type = 'check';
defAns.collectRes = true;

prompt(end+1,:) = {'disp Info/feedback','dispInfo',[]};
formats(2,5).type = 'list';
formats(2,5).format = 'text';
formats(2,5).style = 'popupmenu';
formats(2,5).items = {'no','before','after'};
defAns.dispInfo = 'no';

% ------------------------ 
prompt(end+1,:) = {'startBlock','startBlock',[]};
formats(3,1).type = 'edit';
formats(3,1).format = 'integer';
defAns.startBlock =1;

prompt(end+1,:) = {'nBlock','nBlock',[]};
formats(3,2).type = 'edit';
formats(3,2).format = 'integer';
defAns.nBlock =1;

prompt(end+1,:) = {'start trial','startTr',[]};
formats(3,3).type = 'edit';
formats(3,3).format = 'integer';
defAns.startTr = 1;

prompt(end+1,:) = {'ntrial','ntrialTest',[]};
formats(3,4).type = 'edit';
formats(3,4).format = 'integer';
defAns.ntrialTest = 0;

prompt(end+1,:) = {'subjID','subjID',[]};
formats(3,5).type = 'edit';
formats(3,5).format = 'integer';
defAns.subjID = 0;
% ------------
prompt(end+1,:) = {'Select stimuli File','loadstim',[]};
formats(4,1).type = 'edit';
formats(4,1).format = 'file';
formats(4,1).size = [-1 0];
formats(4,1).span = [1 3];  % item is 1 field x 3 fields
defAns.loadstim = [pwd '/workingdir'];
if ~exist([pwd '/workingdir'])
    mkdir([pwd '/workingdir'])
end

prompt(end+1,:) = {'Task :','task',[]};
formats(5,1).type = 'list';
formats(5,1).format = 'text';
formats(5,1).style = 'popupmenu';
formats(5,1).items = {'identify tar','ori disc','localization'};
defAns.task = 'identify tar';


% Prompt(8,:) = {'Select Input Files','loadfile',[]};
% Formats(3,1).type = 'edit';
% Formats(3,1).format = 'file';
% Formats(3,1).limits = [0 5]; % multi-select files
% Formats(3,1).size = [-1 -1];
% Formats(3,1).items = {'stim_*','Auction Item File';'*.*','All Files'};
% Formats(3,1).span = [1 3];  % item is 1 field x 3 fields
% DefAns.ItemFiles = files(3:end);
Options.Resize = 'on';
Options.Interpreter = 'tex';
Options.CancelButton = 'on';
% Options.ApplyButton = 'on';
Options.ButtonNames = {'Continue','Cancel'}; %<- default names, included here just for illustration

[answer] = inputsdlg(prompt,title,formats,defAns,Options);
return
