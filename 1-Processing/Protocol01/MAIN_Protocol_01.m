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
% Description:   MAIN routine for the instrumented Constant Shoulder Test
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% INIT WORKSPACE
% -------------------------------------------------------------------------
tic
clearvars;
close all;
warning off;
clc;
disp('------------------------------------------------------------------');
disp('KLAB_UpperLimb_toolbox');
disp('Protocole 1');
disp('Auteur : F. Moissenet');
disp('Version : 2 (July 2023)');
disp('------------------------------------------------------------------');
disp(' ');

% -------------------------------------------------------------------------
% SET FOLDERS
% -------------------------------------------------------------------------
disp('Définition des répertoires de travail');
Folder.preprocessing = 'C:\Users\moissene\OneDrive - unige.ch\_AQMS\Matlab\KLAB_ShoulderAnalysis_Toolbox\0-Preprocessing\';
Folder.toolbox       = 'C:\Users\moissene\OneDrive - unige.ch\_AQMS\Matlab\KLAB_ShoulderAnalysis_Toolbox\1-Processing\Protocol01\';
Folder.data          = uigetdir(); % Patient folder defined by GUI
Folder.dependencies  = 'C:\Users\moissene\OneDrive - unige.ch\_AQMS\Matlab\KLAB_ShoulderAnalysis_Toolbox\1-Processing\dependencies\';
addpath(genpath(Folder.dependencies));
disp(' ');

