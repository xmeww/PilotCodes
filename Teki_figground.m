% creat figure stimuli
% put all figure stimuli each generated from coherence_gen to one list
function sig=figground(initL,midL,finL,initC,midC,finC)

n_bursts=   [initL midL finL];           % number of bursts in the first,second and third segments respectively
                                         % actually, duration 
pc_coh =    [initC midC finC];           % Percentage coherence in each chord
                                         % basically, coherence
n_c     =   [10 10 10];                  % number of components in each chord,coherence_gen use 5~15
dur_burst = [50 50 50];                  % duration of each chord
srate=44100;

allsig=[];

for k=1:length(n_bursts) % 3, ground-figure-ground
    
    [sig]=coherence_gen(5,15,n_bursts(k),dur_burst(k),pc_coh(k));
    allsig=[allsig sig]; % all 3 segments after loop
    
end

sig=allsig;

% wavwrite(sig,'sig_fig');
