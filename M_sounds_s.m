function [FGsounds,BGsounds] = M_sounds_s(nintvs,n_c_max,ramp_t,Ffg,Fbg,nfig,coh_levels,ntrials,nFigChord,figOnly,preCyc_int,cond)

% nintv_tr  =180;
% n_c_max = 20;
% ramp_t = 5;
% nfig =4;
% coh_levels = [6,10];
% nFigChord = 3;
% preCyc_int =10;
% ntrials =1;
% figOnly = [0];
% load example_selectF.mat
visualize =0;

  
dur_burst = 50;
srate=44100;   
t=[0:1/srate:dur_burst/1000]; 
%% fg sound
FGsounds = nan(nfig,nFigChord*length(t),length(coh_levels));
for i = 1:length(coh_levels)
%     if i ==1
%         Ffg = FfgL; % 4x6
%     elseif i == 2
%         Ffg = FfgH;% 4x10
%     end
    for n = 1:nfig

        ffg = Ffg(n,:);
        waves_1chord = [];
%-------------------------  make wave of each tone of one  chord ,scale

        for m = 1:length(ffg)


            waves_1chord=[waves_1chord;(0.2/n_c_max)*sin(2*pi*ffg(m)*t)];
            % ------ draw an example  --------
            if  visualize ==1 && n==1
                subplot(length(ffg),1,m)
                plot(waves_1chord(m,:))
                title(sprintf('Frequncy: %d',ffg(m)));
            end 
           
        end
        
 
 % -----------------------------  sum tones of one chord, and ramp 
        
        sumwave_1chord = sum(waves_1chord,1);
        [wave_1chord_wind,~,~] = wind(srate,ramp_t,sumwave_1chord);
        
        if visualize == 1
            figure
           subplot(2,1,1)
           plot(sumwave_1chord)
           subplot(2,1,2)
           plot(wave_1chord_wind)
        end
        
 % ----------------------------- repeat chords 3 times resulting one figure        
        FGsounds(n,:,i) = repmat(wave_1chord_wind,1,3);

    end
end 

%% bg sound 
BGsounds = nan(2,(preCyc_int+nintvs)*length(t),ntrials);

for n =1:length(cond)
    j = cond(n);
    wave_chords_1tr = [];
    if figOnly(j)~=1
        for intv= 1:preCyc_int+nintvs 

            fbg = Fbg{j,intv};

            waves_1chord = [];

            for m = 1:length(fbg)
                waves_1chord=[waves_1chord;(0.2/n_c_max)*sin(2*pi*fbg(m)*t)];

            end
            sumwave_1chord = sum(waves_1chord,1);

            [wave_1chord_wind,~,~] = wind(srate,ramp_t,sumwave_1chord);
            wave_chords_1tr = [wave_chords_1tr wave_1chord_wind];
        end
            BGsounds(:,:,j) = [wave_chords_1tr;wave_chords_1tr];

    end
end
%%
if visualize==1
    if intv == nintvs 
        figure
        for m = 1:length(fbg)
            subplot(length(fbg),1,m)
            plot(waves_1chord(m,:));
        end 

        figure
        plot(sumwave_1chord);
         title('sumed one chord')
%%        



        figure
        plot(wave_1chord_wind);
        title('winded one chord winded ')


        figure
        plot(wave_chords_1tr);
        title('one trial ')
    end
end