% -------------------------------------------------------------------------
% GET SESSION DATA
% -------------------------------------------------------------------------
disp('Récupération des informations de la session');
addpath(Folder.toolbox);
cd([Folder.data,'\']);
[Patient,Session,Pathology] = ImportSessionData();
rmpath(Folder.toolbox);
disp(['  - Patient   : ',num2str(Patient.ID),' - ',Patient.lastname,' ',Patient.firstname]);
disp(['  - Session   : ',datestr(Session.date,'YYYYmmDD')]);
disp(['  - Protocole : ',Session.protocol]);
disp(['  - Objectif  : ',Session.objective]);
disp(' ');

% -------------------------------------------------------------------------
% PRE-PROCESS DATA
% -------------------------------------------------------------------------
% - Markers: fill gap (intercor), smoothing (movmean)
% - EMG: zeroing (mean), filtering (btw bandpass 4th order 30-450 Hz)
% - Force: smoothing (btw lowpass 2nd order 10 Hz)
% -------------------------------------------------------------------------
disp('Pré-traitement des données');
if ~isfolder('Processed')
    addpath(Folder.preprocessing);
    MAIN_Preprocessing_toolbox(Patient.ID,Session.ID,datestr(Session.date,'YYYYmmDD'),Session.protocol,Folder.preprocessing,[Folder.data,'\Raw\']);
    rmpath(Folder.preprocessing);
end
addpath(Folder.toolbox);
cd(Folder.toolbox);

% -------------------------------------------------------------------------
% PROCESS DATA
% -------------------------------------------------------------------------
% Get user commands
cd(Folder.preprocessing);
txtFile      = 'userCommands.txt';
userCommands = fileread(txtFile);
eval(userCommands);
% Load data
cd([Folder.data,'\Processed\']);
c3dFiles   = dir('*.c3d');
trialTypes = {'CALIBRATION','ANALYTIC','FUNCTIONAL'};
k          = 1;
for i = [7,8,5,6,9,10,1,2,3,4] %[7,8,5,6,9,10,1,2,3,4,11,12,13,14]
    for j = 1:size(trialTypes,2)
        if contains(c3dFiles(i).name,trialTypes{j})  
            disp(' ');
            % Extract data from C3D files 
            if contains(c3dFiles(i).name,'CALIBRATION')
                Trial(k).task = c3dFiles(i).name(end-18:end-7);
            elseif contains(c3dFiles(i).name,'ANALYTIC')
                Trial(k).task = c3dFiles(i).name(end-15:end-7);
            elseif contains(c3dFiles(i).name,'FUNCTIONAL')
                Trial(k).task = c3dFiles(i).name(end-17:end-7);
            end
            Trial(k).file        = c3dFiles(i).name;
            Trial(k).btk         = btkReadAcquisition(c3dFiles(i).name);
            Trial(k).n0          = btkGetFirstFrame(Trial(k).btk);
            Trial(k).n1          = btkGetLastFrame(Trial(k).btk)-Trial(k).n0+1;
            Trial(k).fmarker     = btkGetPointFrequency(Trial(k).btk);
            Trial(k).fanalog     = btkGetAnalogFrequency(Trial(k).btk);       
            disp(['Chargement du fichier : ',Trial(k).task]);
            % Set units
            Units                = SetUnits(Trial);
            % Import events
            Event                = btkGetEvents(Trial(k).btk);
            % Import marker trajectories
            Marker               = btkGetMarkers(Trial(k).btk);
            Trial(k).Marker      = [];
            Trial(k)             = InitialiseMarkerTrajectories(markerSet,Trial(k),Marker,Units);
            % Initialise virtual marker trajectories
            Trial(k).Vmarker     = [];
            Trial(k)             = InitialiseVmarkerTrajectories(Trial(k));            
            % Add pointed landmarks as virtual markers
            pointList            = {'SXS'}; % List of virtual markers pointed with stylus (the order must be the same than the events stored in C3D file)
            if contains(c3dFiles(i).name,'CALIBRATION3')
                Vmarker          = [];
            end
            [Trial(k),Vmarker]   = AddPointedLandmarks(Trial(k),Marker,Vmarker,Event,pointList);
            % Add acromial cluster landmarks as virtual markers
            [Trial(k),Vmarker]   = AddACMLandmarks(Session,Trial(k),Marker,Vmarker);
            % Import force data
            Trial(k).Fsensor     = [];
            mass                 = 4; % (kg) Mass used for calibration
            Analog               = btkGetAnalogs(Trial(k).btk);
            if strcmp(Trial(k).task,'CALIBRATION5') || strcmp(Trial(k).task,'CALIBRATION6')
                calibration      = Trial(2).Fsensor.calibration; % from CALIBRATION4
            else
                calibration      = [];
            end
            Trial(k)             = InitialiseForceSignals(c3dFiles(i),Trial(k),Analog,Event,mass,calibration);
            % Import EMG signals
            Trial(k).Emg         = [];
            if strcmp(Trial(k).task,'CALIBRATION3')                
                Trial(k)         = InitialiseEmgSignals(emgSet,Trial(k),[],Analog);
            else                
                Trial(k)         = InitialiseEmgSignals(emgSet,Trial(k),Trial(1),Analog); % Load Trial(1) as reference baseline container
            end
            % Manage kinematics
            Trial(k).Segment     = [];
            Trial(k).Joint       = [];
            Trial(k).Rcycle      = [];
            Trial(k).Lcycle      = [];
            Trial(k).SHR         = [];
            if i ~= 7 && i ~= 8 % Not applicable
                % Initialise segments
                Trial(k)         = InitialiseSegments(Trial(k));
                % Initialise joints
                Trial(k)         = InitialiseJoints(Trial(k));
                % Define body segments (and joint centres)
                Trial(k)         = DefineSegments(c3dFiles(i),Session,Trial(k));   
                % Compute inverse kinematics
                Trial(k)         = ComputeKinematics(c3dFiles(i),Trial(k));
                % Define and cut movement cycles
                % Based on humerothoracic kinematics
                figure;       
                btype = 1; % Automatic baseline selection
                Trial(k)         = CutCycles(c3dFiles(i),Trial(k),btype);
                % Compute SHR
                Trial(k)         = ComputeSHR(c3dFiles(i),Trial(k));
                close all;
            end
            % Update C3D files
            UpdateC3DFile(Trial(k),c3dFiles(i));
            % Increment trial index
            k                    = k+1;
        end
    end
end

% % -------------------------------------------------------------------------
% % GENERATE REPORT
% % -------------------------------------------------------------------------
% disp('Génération du rapport');
% cd(Folder.data);
% mkdir('Report');
% cd('Report');
% close all;
% if isempty(dir('*.docx'))
%     copyfile([Folder.toolbox,'Report\KLAB - Analyse quantifiée du membre supérieur - Rapport - Template.docx'],[Folder.data,'\Report\',num2str(Patient.ID),'-',Session.ID,'-',datestr(Session.date,'YYYYmmDD'),'-Rapport.docx']);
%     copyfile([Folder.toolbox,'Report\Skeleton_left_shoulder.png'],[Folder.data,'\Report\Skeleton_left_shoulder.png']);
%     copyfile([Folder.toolbox,'Report\Skeleton_right_shoulder.png'],[Folder.data,'\Report\Skeleton_right_shoulder.png']);
%     copyfile([Folder.toolbox,'Report\Skeleton_top.png'],[Folder.data,'\Report\Skeleton_top.png']);
% end
% Report = GenerateReportData(Trial);
% Normal = LoadNormativeData(Folder,Session,Patient);
% GenerateReportPlots(Folder,Session,Report,Normal);

% -------------------------------------------------------------------------
% STORE RESULTS
% -------------------------------------------------------------------------
clearvars -except Folder Patient Session Pathology Processing Trial;
% save([Folder.data,'\',num2str(Patient.ID),'-',Session.ID,'-',datestr(Session.date,'YYYYmmDD'),'-',datestr(datetime('today'),'YYYYmmDD'),'.mat']);
save([Folder.data,'\P',num2str(Patient.ID),'.mat']);

% % -------------------------------------------------------------------------
% % STOP ALL PROCESSES
% % -------------------------------------------------------------------------
% close all;
% cd([Folder.data,'\']);
% toc