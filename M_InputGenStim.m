function [answer,paradigm] = M_InputGenStim
[paradigm] = M_InputStimCond;

load('clr_blue.mat');

title = 'stimuli generation';
prompt = {};
formats = {};
defAns = struct([]);

% [n1 n2 n3 n4 n5 n6 ] = deal(1:6)
prompt(1,:) = {'Monitor :','monitor',[]};
formats(1,1).type = 'list';
formats(1,1).style = 'togglebutton';
formats(1,1).format = 'text';
formats(1,1).items = {'Lab1','Macbook'};
formats(1,1).size = 130;
defAns(1).monitor = 'Lab1';

% prompt(end+1,:) = {'paradigm :','paradigm',[]};
% formats(1,2).type = 'list';
% formats(1,2).style = 'popupmenu';
% formats(1,2).format = 'text';
% formats(1,2).limits = [0 3];
% formats(1,2).items = {'Aselect_singleV','Aselect','Vselect','AVredundant'};
% formats(1,2).size = 130;
% % formats(1,2).callback = @(~,~,h,k)get(h(k),'String')
% % formats.callback
% defAns.paradigm = 'Aselect';
% if strcmp(formats(1,2).items,'Aselect_singleV')
%     defAns.nitemChg_type = 0;
%     defAns.nItem_levels= 1;
% else 
%     defAns.nitemChg_type = [1,2,3,1,2,4,1,3,5];
%     defAns.nItem_levels= 16:4:24;
% end


prompt(end+1,:) = {['Exp Design'],[],[]};
formats(2,1).type = 'text';
formats(2,1).size = [-1 0];
% formats(2,1).span = [1 2]; % item is 1 field x 4 fields

prompt(end+1,:) = {'condition rep :','condRep',[]};
% formats(2,1).type = 'list';
% formats(2,1).style = 'popupmenu';
% formats(2,1).items = {'150-rand-100(VanderBurg)','150-ran-150','150-150-150'};
formats(3,1).type = 'edit';
formats(3,1).format = 'integer';
formats(3,1).size = 30;
defAns.condRep = 10;

prompt(end+1,:) = {'trial order','trOrd',[]};
formats(3,2).type = 'list';
formats(3,2).style = 'popupmenu';
formats(3,2).items = {'order','random'};
formats(3,2).size = 100;

prompt(end+1,:) = {'block Rep :','blockRep',[]};
% formats(2,1).type = 'list';
% formats(2,1).style = 'popupmenu';
% formats(2,1).items = {'150-rand-100(VanderBurg)','150-ran-150','150-150-150'};
formats(3,3).type = 'edit';
formats(3,3).format = 'integer';
formats(3,3).size = 50;
defAns.blockRep = 1;

prompt(end+1,:) = {'n cycle:','ncycle',[]};
% formats(2,1).type = 'list';
% formats(2,1).style = 'popupmenu';
% formats(2,1).items = {'150-rand-100(VanderBurg)','150-ran-150','150-150-150'};
formats(3,4).type = 'edit';
formats(3,4).format = 'integer';
formats(3,4).size = 50;
defAns.ncycle = 10;


prompt(end+1,:) = {'temporal design :','t_preTpost',{'(IFIs)'}};
% formats(2,1).type = 'list';
% formats(2,1).style = 'popupmenu';
% formats(2,1).items = {'150-rand-100(VanderBurg)','150-ran-150','150-150-150'};
formats(3,5).type = 'edit';
formats(3,5).format = 'vector';
formats(3,5).limits = {'row'};
defAns.t_preTpost = [0 9 0];
formats(3,5).size = 100;

prompt(end+1,:) = {'V Stim design:',[],[]};
formats(4,1).type = 'text';
formats(4,1).size = [-1 0];
% Formats(1,1).span = [1 2]; % item is 1 field x 4 fields

prompt(end+1,:) = {'nitem change :','nitemChg_type',[]};
% formats(2,1).type = 'list';
% formats(2,1).style = 'popupmenu';
% formats(2,1).items = {'150-rand-100(VanderBurg)','150-ran-150','150-150-150'};
formats(5,1).type = 'edit';
formats(5,1).format = 'vector';
formats(5,1).limits = {'row'};
% formats(5,1).enable = 'inactive';
% formats(5,1).span = [1 3];
if strcmp(paradigm,'Aselect01_singleV01')
    defAns.nitemChg_type = 0;
else
    defAns.nitemChg_type = [1,2,3,1,2,3,1,2,3];
end
formats(5,1).size = [150 50];

