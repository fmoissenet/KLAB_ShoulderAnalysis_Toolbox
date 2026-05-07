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
% Description:   Plot joint angles HT, GH, ST and SHR for each ANALYTIC trial.
%                Layout : 4 rows (HT | GH | ST | SHR) x 4 columns
%                  Column 1 = row label
%                  Columns 2-4 = DOF1, DOF2, DOF3
%                  Blue = Right, Red = Left
%                  Mean + SD (transparent patch)
%                  One figure per ANALYTIC trial
%                  Legend in label column (col 1) of last row
%                  ANALYTIC3/4 : 3 rows only (no SHR), panels larger
%                  ANALYTIC1/2/5 : 4 rows with SHR
% -------------------------------------------------------------------------
% Inputs  : Trial (struct array) all trials from MAIN_Protocol_01
% Outputs : Figure per ANALYTIC trial
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function PlotKinematics(Trial, Pathology)

% -------------------------------------------------------------------------
% PARAMETRES VISUELS
% -------------------------------------------------------------------------
COL_R      = [0.15 0.39 0.92]; 
COL_L      = [0.86 0.15 0.15]; 
ALPHA_SD   = 0.15;
ALPHA_LINE = 0.85;
LW         = 2.0;
pct        = 0:1:100;
angle_x    = 30:1:90;

% -------------------------------------------------------------------------
% LABELS
% -------------------------------------------------------------------------
taskLabels = containers.Map(...
    {'ANALYTIC1','ANALYTIC2','ANALYTIC3','ANALYTIC4','ANALYTIC5'}, ...
    {'Elevation sagittale','Elevation coronale','Rotation externe', ...
     'Rotation interne','Scaption'});

dofLabels = struct(...
    'HT', {{'Abduction/Adduction (deg)', 'Rotation axiale (deg)',    'Flexion/Extension (deg)'}}, ...
    'GH', {{'Abduction/Adduction (deg)', 'Rotation axiale (deg)',    'Flexion/Extension (deg)'}}, ...
    'ST', {{'Rot. lat./med. (deg)',       'Protraction/Retraction (deg)', 'Incl. ant./post. (deg)'}});

shrLabels = {'theta ST (deg)', 'theta GH (deg)', 'SHR (GH/ST)'};

% -------------------------------------------------------------------------
% BOUCLE SUR LES TRIALS
% -------------------------------------------------------------------------
for itrial = 1:length(Trial)
    t = Trial(itrial);
    if ~contains(t.task, 'ANALYTIC'), continue; end
    if isempty(t.Joint),              continue; end

    if isKey(taskLabels, t.task)
        figTitle = [t.task, ' - ', taskLabels(t.task)];
    else
        figTitle = t.task;
    end

    % SHR only for ANALYTIC1/2/5
    hasSHR = contains(t.task,'ANALYTIC1') || contains(t.task,'ANALYTIC2') || ...
             contains(t.task,'ANALYTIC5');
    if hasSHR, nRows = 4; else, nRows = 3; end

    % Affected side from Pathology
    if nargin >= 2 && isstruct(Pathology) && isfield(Pathology,'Diagnosis') && ...
       isfield(Pathology.Diagnosis,'side')
        affectedSide = Pathology.Diagnosis.side;
    else
        affectedSide = '';
    end

    fig = figure('Name', figTitle, 'Color', 'w', ...
                 'Units', 'normalized', 'OuterPosition', [0.02 0.02 0.96 0.96]);

    tl = tiledlayout(fig, nRows, 4, ...
        'TileSpacing', 'compact', 'Padding', 'compact');

    title(tl, figTitle, ...
        'FontSize', 13, 'FontWeight', 'bold', 'Interpreter', 'none', ...
        'Color', [0.15 0.15 0.15]);

    % ---- Row 1 : HT ----
    plotRowLabel(tl, 1, 'HT');
    plotRow(tl, t, 1, 6, 'rcycle', 'lcycle', dofLabels.HT, ...
            pct, COL_R, COL_L, ALPHA_SD, ALPHA_LINE, LW, 2, false);

    % ---- Row 2 : GH ----
    plotRowLabel(tl, 5, 'GH');
    plotRow(tl, t, 2, 7, 'rcycle', 'lcycle', dofLabels.GH, ...
            pct, COL_R, COL_L, ALPHA_SD, ALPHA_LINE, LW, 6, false);

    % ---- Row 3 : ST ----
    plotRowLabel(tl, 9, 'ST');
    plotRow(tl, t, 3, 8, 'rcycle', 'lcycle', dofLabels.ST, ...
            pct, COL_R, COL_L, ALPHA_SD, ALPHA_LINE, LW, 10, false);

    % ---- Legend tile (col 1 of last row) ----
    plotLegend(tl, 4*nRows-3, COL_R, COL_L, affectedSide);

    % ---- SHR (ANALYTIC1/2/5 only) ----
    if hasSHR
        plotSHRrow(tl, t, shrLabels, angle_x, ...
                   COL_R, COL_L, ALPHA_SD, ALPHA_LINE, LW, 4*nRows-2);
    end
end
end

function plotRowLabel(tl, tileIdx, label)
ax = nexttile(tl, tileIdx);
axis(ax, 'off');
text(ax, 0.5, 0.5, label, ...
    'FontSize', 12, 'FontWeight', 'bold', ...
    'Color', [0.30 0.30 0.30], ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'Units', 'normalized');
