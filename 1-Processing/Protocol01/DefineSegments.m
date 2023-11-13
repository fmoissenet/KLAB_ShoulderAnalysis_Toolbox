% Author     :   F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   April 2022
% -------------------------------------------------------------------------
% Description:   Define the segments used in the kinematic chain(s)
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = DefineSegments(c3dFiles,Session,Trial)

% -------------------------------------------------------------------------
% Thorax parameters
% -------------------------------------------------------------------------
% Extract marker trajectories
SJN = Trial.Marker(5).Trajectory.full;
SME = Trial.Marker(6).Trajectory.full;
SXS = Trial.Marker(7).Trajectory.full;
CV7 = Trial.Marker(8).Trajectory.full;
TV5 = Trial.Marker(9).Trajectory.full;
TV8 = Trial.Marker(10).Trajectory.full;
% Segment axes (Wu et al. 2005)
O4 = SJN;
Y4 = Vnorm_array3((CV7+SJN)/2-(TV8+SXS)/2);
Z4 = Vnorm_array3(cross(SJN-(TV8+SXS)/2,CV7-(TV8+SXS)/2));
X4 = Vnorm_array3(cross(Y4,Z4));
Trial.Segment(4).T.full = [X4 Y4 Z4 O4; repmat([0 0 0 1],[1,1,size(SJN,3)])];
% Segment parameters (Naaim thesis)
rP4                      = (CV7+SJN)/2;
rD4                      = (TV8+SXS)/2;
w4                       = Z4;
u4                       = Vnorm_array3(cross((rP4-rD4),w4));
Trial.Segment(4).Q.full  = [u4; rP4; rD4; w4];
Trial.Segment(4).rM.full = [SJN SME SXS CV7 TV5 TV8];

% -------------------------------------------------------------------------
% Right humerus parameters
% -------------------------------------------------------------------------
% Extract marker trajectories
RHDT   = Trial.Marker(26).Trajectory.full;
RHTI   = Trial.Marker(27).Trajectory.full;
RHBI   = Trial.Marker(28).Trajectory.full;
RHME   = Trial.Marker(29).Trajectory.full;
RHLE   = Trial.Marker(30).Trajectory.full;
REOS1  = Trial.Marker(31).Trajectory.full;
REOS2  = Trial.Marker(32).Trajectory.full;
REOS3  = Trial.Marker(33).Trajectory.full;
RCAJ   = Trial.Marker(14).Trajectory.full;
LCAJ   = Trial.Marker(37).Trajectory.full;
if sum(Trial.Marker(57).Trajectory.full(1,1,:)) == 0
    RRSP = [];
else
    RRSP = Trial.Marker(57).Trajectory.full;
end
if sum(Trial.Marker(58).Trajectory.full(1,1,:)) == 0
    RUSP = [];
else
    RUSP = Trial.Marker(58).Trajectory.full;
end
% Define elbow joint centre
REJC                              = (RHME+RHLE)/2;
Trial.Vmarker(10).Trajectory.full = REJC;
% Define glenohumeral joint centre
% Method 1: Rab's regression (Rab et al. 2002)
referenceMarker                   = RCAJ;
referenceLength                   = mean(sqrt(sum(abs(RCAJ-LCAJ).^2,1)),3);
offset                            = -0.17*referenceLength; % -17%
thoraxSIaxis                      = (CV7+SJN)/2-(TV8+SXS)/2;
thoraxSIaxis                      = thoraxSIaxis./sqrt(sum(abs(thoraxSIaxis).^2,1));
RGJC                              = referenceMarker+(offset+Session.markerHeight1)*thoraxSIaxis;
Trial.Vmarker(11).Trajectory.full = RGJC;
% Segment axes (Wu et al. 2005)
O1 = RGJC;
Y1 = Vnorm_array3(RGJC-REJC);
if (~isempty(RUSP) && ~isempty(RRSP)) && (contains(c3dFiles.name,'ANALYTIC3') || contains(c3dFiles.name,'ANALYTIC4'))
    X1 = Vnorm_array3((RUSP+RRSP)/2-REJC); % Wu et al. 2005 option 2
else
    X1 = Vnorm_array3(cross(RGJC-RHLE,RGJC-RHME)); % Wu et al. 2005 option 1
end
Z1 = Vnorm_array3(cross(X1,Y1));
Trial.Segment(1).T.full = [X1 Y1 Z1 O1; repmat([0 0 0 1],[1,1,size(SJN,3)])];
% Segment parameters (Naaim thesis)
u1                       = X1;
rP1                      = RGJC;
rD1                      = REJC;
w1                       = Z1;
Trial.Segment(1).Q.full  = [u1; rP1; rD1; w1];
if sum(sum(REOS1)) == 0 % Case when skin cluster markers are used
    Trial.Segment(1).rM.full = [RHDT RHTI RHBI RHME RHLE];
elseif sum(sum(RHDT)) == 0 % Case when EOS cluster markers are used
    Trial.Segment(1).rM.full = [REOS1 REOS2 REOS3 RHME RHLE];
end