prompt(end+1,:) = {'Vsize','nItem_levels',[]};
formats(5,2).type = 'edit';
formats(5,2).format = 'vector';
formats(5,2).limits = {'row'};
formats(5,2).size = 100;
% formats(5,2).enable = 'inactive';
if strcmp(paradigm,'Aselect01_singleV01')
    defAns.nItem_levels = 1;  
else 
    defAns.nItem_levels = [8,16];
end

prompt(end+1,:) = {'color1','clr1',[]};
formats(5,3).type = 'color';
formats(5,3).style = 'pushbutton';
defAns.clr1 = lgtBlue;

prompt(end+1,:) = {'color2','clr2',[]};
formats(5,4).type = 'color';
formats(5,4).style = 'pushbutton';
defAns.clr2 = drkBlue;

prompt(end+1,:) = {['Aud Stim Design'],[],[]};
formats(6,1).type = 'text';
formats(6,1).size = [-1 0];
% Formats(1,1).span = [1 2]; % item is 1 field x 4 fields


prompt(end+1,:) = {'nbg levels','nbg_levels',{'(randomly)'}};
formats(7,1).type = 'edit';
formats(7,1).format = 'vector';
formats(7,1).limits = {'row'};
formats(7,1).size = 100;
if strcmp(paradigm,'Vselect1_singleA01')
    defAns.nbg_levels= [];
else
    defAns.nbg_levels= 5:15;
end


prompt(end+1,:) = {'coh levels','coh_levels',[]};
formats(7,2).type = 'edit';
formats(7,2).format = 'vector';
formats(7,2).limits = {'row'};
formats(7,2).size = 100;
% if strcmp(paradigm,'Vselect1_singleA01')
%     defAns.coh_levels = 0;
% else
    defAns.coh_levels = [6 10];
% end

prompt(end+1,:) = {'chord dur','ifi_chord',{'(IFIs)'}};
formats(7,3).type = 'edit';
formats(7,3).format = 'float';
formats(7,3).size = 50;
defAns.ifi_chord= 3; % ~50ms

prompt(end+1,:) = {'ramp dur','durRamp',{'(s)'}};
formats(7,4).type = 'edit';
formats(7,4).format = 'float';
formats(7,4).size = 50;
defAns.durRamp = 0.005; % 

prompt(end+1,:) = {'bg type','bgType',[]};
formats(7,5).type = 'list';
formats(7,5).style = 'popupmenu';
formats(7,5).items = {'random','fixed'};
formats(7,5).format = 'text';
formats(7,5).size = 130;
defAns.bgType = 'random';

prompt(end+1,:) = {'noise comp max','n_c_max',[]};
formats(8,1).type = 'edit';
formats(8,1).format = 'integer';
formats(8,1).size = 50;
defAns.n_c_max = max(defAns.nbg_levels); 

prompt(end+1,:) = {'sound norm method','normMethod',[]};
formats(8,2).type = 'list';
formats(8,2).style = 'popupmenu';
formats(8,2).format = 'text';
formats(8,2).items = {'nbg_max','sound_max'};
formats(8,2).size = 130;
defAns.normMethod = 'nbg_max';

prompt(end+1,:) = {'sample method','sample_meth',[]};
formats(8,3).type = 'list';
formats(8,3).style = 'popupmenu';
formats(8,3).items = {'makebeep','Teki'};
formats(8,3).format = 'text';
formats(8,3).size = 130;
defAns.sample_meth = 'makebeep';

prompt(end+1,:) = {'sound target dur','tardur',{'ifi'}};
formats(8,4).type = 'edit';
formats(8,4).format = 'float';
formats(8,4).size = 50;
defAns.tardur = 9; 

prompt(end+1,:) = {'catch trial','pC',{'%'}};
formats(8,5).type = 'edit';
formats(8,5).format = 'float';
formats(8,5).size = 50;
defAns.pC = 14; 

prompt(end+1,:) = {'savestim','savefile',[]};
formats(9,1).type = 'edit';
formats(9,1).format = 'text';
formats(9,1).size = [-1 0];
formats(9,1).span = [1 3];  % item is 1 field x 3 fields
defAns.savefile = [pwd '/workingdir/' paradigm '/.mat'];

options.Resize = 'on';
options.Interpreter = 'tex';
options.CancelButton = 'on';
% Options.ApplyButton = 'on';
options.ButtonNames = {'Continue','Cancel'}; 

[answer,cancelld] = inputsdlg(prompt,title,formats,defAns,options);

