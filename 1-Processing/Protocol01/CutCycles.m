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

function Trial = CutCycles(c3dFiles,Trial,btype)

% Initialisation
disp('  - Découpage des cycles de mouvement');
Rcycles = [];
Lcycles = [];

if contains(c3dFiles.name,'ANALYTIC') || contains(c3dFiles.name,'FUNCTIONAL')
    % Short motion label for display (e.g. "ANALYTIC1") instead of the full file name
    motionLabel = regexp(c3dFiles.name, '(ANALYTIC\d|FUNCTIONAL\d)', 'tokens', 'once');
    if isempty(motionLabel)
        motionLabel = c3dFiles.name;
    else
        motionLabel = motionLabel{1};
    end
    % Set cycles
    start = [];
    stop = [];
    value = [];
    % Right side
    if contains(c3dFiles.name,'ANALYTIC2') || contains(c3dFiles.name,'ANALYTIC5') || contains(c3dFiles.name,'FUNCTIONAL3')
        value = abs(squeeze(Trial.Joint(1).Euler.full(:,1,:))');
    elseif contains(c3dFiles.name,'ANALYTIC1') || contains(c3dFiles.name,'FUNCTIONAL1') || contains(c3dFiles.name,'FUNCTIONAL2')
        value = abs(squeeze(Trial.Joint(1).Euler.full(:,3,:))');
    elseif contains(c3dFiles.name,'ANALYTIC3') || contains(c3dFiles.name,'FUNCTIONAL4')
        value = -squeeze(Trial.Joint(1).Euler.full(:,2,:))';
    elseif contains(c3dFiles.name,'ANALYTIC4')
        value = squeeze(Trial.Joint(1).Euler.full(:,2,:))';
    end
    if ~isempty(value)
        % Cycle detection: click on the figure to set the threshold (Y = threshold),
        % cycles update live. Enter = validate, m+Enter = manual fallback (ginput(6)).
        value   = unwrap(value);
        Rcycles = detectCyclesAuto(value, 'Côté droit', motionLabel);
    end
    % Left side
    if contains(c3dFiles.name,'ANALYTIC2') || contains(c3dFiles.name,'ANALYTIC5') || contains(c3dFiles.name,'FUNCTIONAL3')
        value = abs(squeeze(Trial.Joint(6).Euler.full(:,1,:))');
    elseif contains(c3dFiles.name,'ANALYTIC1') || contains(c3dFiles.name,'FUNCTIONAL1') || contains(c3dFiles.name,'FUNCTIONAL2')
        value = abs(squeeze(Trial.Joint(6).Euler.full(:,3,:))');
    elseif contains(c3dFiles.name,'ANALYTIC3') || contains(c3dFiles.name,'FUNCTIONAL4')
        value = -squeeze(Trial.Joint(6).Euler.full(:,2,:))';
    elseif contains(c3dFiles.name,'ANALYTIC4')
        value = squeeze(Trial.Joint(6).Euler.full(:,2,:))';
    end
    if ~isempty(value)
        value   = unwrap(value);
        Lcycles = detectCyclesAuto(value, 'Côté gauche', motionLabel);
    end

    % Cut cycles
    % Cycle
    Trial.Rcycle = Rcycles;
    Trial.Lcycle = Lcycles;
    % Markers
    for imarker = 1:size(Trial.Marker,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isnan(sum(Trial.Marker(imarker).Trajectory.full(1,1,:)))
                    Trial.Marker(imarker).Trajectory.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Marker(imarker).Trajectory.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);

                else
                    Trial.Marker(imarker).Trajectory.rcycle(:,:,:,icycle) = nan(3,1,101,1);
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isnan(sum(Trial.Marker(imarker).Trajectory.full(1,1,:)))
                    Trial.Marker(imarker).Trajectory.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Marker(imarker).Trajectory.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Marker(imarker).Trajectory.lcycle(:,:,:,icycle) = nan(3,1,101,1);
                end
            end
        end
    end
    % Vmarkers
    for ivmarker = 1:size(Trial.Vmarker,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Vmarker(ivmarker).Trajectory.full)
                    Trial.Vmarker(ivmarker).Trajectory.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Vmarker(ivmarker).Trajectory.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Vmarker(ivmarker).Trajectory.full)
                    Trial.Vmarker(ivmarker).Trajectory.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Vmarker(ivmarker).Trajectory.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                end
            end
        end
    end
    % Segments
    for isegment = 1:size(Trial.Segment,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Segment(isegment).rM.full)
                    Trial.Segment(isegment).rM.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).rM.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).rM.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Q.full)
                    Trial.Segment(isegment).Q.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Q.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Q.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).T.full)
                    Trial.Segment(isegment).T.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).T.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).T.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Euler.full)
                    Trial.Segment(isegment).Euler.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Euler.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Euler.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).dj.full)
                    Trial.Segment(isegment).dj.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).dj.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).dj.rcycle = [];
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Segment(isegment).rM.full)
                    Trial.Segment(isegment).rM.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).rM.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).rM.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Q.full)
                    Trial.Segment(isegment).Q.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Q.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Q.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).T.full)
                    Trial.Segment(isegment).T.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).T.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).T.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Euler.full)
                    Trial.Segment(isegment).Euler.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Euler.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Euler.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).dj.full)
                    Trial.Segment(isegment).dj.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).dj.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).dj.lcycle = [];
                end
            end
        end
    end
    % Joints
    for ijoint = 1:size(Trial.Joint,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Joint(ijoint).T.full)
                    Trial.Joint(ijoint).T.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).T.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).T.rcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).Euler.full)
                    Trial.Joint(ijoint).Euler.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).Euler.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                    if ijoint == 1 || ijoint == 6
                        if ~isempty(Trial.Joint(ijoint).ElevationPlane.full)
                            Trial.Joint(ijoint).ElevationPlane.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).ElevationPlane.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                        else
                            Trial.Joint(ijoint).ElevationPlane.rcycle = [];
                        end
                    end
                else
                    Trial.Joint(ijoint).Euler.rcycle = [];
                    Trial.Joint(ijoint).ElevationPlane.rcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).dj.full)
                    Trial.Joint(ijoint).dj.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).dj.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).dj.rcycle = [];
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Joint(ijoint).T.full)
                    Trial.Joint(ijoint).T.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).T.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).T.lcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).Euler.full)
                    Trial.Joint(ijoint).Euler.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).Euler.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                    if ijoint == 1 || ijoint == 6
                        if ~isempty(Trial.Joint(ijoint).ElevationPlane.full)
                            Trial.Joint(ijoint).ElevationPlane.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).ElevationPlane.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                        else
                            Trial.Joint(ijoint).ElevationPlane.lcycle = [];
                        end
                    end
                else
                    Trial.Joint(ijoint).Euler.lcycle = [];
                    Trial.Joint(ijoint).ElevationPlane.lcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).dj.full)
                    Trial.Joint(ijoint).dj.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).dj.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).dj.lcycle = [];
                end
            end
        end
    end
    % Emg
    fratio = Trial.fanalog/Trial.fmarker;
    manualCheck = 1;
    Trial  = OnsetDetection(Trial,Rcycles,Lcycles,btype,manualCheck);
    if ~isempty(Trial.Emg)
        for iemg = 1:size(Trial.Emg,2)
            % cycleRangeOverride: per-muscle EMG cycle boundaries redefined manually
            % in OnsetDetection.m. When present, it is used instead of 
            % Rcycles/Lcycles*fratio for this muscle only.
            hasOverride = isfield(Trial.Emg(iemg).Signal,'cycleRangeOverride') && ~isempty(Trial.Emg(iemg).Signal.cycleRangeOverride);
            % Right side
            if ~isempty(Rcycles)
                if ~isempty(Trial.Emg(iemg).Signal.full)
                    for icycle = 1:size(Rcycles,2)
                        isOverridden = hasOverride && icycle <= numel(Trial.Emg(iemg).Signal.cycleRangeOverride) && ~isempty(Trial.Emg(iemg).Signal.cycleRangeOverride{icycle});
                        isRejected   = isOverridden && isscalar(Trial.Emg(iemg).Signal.cycleRangeOverride{icycle}) && isnan(Trial.Emg(iemg).Signal.cycleRangeOverride{icycle});
                        if isRejected
                            % Cycle manually rejected (mixed-sign clicks in OnsetDetection.m)
                            Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle)   = nan(1,1,101);
                            Trial.Emg(iemg).Signal.rcycle.envelop(:,:,:,icycle) = nan(1,1,101);
                            continue;
                        end
                        if isOverridden
                            aStart = Trial.Emg(iemg).Signal.cycleRangeOverride{icycle}(1);
                            aEnd   = Trial.Emg(iemg).Signal.cycleRangeOverride{icycle}(2);
                        else
                            aStart = Rcycles(icycle).range(1)*fratio;
                            aEnd   = Rcycles(icycle).range(end)*fratio;
                        end
                        n  = length(aStart:aEnd);
                        k0 = (1:n)';
                        k1 = (linspace(1,n,101))';
                        if ~isempty(Trial.Emg(iemg).Signal.onset)
                            Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.onset(:,:,aStart:aEnd),[3,1,2]),k1,'spline'),[2,3,1]);
                            Trial.Emg(iemg).Signal.rcycle.envelop(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.envelop(:,:,aStart:aEnd),[3,1,2]),k1,'spline'),[2,3,1]);
                            Trial.Emg(iemg).Signal.rcycle.onset(:,:,find(Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle)<0.5),icycle) = 0;
                            Trial.Emg(iemg).Signal.rcycle.onset(:,:,find(Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle)>0.5),icycle) = 1;
                        else
                            Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle) = NaN;
                            Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle) = [];
                            Trial.Emg(iemg).Signal.rcycle.envelop(:,:,:,icycle) = NaN;
                            Trial.Emg(iemg).Signal.rcycle.envelop(:,:,:,icycle) = [];
                        end
                    end
                end
            end
            % Left side
            if ~isempty(Lcycles)
                if ~isempty(Trial.Emg(iemg).Signal.full)
                    for icycle = 1:size(Lcycles,2)
                        isOverridden = hasOverride && icycle <= numel(Trial.Emg(iemg).Signal.cycleRangeOverride) && ~isempty(Trial.Emg(iemg).Signal.cycleRangeOverride{icycle});
                        isRejected   = isOverridden && isscalar(Trial.Emg(iemg).Signal.cycleRangeOverride{icycle}) && isnan(Trial.Emg(iemg).Signal.cycleRangeOverride{icycle});
                        if isRejected
                            Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle)   = nan(1,1,101);
                            Trial.Emg(iemg).Signal.lcycle.envelop(:,:,:,icycle) = nan(1,1,101);
                            continue;
                        end
                        if isOverridden
                            aStart = Trial.Emg(iemg).Signal.cycleRangeOverride{icycle}(1);
                            aEnd   = Trial.Emg(iemg).Signal.cycleRangeOverride{icycle}(2);
                        else
                            aStart = Lcycles(icycle).range(1)*fratio;
                            aEnd   = Lcycles(icycle).range(end)*fratio;
                        end
                        n  = length(aStart:aEnd);
                        k0 = (1:n)';
                        k1 = (linspace(1,n,101))';
                        if ~isempty(Trial.Emg(iemg).Signal.onset)
                            Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.onset(:,:,aStart:aEnd),[3,1,2]),k1,'spline'),[2,3,1]);
                            Trial.Emg(iemg).Signal.lcycle.envelop(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.envelop(:,:,aStart:aEnd),[3,1,2]),k1,'spline'),[2,3,1]);
                            Trial.Emg(iemg).Signal.lcycle.onset(:,:,find(Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle)<0.5),icycle) = 0;
                            Trial.Emg(iemg).Signal.lcycle.onset(:,:,find(Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle)>0.5),icycle) = 1;
                        else
                            Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle) = NaN;
                            Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle) = [];
                            Trial.Emg(iemg).Signal.lcycle.envelop(:,:,:,icycle) = NaN;
                            Trial.Emg(iemg).Signal.lcycle.envelop(:,:,:,icycle) = [];
                        end
                    end
                end
            end
        end
    end

    % Export cycles
    Trial.Rcycle = Rcycles;
    Trial.Lcycle = Lcycles;
