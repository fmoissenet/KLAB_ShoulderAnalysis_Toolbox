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
% Modified     : Hugo Francalanci 
%                Biomechanics and Translational Research in Surgery (B-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/chiru/en/research-groups/nicolas-holzer-et-florent-moissenet
% Date         : June 2026
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
ylimit = 4e-4;

% btype 4 - inter-cycle baseline settings (gap between two cycles, with margin)
baselineCyclePair = [1 2];                          % gap taken between cycle 1 and cycle 2
baselineMarginSec = 0.5;                            % margin trimmed on each side of the gap (s)
minBaselineSec    = 0.2;                            % minimum usable gap length after trimming (s)
marginFrames      = round(baselineMarginSec*Trial.fanalog);
minBaselineFrames = round(minBaselineSec*Trial.fanalog);

% Manual validation of EMG signal
iemg = 1;
while iemg <= size(Trial.Emg,2) % All EMG (right and left)
    % 0- Load EMG signal and baseline
    signal0 = filloutliers(squeeze(Trial.Emg(iemg).Signal.full),'nearest','mean',ThresholdFactor=5); % Remove outliers to avoid spikes

    if sum(signal0-mean(signal0)) ~= 0

        % 0- Signal preprocessing
        % https://doi.org/10.1371/journal.pone.0237727
        [B,A]  = butter(1,[10 500]./(Trial.fanalog/2),'bandpass');
        signal = filtfilt(B,A,signal0);
        signal = abs(signal);
        envelop = interpft(rms2(signal,0.02*Trial.fanalog,0.01*Trial.fanalog,1),length(signal)); % Used to compute SNR
        [B,A]  = butter(1,2./(Trial.fanalog/2),'low');
        envelop2 = smoothdata(envelop,'gaussian',3*Trial.fanalog)'; % Used to compute signal peak

        % Side assignment (needed here so btype 4 can read the cycle ranges)
        if iemg <= size(Trial.Emg,2)/2 % Right side EMG
            currentCycles = Rcycles;
            sideLabel     = 'Côté droit';
        else % Left side EMG
            currentCycles = Lcycles;
            sideLabel     = 'Côté gauche';
        end

        if manualCheck == 1
            fig = figure('units','normalized','outerposition',[0 0 1 1]);
            ylim([-ylimit ylimit]);
%             ylimit = max(signal);
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
        fframe = 0; baselineLen = 0;
        % a- Automatic selection
        if btype == 1
            Lb = 1*Trial.fanalog; % Optimised: 1s
            Kb = 5; % Rank 5
            for iframe = 1:fix(size(signal,1)*0.90)-Lb % 90% of the signal is analysed to avoid issue related to bad signal stop time
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
            baselineLen = length(baseline);
            if manualCheck == 1
                plot(fframe:fframe+Lb-1,baseline,'red');
            end
        end
        % b- Manual selection
        if btype == 2
            [x,~] = ginput(2);
            baseline = signal(x(1):x(2));
            fframe = round(x(1));
            baselineLen = round(x(2))-round(x(1));
        end
        % c- Baseline based on reference record
        if btype == 3
            % Same process as for the signal preprocessing
            baseline = squeeze(Trial.Emg(iemg).baseline);
            [B,A]  = butter(1,[10 500]./(Trial.fanalog/2),'bandpass'); % Same as for the signal preprocessing
            baseline = filtfilt(B,A,baseline);
            baseline = abs(baseline);
            fframe = 0; baselineLen = 0; % not on the same timeline as signal -> no patch
        end
        % d- Baseline taken between two cycles (with a margin trimmed on each side)
        if btype == 4
            baselineOK = false;
            if numel(currentCycles) >= max(baselineCyclePair)
                ic1     = baselineCyclePair(1);
                ic2     = baselineCyclePair(2);
                aEnd1   = round(currentCycles(ic1).range(end) * fratio);
                aStart2 = round(currentCycles(ic2).range(1)   * fratio);
                gStart  = aEnd1   + marginFrames;
                gEnd    = aStart2 - marginFrames;
                if (gEnd - gStart) >= minBaselineFrames && gEnd <= length(signal) && gStart >= 1
                    baseline    = signal(gStart:gEnd);
                    fframe      = gStart;
                    baselineLen = gEnd - gStart;
                    baselineOK  = true;
                end
            end
            if ~baselineOK
                fprintf('  [%s | %s] Baseline inter-cycle indisponible (cycles %d-%d insuffisants/trop proches) -> repli sur les 100 premières frames.\n', ...
                        Trial.Emg(iemg).label, sideLabel, baselineCyclePair(1), baselineCyclePair(2));
                nBase    = min(100, length(signal));
                baseline = signal(1:nBase);
                fframe   = 1;
                baselineLen = nBase;
            end
        end
        if manualCheck == 1 && btype ~= 1 && btype ~= 3 && fframe > 0 && baselineLen > 0
            hBaseline = patch([fframe fframe+baselineLen fframe+baselineLen fframe], ...
                  [-ylimit -ylimit ylimit ylimit], ...
                  [1 0.6 0], 'FaceAlpha',0.2, 'EdgeColor','none', 'HandleVisibility','off');
        else
            hBaseline = [];
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
            title([Trial.Emg(iemg).label,' (',sideLabel,') - SNR : ',num2str(SNR),' dB, Moyenne : ',num2str(meansignal),' uv']);
            hThresh = line([1 size(signal,1)],[mean(baseline)+nsd*std(baseline) mean(baseline)+nsd*std(baseline)],'Color','red','Linestyle','-');
            ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
        end
        % Store results
        Trial.Emg(iemg).Signal.filtrect(:,:,:) = permute(signal,[2,3,1]);
        Trial.Emg(iemg).Signal.envelop(:,:,:)  = permute(envelop2,[2,3,1]);
        Trial.Emg(iemg).Signal.onset(:,:,:)    = permute(onset,[2,3,1]);
        % Manual validation
        if manualCheck == 1
            if ~isempty(currentCycles)
                ncycles = size(currentCycles,2);
                hCyclePatch = gobjects(1,ncycles);
                hCycleStar  = gobjects(1,ncycles);
                for icycle = 1:ncycles
                    aStart = max(1, round(currentCycles(icycle).range(1)  * fratio));
                    aEnd   = min(length(signal), round(currentCycles(icycle).range(end) * fratio));
                    [vmax,imax] = max(envelop2(aStart:aEnd));
                    hCycleStar(icycle) = plot(aStart+imax-1,vmax,'Marker','p','MarkerEdgeColor','none','MarkerFaceColor','black','MarkerSize',15);
                    hCyclePatch(icycle) = rectangle('Position',[aStart 0 aEnd-aStart max(signal0)],'FaceColor',[0 1 0],'FaceAlpha',0.2,'EdgeColor','none');
                end

                % EMG cycles & baseline (global validation)
                fprintf('\n %s (%s)\n', Trial.Emg(iemg).label, sideLabel);
                resp = input('  - Entrée = OK, m + Entrée = manuel, b + Entrée = muscle précédent : ', 's');

                if strcmpi(strtrim(resp), 'b')
                    close(fig);
                    iemg = max(1, iemg-1);
                    continue;
                end

                if strcmpi(strtrim(resp), 'm')

                    % Baseline - Enter=OK or m=manual (2 clicks)
                    respB = input('  - Baseline : Entrée = OK, m + Entrée = manuel : ','s');
                    if strcmpi(strtrim(respB), 'm')
                        fprintf('  Cliquez le début et la fin de la nouvelle fenêtre de baseline sur la figure :\n');
                        [xb,~] = ginput(2);
                        gStart = max(1, round(min(xb)));
                        gEnd   = min(length(signal), round(max(xb)));
                        baseline    = signal(gStart:gEnd);
                        fframe      = gStart;
                        baselineLen = gEnd - gStart;

                        % Recompute onset/SNR/amplitude with the new baseline
                        [onset,SNR,meansignal] = localComputeOnset(signal,envelop,baseline,Trial.fanalog);
                        Trial.Emg(iemg).SNR        = SNR;
                        Trial.Emg(iemg).signalMean = meansignal;
                        Trial.Emg(iemg).Signal.onset(:,:,:) = permute(onset,[2,3,1]);

                        % Redraw baseline zone, threshold and onset
                        if ~isempty(hBaseline) && ishandle(hBaseline); delete(hBaseline); end
                        hBaseline = patch([fframe fframe+baselineLen fframe+baselineLen fframe], ...
                              [-ylimit -ylimit ylimit ylimit], ...
                              [1 0.6 0], 'FaceAlpha',0.2, 'EdgeColor','none', 'HandleVisibility','off');
                        delete(hThresh);
                        hThresh = line([1 size(signal,1)],[mean(baseline)+nsd*std(baseline) mean(baseline)+nsd*std(baseline)],'Color','red','Linestyle','-');
                        delete(ponset);
                        ponset = plot(onset*ylimit/2,'Color','black','Linewidth',2);
                        title([Trial.Emg(iemg).label,' (',sideLabel,') - SNR : ',num2str(SNR),' dB, Moyenne : ',num2str(meansignal),' uv (baseline redéfinie)']);
                        drawnow;
                    end

                    % EMG cycles - Entrée=OK ou m=manuel (clics, cycle byr cycle)
                    respC = input('  - Cycles : Entrée = OK, m + Entrée = manuel : ', 's');
                    if strcmpi(strtrim(respC), 'm')
                        newRanges = cell(1,ncycles);
                        for ic = 1:ncycles
                            fprintf('  [Cycle %d/%d] 2 clics : les deux y>0 = redéfinir, les deux y<0 = garder automatique, signes mixtes = rejeter le cycle (NaN)\n', ic, ncycles);
                            pts = ginput(2);
                            if pts(1,2) > 0 && pts(2,2) > 0
                                s = max(1, round(min(pts(:,1))));
                                e = min(length(signal), round(max(pts(:,1))));
                                newRanges{ic} = [s e];
                                % Yellow zone overlaid on top of the original green cycle zone
                                patch([s e e s], [-ylimit -ylimit ylimit ylimit], ...
                                      'yellow', 'FaceAlpha',0.35, 'EdgeColor',[0.9 0.7 0], ...
                                      'LineWidth',1.5, 'HandleVisibility','off');
                                drawnow;
                            elseif pts(1,2) < 0 && pts(2,2) < 0
                                fprintf('  Cycle %d conservé (bornes automatiques).\n', ic);
                            else
                                % Mixed signs: reject this cycle entirely (onset/envelop -> NaN)
                                newRanges{ic} = NaN;
                                aStartR = max(1, round(currentCycles(ic).range(1)  * fratio));
                                aEndR   = min(length(signal), round(currentCycles(ic).range(end) * fratio));
                                patch([aStartR aEndR aEndR aStartR], [-ylimit -ylimit ylimit ylimit], ...
                                      'red', 'FaceAlpha',0.35, 'EdgeColor',[0.8 0 0], ...
                                      'LineWidth',1.5, 'HandleVisibility','off');
                                drawnow;
                                fprintf('  Cycle %d rejeté (mis à NaN).\n', ic);
                            end
                        end
                        Trial.Emg(iemg).Signal.cycleRangeOverride = newRanges;
                        title([Trial.Emg(iemg).label,' (',sideLabel,') - SNR : ',num2str(SNR),' dB, Moyenne : ',num2str(meansignal),' uv (cycles redéfinis)']);
                        drawnow;
                        input('  Appuyez sur Entrée pour confirmer et continuer : ','s');
                    end
                end
                close(fig);

            else
                % No cycles on this side: show full signal, nothing to validate per cycle
                drawnow;
                input('  Aucun cycle - Appuyez sur Entrée pour continuer : ','s');
                close(fig);
            end
        end
    else
        if iemg <= size(Trial.Emg,2)/2
            Trial.Emg(iemg).Signal.envelop = [];
            Trial.Emg(iemg).Signal.onset = [];
        elseif iemg > size(Trial.Emg,2)/2 % Left side EMG
                Trial.Emg(iemg).Signal.envelop = [];
                Trial.Emg(iemg).Signal.onset = [];
        end
    end

    iemg = iemg+1;

    % Clean workspace
    clearvars -except Trial Rcycles Lcycles iplot fratio iemg btype ylimit manualCheck ...
                       baselineCyclePair baselineMarginSec minBaselineSec marginFrames minBaselineFrames;
end
end

% =========================================================================
% SUBFUNCTION: threshold + onset refinement + SNR/amplitude criteria
% (same logic as above + SNR/amplitude criteria below; used only
% to recompute the onset after a manual baseline redefinition)
% =========================================================================
function [onset,SNR,meansignal] = localComputeOnset(signal,envelop,baseline,fanalog)

nsd   = 3;
onset = zeros(size(signal));
onset(abs(signal) > (mean(baseline)+nsd*std(baseline))) = 1;

Ton     = 0.004*fanalog;
ifinder = 0; finder = 0;
for iframe = 1:size(onset,1)
    if onset(iframe)==1 && finder==0
        ifinder = iframe; finder = finder+1;
    elseif onset(iframe)==1 && finder>0
        finder = finder+1;
    elseif finder>0 && onset(iframe)==0
        if finder < Ton
            onset(ifinder:iframe) = 0;
        end
        ifinder = 0; finder = 0;
    end
end

Toff    = 0.25*fanalog;
ifinder = 0; finder = 0;
for iframe = 1:size(onset,1)
    if onset(iframe)==0 && finder==0
        ifinder = iframe; finder = finder+1;
    elseif onset(iframe)==0 && finder>0
        finder = finder+1;
    elseif finder>0 && onset(iframe)==1
        if finder < Toff
            onset(ifinder:iframe) = 1;
        end
        ifinder = 0; finder = 0;
    end
end

Ts      = 2*fanalog;
ifinder = 0; finder = 0;
for iframe = 1:size(onset,1)
    if onset(iframe)==1 && finder==0
        ifinder = iframe; finder = finder+1;
    elseif onset(iframe)==1 && finder>0
        finder = finder+1;
    elseif finder>0 && onset(iframe)==0
        if finder < Ts
            onset(ifinder:iframe) = 0;
        end
        ifinder = 0; finder = 0;
    end
end

snrThreshold = 12;
MT  = rms(envelop(onset==1));
MN  = rms(envelop(onset==0));
SNR = abs(20*log(MT/MN));
if SNR < snrThreshold
    onset = zeros(size(onset));
end

amplitudeThreshold = 0.2*1e-6;
meansignal = mean(signal);
if meansignal < amplitudeThreshold
    onset = zeros(size(onset));
end
end