% -------------------------------------------------------------------------
% Right scapula parameters
% -------------------------------------------------------------------------
% Extract marker trajectories
RCAJ  = Trial.Marker(14).Trajectory.full;
RSIA2 = Trial.Vmarker(2).Trajectory.full;
RSRS2 = Trial.Vmarker(3).Trajectory.full;
RSAA2 = Trial.Vmarker(4).Trajectory.full;
RSCT2 = Trial.Vmarker(5).Trajectory.full;
% Segment axes (Wu et al. 2005)
O2 = RSAA2;
Z2 = Vnorm_array3(RSAA2-RSRS2);
X2 = Vnorm_array3(cross(RSRS2-RSIA2,RSAA2-RSIA2));
Y2 = Vnorm_array3(cross(Z2,X2));
Trial.Segment(2).T.full = [X2 Y2 Z2 O2; repmat([0 0 0 1],[1,1,size(RSIA2,3)])];
% Segment parameters
u2                       = X2;
rP2                      = RCAJ; % Should be the equivalent point on scapula, but not available in dataset
rD2                      = RSAA2; % Should be the glenoid fossa centre, but not available in dataset
w2                       = Z2;
Trial.Segment(2).Q.full  = [u2; rP2; rD2; w2];
Trial.Segment(2).rM.full = [RSIA2 RSRS2 RSAA2 RSCT2];

% -------------------------------------------------------------------------
% Right clavicle parameters
% -------------------------------------------------------------------------
% To be done

% -------------------------------------------------------------------------
% Left humerus parameters
% -------------------------------------------------------------------------
% Extract marker trajectories
LHDT  = Trial.Marker(49).Trajectory.full;
LHTI  = Trial.Marker(50).Trajectory.full;
LHBI  = Trial.Marker(51).Trajectory.full;
LHME  = Trial.Marker(52).Trajectory.full;
LHLE  = Trial.Marker(53).Trajectory.full;
LEOS1  = Trial.Marker(54).Trajectory.full;
LEOS2  = Trial.Marker(55).Trajectory.full;
LEOS3  = Trial.Marker(56).Trajectory.full;
RCAJ  = Trial.Marker(14).Trajectory.full;
LCAJ  = Trial.Marker(37).Trajectory.full;
if sum(Trial.Marker(61).Trajectory.full(1,1,:)) == 0
    LRSP = [];
else
    LRSP = Trial.Marker(61).Trajectory.full;
end
if sum(Trial.Marker(62).Trajectory.full(1,1,:)) == 0
    LUSP = [];
else
    LUSP = Trial.Marker(62).Trajectory.full;
end
% Define elbow joint centre
LEJC                              = (LHME+LHLE)/2;
Trial.Vmarker(12).Trajectory.full = LEJC;
% Define glenohumeral joint centre
% Method 1: Rab's regression (Rab et al. 2002)
referenceMarker                   = LCAJ;
referenceLength                   = mean(sqrt(sum(abs(RCAJ-LCAJ).^2,1)),3);
offset                            = -0.17*referenceLength; % -17%
thoraxSIaxis                      = (CV7+SJN)/2-(TV8+SXS)/2;
thoraxSIaxis                      = thoraxSIaxis./sqrt(sum(abs(thoraxSIaxis).^2,1));
LGJC                              = referenceMarker+(offset+Session.markerHeight1)*thoraxSIaxis;
Trial.Vmarker(13).Trajectory.full = LGJC;
% Segment axes (Wu et al. 2005)
O5 = LGJC;
Y5 = Vnorm_array3(LGJC-LEJC);
if (~isempty(LUSP) && ~isempty(LRSP)) && (contains(c3dFiles.name,'ANALYTIC3') || contains(c3dFiles.name,'ANALYTIC4'))
    X5 = Vnorm_array3((LUSP+LRSP)/2-LEJC); % Wu et al. 2005 option 2
else
    X5 = Vnorm_array3(cross(LGJC-LHLE,LGJC-LHME)); % Wu et al. 2005 option 1
end
Z5 = Vnorm_array3(cross(X5,Y5));
Trial.Segment(5).T.full = [X5 Y5 Z5 O5; repmat([0 0 0 1],[1,1,size(SJN,3)])];
% Segment parameters (Naaim thesis)
u5                       = X5;
rP5                      = LGJC;
rD5                      = LEJC;
w5                       = Z5;
Trial.Segment(5).Q.full  = [u5; rP5; rD5; w5];
if sum(sum(LEOS1)) == 0 % Case when skin cluster markers are used
    Trial.Segment(5).rM.full = [LHDT LHTI LHBI LHME LHLE];
elseif sum(sum(LHDT)) == 0 % Case when EOS cluster markers are used
    Trial.Segment(5).rM.full = [LEOS1 LEOS2 LEOS3 LHME LHLE];
end

% -------------------------------------------------------------------------
% Left scapula parameters
% -------------------------------------------------------------------------
% Extract marker trajectories
LCAJ = Trial.Marker(37).Trajectory.full;
LSIA2 = Trial.Vmarker(6).Trajectory.full;
LSRS2 = Trial.Vmarker(7).Trajectory.full;
LSAA2 = Trial.Vmarker(8).Trajectory.full;
LSCT2 = Trial.Vmarker(9).Trajectory.full;
% Segment axes (Wu et al. 2005)
O6 = LSAA2;
Z6 = Vnorm_array3(LSAA2-LSRS2);
X6 = Vnorm_array3(cross(LSRS2-LSIA2,LSAA2-LSIA2));
Y6 = Vnorm_array3(cross(Z6,X6));
Trial.Segment(6).T.full = [X6 Y6 Z6 O6; repmat([0 0 0 1],[1,1,size(LSIA2,3)])];
% Segment parameters
u6                       = X6;
rP6                      = LCAJ; % Should be the equivalent point on scapula, but not available in dataset
rD6                      = LSAA2; % Should be the glenoid fossa centre, but not available in dataset
w6                       = Z6;
Trial.Segment(6).Q.full  = [u6; rP6; rD6; w6];
Trial.Segment(6).rM.full = [LSIA2 LSRS2 LSAA2 LSCT2];

% -------------------------------------------------------------------------
% Left clavicle parameters
% -------------------------------------------------------------------------
% To be done