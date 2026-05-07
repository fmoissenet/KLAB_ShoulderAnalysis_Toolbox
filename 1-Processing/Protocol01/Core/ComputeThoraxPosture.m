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
% Description:   Compute thorax posture summary (PostureSummary) relative to
%                the patient-referenced ICS.
%
%                Joint(11).Euler.full is read directly from ComputeKinematics
%                (computed via Segment(8) ICS defined in DefineSegments),
%                so this function focuses exclusively on :
%                  - Statistical summary of thorax kinematics
%                  - Thoracic curvature angle (Cobb approach)
%                  - Moroder classification (scapular internal rotation)
%
% Inputs  : Trial   (struct)  with Joint(11).Euler.full, Segment(4).T.full,
%                             Marker and Joint(3), Joint(8) populated

% Outputs : Trial   (struct)  Joint(11).PostureSummary populated
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = ComputeThoraxPosture(Trial)

% Joint(11) must be populated by ComputeKinematics
if isempty(Trial.Joint(11).Euler.full)
    warning('Joint(11).Euler.full is empty');
    return;
end

% -------------------------------------------------------------------------
% READ EULER ANGLES FROM Joint(11)
%   (1,1,:) X — lateral tilt      (+= tilt toward right)
%   (1,2,:) Y — axial rotation    (+= rotation toward right)
%   (1,3,:) Z — kyphosis/flexion  (+= anterior flexion)
% -------------------------------------------------------------------------
euler_X = squeeze(Trial.Joint(11).Euler.full(1,1,:))'; 
euler_Y = squeeze(Trial.Joint(11).Euler.full(1,2,:))'; 
euler_Z = squeeze(Trial.Joint(11).Euler.full(1,3,:))';

% -------------------------------------------------------------------------
% STATISTICAL SUMMARY
% -------------------------------------------------------------------------
Trial.Joint(11).PostureSummary.axialRotation_mean  = mean(euler_Y, 'omitnan');
Trial.Joint(11).PostureSummary.lateralTilt_mean    = mean(euler_X, 'omitnan');
Trial.Joint(11).PostureSummary.kyphosis_mean       = mean(euler_Z, 'omitnan');
Trial.Joint(11).PostureSummary.axialRotation_range = range(euler_Y);
Trial.Joint(11).PostureSummary.lateralTilt_range   = range(euler_X);
Trial.Joint(11).PostureSummary.kyphosis_range      = range(euler_Z);

% -------------------------------------------------------------------------
% THORACIC CURVATURE ANGLE — Cobb approach
% -------------------------------------------------------------------------
% Estimated from spinal marker geometry in the Qualisys ICS sagittal plane,
% independent of the thoracic segment frame.
% Computed over the first 100 frames (patient at rest before movement).
%
% Markers used (posterior, spinal line) :
%   CV7 — C7 spinous process
%   TV5 — T5 spinous process  (kyphosis apex)
%   TV8 — T8 spinous process  (lower thorax)
%   S1  — sacrum
%
% Cobb T1-T12 approach : angle between vector TV8->CV7 and vector S1->TV8
%   projected in the sagittal plane (X=anterior, Z=superior in Qualisys).
%
% Functional classification (Cobb + Roussouly) :
%   < 20 deg : Flat trunk
%   20-40 deg: Moderate curvature — neutral trunk
%   40-55 deg: High curvature — curved trunk
%   > 55 deg : Very high curvature — hyper curved trunk
%
% References :
%   Cobb JR. Outline for the study of scoliosis. AAOS, 1948;5:261-275.
%   Roussouly P et al. Spine, 2005;30(3):346-353.

nPostural = min(100, Trial.n1);

CV7_pos = getMarkerMean(Trial.Marker, 'CV7', nPostural);
TV5_pos = getMarkerMean(Trial.Marker, 'TV5', nPostural);
TV8_pos = getMarkerMean(Trial.Marker, 'TV8', nPostural);
S1_pos  = getMarkerMean(Trial.Marker, 'S1',  nPostural);

% Sagittal plane vectors (X=idx1, Z=idx3 in Qualisys)
v_sup = CV7_pos([1,3]) - TV8_pos([1,3]);  % TV8 -> CV7 (upper global)
v_mid = TV5_pos([1,3]) - TV8_pos([1,3]);  % TV8 -> TV5 (intermediate)
v_inf = TV8_pos([1,3]) - S1_pos([1,3]);   % S1  -> TV8 (lower global)

