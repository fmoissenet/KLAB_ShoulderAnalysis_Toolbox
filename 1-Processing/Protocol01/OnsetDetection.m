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

function Trial = OnsetDetection(Trial,Rcycles,Lcycles,btype)

% Frequency ratio between analogs and markers
fratio = Trial.fanalog/Trial.fmarker;

% Manual validation of EMG signal
iemg = 1;
while iemg < 15 % All EMG (right and left)

    % Rashid et al. 2019
    % 0- Load EMG signal and baseline
    signal = squeeze(Trial.Emg(iemg).Signal.full);  
    signal0 = signal;
    % 0- Signal preprocessing
    %    Zero-phase bandpass filter 10-100 Hz using a 2th order Butterworth filter
    [B,A]  = butter(3,[30 300]./(Trial.fanalog/2),'bandpass');
    signal = filtfilt(B,A,signal);
    [B,A]  = butter(1,50./(Trial.fanalog/2),'low');
    envelop = filtfilt(B,A,abs(signal)); % Only used for SNR computation
    smax = max(signal);
    [~,signal] = energyop(signal);
    signal = abs(signal*smax/max(signal));
    % 0- Plot
    fig = figure('Position',[200 300 1200 400]);
    hold on;
    plot(signal0,'Color','blue');
    % 1- Baseline selection
    % a- Automatic selection
    if btype == 1
        Lb = 0.15*Trial.fanalog; % 0.15 s expressed in frames
        Kb = 5; % Rank 5
        for iframe = 1:fix(size(signal,1)*0.80) % 80% of the signal is analysed to avoid issue related to bad signal stop time
            mrect(iframe) = mean(abs(signal(iframe:iframe+Lb-1)));
        end
        srect = unique(mrect);
        fframe = 0;
        for iframe = 1:size(signal,1)-Lb
            if mean(abs(signal(iframe:iframe+Lb-1))) == srect(Kb)
                fframe = iframe;
                baseline = abs(signal(iframe:iframe+Lb-1));
            end
        end
    end
    % b- Manual selection
    if btype == 2
        [x,~] = ginput(2);
        baseline = rmoutliers(abs(signal(x(1):x(2))));
    end
    % c- Baseline based on reference record
    if btype == 3
        baseline = squeeze(Trial.Emg(iemg).baseline); 
        [B,A]  = butter(3,[30 300]./(Trial.fanalog/2),'bandpass');
        baseline = filtfilt(B,A,baseline);
        [B,A]  = butter(1,50./(Trial.fanalog/2),'low');
        baseline = filtfilt(B,A,abs(baseline));
        smax = max(baseline);
        [~,baseline] = energyop(baseline);
        baseline = baseline*smax/max(baseline);
    end
    % 2- First threshold using baseline parameters
    if btype == 3
        nsd = 10;
    else
        nsd = 40;
    end
    onset = zeros(size(signal));
    onset(abs(signal)>(mean(baseline)+nsd*std(baseline))) = 1;
    % 3- Second threshold using on time
    Ton = 0.01*0.5*Trial.fanalog; % 0.01 s expressed in frames
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
    Toff = 1*0.5*Trial.fanalog; % 1 s expressed in frames
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
    Ts = 0.01*20*Trial.fanalog; % 0.01 s expressed in frames
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
    MT  = rms(abs(envelop(find(onset==1))));
    MN  = rms(abs(envelop(find(onset==0))));
    SNR = abs(20*log(MT/MN));
    % Complete plot        
    title([Trial.Emg(iemg).label,', SNR: ',num2str(SNR),' dB']);    
    line([1 size(signal,1)],[mean(baseline)+nsd*std(baseline) mean(baseline)+nsd*std(baseline)],'Color','red','Linestyle','-');
    plot(onset*max(signal),'Color','black','Linewidth',1);
    % Manual validation
    if iemg < 8 % Right side EMG
        Trial.Emg(iemg).Signal.envelop(:,:,:) = permute(signal,[2,3,1]);
        Trial.Emg(iemg).Signal.onset(:,:,:)   = permute(onset,[2,3,1]);
%         for icycle = 1:size(Rcycles,2)
%             [vmax,imax] = max(signal(Rcycles(icycle).range*fratio));
%             plot((Rcycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
%             rectangle('Position',[Rcycles(icycle).range(1)*fratio 0 length(Rcycles(icycle).range)*fratio max(signal0)],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
%             [~,y] = ginput(1);
%             if y < 0 % Signal not usable = NaN
%                 Trial.Emg(iemg).Signal.envelop(:,:,Rcycles(icycle).range) = NaN;
%             end
%         end
        close(fig);
    elseif iemg > 7 % Left side EMG
        Trial.Emg(iemg).Signal.envelop(:,:,:) = permute(signal,[2,3,1]);
        Trial.Emg(iemg).Signal.onset(:,:,:)   = permute(onset,[2,3,1]);
%         for icycle = 1:size(Lcycles,2)
%             [vmax,imax] = max(signal(Lcycles(icycle).range*fratio));
%             plot((Lcycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
%             rectangle('Position',[Lcycles(icycle).range(1)*fratio 0 length(Lcycles(icycle).range)*fratio max(signal0)],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
%             [~,y] = ginput(1);
%             if y < 0 % Signal not usable = NaN
%                 Trial.Emg(iemg).Signal.envelop(:,:,Lcycles(icycle).range) = NaN;
%             end
%         end
        close(fig);
    end
    iemg = iemg+1;
    
    % Clean workspace
    clearvars -except Trial Rcycles Lcycles iplot fratio iemg btype;
end