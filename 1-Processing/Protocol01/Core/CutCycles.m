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
% Description:   Extract movement cycle time windows from .mat
%                file (manually selected by the operator) and normalise all
%                kinematic data (markers, segments, joints) to 101 frames
%                using spline interpolation, ensuring inter-cycle and
%                inter-subject comparison independent of movement duration.
%                Applied to ANALYTIC trials.
% -------------------------------------------------------------------------
% Inputs  : c3dFiles   (struct)  output of dir('*.c3d'), used for file name
%           Trial      (struct)  with .Joint and .Segment populated
%           folderData (char)    patient folder containing the .mat (optional)
% Outputs : Trial      (struct)  .Rcycle .Lcycle + all .rcycle/.lcycle populated
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = CutCycles(c3dFiles, Trial, folderData)

if nargin < 3, folderData = ''; end

if ~contains(c3dFiles.name, 'ANALYTIC')
    return;
end

% -------------------------------------------------------------------------
% AUTOMATIC .MAT DETECTION
% -------------------------------------------------------------------------
matFile = '';
if ~isempty(folderData)
    matFiles = dir(fullfile(folderData, '*.mat'));
    if ~isempty(matFiles)
        matFile = fullfile(folderData, matFiles(1).name);
        disp('mat detected');
    else
        disp('No .mat found in patient folder -> ginput mode');
    end
end

% -------------------------------------------------------------------------
% READ CYCLES
% -------------------------------------------------------------------------
if ~isempty(matFile)
    % disp('  - Reading cycles from K-LAB .mat');
    [Rcycles, Lcycles] = getCyclesFromMat(matFile, Trial.file);

    if isempty(Rcycles) && isempty(Lcycles)
        warning('No cycle found in .mat for %s -> ginput mode.', Trial.file);
        [Rcycles, Lcycles] = selectCyclesManual(Trial, c3dFiles.name);
    end
else
    disp('  - Manual cycle selection (ginput)');
    [Rcycles, Lcycles] = selectCyclesManual(Trial, c3dFiles.name);
end

% -------------------------------------------------------------------------
% NORMALISATION TO 101 FRAMES
% -------------------------------------------------------------------------
Trial = normaliseAllData(Trial, Rcycles, Lcycles);
Trial.Rcycle = Rcycles;
Trial.Lcycle = Lcycles;
end

% -------------------------------------------------------------------------
%  LECTURE DES CYCLES DEPUIS LE .MAT
% -------------------------------------------------------------------------
function [Rcycles, Lcycles] = getCyclesFromMat(matFile, trialFile)

Rcycles = struct('range', {});
Lcycles = struct('range', {});

data = load(matFile, 'Trial');
if ~isfield(data, 'Trial')
    warning('Variable Trial not found in .mat.');
    return;
end

matTrials = data.Trial;

% Find matching trial by task
matchIdx = [];
for i = 1:numel(matTrials)
    tTask = char(matTrials(i).task);
    tFile = char(matTrials(i).file);
    if contains(trialFile, tTask) || contains(tFile, trialFile)
        matchIdx = i;
        break;
    end
end

if isempty(matchIdx)
    warning('No matching trial found for %s in .mat.', trialFile);
    return;
end

rc_raw = matTrials(matchIdx).Rcycle;
lc_raw = matTrials(matchIdx).Lcycle;

for ic = 1:numel(rc_raw)
    r = double(rc_raw(ic).range(:));
    if ~isempty(r)
        Rcycles(end+1).range = r; %#ok<AGROW>
    end
end
for ic = 1:numel(lc_raw)
    r = double(lc_raw(ic).range(:));
    if ~isempty(r)
        Lcycles(end+1).range = r; %#ok<AGROW>
    end
end

disp(['Rcycles: ', num2str(numel(Rcycles)), ...
      ' - Lcycles: ', num2str(numel(Lcycles))]);
end


%  -------------------------------------------------------------------------
%  SELECTION MANUELLE DES CYCLES
%  -------------------------------------------------------------------------
function [Rcycles, Lcycles] = selectCyclesManual(Trial, fileName)

Rcycles = struct('range', {});
Lcycles = struct('range', {});

if contains(fileName, 'ANALYTIC2') || contains(fileName, 'ANALYTIC5')
    col = 1;
elseif contains(fileName, 'ANALYTIC1')
    col = 3;
elseif contains(fileName, 'ANALYTIC3') || contains(fileName, 'ANALYTIC4')
    col = 2;
else
    col = 1;
end