% Cobb T1-T12 approach
thoracic_curvature_angle = acosd(max(-1, min(1, dot(v_sup, v_inf) / ...
    (norm(v_sup) * norm(v_inf) + 1e-10))));

% Segmental angle superior : CV7-TV5-TV8 (T1-T8 approach)
thoracic_upper_curvature = acosd(max(-1, min(1, dot(v_sup, v_mid) / ...
    (norm(v_sup) * norm(v_mid) + 1e-10))));

% Segmental angle inferior : TV5-TV8-S1 (T5-T12 approach)
thoracic_lower_curvature = acosd(max(-1, min(1, dot(v_mid, v_inf) / ...
    (norm(v_mid) * norm(v_inf) + 1e-10))));

% Functional classification
if thoracic_curvature_angle < 20
    thorax_posture_type = 'Flat trunk (<20 deg)';
elseif thoracic_curvature_angle < 40
    thorax_posture_type = 'Moderate curvature — neutral trunk (20-40 deg)';
elseif thoracic_curvature_angle < 55
    thorax_posture_type = 'High curvature — curved trunk (40-55 deg)';
else
    thorax_posture_type = 'Very high curvature — hyper curved trunk (>55 deg)';
end

Trial.Joint(11).PostureSummary.thoracic_curvature_angle = round(thoracic_curvature_angle, 1);
Trial.Joint(11).PostureSummary.thoracic_upper_curvature = round(thoracic_upper_curvature, 1);
Trial.Joint(11).PostureSummary.thoracic_lower_curvature = round(thoracic_lower_curvature, 1);
Trial.Joint(11).PostureSummary.thorax_posture_type      = thorax_posture_type;

% -------------------------------------------------------------------------
% MORODER CLASSIFICATION — scapular internal rotation (SIR)
% -------------------------------------------------------------------------
% Moroder (2024) classifies patients in 3 types based on scapular
% internal rotation (SIR) measured on CT axial view :
%   Type A (upright, retracted scapulae) : SIR <= 36 deg
%   Type B (intermediate)                : 36 < SIR <= 46 deg
%   Type C (kyphotic, protracted scapulae): SIR > 46 deg
%
% Approximation from kinematics :
%   RST Joint(3) DOF2 Y ~ SIR right
%   LST Joint(8) DOF2 Y ~ SIR left
%   Averaged over the first 100 frames (patient at rest).
%
% Reference :
%   Moroder P et al. J Shoulder Elbow Surg, 2024.

nMoroder = min(100, Trial.n1);

% SIR right --> Joint(3), DOF2 Y
if length(Trial.Joint) >= 3 && ~isempty(Trial.Joint(3).Euler.full)
    SIR_R = mean(abs(squeeze(Trial.Joint(3).Euler.full(1,2,1:nMoroder))), 'omitnan');
else
    SIR_R = NaN;
end

% SIR left --> Joint(8), DOF2 Y
if length(Trial.Joint) >= 8 && ~isempty(Trial.Joint(8).Euler.full)
    SIR_L = mean(abs(squeeze(Trial.Joint(8).Euler.full(1,2,1:nMoroder))), 'omitnan');
else
    SIR_L = NaN;
end

moroder_R = getMoroderType(SIR_R);
moroder_L = getMoroderType(SIR_L);

Trial.Joint(11).PostureSummary.SIR_R     = round(SIR_R, 1);
Trial.Joint(11).PostureSummary.SIR_L     = round(SIR_L, 1);
Trial.Joint(11).PostureSummary.moroder_R = moroder_R;
Trial.Joint(11).PostureSummary.moroder_L = moroder_L;

end

%  MEAN POSITION OF A MARKER OVER nRef FRAMES
function pos = getMarkerMean(MarkerArray, label, nRef)
pos = [];
for i = 1:length(MarkerArray)
    if strcmp(MarkerArray(i).label, label)
        traj = MarkerArray(i).Trajectory.full;
        pos  = mean(traj(:,1,1:min(nRef,size(traj,3))), 3);
        return;
    end
end
if isempty(pos)
    error('Marker ''%s'' not found.', label);
end
end

%  MORODER CLASSIFICATION
function type = getMoroderType(SIR)
if isnan(SIR)
    type = 'N/A';
elseif SIR <= 36
    type = 'Type A — Upright (SIR <=36 deg)';
elseif SIR <= 46
    type = 'Type B — Intermediate (36 < SIR <=46 deg)';
else
    type = 'Type C — Kyphotic (SIR >46 deg)';
end
end