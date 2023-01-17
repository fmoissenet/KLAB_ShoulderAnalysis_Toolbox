
function Trial = OnsetDetection(Trial,Cycles)

% Frequency ratio between analogs and markers
fratio = Trial.fanalog/Trial.fmarker;

% Manual validation of EMG signal
for iemg = 1:14 % All EMG (right and left)

    % Get full EMG signal
    emgfull = squeeze(Trial.Emg(iemg).Signal.full);

    % Remove first and last 5% of the recording
    subemg = emgfull(1+length(emgfull)*0.05:end-length(emgfull)*0.05,1);

    % Define onsets (x % of signal amplitude)
    threshold = (max(subemg)-min(subemg))*0.3; % 30% of the signal amplitude (doi: 10.1016/j.proeng.2016.06.208)

    % Ininialise onset
    onset = zeros(length(emgfull),1);

    % Define onsets
    onset(find(emgfull>threshold+min(subemg))) = 1;

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
    plot(emgfull-min(subemg),'red');
    plot(onset*5e-5,'black','LineWidth',1);
    line([0 length(emgfull)],[1e-5 1e-5],'Linestyle','--','Color','black'); % Threshold of signal acceptability
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