end
end

% =========================================================================
% SUBFUNCTION: automatic cycle detection - click on the figure to set the
% threshold (Y position = threshold), cycles update live. Re-click to
% adjust. Enter = validate, m+Enter = manual fallback.
% =========================================================================
function cycles = detectCyclesAuto(value, label, filename)

cycles = [];

fig = figure('Position',[100 200 1400 500]);
fprintf('\n %s (%s)\n', filename, label);
fprintf('  - Cliquez sur la figure pour définir le seuil (Y) et le départ (X). Re-cliquez pour ajuster.\n');
fprintf('  - Entrée = valider | m+Entrée = manuel\n');

ymin      = min(value) * 1.1;
ymax      = max(value) * 1.1;
threshold = [];
xStart    = 1; % Frame from which the threshold is applied (to ignore noise at the onset of movement).

while true
    clf(fig);
    axes('Parent', fig); hold on;
    title(sprintf('%s (%s) - Cliquez pour définir le seuil  |  Entrée=OK  m+Entrée=manuel', ...
          filename, label), 'Interpreter','none');
    plot(1:length(value), value, 'Color',[0.4 0.4 0.8], 'LineWidth',1.2);
    xlabel('Frames'); ylabel('Angle (deg)');
    ylim([ymin ymax]);

    if ~isempty(threshold)
        yline(threshold, 'r--', 'LineWidth',1.5, ...
              'Label', sprintf('Seuil : %.1f deg', threshold), ...
              'LabelVerticalAlignment','bottom');
        if xStart > 1
            xline(xStart, 'b--', 'LineWidth',1.5, ...
                  'Label', sprintf('Départ : frame %d', xStart), ...
                  'LabelVerticalAlignment','top');
            patch([1 xStart xStart 1], [ymin ymin ymax ymax], ...
                  [0.5 0.5 0.5], 'FaceAlpha',0.15, 'EdgeColor','none');
        end
        above  = value > threshold;
        above(1:xStart-1) = false;
        starts = find(diff([0; above(:)]) ==  1);
        stops  = find(diff([above(:); 0]) == -1);
        nc     = min(length(starts), length(stops));
        for ic = 1:nc
            r = starts(ic):stops(ic);
            patch([r(1) r(end) r(end) r(1)], [ymin ymin ymax ymax], ...
                  [0 0.8 0], 'FaceAlpha',0.2, 'EdgeColor','none');
            plot(r, value(r), 'Color',[0 0.6 0], 'LineWidth',1.5);
        end
        title(sprintf('%s (%s) - %d cycle(s) | Seuil : %.1f deg | Départ : frame %d  |  Entrée=OK  m+Entrée=manuel', ...
              filename, label, nc, threshold, xStart), 'Interpreter','none');
    end
    drawnow;

    [xclk, yclk, btn] = ginput(1);
    if isempty(btn)
        break;
    elseif btn == 109  % 'm' key
        close(fig);
        cycles = manualCycleSelection(value, label, filename);
        return;
    else
        threshold = yclk; % signed: user clicks at the right Y level
        xStart    = max(1, round(xclk)); % Starting frame = X from the mouse click
    end
