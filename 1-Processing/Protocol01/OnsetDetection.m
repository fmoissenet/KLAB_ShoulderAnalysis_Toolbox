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

function Trial = OnsetDetection(Trial,Rcycles,Lcycles,iplot)

% Frequency ratio between analogs and markers
fratio = Trial.fanalog/Trial.fmarker;

% Manual validation of EMG signal
iemg = 1;
while iemg < 15 % All EMG (right and left)

    % Load EMG signal
    emgfull = squeeze(Trial.Emg(iemg).Signal.full);    

    % Set signal of interest
    signal1 = emgfull;
    maxSignal = max(signal1);
    minSignal = min(signal1);

    % Compute the signal envelop 
    window = 500; % ms
    envelop1 = sqrt(movmean(signal1.^2,window));%smoothdata(abs(signal1),'movmean',100);
    
    % Set figure
    if iplot == 1
        fig = figure('Position',[200 300 850 400]);
        hold on;    
        title([Trial.Emg(iemg).label]);
        plot(signal1,'Color',[0.5,0.5,0.5],'Linewidth',0.5);
        plot(envelop1,'black');
    end

    % Set the baseline and remove it from the signal
    [x,y] = ginput(2);
    if y(1) < 0 && y(2) < 0 % Baseline based on the postural muscle activity
        delta = 2; % Number of std   
        signal2 = envelop1;
        signal2(signal2<Trial.Emg(iemg).baseline*delta) = 0;
    else % Manual baseline
        delta = 3; % n std of the baseline
        signal2 = envelop1;
        signal2(signal2<std(signal2(x(1):x(2)))*delta) = 0;
    end

    % Create onsets
    onset               = signal2;
    onset(abs(onset)>0) = 1;

    % Fill small holes
    finder1 = find(onset>0); % frames
    finder2 = finder1/Trial.fanalog*1e3; % ms
    desactivationDelay = 200; % ms
    for ifinder = 1:size(finder2,1)-1
        if finder2(ifinder+1)-finder2(ifinder) < desactivationDelay
            onset(finder1(ifinder)+1:finder1(ifinder+1)-1) = 1;
        end
    end
    
    % Remove isolated spikes
    finder1 = find(onset==0); % frames
    finder2 = finder1/Trial.fanalog*1e3; % ms
    minActivationDuration = 1*Trial.fanalog; % 1s minimum
    for ifinder = 1:size(finder2,1)-1
        if finder2(ifinder+1)-finder2(ifinder) < minActivationDuration
            onset(finder1(ifinder)+1:finder1(ifinder+1)-1) = 0;
        end
    end
    signal2(find(onset==0)) = 0;
    
    % Signal-to-noise ratio
    MT  = rms(signal1(find(onset==1)));
    MN  = rms(signal1(find(onset==0)));
    SNR = abs(20*log(MT/MN));
    if SNR < 10 % Value adjusted from: https://doi.org/10.1152/jappl.1995.79.5.1803
        onset = zeros(size(onset));
        signal2(find(onset==0)) = 0;   
    end
    Trial.Emg(iemg).SNR = SNR;

    % Update plot
    envelop2 = envelop1;
    envelop2(find(onset==0)) = NaN;
    if iplot == 1
        plot(onset*maxSignal,'Color','black','Linewidth',1.5);
        plot(envelop2,'Color','red','Linewidth',2);
        title([Trial.Emg(iemg).label,', SNR: ',num2str(SNR),' dB']);
    end

    % Manual validation
    if iemg < 8 % Right side EMG
        if iplot == 1
            for icycle = 1:size(Rcycles,2)
                [vmax,imax] = max(envelop2(Rcycles(icycle).range*fratio));
                plot((Rcycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
                rectangle('Position',[Rcycles(icycle).range(1)*fratio 0 length(Rcycles(icycle).range)*fratio maxSignal],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
                line([1 size(signal1,1)],[1*Trial.Emg(iemg).baseline 1*Trial.Emg(iemg).baseline],'Color','black','Linewidth',2,'Linestyle','-');
                line([1 size(signal1,1)],[2*Trial.Emg(iemg).baseline 2*Trial.Emg(iemg).baseline],'Color','black','Linewidth',2,'Linestyle','--');
                line([1 size(signal1,1)],[3*Trial.Emg(iemg).baseline 3*Trial.Emg(iemg).baseline],'Color','black','Linewidth',2,'Linestyle','-.');
            end
            [~,y] = ginput(1);
            close(fig);
        end
        Trial.Emg(iemg).Signal.envelop(:,:,:) = permute(envelop1,[2,3,1]);
        Trial.Emg(iemg).Signal.onset(:,:,:)   = permute(onset,[2,3,1]);
        if iplot == 1
            if y > 0
                iemg = iemg+1; % If y < 0, the same emg will be reprocessed
            end
        else
            iemg = iemg+1; % If no visual check, iemg directly updated (process directly validated)
        end
    elseif iemg > 7 % Left side EMG
        if iplot == 1
            for icycle = 1:size(Lcycles,2)
                [vmax,imax] = max(envelop2(Lcycles(icycle).range*fratio));
                plot((Lcycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
                rectangle('Position',[Lcycles(icycle).range(1)*fratio 0 length(Lcycles(icycle).range)*fratio maxSignal],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
                line([1 size(signal1,1)],[1*Trial.Emg(iemg).baseline 1*Trial.Emg(iemg).baseline],'Color','black','Linewidth',2,'Linestyle','-');
                line([1 size(signal1,1)],[2*Trial.Emg(iemg).baseline 2*Trial.Emg(iemg).baseline],'Color','black','Linewidth',2,'Linestyle','--');
                line([1 size(signal1,1)],[3*Trial.Emg(iemg).baseline 3*Trial.Emg(iemg).baseline],'Color','black','Linewidth',2,'Linestyle','-.');
            end
            [~,y] = ginput(1);
            close(fig);
        end
        Trial.Emg(iemg).Signal.envelop(:,:,:) = permute(envelop1,[2,3,1]);
        Trial.Emg(iemg).Signal.onset(:,:,:)   = permute(onset,[2,3,1]);
        if iplot == 1
            if y > 0
                iemg = iemg+1; % If y < 0, the same emg will be reprocessed
            end
        else
            iemg = iemg+1; % If no visual check, iemg directly updated (process directly validated)
        end
    end
    
    % Clean workspace
    clearvars -except Trial Rcycles Lcycles iplot fratio iemg;
end