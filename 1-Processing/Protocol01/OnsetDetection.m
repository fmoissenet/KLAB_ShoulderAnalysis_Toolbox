% Author     :   F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   June 2022
% -------------------------------------------------------------------------
% Description:   To be defined
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = OnsetDetection(Trial,Rcycles,Lcycles,btype,manualCheck)

disp('  - Détection des onsets/offsets des signaux EMG');

% Frequency ratio between analogs and markers
fratio = Trial.fanalog/Trial.fmarker;

% Plot ylim
ylimit = 8e-4;

% Manual validation of EMG signal
iemg = 1;
while iemg < 15 % All EMG (right and left)
    % 0- Load EMG signal and baseline
    signal0 = filloutliers(squeeze(Trial.Emg(iemg).Signal.full),'nearest','mean',ThresholdFactor=5); % Remove outliers to avoid spikes
    % 0- Signal preprocessing
    % https://doi.org/10.1371/journal.pone.0237727 
    [B,A]  = butter(1,[10 500]./(Trial.fanalog/2),'bandpass');
    signal = filtfilt(B,A,signal0);  
    signal = abs(signal);
    envelop = interpft(rms2(signal,0.02*Trial.fanalog,0.01*Trial.fanalog,1),length(signal)); % Used to compute SNR
    [B,A]  = butter(1,2./(Trial.fanalog/2),'low');
    envelop2 = smoothdata(envelop,'gaussian',3*Trial.fanalog)'; % Used to compute signal peak
    if manualCheck == 1
        fig = figure('units','normalized','outerposition',[0 0 1 1]);
    %     ylim([-ylimit ylimit]);
        ylimit = max(signal);
        hold on;
        plot(signal0,'Color',[0.5 0.5 0.5]);
        plot(signal,'Color','blue');
        plot(envelop,'Color','green');
        plot(envelop2,'Color','magenta','LineWidth',2);
    end
    % Extended double thresholding algorithm
    % (Onset parameters optimisation)
    % https://doi.org/10.1016/j.jelekin.2019.06.010
    % 1- Baseline selection
    % a- Automatic selection
    if btype == 1
        Lb = 1*Trial.fanalog; % Optimised: 1s
        Kb = 5; % Rank 5
        for iframe = 1:fix(size(signal,1)*0.80)-Lb % 80% of the signal is analysed to avoid issue related to bad signal stop time
            mrect(iframe) = mean(signal(iframe:iframe+Lb-1));
        end
        srect = unique(mrect);
        fframe = 0;
        if length(srect) > 1
            for iframe = 1:size(signal,1)-Lb
                if mean(signal(iframe:iframe+Lb-1)) == srect(Kb)
                    fframe = iframe;
                    baseline = signal(iframe:iframe+Lb-1);
                end
            end
        else
            baseline = signal;
        end
        if manualCheck == 1
            plot(fframe:fframe+Lb-1,baseline,'red');
        end
    end
    % b- Manual selection
    if btype == 2
        [x,~] = ginput(2);
        baseline = signal(x(1):x(2));
    end
    % c- Baseline based on reference record
    if btype == 3
        % Same process as for the signal preprocessing
        baseline = squeeze(Trial.Emg(iemg).baseline); 
        [B,A]  = butter(1,[10 500]./(Trial.fanalog/2),'bandpass'); % Same as for the signal preprocessing
        baseline = filtfilt(B,A,baseline);
        baseline = abs(baseline);
    end
    % 2- First threshold using baseline parameters
    nsd = 3; % Optimised: 3 sd
    onset = zeros(size(signal));
    onset(abs(signal)>(mean(baseline)+nsd*std(baseline))) = 1;
    % 3- Second threshold using on time
    Ton = 0.004*Trial.fanalog; % Optimised: 0.004*Trial.fanalog
    ifinder = 0;
    finder = 0;
    for iframe = 1:size(onset,1)
        if onset(iframe) == 1 && finder == 0
            ifinder = iframe;
            finder = finder+1;
        elseif onset(iframe) == 1 && finder > 0
            finder = finder+1;
        elseif finder > 0 && onset(iframe) == 0
            if finder < Ton
                onset(ifinder:iframe) = 0;
            end
            ifinder = 0;
            finder = 0;
        end
    end
    % 4- Third threshold using off time
    Toff = 0.25*Trial.fanalog; % Optimised: 0.25s
    ifinder = 0;
    finder = 0;
    for iframe = 1:size(onset,1)
        if onset(iframe) == 0 && finder == 0
            ifinder = iframe;
            finder = finder+1;
        elseif onset(iframe) == 0 && finder > 0
            finder = finder+1;
        elseif finder > 0 && onset(iframe) == 1
            if finder < Toff
                onset(ifinder:iframe) = 1;
            end
            ifinder = 0;
            finder = 0;
        end
    end
    % 5- Prune short events
    Ts = 2*Trial.fanalog; % Optimised: 2s
    ifinder = 0;
    finder = 0;
    for iframe = 1:size(onset,1)
        if onset(iframe) == 1 && finder == 0
            ifinder = iframe;
            finder = finder+1;
        elseif onset(iframe) == 1 && finder > 0
            finder = finder+1;
        elseif finder > 0 && onset(iframe) == 0
            if finder < Ts
                onset(ifinder:iframe) = 0;
            end
            ifinder = 0;
            finder = 0;
        end
    end
    % Signal-to-noise ratio
    % https://doi.org/10.1109/TLA.2018.8528223
    snrThreshold = 12; % dB % Optimised: 12 dB
    MT  = rms(envelop(find(onset==1)));
    MN  = rms(envelop(find(onset==0)));
    SNR = abs(20*log(MT/MN));
    Trial.Emg(iemg).SNR = SNR;
    if SNR < snrThreshold
        onset = zeros(size(onset));
    end
    % Signal amplitude threshold
    % https://doi.org/10.1523/JNEUROSCI.1327-05.2005
    amplitudeThreshold = 0.2*1e-6; % uv, 1e-6 v % Optimised: 0.2*1e-6 uV
    meansignal = mean(signal);
    Trial.Emg(iemg).signalMean = meansignal;
    if meansignal < amplitudeThreshold
        onset = zeros(size(onset));
    end
    % Complete plot    
    if manualCheck == 1
        title([Trial.Emg(iemg).label,', SNR: ',num2str(SNR),' dB',', Mean: ',num2str(meansignal),' uv']);    
        line([1 size(signal,1)],[mean(baseline)+nsd*std(baseline) mean(baseline)+nsd*std(baseline)],'Color','red','Linestyle','-');
        ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
    end
    % Store results
    Trial.Emg(iemg).Signal.filtrect(:,:,:) = permute(signal,[2,3,1]);
    Trial.Emg(iemg).Signal.envelop(:,:,:)  = permute(envelop2,[2,3,1]);
    Trial.Emg(iemg).Signal.onset(:,:,:)    = permute(onset,[2,3,1]);
    % Manual validation
    if manualCheck == 1
        if iemg < 8 % Right side EMG
            for icycle = 1:size(Rcycles,2)
                [vmax,imax] = max(envelop2(Rcycles(icycle).range*fratio));
                plot((Rcycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
                rectangle('Position',[Rcycles(icycle).range(1)*fratio 0 length(Rcycles(icycle).range)*fratio max(signal0)],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
                title('Y > 0 : Onset accepté, Y < 0 : Onset refusé');
                [~,y] = ginput(1);
                if y < 0 % Manual onset definition
                    title('Y > 0 : Région à remettre à zéro, Y < 0 : Onset refusé');
                    [x,y] = ginput(2);
                    if y(1) > 0 % New detection
                        Trial.Emg(iemg).Signal.onset(:,:,x(1):x(2)) = 0; % Clean onset
                        onset(x(1):x(2)) = 0; % Clean onset
                        delete(ponset);
                        ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                        drawnow;
                        title('Sélectionner le début et fin du nouvel onset');
                        [x,y] = ginput(2);
                        if y(1) > 0 % New detection
                            Trial.Emg(iemg).Signal.onset(:,:,x(1):x(2)) = 1; % Update onset
                            onset(x(1):x(2)) = 1; % Update onset
                            delete(ponset);
                            ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                            drawnow;
                        end
                    else % No signal
                        Trial.Emg(iemg).Signal.envelop(:,:,Rcycles(icycle).range) = NaN;
                        Trial.Emg(iemg).Signal.onset(:,:,Rcycles(icycle).range) = NaN;
                        onset(Rcycles(icycle).range) = NaN;
                        delete(ponset);
                        ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                        drawnow;
                    end
                end
            end
            close(fig);
        elseif iemg > 7 % Left side EMG
            for icycle = 1:size(Lcycles,2)
                [vmax,imax] = max(envelop2(Lcycles(icycle).range*fratio));
                plot((Lcycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
                rectangle('Position',[Lcycles(icycle).range(1)*fratio 0 length(Lcycles(icycle).range)*fratio max(signal0)],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
                [~,y] = ginput(1);
                if y < 0 % Manual onset definition
                    title('Y > 0 : Région à remettre à zéro, Y < 0 : Onset refusé');
                    [x,y] = ginput(2);
                    if y(1) > 0 % New detection
                        Trial.Emg(iemg).Signal.onset(:,:,x(1):x(2)) = 0; % Clean onset
                        onset(x(1):x(2)) = 0; % Clean onset
                        delete(ponset);
                        ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                        drawnow;
                        title('Sélectionner le début et fin du nouvel onset');
                        [x,y] = ginput(2);
                        if y(1) > 0 % New detection
                            Trial.Emg(iemg).Signal.onset(:,:,x(1):x(2)) = 1; % Update onset
                            onset(x(1):x(2)) = 1; % Update onset
                            delete(ponset);
                            ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                            drawnow;
                        end
                    else % No signal
                        Trial.Emg(iemg).Signal.envelop(:,:,Lcycles(icycle).range) = NaN;
                        Trial.Emg(iemg).Signal.onset(:,:,Lcycles(icycle).range) = NaN;
                        onset(Lcycles(icycle).range) = NaN;
                        delete(ponset);
                        ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                        drawnow;
                    end
                end
            end
            close(fig);
        end
    end
    iemg = iemg+1;
    
    % Clean workspace
    clearvars -except Trial Rcycles Lcycles iplot fratio iemg btype ylimit manualCheck;
end