for side = 1:2
    if side == 1, jointIdx = 1; sideStr = 'Droit';
    else,         jointIdx = 6; sideStr = 'Gauche';
    end

    if jointIdx > length(Trial.Joint) || isempty(Trial.Joint(jointIdx).Euler.full)
        continue;
    end

    value = squeeze(Trial.Joint(jointIdx).Euler.full(1, col, :))';
    if isempty(value), continue; end

    figure;
    hold on;
    title([fileName, ' - ', sideStr, ' | Cliquer debut et fin de chaque cycle']);
    plot(1:length(value), value, 'b');
    xlabel('Frame'); ylabel('Angle HT (deg)');

    localmin = ginput(6);
    index    = [];
    for imin = 1:2:size(localmin, 1)
        if size(localmin, 1) >= imin + 1
            index = [index, fix(localmin(imin,1)), fix(localmin(imin+1,1))]; %#ok<AGROW>
        end
    end
    close gcf;

    cycles = struct('range', {});
    for iindex = 1:2:length(index)-1
        f0 = max(1, index(iindex));
        f1 = min(Trial.n1, index(iindex+1));
        if f1 > f0
            cycles(end+1).range = (f0:f1)'; %#ok<AGROW>
        end
    end

    if side == 1, Rcycles = cycles;
    else,         Lcycles = cycles;
    end
end
end

%  -------------------------------------------------------------------------
%  NORMALISATION SUR 101 FRAMES
%  -------------------------------------------------------------------------
function Trial = normaliseAllData(Trial, Rcycles, Lcycles)

for im = 1:length(Trial.Marker)
    Trial.Marker(im).Trajectory = normaliseField( ...
        Trial.Marker(im).Trajectory, Rcycles, Lcycles, Trial.n1);
end

for iv = 1:length(Trial.Vmarker)
    Trial.Vmarker(iv).Trajectory = normaliseField( ...
        Trial.Vmarker(iv).Trajectory, Rcycles, Lcycles, Trial.n1);
end

for is = 1:length(Trial.Segment)
    for fn = {'rM','Q','T','Euler','dj'}
        if isfield(Trial.Segment(is), fn{1})
            Trial.Segment(is).(fn{1}) = normaliseField( ...
                Trial.Segment(is).(fn{1}), Rcycles, Lcycles, Trial.n1);
        end
    end
end

for ij = 1:length(Trial.Joint)
    for fn = {'T','Euler','dj'}
        if isfield(Trial.Joint(ij), fn{1})
            Trial.Joint(ij).(fn{1}) = normaliseField( ...
                Trial.Joint(ij).(fn{1}), Rcycles, Lcycles, Trial.n1);
        end
    end
    if (ij == 1 || ij == 6) && ...
       isfield(Trial.Joint(ij), 'ElevationPlane') && ...
       ~isempty(Trial.Joint(ij).ElevationPlane.full)
        Trial.Joint(ij).ElevationPlane = normaliseField( ...
            Trial.Joint(ij).ElevationPlane, Rcycles, Lcycles, Trial.n1);
    end
end
end

% -------------------------------------------------------------------------
%  NORMALISATION D'UN CHAMP (full -> rcycle / lcycle)
% -------------------------------------------------------------------------
function field = normaliseField(field, Rcycles, Lcycles, N)

if ~isfield(field, 'full') || isempty(field.full), return; end

full = field.full;
sz   = size(full);
nd   = length(sz);

for side = 1:2
    if side == 1, cycles = Rcycles; cf = 'rcycle';
    else,         cycles = Lcycles; cf = 'lcycle';
    end

    if isempty(cycles)
        field.(cf) = [];
        continue;
    end

    accumulated = [];

    for ic = 1:length(cycles)
        rng     = cycles(ic).range;
        rng     = rng(rng >= 1 & rng <= N);
        if length(rng) < 2, continue; end

        n       = length(rng);
        k0      = (1:n)';
        k1      = linspace(1, n, 101)';

        idx     = repmat({':'}, 1, nd);
        idx{nd} = rng;
        chunk   = full(idx{:});

        nLead   = prod(sz(1:end-1));
        flat    = reshape(chunk, nLead, n);

        if ~any(isnan(flat(:)))
            flat_i = interp1(k0, flat', k1, 'spline')';
        else
            flat_i = nan(nLead, 101);
        end

        ic_data  = reshape(flat_i, [sz(1:end-1), 101]);
        new_data = reshape(ic_data, [sz(1:end-1), 101, 1]);

        if isempty(accumulated)
            accumulated = new_data;
        else
            accumulated = cat(nd + 1, accumulated, new_data);
        end
    end

    field.(cf) = accumulated;
end
end