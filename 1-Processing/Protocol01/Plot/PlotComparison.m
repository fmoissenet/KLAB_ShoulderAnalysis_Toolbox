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
% Description:   Compare pipeline results with K-LAB .mat reference and
%                optionally with an external author dataset.
%                Layout identical to PlotKinematics :
%                  4 rows (HT | GH | ST | SHR) x 4 columns
%                  Blue solid   = Pipeline right
%                  Blue dashed  = Pipeline left
%                  Green solid  = K-LAB right
%                  Green dashed = K-LAB left
%                  Orange       = External author (optional)
%                  Legend in first panel (HT DOF1)
% -------------------------------------------------------------------------
% Inputs  : Trial      (struct array)  pipeline results
%           folderData (char)          patient folder containing K-LAB .mat
%           Pathology  (struct)         from ImportSessionData (for affected side)
%           authorFile (char)          path to author Excel file (optional)
% Outputs : Figure per ANALYTIC trial
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function PlotComparison(Trial, folderData, Pathology, authorFile)

if nargin < 3, Pathology = struct(); end
if nargin < 4, authorFile = ''; end

% -------------------------------------------------------------------------
% PARAMETRES VISUELS
% -------------------------------------------------------------------------
COL_PIPE   = [0.15 0.39 0.92];   % Bleu   — ta pipeline
COL_KLAB   = [0.13 0.65 0.35];   % Vert   — K-LAB référence
COL_AUTH   = [0.90 0.50 0.10];   % Orange — auteur externe
ALPHA_SD   = 0.12;
ALPHA_LINE = 0.85;
LW         = 2.0;
pct        = 0:1:100;
angle_x    = 30:1:90;

% -------------------------------------------------------------------------
% CHARGEMENT DU .MAT K-LAB
% -------------------------------------------------------------------------
klabTrials = [];
matFiles   = dir(fullfile(folderData, '*.mat'));
if ~isempty(matFiles)
    matPath = fullfile(folderData, matFiles(1).name);
    % disp(['[PlotComparison] .mat charge : ', matFiles(1).name]);
    data = load(matPath, 'Trial');
    if isfield(data, 'Trial')
        klabTrials = data.Trial;
    end
else
    warning('[PlotComparison] Aucun .mat trouve dans %s', folderData);
end

% -------------------------------------------------------------------------
% CHARGEMENT DES DONNEES AUTEUR (optionnel)
% -------------------------------------------------------------------------
authorData = [];
if ~isempty(authorFile) && isfile(authorFile)
    disp(['[PlotComparison] Donnees auteur chargees : ', authorFile]);
    authorData = loadAuthorData(authorFile);
else
    if ~isempty(authorFile)
        warning('[PlotComparison] Fichier auteur introuvable : %s', authorFile);
    end
end

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

    % Trouver le trial K-LAB correspondant
    tKlab = findKlabTrial(klabTrials, t.task);

    % Trouver les données auteur correspondantes
    tAuth = [];
    if ~isempty(authorData) && isfield(authorData, t.task)
        tAuth = authorData.(t.task);
    end

    % Titre
    if isKey(taskLabels, t.task)
        figTitle = [t.task, ' - ', taskLabels(t.task), '  |  Comparaison'];
    else
        figTitle = [t.task, '  |  Comparaison'];
    end

    % SHR only for ANALYTIC1/2/5
    hasSHR = contains(t.task,'ANALYTIC1') || contains(t.task,'ANALYTIC2') || ...
             contains(t.task,'ANALYTIC5');
    if hasSHR, nRows = 4; else, nRows = 3; end

    % Affected side from Pathology
    if isstruct(Pathology) && isfield(Pathology,'Diagnosis') && ...
       isfield(Pathology.Diagnosis,'side')
        affectedSide = Pathology.Diagnosis.side;
    else
        affectedSide = '';
    end

    hasAuth = ~isempty(tAuth);

    fig = figure('Name', figTitle, 'Color', 'w', ...
                 'Units', 'normalized', 'OuterPosition', [0.02 0.02 0.96 0.96]);

    tl = tiledlayout(fig, nRows, 4, ...
        'TileSpacing', 'compact', 'Padding', 'compact');

    title(tl, figTitle, ...
        'FontSize', 13, 'FontWeight', 'bold', 'Interpreter', 'none', ...
        'Color', [0.15 0.15 0.15]);

    % ---- Row 1 : HT ----
    plotRowLabel(tl, 1, 'HT');
    plotRow(tl, t, tKlab, tAuth, 1, 6, 'rcycle', 'lcycle', dofLabels.HT, ...
            pct, COL_PIPE, COL_KLAB, COL_AUTH, ALPHA_SD, ALPHA_LINE, LW, 2, false, false);

    % ---- Row 2 : GH ----
    plotRowLabel(tl, 5, 'GH');
    plotRow(tl, t, tKlab, tAuth, 2, 7, 'rcycle', 'lcycle', dofLabels.GH, ...
            pct, COL_PIPE, COL_KLAB, COL_AUTH, ALPHA_SD, ALPHA_LINE, LW, 6, false, false);

    % ---- Row 3 : ST ----
    plotRowLabel(tl, 9, 'ST');
    plotRow(tl, t, tKlab, tAuth, 3, 8, 'rcycle', 'lcycle', dofLabels.ST, ...
            pct, COL_PIPE, COL_KLAB, COL_AUTH, ALPHA_SD, ALPHA_LINE, LW, 10, false, false);

    % ---- Legend tile (col 1 of last row) ----
    plotLegend(tl, 4*nRows-3, COL_PIPE, COL_KLAB, COL_AUTH, affectedSide, hasAuth);

    % ---- SHR (ANALYTIC1/2/5 only) ----
    if hasSHR
        plotSHRrow(tl, t, tKlab, tAuth, shrLabels, angle_x, ...
                   COL_PIPE, COL_KLAB, COL_AUTH, ALPHA_SD, ALPHA_LINE, LW, 4*nRows-2);
    end
