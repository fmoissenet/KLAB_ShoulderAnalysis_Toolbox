% Author     :   H. Francalanci
%                Biomechanics and Translational Research in Surgery Group
%                University of Geneva
%                https://www.unige.ch/medecine/chiru/en/research-groups/nicolas-holzer-et-florent-moissenet
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   May 2026
% -------------------------------------------------------------------------
% Description:   Plot relative thoracic posture dynamics in the patient-ICS.
%                Reference = first 50 frames of the trial (patient at rest).
%
%                Layout : 1 row x 3 columns
%                  Col 1 : Axial rotation    Y  (+= rotation right)
%                  Col 2 : Lateral tilt      X  (+= tilt right)
%                  Col 3 : Flexion/Kyphosis  Z  (+= anterior flexion)
%
%                Individual cycles (thin lines) + mean + SD (patch).
%                Cobb and Moroder summary displayed in subtitle if available.
% -------------------------------------------------------------------------
% Inputs  : Trial    (struct)  with Joint(11).Euler.full and Rcycle populated
%           taskName (char)    e.g. 'ANALYTIC1'
% Outputs : Figure
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function PlotThoraxPosture(Trial, taskName)

% Guard
if length(Trial.Joint) < 11 || isempty(Trial.Joint(11).Euler.full)
    warning('[PlotThoraxPosture] No Thorax/ICS data for %s.', taskName);
    return;
end
if isempty(Trial.Rcycle)
    warning('[PlotThoraxPosture] No cycles available for %s.', taskName);
    return;
end

% -------------------------------------------------------------------------
% PARAMETRES VISUELS
% -------------------------------------------------------------------------
dof_labels    = {'Axial rotation (deg)', 'Lateral tilt (deg)', 'Flexion / Kyphosis (deg)'};
dof_subtitles = {'Y  (+= right rotation)', 'X  (+= right tilt)', 'Z  (+= anterior flexion)'};
subplot_bg    = {[0.97 0.98 1.0], [0.98 1.0 0.97], [1.0 0.98 0.96]};
gc            = [0.25 0.45 0.75];
gc_light      = min(1, gc + 0.45);
pct           = 0:1:100;

% -------------------------------------------------------------------------
% EXTRACT AND NORMALISE EULER ANGLES
%   Row 1 : X — lateral tilt
%   Row 2 : Y — axial rotation
%   Row 3 : Z — flexion
% Reorder to [RotY, TiltX, FlexZ] for display columns 1-3
% -------------------------------------------------------------------------
ang_full_raw = squeeze(Trial.Joint(11).Euler.full); % [3 x N]
% Reorder : col1=Y(row2), col2=X(row1), col3=Z(row3)
ang_full = [ang_full_raw(2,:); ang_full_raw(1,:); ang_full_raw(3,:)]; % [3 x N]

nF = size(ang_full, 2);
nC = length(Trial.Rcycle);

ang_cycle = zeros(3, 101, nC);
for ic = 1:nC
    f0 = max(1,  Trial.Rcycle(ic).range(1));
    f1 = min(nF, Trial.Rcycle(ic).range(end));
    nR = f1 - f0 + 1;
    k0 = (1:nR)';
    k1 = linspace(1, nR, 101)';
    raw = ang_full(:, f0:f1)';
    ang_cycle(:,:,ic) = interp1(k0, raw, k1, 'spline')';
end

% -------------------------------------------------------------------------
% FIGURE
% -------------------------------------------------------------------------
fig_title = sprintf('Thorax / patient-ICS  —  %s', taskName);
fig = figure('Name', fig_title, 'Color', [0.973 0.976 0.980], ...
    'Units', 'normalized', 'OuterPosition', [0.05 0.1 0.9 0.72]);

tl = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

title(tl, fig_title, 'FontSize', 12, 'FontWeight', 'bold', ...
    'Color', [0.17 0.17 0.17], 'Interpreter', 'none');

% Posture summary subtitle if available
if isfield(Trial.Joint(11), 'PostureSummary') && ...
   isfield(Trial.Joint(11).PostureSummary, 'thoracic_curvature_angle')
    ps = Trial.Joint(11).PostureSummary;
    subtitle(tl, sprintf('Cobb : %.1f deg  |  %s  |  Moroder R: %s  L: %s', ...
        ps.thoracic_curvature_angle, ps.thorax_posture_type, ...
        ps.moroder_R, ps.moroder_L), ...
        'FontSize', 8, 'Color', [0.45 0.45 0.45], 'Interpreter', 'none');
end

% -------------------------------------------------------------------------
% PLOT EACH DOF
% -------------------------------------------------------------------------
for dof = 1:3
    ax = nexttile(tl, dof);
    set(ax, 'Color', subplot_bg{dof});
    hold(ax, 'on');

    for ic = 1:nC
        plot(ax, pct, ang_cycle(dof,:,ic), ...
            'Color', [gc_light, 0.35], 'LineWidth', 0.8);
    end

    gm = mean(ang_cycle(dof,:,:), 3, 'omitnan');
    gs = std( ang_cycle(dof,:,:), 0, 3, 'omitnan');
    patch(ax, [pct fliplr(pct)], [gm+gs fliplr(gm-gs)], ...
        gc, 'FaceAlpha', 0.18, 'EdgeColor', 'none');
    plot(ax, pct, gm, 'Color', gc, 'LineWidth', 2.2);

    yline(ax, 0, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.8, 'Alpha', 0.6);

    xlabel(ax, 'Cycle (%)', 'FontSize', 8, 'Color', [0.4 0.4 0.4]);
    ylabel(ax, dof_labels{dof}, 'FontSize', 8, 'Color', [0.4 0.4 0.4]);
    title(ax, sprintf('%s\n%s', dof_labels{dof}, dof_subtitles{dof}), ...
        'FontSize', 9, 'FontWeight', 'bold', ...
        'Color', [0.17 0.17 0.17], 'Interpreter', 'none');
    xlim(ax, [0 100]);
    grid(ax, 'on');
    ax.GridAlpha = 0.22;
    ax.GridColor = [0.5 0.5 0.5];
    ax.Box       = 'off';
    ax.FontSize  = 9;
    hold(ax, 'off');
end
end