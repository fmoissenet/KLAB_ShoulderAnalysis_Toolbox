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
% Description:   Get SXS position in a local thorax frame
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function SXSlocal = DefineLocalSXS(Folder,STY06)

% Load marker trajectories stored in C3D files
cd([Folder.data,'\Processed\']);
temp        = dir('*STATIC3*.c3d');
c3dFile     = temp.name;
btkFile     = btkReadAcquisition(c3dFile);
Marker      = btkGetMarkers(btkFile);
markerNames = fieldnames(Marker); % Marker names in the marker trajectories
nMarker     = length(Marker.STY01); % n frames stored in the marker trajectories
fMarker     = btkGetPointFrequency(btkFile); % Marker trajectories frequency
Event       = btkGetEvents(btkFile);
frame       = round(Event.Remote*fMarker)-btkGetFirstFrame(btkFile)+1;
clear temp;
% Define stylus coordinate system
Os      = Marker.STY04(frame,:);
Ys      = (Marker.STY02(frame,:)-Marker.STY05(frame,:));
Ys      = Ys./sqrt(Ys(:,1).^2+Ys(:,2).^2+Ys(:,3).^2);
Xs      = cross((Marker.STY03(frame,:)-Marker.STY05(frame,:)),(Marker.STY01(frame,:)-Marker.STY05(frame,:)));
Xs      = Xs./sqrt(Xs(:,1).^2+Xs(:,2).^2+Xs(:,3).^2);   
Zs      = cross(Xs,Ys);
Xs      = cross(Ys,Zs);
T_ics_s = [[Xs' Ys' Zs'] Os'; 0 0 0 1]; % from s to ics
% Compute the virtual marker corresponding to the stylus tip
temp       = T_ics_s*[STY06*1e-3;1]; % It is assumed here that STY06 has been stored in mm and other trajectories in m
Marker.SXS = temp(1:3);
% Store the SXS marker in a thorax technical coordinate system
Ot       = Marker.SJN(frame,:);
Yt       = (Marker.SJN(frame,:)-Marker.SME(frame,:));
Yt       = Yt./sqrt(Yt(:,1).^2+Yt(:,2).^2+Yt(:,3).^2);
Zt       = cross((Marker.SME(frame,:)-Marker.TV5(frame,:)),(Marker.CV7(frame,:)-Marker.TV5(frame,:)));
Zt       = Zt./sqrt(Zt(:,1).^2+Zt(:,2).^2+Zt(:,3).^2);   
Xt       = cross(Yt,Zt); 
Zt       = cross(Xt,Yt);
T_ics_t  = [[Xt' Yt' Zt'] Ot'; 0 0 0 1]; % from t to ics
temp     = inv(T_ics_t)*[Marker.SXS;1];
SXSlocal = temp(1:3);