function [FGsounds,BGsounds,Presounds] = M_sounds(nintv_tr,n_c_max,ramp_t,Ffg6,Ffg10,Fbg,Fpre,nfig,coh_levels,dur_burst,preCyc_int,ntrials)
% dur_burst = 50;
srate=44100;   
t=[0:1/srate:dur_burst/1000]; 
% nintv_tr  =180;
% n_c_max = 20;
% ramp_t = 5;
% nfig =4;
% coh_levels = [6,10];
visualize =0;
%% fg sound
FGsounds = nan(nfig,3*length(t),2);
for i = 1:length(coh_levels)
    if i ==1
        Ffg = Ffg6;
    elseif i == 2
        Ffg = Ffg10;
    end
    for n = 1:nfig
%         n=1
        ffg = Ffg(n,:);
        waves_1chord = [];
%         for m = 1:length(fbg)
%             waves_1chord=[waves_1chord;sin(2*pi*fbg(m)*t)];
%         end
%         wave_1chord = sum(waves_1chord,1);
%         wave_1chord_scl = wave_1chord./max(wave_1chord);
%         [wave_1chord_scl_wind,~,~] = wind(srate,ramp_t,wave_1chord_scl);
        for m = 1:length(ffg)
%             m=1
            waves_1chord=[waves_1chord;(0.2/n_c_max)*sin(2*pi*ffg(m)*t)];
           
        end
        wave_1chord = sum(waves_1chord,1);
%%       
        [wave_1chord_wind,~,~] = wind(srate,ramp_t,wave_1chord);
        FGsounds(n,:,i) = repmat(wave_1chord_wind,1,3);
    end
end 
if visualize ==1
    % close all
    for i = 1:length(coh_levels)
        figure('Name',['coh',num2str(coh_levels(i))])
        for n = 1:nfig
            subplot(nfig,1,n)
            plot(FG(2*n,:,i))
        end
    end
end
% n = 4;
% i = 2;
% Snd('Play',FG(2*n-1:2*n,:,i))
%% bg sound 
BGsounds = nan(2,nintv_tr*length(t),ntrials);

for j =1:ntrials
    wave_chords_1tr = [];

    for intv= 1:nintv_tr 
       
        fbg = Fbg{j,intv};
        
        waves_1chord = [];
%         for m = 1:length(fbg)
%             waves_1chord=[waves_1chord;sin(2*pi*fbg(m)*t)];
%         end
%         wave_1chord = sum(waves_1chord,1);
%         wave_1chord_scl = wave_1chord./max(wave_1chord);
%         [wave_1chord_scl_wind,~,~] = wind(srate,ramp_t,wave_1chord_scl);
        for m = 1:length(fbg)
            waves_1chord=[waves_1chord;(0.2/n_c_max)*sin(2*pi*fbg(m)*t)];
           
        end
        wave_1chord = sum(waves_1chord,1);
%%       
        [wave_1chord_wind,~,~] = wind(srate,ramp_t,wave_1chord);
        wave_chords_1tr = [wave_chords_1tr wave_1chord_wind];
        
        if visualize==1
            if intv == nintv_tr 
                figure
                for m = 1:length(fbg)
                    subplot(length(fbg),1,m)
                    plot(waves_1chord(m,:));
                end 

                figure
                plot(wave_1chord);
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
    end       
    BGsounds(:,:,j) = [wave_chords_1tr;wave_chords_1tr];
end

%%
Presounds = nan(2,preCyc_int*length(t),ntrials);

for j =1:ntrials
    wave_chords_1tr = [];

    for intv= 1:preCyc_int
       
        fbg = Fpre{j,intv};
        
        waves_1chord = [];
%         for m = 1:length(fbg)
%             waves_1chord=[waves_1chord;sin(2*pi*fbg(m)*t)];
%         end
%         wave_1chord = sum(waves_1chord,1);
%         wave_1chord_scl = wave_1chord./max(wave_1chord);
%         [wave_1chord_scl_wind,~,~] = wind(srate,ramp_t,wave_1chord_scl);
        for m = 1:length(fbg)
            waves_1chord=[waves_1chord;(0.2/n_c_max)*sin(2*pi*fbg(m)*t)];
           
        end
        wave_1chord = sum(waves_1chord,1);
%%       
        [wave_1chord_wind,~,~] = wind(srate,ramp_t,wave_1chord);
        wave_chords_1tr = [wave_chords_1tr wave_1chord_wind];
        
    end
    Presounds(:,:,j) = [wave_chords_1tr;wave_chords_1tr];
end
%  Snd('Play', BGsounds(:,:,1))
 
 
 