end

function plotRow(tl, t, jiR, jiL, cfR, cfL, dofLbls, ...
                 pct, colR, colL, alphaSD, alphaLine, lw, tileStart, ~)

for dof = 1:3
    ax = nexttile(tl, tileStart + dof - 1);
    styleAx(ax);

    % Droite
    if jiR <= length(t.Joint) && ~isempty(t.Joint(jiR).Euler.(cfR))
        data = extractEuler(t.Joint(jiR).Euler.(cfR), dof);
        if ~isempty(data)
            plotMeanSD(ax, pct, data, colR, alphaSD, alphaLine, lw);
        end
    end

    % Gauche
    if jiL <= length(t.Joint) && ~isempty(t.Joint(jiL).Euler.(cfL))
        data = extractEuler(t.Joint(jiL).Euler.(cfL), dof);
        if ~isempty(data)
            plotMeanSD(ax, pct, data, colL, alphaSD, alphaLine, lw);
        end
    end

    yline(ax, 0, '--', 'Color', [0.72 0.72 0.72], 'LineWidth', 0.8, 'Alpha', 0.7);
    ylabel(ax, dofLbls{dof}, 'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlabel(ax, 'Cycle (%)',   'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlim(ax, [0 100]);
    hold(ax, 'off');
end
end


function plotSHRrow(tl, t, shrLabels, angle_x, ...
                    colR, colL, alphaSD, alphaLine, lw, tileStart)

fields = {'theta_ST', 'theta_GH', 'SHR_curve'};
hasSHR = isstruct(t.SHR) && ~isempty(t.SHR);

for col = 1:3
    ax = nexttile(tl, tileStart + col - 1);
    styleAx(ax);

    if hasSHR
        if length(t.SHR) >= 1
            raw = extractSHR(t.SHR(1), fields{col}, 1, 'rcycle');
            if ~isempty(raw)
                plotMeanSD(ax, angle_x, raw, colR, alphaSD, alphaLine, lw);
            end
        end
        if length(t.SHR) >= 2
            raw = extractSHR(t.SHR(2), fields{col}, 1, 'lcycle');
            if ~isempty(raw)
                plotMeanSD(ax, angle_x, raw, colL, alphaSD, alphaLine, lw);
            end
        end
    end

    if col == 3
        yline(ax, 2, '--', 'Color', [0.50 0.50 0.50], ...
            'LineWidth', 1.2, 'Alpha', 0.7, ...
            'Label', 'SHR=2', ...
            'LabelHorizontalAlignment', 'left', ...
            'FontSize', 8);
    end

    ylabel(ax, shrLabels{col},      'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlabel(ax, 'Elevation HT (deg)','FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlim(ax, [30 90]);
    hold(ax, 'off');
end
end

function styleAx(ax)
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'off');
ax.FontSize  = 8;
ax.GridColor = [0.82 0.82 0.82];
ax.GridAlpha = 0.7;
ax.TickDir   = 'out';
ax.XColor    = [0.50 0.50 0.50];
ax.YColor    = [0.50 0.50 0.50];
ax.LineWidth = 0.5;
end

function plotMeanSD(ax, x, data, gc, alphaSD, alphaLine, lw)
if isempty(data), return; end
if isvector(data), data = data(:); end

x  = x(:)';
mu = mean(data, 2, 'omitnan')';
sd = std(data,  0, 2, 'omitnan')';

% Patch SD
fill(ax, [x, fliplr(x)], [mu+sd, fliplr(mu-sd)], gc, ...
    'FaceAlpha', alphaSD, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% Ligne moyenne
plot(ax, x, mu, '-', 'Color', [gc, alphaLine], 'LineWidth', lw);
end

function data = extractEuler(rcycle, dof)
data = [];
if isempty(rcycle), return; end
raw = squeeze(rcycle(1, dof, :, :));
if isvector(raw), raw = raw(:); end
data = double(raw);
end

function raw = extractSHR(shrS, field, phase, cycField)
raw = [];
if ~isfield(shrS, field), return; end
sub = shrS.(field);
if ~isstruct(sub) || phase > length(sub), return; end
if ~isfield(sub(phase), cycField),        return; end
raw = squeeze(sub(phase).(cycField));
if isvector(raw), raw = raw(:); end
if size(raw,1) ~= 61, raw = raw'; end
raw = double(raw);
end

function plotLegend(tl, tileIdx, colR, colL, affectedSide)
ax = nexttile(tl, tileIdx);
axis(ax, 'off');
hold(ax, 'on');

plot(ax, NaN, NaN, '-', 'Color', colR, 'LineWidth', 2.0);
plot(ax, NaN, NaN, '-', 'Color', colL, 'LineWidth', 2.0);

lblR = 'Right shoulder';
lblL = 'Left shoulder';
if ~isempty(affectedSide)
    if strcmpi(affectedSide,'Right') || strcmpi(affectedSide,'Droit')
        lblR = 'Right shoulder  [affected]';
    elseif strcmpi(affectedSide,'Left') || strcmpi(affectedSide,'Gauche')
        lblL = 'Left shoulder  [affected]';
    end
end

lh = legend(ax, {lblR, lblL}, ...
    'Location', 'best', 'FontSize', 8, 'Box', 'off');
lh.ItemTokenSize = [15, 9];
hold(ax, 'off');
end