end
close(fig);

% Build cycles from final threshold (only from xStart onward)
above  = value > threshold;
above(1:xStart-1) = false;
starts = find(diff([0; above(:)]) ==  1);
stops  = find(diff([above(:); 0]) == -1);
ncycles = min(length(starts), length(stops));

if ncycles == 0
    fprintf('  - Aucun cycle détecté au-dessus du seuil %.1f -- passage en mode manuel.\n', threshold);
    cycles = manualCycleSelection(value, label, filename);
    return;
end

for ic = 1:ncycles
    cycles(ic).range = (starts(ic):stops(ic))';
end
end

% =========================================================================
% SUBFUNCTION: manual fallback (ginput(6))
% =========================================================================
function cycles = manualCycleSelection(value, label, filename)

cycles = [];
fig2   = figure('Position',[200 300 1200 400]);
hold on;
title(sprintf('%s (%s) MANUEL - 6 clics : paires début/fin. Cliquez dans la zone rouge pour ignorer.', ...
      filename, label), 'Interpreter','none');
plot(1:length(value), value, 'red');
rectangle('Position',[0 -10 length(value) 10],'FaceColor',[1 0 0],'FaceAlpha',0.2,'EdgeColor','none');
localmin = ginput(6); % If nothing to select, click in the red rectangle
close(fig2);

index = [];
for imin = 1:2:size(localmin,1)
    if localmin(imin,2) > 0
        index = [index fix(localmin(imin,1)) fix(localmin(imin+1,1))]; % Store current and next mins
    end
end
icycle = 1;
for iindex = 1:2:size(index,2)-1
    cycles(icycle).range = (index(iindex):index(iindex+1))';
    icycle = icycle+1;
end
end
