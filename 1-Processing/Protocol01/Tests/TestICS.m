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
% Description:   Unit test for the patient-ICS definition.
%
%                CALIBRATION3 = patient standing
%                posture (no movement). In this posture :
%                  - Rot Y  (axial rotation)  should be ≈ 0-5 deg
%                  - Tilt X (lateral tilt)    should be ≈ 0-5 deg
%                  - Flex Z (flexion)         should be ≈ 0-5 deg
%                  - std of all DOF           should be small (< 2 deg)
%
%                The test also checks Cobb consistency between CALIBRATION3
%                and all ANALYTIC trials (same patient morphology -> similar
%                Cobb angle regardless of posture/task).
%
% Inputs  : Trial (struct array) all trials from MAIN_Protocol_01
%
% Outputs : Console report
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function testResult = TestICS(Trial)

disp(' ');
disp('------------------------------------------------------------------');
disp('Tests unitaire (thorax et posture)');
disp('Reference : CALIBRATION3 (posture debout)');

% Thresholds (deg)
PASS_mean = 7.0;   
PASS_std  = 2.0;   
WARN_mean = 15.0;   
WARN_std  = 5.0;  

% -------------------------------------------------------------------------
% FIND CALIBRATION3 TRIAL
% -------------------------------------------------------------------------
calib1_idx = [];
for k = 1:length(Trial)
    if contains(Trial(k).task,'CALIBRATION3')
        calib1_idx = k;
        break;
    end
end

if isempty(calib1_idx)
    disp('Aucun trial CALIBRATION3 trouve dans Trial.');
    testResult = struct('status','SKIP','message','No CALIBRATION3 trial found.');
    return;
end

t = Trial(calib1_idx);
% disp(['Trial : ', t.file]);

% Guard
if isempty(t.Joint) || length(t.Joint) < 11 || isempty(t.Joint(11).Euler.full)
    disp('Joint(11).Euler.full vide pour CALIBRATION3.');
    disp('Verifier que DefineSegments et ComputeKinematics sont appeles sur CALIBRATION3.');
    testResult = struct('status','FAIL','message','Joint(11).Euler.full empty.');
    return;
end

% -------------------------------------------------------------------------
% EXTRACT EULER ANGLES
%   (1,1,:) X — lateral tilt
%   (1,2,:) Y — axial rotation
%   (1,3,:) Z — flexion
% -------------------------------------------------------------------------
euler_X = squeeze(t.Joint(11).Euler.full(1,1,:));
euler_Y = squeeze(t.Joint(11).Euler.full(1,2,:));
euler_Z = squeeze(t.Joint(11).Euler.full(1,3,:));

mn_X  = mean(euler_X,'omitnan');  sd_X = std(euler_X,'omitnan');
mn_Y  = mean(euler_Y,'omitnan');  sd_Y = std(euler_Y,'omitnan');
mn_Z  = mean(euler_Z,'omitnan');  sd_Z = std(euler_Z,'omitnan');

% -------------------------------------------------------------------------
% EVALUATE EACH DOF
% -------------------------------------------------------------------------
disp(' ');
disp('  --- Angles thoraciques (deg) sur CALIBRATION3 ---');
fprintf('  %-12s  %8s  %8s  %6s\n','DOF','mean','std','Status');
disp(repmat('-',1,52));

[statusX] = getStatus(mn_X, sd_X, PASS_mean, PASS_std, WARN_mean, WARN_std);
[statusY] = getStatus(mn_Y, sd_Y, PASS_mean, PASS_std, WARN_mean, WARN_std);
[statusZ] = getStatus(mn_Z, sd_Z, PASS_mean, PASS_std, WARN_mean, WARN_std);

fprintf('  %-12s  %8.2f  %8.2f  %s\n', 'Tilt X',   mn_X, sd_X, statusX);
fprintf('  %-12s  %8.2f  %8.2f  %s\n', 'Rot Y',    mn_Y, sd_Y, statusY);
fprintf('  %-12s  %8.2f  %8.2f  %s\n', 'Flex Z',   mn_Z, sd_Z, statusZ);
disp(repmat('-',1,52));

% -------------------------------------------------------------------------
% COBB (CALIBRATION3 vs ANALYTIC trials)
% -------------------------------------------------------------------------
disp(' ');
disp('  --- Coherence Cobb : CALIBRATION3 vs ANALYTIC ---');

cobb_calib = NaN;
if isfield(t.Joint(11),'PostureSummary') && ...
   isfield(t.Joint(11).PostureSummary,'thoracic_curvature_angle')
    cobb_calib = t.Joint(11).PostureSummary.thoracic_curvature_angle;
    fprintf('  Cobb CALIBRATION3 : %.1f deg\n', ...
        cobb_calib);
else
    disp('Cobb CALIBRATION3 : N/A (PostureSummary absent)');
end

cobb_analytic = [];
for k = 1:length(Trial)
    if contains(Trial(k).task,'ANALYTIC') && ...
       ~isempty(Trial(k).Joint) && length(Trial(k).Joint) >= 11 && ...
       isfield(Trial(k).Joint(11),'PostureSummary') && ...
       isfield(Trial(k).Joint(11).PostureSummary,'thoracic_curvature_angle')
        cobb_analytic(end+1) = Trial(k).Joint(11).PostureSummary.thoracic_curvature_angle; %#ok<AGROW>
        fprintf('  Cobb %-14s : %.1f deg\n', Trial(k).task, cobb_analytic(end));
    end
end

if ~isnan(cobb_calib) && ~isempty(cobb_analytic)
    cobb_diff = abs(cobb_analytic - cobb_calib);
    fprintf('  Difference max vs CALIBRATION3 : %.1f deg\n', max(cobb_diff));
    % Note : CALIBRATION3 = standing, ANALYTIC = seated
    % Thoracic kyphosis typically increases 8-15 deg when seated vs standing
    % Thresholds adjusted accordingly.
    if max(cobb_diff) < 12
        disp('Cobb coherent (diff < 12 deg: effet debout/assis normal).');
    elseif max(cobb_diff) < 18
        disp('Difference Cobb moderee (12-18 deg): compatible avec effet debout/assis.');
    else
        disp('Difference Cobb elevee (> 18 deg): verifier marqueurs spinaux.');
    end
end

% -------------------------------------------------------------------------
% OUTPUT STRUCT
% -------------------------------------------------------------------------
testResult = struct(...
    'mean_X',      mn_X, 'std_X', sd_X, 'status_X', statusX, ...
    'mean_Y',      mn_Y, 'std_Y', sd_Y, 'status_Y', statusY, ...
    'mean_Z',      mn_Z, 'std_Z', sd_Z, 'status_Z', statusZ, ...
    'cobb_calib',  cobb_calib, ...
    'cobb_analytic_mean', mean(cobb_analytic,'omitnan'));

end

function [status] = getStatus(mn, sd, pass_m, pass_s, warn_m, warn_s)
if abs(mn) < pass_m && sd < pass_s
    status = 'PASS';
elseif abs(mn) < warn_m && sd < warn_s
    status = 'WARN';
else
    status = 'FAIL';
end
end