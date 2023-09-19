% Author       : F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/NSLBP-BIOToolbox
% Reference    : To be defined
% Date         : May 2022
% -------------------------------------------------------------------------
% Description  : To be defined
% Inputs       : To be defined
% Outputs      : To be defined
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function [] = CalibrateACM(Session,Folder)

% -------------------------------------------------------------------------
% RIGHT ACM CALIBRATION
% -------------------------------------------------------------------------
% Get 3D marker trajectories
cd([Folder.data,'\Processed\']);
temp    = dir('*STATIC1*.c3d');
c3dFile = temp.name;
btkFile = btkReadAcquisition(c3dFile);
Marker  = btkGetMarkers(btkFile);
n       = size(Marker.SJN,1);
clear temp;
% Define ACM technical coordinate system
Oacs = Marker.RACM2;
Xacs = Marker.RACM1-Marker.RACM2;
Xacs = Xacs./sqrt(Xacs(:,1).^2+Xacs(:,2).^2+Xacs(:,3).^2);
Yacs = cross(Marker.RACM2-Marker.RACM3,Marker.RACM1-Marker.RACM2);
Yacs = Yacs./sqrt(Yacs(:,1).^2+Yacs(:,2).^2+Yacs(:,3).^2);
Zacs = cross(Xacs,Yacs);
Yacs = cross(Zacs,Xacs);
Tacs = [Xacs' Yacs' Zacs' Oacs'; 0 0 0 1];
% Set scapular plane normal
scapularNormal = cross(Marker.RSAA-Marker.RSIA,Marker.RSRS-Marker.RSIA);
scapularNormal = scapularNormal./sqrt(scapularNormal(:,1).^2+scapularNormal(:,2).^2+scapularNormal(:,3).^2);
% Set SIA, SRS, SAA and SCT markers in the ACM technical coordinate system
% Remove marker height along the scapular plane normal
% (negative direction for SIA, SAA and SRS, positive direction for SCT)
Session.LocalPoints.RSIA = inv(Tacs)*[Marker.RSIA'-Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.RSIA = Session.LocalPoints.RSIA(1:3);
Session.LocalPoints.RSRS = inv(Tacs)*[Marker.RSRS'-Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.RSRS = Session.LocalPoints.RSRS(1:3);
Session.LocalPoints.RSAA = inv(Tacs)*[Marker.RSAA'-Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.RSAA = Session.LocalPoints.RSAA(1:3);
Session.LocalPoints.RSCT = inv(Tacs)*[Marker.RSCT'+Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.RSCT = Session.LocalPoints.RSCT(1:3);
% Load C3D files
cd([Folder.data,'\Processed\']);
c3dFiles   = dir('*.c3d');
trialTypes = {'STATIC','ANALYTIC','FUNCTIONAL','FORCE'};
k          = 1;
for i = 1:size(c3dFiles,1)
    for j = 1:size(trialTypes,2)
        if contains(c3dFiles(i).name,trialTypes{j})    
            Trial(k).file    = c3dFiles(i).name;
            Trial(k).btk     = btkReadAcquisition(c3dFiles(i).name);
            Trial(k).n0      = btkGetFirstFrame(Trial(k).btk);
            Trial(k).n1      = btkGetLastFrame(Trial(k).btk)-Trial(k).n0+1;
            Trial(k).fmarker = btkGetPointFrequency(Trial(k).btk);
            Trial(k).fanalog = btkGetAnalogFrequency(Trial(k).btk);
            k                = k+1;
        end
    end
end
% For each file
for itrial = 1:size(Trial,2)
    % Get markers
    Marker = btkGetMarkers(Trial(itrial).btk);
    % Define ACM technical coordinate system
    % Compute and express scapula landmarks in the inertial coordinate system
    Oacs = Marker.RACM2;
    Xacs = Marker.RACM1-Marker.RACM2;
    Xacs = Xacs./sqrt(Xacs(:,1).^2+Xacs(:,2).^2+Xacs(:,3).^2);
    Yacs = cross(Marker.RACM2-Marker.RACM3,Marker.RACM1-Marker.RACM2);
    Yacs = Yacs./sqrt(Yacs(:,1).^2+Yacs(:,2).^2+Yacs(:,3).^2);
    Zacs = cross(Xacs,Yacs);
    Yacs = cross(Zacs,Xacs);
    for t = 1:size(Oacs,1)
        clear T_ics_t;
        T_ics_acs         = [[Xacs(t,:)' Yacs(t,:)' Zacs(t,:)'] Oacs(t,:)'; 0 0 0 1]; % from acs to ics
        temp              = T_ics_acs*[Session.LocalPoints.RSIA;1];
        Marker.RSIA2(t,:) = temp(1:3);
        temp              = T_ics_acs*[Session.LocalPoints.RSRS;1];
        Marker.RSRS2(t,:) = temp(1:3);
        temp              = T_ics_acs*[Session.LocalPoints.RSAA;1];
        Marker.RSAA2(t,:) = temp(1:3);
        temp              = T_ics_acs*[Session.LocalPoints.RSCT;1];
        Marker.RSCT2(t,:) = temp(1:3);
    end
    % Update C3D files
    try
        btkAppendPoint(Trial(itrial).btk,'marker','RSIA2',Marker.RSIA2);
        btkAppendPoint(Trial(itrial).btk,'marker','RSRS2',Marker.RSRS2);
        btkAppendPoint(Trial(itrial).btk,'marker','RSAA2',Marker.RSAA2);
        btkAppendPoint(Trial(itrial).btk,'marker','RSCT2',Marker.RSCT2);
    catch ME
        btkSetPoint(Trial(itrial).btk,'RSIA2',Marker.RSIA2);
        btkSetPoint(Trial(itrial).btk,'RSRS2',Marker.RSRS2);
        btkSetPoint(Trial(itrial).btk,'RSAA2',Marker.RSAA2);
        btkSetPoint(Trial(itrial).btk,'RSCT2',Marker.RSCT2);
    end
    btkWriteAcquisition(Trial(itrial).btk,Trial(itrial).file);
end

% -------------------------------------------------------------------------
% LEFT ACM CALIBRATION
% -------------------------------------------------------------------------
% Get 3D marker trajectories
cd([Folder.data,'\Processed\']);
temp    = dir('*STATIC1*.c3d');
c3dFile = temp.name;
btkFile = btkReadAcquisition(c3dFile);
Marker  = btkGetMarkers(btkFile);
n       = size(Marker.SJN,1);
clear temp;
% Define ACM technical coordinate system
Oacs = Marker.LACM2;
Xacs = Marker.LACM1-Marker.LACM2;
Xacs = Xacs./sqrt(Xacs(:,1).^2+Xacs(:,2).^2+Xacs(:,3).^2);
Yacs = cross(Marker.LACM2-Marker.LACM3,Marker.LACM1-Marker.LACM2);
Yacs = Yacs./sqrt(Yacs(:,1).^2+Yacs(:,2).^2+Yacs(:,3).^2);
Zacs = cross(Xacs,Yacs);
Yacs = cross(Zacs,Xacs);
Tacs = [Xacs' Yacs' Zacs' Oacs'; 0 0 0 1];
% Set scapular plane normal
scapularNormal = cross(Marker.LSAA-Marker.LSIA,Marker.LSRS-Marker.LSIA);
scapularNormal = scapularNormal./sqrt(scapularNormal(:,1).^2+scapularNormal(:,2).^2+scapularNormal(:,3).^2);
% Set SIA, SRS, SAA and SCT markers in the ACM technical coordinate system
% Remove marker height along the scapular plane normal
% (negative direction for SIA, SAA and SRS, positive direction for SCT)
Session.LocalPoints.LSIA = inv(Tacs)*[Marker.LSIA'+Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.LSIA = Session.LocalPoints.LSIA(1:3);
Session.LocalPoints.LSRS = inv(Tacs)*[Marker.LSRS'+Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.LSRS = Session.LocalPoints.LSRS(1:3);
Session.LocalPoints.LSAA = inv(Tacs)*[Marker.LSAA'+Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.LSAA = Session.LocalPoints.LSAA(1:3);
Session.LocalPoints.LSCT = inv(Tacs)*[Marker.LSCT'-Session.markerHeight1*scapularNormal';1];
Session.LocalPoints.LSCT = Session.LocalPoints.LSCT(1:3);
% Load C3D files
cd([Folder.data,'\Processed\']);
c3dFiles   = dir('*.c3d');
trialTypes = {'STATIC','ANALYTIC','FUNCTIONAL','FORCE'};
k          = 1;
for i = 1:size(c3dFiles,1)
    for j = 1:size(trialTypes,2)
        if contains(c3dFiles(i).name,trialTypes{j})    
            Trial(k).file    = c3dFiles(i).name;
            Trial(k).btk     = btkReadAcquisition(c3dFiles(i).name);
            Trial(k).n0      = btkGetFirstFrame(Trial(k).btk);
            Trial(k).n1      = btkGetLastFrame(Trial(k).btk)-Trial(k).n0+1;
            Trial(k).fmarker = btkGetPointFrequency(Trial(k).btk);
            Trial(k).fanalog = btkGetAnalogFrequency(Trial(k).btk);
            k                = k+1;
        end
    end
end
% For each file
for itrial = 1:size(Trial,2)
    % Get markers
    Marker = btkGetMarkers(Trial(itrial).btk);
    % Define ACM technical coordinate system
    % Compute and express scapula landmarks in the inertial coordinate system
    Oacs = Marker.LACM2;
    Xacs = Marker.LACM1-Marker.LACM2;
    Xacs = Xacs./sqrt(Xacs(:,1).^2+Xacs(:,2).^2+Xacs(:,3).^2);
    Yacs = cross(Marker.LACM2-Marker.LACM3,Marker.LACM1-Marker.LACM2);
    Yacs = Yacs./sqrt(Yacs(:,1).^2+Yacs(:,2).^2+Yacs(:,3).^2);
    Zacs = cross(Xacs,Yacs);
    Yacs = cross(Zacs,Xacs);
    for t = 1:size(Oacs,1)
        clear T_ics_t;
        T_ics_acs         = [[Xacs(t,:)' Yacs(t,:)' Zacs(t,:)'] Oacs(t,:)'; 0 0 0 1]; % from acs to ics
        temp              = T_ics_acs*[Session.LocalPoints.LSIA;1];
        Marker.LSIA2(t,:) = temp(1:3);
        temp              = T_ics_acs*[Session.LocalPoints.LSRS;1];
        Marker.LSRS2(t,:) = temp(1:3);
        temp              = T_ics_acs*[Session.LocalPoints.LSAA;1];
        Marker.LSAA2(t,:) = temp(1:3);
        temp              = T_ics_acs*[Session.LocalPoints.LSCT;1];
        Marker.LSCT2(t,:) = temp(1:3);
    end
    % Update C3D files
    try
        btkAppendPoint(Trial(itrial).btk,'marker','LSIA2',Marker.LSIA2);
        btkAppendPoint(Trial(itrial).btk,'marker','LSRS2',Marker.LSRS2);
        btkAppendPoint(Trial(itrial).btk,'marker','LSAA2',Marker.LSAA2);
        btkAppendPoint(Trial(itrial).btk,'marker','LSCT2',Marker.LSCT2);
    catch ME
        btkSetPoint(Trial(itrial).btk,'LSIA2',Marker.LSIA2);
        btkSetPoint(Trial(itrial).btk,'LSRS2',Marker.LSRS2);
        btkSetPoint(Trial(itrial).btk,'LSAA2',Marker.LSAA2);
        btkSetPoint(Trial(itrial).btk,'LSCT2',Marker.LSCT2);
    end
    btkWriteAcquisition(Trial(itrial).btk,Trial(itrial).file);
end