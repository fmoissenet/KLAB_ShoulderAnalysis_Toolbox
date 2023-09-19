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
% Description:   Define SXS in the inertial coordinate system of each file
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function [] = AddGlobalSXSToFiles(Folder,SXSlocal)

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
    % Define the thorax technical coordinate system
    % Compute and express SXS in the inertial coordinate system
    Ot       = Marker.SJN;
    Yt       = (Marker.SJN-Marker.SME);
    Yt       = Yt./sqrt(Yt(:,1).^2+Yt(:,2).^2+Yt(:,3).^2);
    Zt       = cross((Marker.SME-Marker.TV5),(Marker.CV7-Marker.TV5));
    Zt       = Zt./sqrt(Zt(:,1).^2+Zt(:,2).^2+Zt(:,3).^2);   
    Xt       = cross(Yt,Zt);   
    Zt       = cross(Xt,Yt);
    for t = 1:size(Ot,1)
        clear T_ics_t;
        T_ics_t         = [[Xt(t,:)' Yt(t,:)' Zt(t,:)'] Ot(t,:)'; 0 0 0 1]; % from t to ics
        temp            = T_ics_t*[SXSlocal;1];
        Marker.SXS(t,:) = temp(1:3);
    end
    % Update file
    btkSetPoint(Trial(itrial).btk,'SXS',Marker.SXS);
    btkWriteAcquisition(Trial(itrial).btk,Trial(itrial).file);
end