end
end

% -------------------------------------------------------------------------
%  TROUVER LE TRIAL K-LAB CORRESPONDANT
% -------------------------------------------------------------------------
function tKlab = findKlabTrial(klabTrials, taskName)
tKlab = [];
if isempty(klabTrials), return; end
for i = 1:numel(klabTrials)
    if contains(char(klabTrials(i).task), taskName)
        tKlab = klabTrials(i);
        return;
    end
end
end

% -------------------------------------------------------------------------
%  CHARGEMENT DES DONNEES AUTEUR DEPUIS EXCEL
%  Format attendu : une feuille par tâche (ex: 'ANALYTIC1')
%  Colonnes : DOF1_mu | DOF1_sd | DOF2_mu | DOF2_sd | DOF3_mu | DOF3_sd
%  101 lignes pour HT/GH/ST, 61 lignes pour SHR
% -------------------------------------------------------------------------
function authorData = loadAuthorData(xlsxPath)
authorData = struct();
tasks = {'ANALYTIC1','ANALYTIC2','ANALYTIC3','ANALYTIC4','ANALYTIC5'};
joints = {'HT_R','HT_L','GH_R','GH_L','ST_R','ST_L','SHR_R','SHR_L'};

for it = 1:length(tasks)
    task = tasks{it};
    for ij = 1:length(joints)
        sheetName = [task, '_', joints{ij}];
        try
            raw = readmatrix(xlsxPath, 'Sheet', sheetName);
            if ~isempty(raw) && size(raw,2) >= 6
                authorData.(task).(joints{ij}).mu = raw(:,1:2:5);  % col 1,3,5 = mu DOF1,2,3
                authorData.(task).(joints{ij}).sd = raw(:,2:2:6);  % col 2,4,6 = sd DOF1,2,3
            end
        catch
            % Feuille absente = pas de données auteur pour cette combo
        end
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

function plotRow(tl, t, tKlab, tAuth, jiR, jiL, cfR, cfL, dofLbls, ...
                 pct, colP, colK, colA, alphaSD, alphaLine, lw, tileStart, ~, ~)

