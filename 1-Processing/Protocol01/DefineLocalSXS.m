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

function SXSlocal = DefineLocalSXS(Folder)

% Load marker trajectories stored in C3D files
cd([Folder.data,'\Processed\']);
temp        = dir('*STATIC3*.c3d');
c3dFile     = temp.name;
btkFile     = btkReadAcquisition(c3dFile);
Marker      = btkGetMarkers(btkFile);
fMarker     = btkGetPointFrequency(btkFile); % Marker trajectories frequency
Event       = btkGetEvents(btkFile);
frame       = round(Event.Remote*fMarker)-btkGetFirstFrame(btkFile)+1;
clear temp;
% Store the virtual marker corresponding to the stylus tip at SXS landmarks
Marker.SXS  = Marker.STY05(frame,:)';
% Store the SXS marker in a thorax technical coordinate system
Ot          = Marker.SJN(frame,:);
Yt          = (Marker.SJN(frame,:)-Marker.SME(frame,:));
Yt          = Yt./sqrt(Yt(:,1).^2+Yt(:,2).^2+Yt(:,3).^2);
Zt          = cross((Marker.SME(frame,:)-Marker.TV5(frame,:)),(Marker.CV7(frame,:)-Marker.TV5(frame,:)));
Zt          = Zt./sqrt(Zt(:,1).^2+Zt(:,2).^2+Zt(:,3).^2);   
Xt          = cross(Yt,Zt); 
Zt          = cross(Xt,Yt);
T_ics_t     = [[Xt' Yt' Zt'] Ot'; 0 0 0 1]; % from t to ics
temp        = inv(T_ics_t)*[Marker.SXS;1];
SXSlocal    = temp(1:3);