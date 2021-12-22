% creat ground stimuli
% generate single ground stimulus
function sig=Teki_figground_rand(initL,midL,finL,initC,midC,finC)

n_bursts=   [initL midL finL];          % number of bursts in the first,second and third segments respectively
pc_coh =    [initC midC finC];          % Percentage coherence in each segment
n_c     =   [10 10 10];                 % number of components in each chord
dur_burst = [50 50 50];                 % duration of each chord
srate=44100;

allsig=[];

for k=1:length(n_bursts)
    
    [sig]=coherence_gen_rand(5,15,n_bursts(k),dur_burst(k),pc_coh(k));
    allsig=[allsig sig];  % 25 frequencies [[(15~20)*t] [(2-7)*t][(25-)*t]]
    
end

sig=allsig; % all chords across three segments, sum(scaled sin(wt))?

%    wavwrite(sig,'sig_gnd');