for dof = 1:3
    ax = nexttile(tl, tileStart + dof - 1);
    styleAx(ax);

    % --- Pipeline droite ---
    if jiR <= length(t.Joint) && ~isempty(t.Joint(jiR).Euler.(cfR))
        data = extractEuler(t.Joint(jiR).Euler.(cfR), dof);
        if ~isempty(data), plotMeanSD(ax, pct, data, colP, alphaSD, alphaLine, lw); end
    end

    % --- Pipeline gauche ---
    if jiL <= length(t.Joint) && ~isempty(t.Joint(jiL).Euler.(cfL))
        data = extractEuler(t.Joint(jiL).Euler.(cfL), dof);
        if ~isempty(data), plotMeanSD(ax, pct, data, colP, alphaSD, alphaLine, lw, '--'); end
    end

    % --- K-LAB droite ---
    if ~isempty(tKlab) && jiR <= length(tKlab.Joint) && ~isempty(tKlab.Joint(jiR).Euler.(cfR))
        data = extractEulerKlab(tKlab.Joint(jiR).Euler.(cfR), dof);
        if ~isempty(data), plotMeanSD(ax, pct, data, colK, alphaSD, alphaLine, lw); end
    end

    % --- K-LAB gauche ---
    if ~isempty(tKlab) && jiL <= length(tKlab.Joint) && ~isempty(tKlab.Joint(jiL).Euler.(cfL))
        data = extractEulerKlab(tKlab.Joint(jiL).Euler.(cfL), dof);
        if ~isempty(data), plotMeanSD(ax, pct, data, colK, alphaSD, alphaLine, lw, '--'); end
    end

    % --- Auteur droite ---
    jointKey = getJointKey(jiR, 'R');
    if ~isempty(tAuth) && isfield(tAuth, jointKey)
        d = tAuth.(jointKey);
        if dof <= size(d.mu,2)
            plotMeanSDfromMuSD(ax, pct, d.mu(:,dof), d.sd(:,dof), colA, alphaSD, alphaLine, lw);
        end
    end

    % --- Auteur gauche ---
    jointKey = getJointKey(jiL, 'L');
    if ~isempty(tAuth) && isfield(tAuth, jointKey)
        d = tAuth.(jointKey);
        if dof <= size(d.mu,2)
            plotMeanSDfromMuSD(ax, pct, d.mu(:,dof), d.sd(:,dof), colA, alphaSD, alphaLine, lw, '--');
        end
    end

    yline(ax, 0, '--', 'Color', [0.72 0.72 0.72], 'LineWidth', 0.8, 'Alpha', 0.6);
    ylabel(ax, dofLbls{dof}, 'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlabel(ax, 'Cycle (%)',   'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlim(ax, [0 100]);
    hold(ax, 'off');
end
end

function plotSHRrow(tl, t, tKlab, tAuth, shrLabels, angle_x, ...
                    colP, colK, colA, alphaSD, alphaLine, lw, tileStart)

fields    = {'theta_ST', 'theta_GH', 'SHR_curve'};
hasSHR_P  = isstruct(t.SHR)     && ~isempty(t.SHR);
hasSHR_K  = ~isempty(tKlab)     && isstruct(tKlab.SHR) && ~isempty(tKlab.SHR);

for col = 1:3
    ax = nexttile(tl, tileStart + col - 1);
    styleAx(ax);

    % Pipeline droite
    if hasSHR_P && length(t.SHR) >= 1
        raw = extractSHR(t.SHR(1), fields{col}, 1, 'rcycle');
        if ~isempty(raw), plotMeanSD(ax, angle_x, raw, colP, alphaSD, alphaLine, lw); end
    end
    % Pipeline gauche
    if hasSHR_P && length(t.SHR) >= 2
        raw = extractSHR(t.SHR(2), fields{col}, 1, 'lcycle');
        if ~isempty(raw), plotMeanSD(ax, angle_x, raw, colP, alphaSD, alphaLine, lw, '--'); end
    end

    % K-LAB droite
    if hasSHR_K && length(tKlab.SHR) >= 1
        raw = extractSHR(tKlab.SHR(1), fields{col}, 1, 'rcycle');
        if ~isempty(raw), plotMeanSD(ax, angle_x, raw, colK, alphaSD, alphaLine, lw); end
    end
    % K-LAB gauche
    if hasSHR_K && length(tKlab.SHR) >= 2
        raw = extractSHR(tKlab.SHR(2), fields{col}, 1, 'lcycle');
        if ~isempty(raw), plotMeanSD(ax, angle_x, raw, colK, alphaSD, alphaLine, lw, '--'); end
    end

    % Auteur SHR droite
    if ~isempty(tAuth) && isfield(tAuth, 'SHR_R')
        d = tAuth.SHR_R;
        if col <= size(d.mu,2)
            plotMeanSDfromMuSD(ax, angle_x, d.mu(:,col), d.sd(:,col), colA, alphaSD, alphaLine, lw);
        end
    end
    % Auteur SHR gauche
    if ~isempty(tAuth) && isfield(tAuth, 'SHR_L')
        d = tAuth.SHR_L;
        if col <= size(d.mu,2)
            plotMeanSDfromMuSD(ax, angle_x, d.mu(:,col), d.sd(:,col), colA, alphaSD, alphaLine, lw, '--');
        end
    end

    if col == 3
        yline(ax, 2, '--', 'Color', [0.50 0.50 0.50], 'LineWidth', 1.2, 'Alpha', 0.7, ...
            'Label', 'SHR=2', 'LabelHorizontalAlignment', 'left', 'FontSize', 8);
    end

    ylabel(ax, shrLabels{col},       'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlabel(ax, 'Elevation HT (deg)', 'FontSize', 8, 'Color', [0.45 0.45 0.45]);
    xlim(ax, [30 90]);
    hold(ax, 'off');
end
end

function key = getJointKey(ji, side)
map = containers.Map([1,2,3,6,7,8], ...
    {'HT_R','GH_R','ST_R','HT_L','GH_L','ST_L'});
if isKey(map, ji)
    key = map(ji);
else
    key = ['J',num2str(ji),'_',side];
end
end

function styleAx(ax)
hold(ax, 'on'); grid(ax, 'on'); box(ax, 'off');
ax.FontSize  = 8;
ax.GridColor = [0.82 0.82 0.82];
ax.GridAlpha = 0.7;
ax.TickDir   = 'out';
ax.XColor    = [0.50 0.50 0.50];
ax.YColor    = [0.50 0.50 0.50];
ax.LineWidth = 0.5;
end

function plotMeanSD(ax, x, data, gc, alphaSD, alphaLine, lw, ls)
if nargin < 8, ls = '-'; end
if isempty(data), return; end
if isvector(data), data = data(:); end
x  = x(:)';
mu = mean(data, 2, 'omitnan')';
sd = std(data,  0, 2, 'omitnan')';
fill(ax, [x, fliplr(x)], [mu+sd, fliplr(mu-sd)], gc, ...
    'FaceAlpha', alphaSD, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(ax, x, mu, ls, 'Color', [gc, alphaLine], 'LineWidth', lw);
end

function plotMeanSDfromMuSD(ax, x, mu, sd, gc, alphaSD, alphaLine, lw, ls)
if nargin < 9, ls = '-'; end
if isempty(mu), return; end
x  = x(:)'; mu = mu(:)'; sd = sd(:)';
if length(mu) ~= length(x)
    mu = interp1(linspace(1,length(x),length(mu)), mu, 1:length(x), 'spline');
    sd = interp1(linspace(1,length(x),length(sd)), sd, 1:length(x), 'spline');
end
fill(ax, [x, fliplr(x)], [mu+sd, fliplr(mu-sd)], gc, ...
    'FaceAlpha', alphaSD, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(ax, x, mu, ls, 'Color', [gc, alphaLine], 'LineWidth', lw);
end

function data = extractEuler(rcycle, dof)
data = [];
if isempty(rcycle), return; end
raw = squeeze(rcycle(1, dof, :, :));
if isvector(raw), raw = raw(:); end
data = double(raw);
end

function data = extractEulerKlab(rcycle, dof)
data = [];
if isempty(rcycle), return; end
sz = size(rcycle);
if length(sz) == 4 && sz(1) == 1
    raw = squeeze(rcycle(1, dof, :, :));
elseif length(sz) >= 2 && sz(1) == 3
    raw = squeeze(rcycle(dof, :, :));
else
    return;
end
if isvector(raw), raw = raw(:); end
data = double(raw);
end

function raw = extractSHR(shrS, field, phase, cycField)
raw = [];
if ~isfield(shrS, field), return; end
sub = shrS.(field);
if ~isstruct(sub) || phase > length(sub), return; end
if ~isfield(sub(phase), cycField), return; end
raw = squeeze(sub(phase).(cycField));
if isvector(raw), raw = raw(:); end
if size(raw,1) ~= 61, raw = raw'; end
raw = double(raw);
end

% =========================================================================
%  LEGEND TILE
% =========================================================================
function plotLegend(tl, tileIdx, colP, colK, colA, affectedSide, hasAuth)
ax = nexttile(tl, tileIdx);
axis(ax, 'off');
hold(ax, 'on');

% Dummy lines
plot(ax, NaN, NaN, '-',  'Color', colP, 'LineWidth', 2.0);
plot(ax, NaN, NaN, '--', 'Color', colP, 'LineWidth', 2.0);
plot(ax, NaN, NaN, '-',  'Color', colK, 'LineWidth', 2.0);
plot(ax, NaN, NaN, '--', 'Color', colK, 'LineWidth', 2.0);
if hasAuth
    plot(ax, NaN, NaN, '-', 'Color', colA, 'LineWidth', 2.0);
end

% Build labels with affected side
lblPR = 'Pipeline R';
lblPL = 'Pipeline L';
lblKR = 'K-LAB R';
lblKL = 'K-LAB L';
if ~isempty(affectedSide)
    if strcmpi(affectedSide,'Right') || strcmpi(affectedSide,'Droit')
        lblPR = 'Pipeline R  [affected]';
        lblKR = 'K-LAB R  [affected]';
    elseif strcmpi(affectedSide,'Left') || strcmpi(affectedSide,'Gauche')
        lblPL = 'Pipeline L  [affected]';
        lblKL = 'K-LAB L  [affected]';
    end
end

if hasAuth
    lbls = {lblPR, lblPL, lblKR, lblKL, 'Author'};
else
    lbls = {lblPR, lblPL, lblKR, lblKL};
end

lh = legend(ax, lbls, 'Location', 'best', 'FontSize', 7, 'Box', 'off');
lh.ItemTokenSize = [12, 9];
hold(ax, 'off');
end