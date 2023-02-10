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

function Trial = OnsetDetection(Trial,Cycles)

% Frequency ratio between analogs and markers
fratio = Trial.fanalog/Trial.fmarker;

% Manual validation of EMG signal
for iemg = 1:14 % All EMG (right and left)

    % Get full EMG signal
    emgfull = squeeze(Trial.Emg(iemg).Signal.full);
    
    % Acceptability threshold
    acceptability_threshold = 1e-5;
    if max(emgfull)-min(emgfull) <= acceptability_threshold
        emgfull2 = zeros(size(emgfull));
    else
        emgfull2 = emgfull;
    end

    % Define onsets (x % of signal amplitude)
    if emgfull2 == zeros(size(emgfull2))
        threshold = 1;
    else
        threshold = (max(emgfull2)-min(emgfull2))*0.3; % 30% of the signal amplitude (doi: 10.1016/j.proeng.2016.06.208)
    end

    % Ininialise onset
    onset = zeros(length(emgfull2),1);

    % Define onsets
    onset(find(emgfull2>threshold+min(emgfull2))) = 1;

    % Remove small sample of onset time    
    finder = nan(length(onset),1);
    found  = 0;
    k      = 1;
    for t = 1:length(onset)
        if onset(t) == 1 && found == 0
            found = 1;
            k = t;
            finder(t) = 1;
        elseif onset(t) == 1 && found == 1
            finder(k) = finder(k)+1;
        elseif onset(t) == 0 && found == 1
            found = 0;
            k = k+1;
        end
    end
    threshold2 = (50*1e-3)*Trial.fanalog; % 50 ms threshold (doi: 10.1002/mdc3.13044)
    for t = 1:length(onset)
        if finder(t) <= threshold2
            for t2 = t:t+finder(t)-1
                onset(t2) = 0;
            end
        end
    end  

    % Manual validation
    fig = figure; hold on;
    title(Trial.Emg(iemg).label);
    plot(emgfull-min(emgfull),'red');
    plot(onset*5e-5,'black','LineWidth',1);
    line([0 length(emgfull)],[acceptability_threshold acceptability_threshold],'Linestyle','--','Color','black'); % Threshold of signal acceptability
    ylim([0 1e-4]);
%     plot(onset*0.05,'black','LineWidth',1); % If records performed at Klab
%     line([0 length(emgfull)],[0.01 0.01],'Linestyle','--','Color','black'); % Threshold of signal acceptability
%     ylim([0 0.1]);
    for icycle = 1:size(Cycles,2)
        rectangle('Position',[Cycles(icycle).range(1)*fratio+2*length(Cycles(icycle).range)/3*fratio 0 1*length(Cycles(icycle).range)/3*fratio 1],'FaceColor',[0 1 0 0.2],'EdgeColor','none');
        rectangle('Position',[Cycles(icycle).range(1)*fratio+1*length(Cycles(icycle).range)/3*fratio 0 1*length(Cycles(icycle).range)/3*fratio 1],'FaceColor',[0 0 1 0.2],'EdgeColor','none');
        rectangle('Position',[Cycles(icycle).range(1)*fratio+0*length(Cycles(icycle).range)/3*fratio 0 1*length(Cycles(icycle).range)/3*fratio 1],'FaceColor',[1 0 0 0.2],'EdgeColor','none');
        temp = ginput(1);
        if temp(1) >= Cycles(icycle).range(1)*fratio+2*length(Cycles(icycle).range)/3*fratio && temp(1) <= Cycles(icycle).range(1)*fratio+3*length(Cycles(icycle).range)/3*fratio
            validity(icycle) = 2; % Green area
        elseif temp(1) >= Cycles(icycle).range(1)*fratio+1*length(Cycles(icycle).range)/3*fratio && temp(1) <= Cycles(icycle).range(1)*fratio+2*length(Cycles(icycle).range)/3*fratio
            validity(icycle) = 1; % Blue area
        else
            validity(icycle) = 0; % Red area
        end
        clear temp;
    end
    close(fig);
    
    % Store onsets
    Trial.Emg(iemg).Signal.full = zeros(size(Trial.Emg(iemg).Signal.full)); % Clean vector while keeping its original size fill by NaN
    for icycle = 1:size(Cycles,2)
        if validity(icycle) == 2
            Trial.Emg(iemg).Signal.full(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio) = permute(onset(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1]);
        elseif validity(icycle) == 1
            Trial.Emg(iemg).Signal.full(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio) = zeros(size(permute(onset(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1])));
        elseif validity(icycle) == 0
            Trial.Emg(iemg).Signal.full(:,:,Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio) = nan(size(permute(onset(Cycles(icycle).range(1)*fratio:Cycles(icycle).range(end)*fratio),[2,3,1])));
        end
    end
    
    % Clean workspace
    clear temp emg onset;
end