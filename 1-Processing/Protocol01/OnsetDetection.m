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

function Trial = OnsetDetection(Session,Trial,Cycles)

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
%     cutoff  = 2;
%     [B,A]   = butter(1,cutoff/(Trial.fanalog/2),'low');
%     envelop = filtfilt(B,A,abs(signal1));
    envelop1 = smoothdata(abs(signal1),'movmean',1000);
    
    % Set figure
    fig = figure('Position',[200 300 850 400]);
    hold on;    
    title([Trial.Emg(iemg).label]);
    plot(signal1,'Color',[0.5,0.5,0.5],'Linewidth',0.5);
    plot(envelop1,'black');

    % Set manually the baseline and remove it from the signal
    x = ginput(2); % Select the baseline with the highest amplitude
    delta = 3; % n std of the baseline
    signal2 = signal1;
    signal2(abs(signal2)<mean(signal2(x(1):x(2)))+std(signal2(x(1):x(2)))*delta) = 0;

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
    percentRecord = 7.5; % Signal must be at least long of n % of the record
    minActivationDuration = Trial.n1/Trial.fmarker*percentRecord/100*1e3;
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
    if SNR < 15 % https://doi.org/10.1152/jappl.1995.79.5.1803
        onset = zeros(size(onset));
        signal2(find(onset==0)) = 0;   
    end
    Trial.Emg(iemg).SNR = SNR;

    % Update plot
    envelop2 = envelop1;
    envelop2(find(onset==0)) = NaN;
    plot(onset*maxSignal,'Color','black','Linewidth',1.5);
    plot(envelop2,'Color','red','Linewidth',2);
    title([Trial.Emg(iemg).label,', SNR: ',num2str(SNR),' dB']);

    % Manual validation
    validity  = nan(size(Cycles,2));
    reprocess = 0;
    for icycle = 1:size(Cycles,2)
        [vmax,imax] = max(envelop2(Cycles(icycle).range*fratio));
        plot((Cycles(icycle).range(1)+imax)*fratio,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
        rectangle('Position',[Cycles(icycle).range(1)*fratio+2*length(Cycles(icycle).range)/3*fratio 0 1*length(Cycles(icycle).range)/3*fratio maxSignal],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
        rectangle('Position',[Cycles(icycle).range(1)*fratio+1*length(Cycles(icycle).range)/3*fratio 0 1*length(Cycles(icycle).range)/3*fratio maxSignal],'FaceColor',[0 0 1 0.2],'EdgeColor','none');
        rectangle('Position',[Cycles(icycle).range(1)*fratio+0*length(Cycles(icycle).range)/3*fratio 0 1*length(Cycles(icycle).range)/3*fratio maxSignal],'FaceColor',[1 0 0 0.2],'EdgeColor','none');
        rectangle('Position',[1 minSignal size(signal1,1) 5*abs(maxSignal-minSignal)/100],'FaceColor',[1 0 0 1],'EdgeColor','none')
        temp = ginput(1);
        if temp(1) >= Cycles(icycle).range(1)*fratio+2*length(Cycles(icycle).range)/3*fratio && temp(1) <= Cycles(icycle).range(1)*fratio+3*length(Cycles(icycle).range)/3*fratio
            validity(icycle) = 2; % Green area
        elseif temp(1) >= Cycles(icycle).range(1)*fratio+1*length(Cycles(icycle).range)/3*fratio && temp(1) <= Cycles(icycle).range(1)*fratio+2*length(Cycles(icycle).range)/3*fratio
            validity(icycle) = 1; % Blue area
        elseif temp(1) >= Cycles(icycle).range(1)*fratio*length(Cycles(icycle).range)/3*fratio && temp(1) <= Cycles(icycle).range(1)*fratio+1*length(Cycles(icycle).range)/3*fratio
            validity(icycle) = 0; % Red area
        elseif temp(2) >= minSignal && temp(2) <= 5*abs(maxSignal-minSignal)/100
            reprocess = 1; % Reprocess area
            break;
        end
        clear temp;
    end
    close(fig);
    
    % Store onsets
    if reprocess == 0
        Trial.Emg(iemg).Signal.onset = zeros(size(Trial.Emg(iemg).Signal.full)); % Clean vector while keeping its original size fill by NaN
        for icycle = 1:size(Cycles,2)
            if validity(icycle) == 2
                Trial.Emg(iemg).Signal.envelop(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio) = permute(envelop2(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1]);
                Trial.Emg(iemg).Signal.onset(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio)   = permute(onset(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1]);
            elseif validity(icycle) == 1
                Trial.Emg(iemg).Signal.envelop(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio) = zeros(size(permute(envelop2(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1])));
                Trial.Emg(iemg).Signal.onset(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio)   = zeros(size(permute(onset(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1])));
            elseif validity(icycle) == 0
                Trial.Emg(iemg).Signal.envelop(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio) = nan(size(permute(envelop2(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1])));
                Trial.Emg(iemg).Signal.onset(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio)   = nan(size(permute(onset(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1])));
            end
        end
    end

    if reprocess == 0
        iemg = iemg+1; % If at least 1 cycle has been validated by the user, the EMG is valid
    end
    
    % Clean workspace
    clear temp emg onset;
end