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
% Dependencies : To be defined
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
system('taskkill /F /IM EXCEL.EXE'); 
clc;
disp('------------------------------------------------------------------');
disp('KLAB_UpperLimb_toolbox');
disp('Protocole 1');
disp('Auteur : F. Moissenet');
disp('------------------------------------------------------------------');
disp(' ');

% -------------------------------------------------------------------------
% SET FOLDERS
% -------------------------------------------------------------------------
disp('D�finition des r�pertoires de travail');
Folder.preprocessing = 'C:\Users\moissene\OneDrive - unige.ch\_AQMS\Matlab\KLAB_ShoulderAnalysis_Toolbox\0-Preprocessing\';
Folder.toolbox       = 'C:\Users\moissene\OneDrive - unige.ch\_AQMS\Matlab\KLAB_ShoulderAnalysis_Toolbox\1-Processing\Protocol01\';
Folder.data          = uigetdir();
Folder.dependencies  = 'C:\Users\moissene\OneDrive - unige.ch\_AQMS\Matlab\KLAB_ShoulderAnalysis_Toolbox\1-Processing\dependencies\';
addpath(genpath(Folder.dependencies));
disp(' ');

% -------------------------------------------------------------------------
% GET SESSION DATA
% -------------------------------------------------------------------------
disp('R�cup�ration des informations de la session');
addpath(Folder.toolbox);
cd([Folder.data,'\']);
[Patient,Session,Pathology] = ImportSessionData();
rmpath(Folder.toolbox);
disp(['  - Patient   : ',num2str(Patient.ID),' - ',Patient.lastname,' ',Patient.firstname]);
disp(['  - Session   : ',datestr(Session.date,'yyyyMMdd')]);
disp(['  - Protocole : ',Session.protocol]);
disp(['  - Objectif  : ',Session.objective]);
disp(' ');

% -------------------------------------------------------------------------
% PRE-PROCESS DATA
% -------------------------------------------------------------------------
disp('Pr�-traitement des donn�es');
% if ~isfolder('Processed')
    addpath(Folder.preprocessing);
    MAIN_Preprocessing_toolbox(Patient.ID,Session.ID,datestr(Session.date,'yyyyMMdd'),Session.protocol,Folder.preprocessing,[Folder.data,'\Raw\']);
    rmpath(Folder.preprocessing);
% end
disp(' ');

% -------------------------------------------------------------------------
% ADD 3D MARKER TRAJECTORIES BASED ON POINTING TASKS (SXS)
% -------------------------------------------------------------------------
disp('Ajout des marqueurs point�s');
addpath(Folder.toolbox);
STY06                   = CalibrateStylus(Folder);
Session.LocalPoints.SXS = DefineLocalSXS(Folder,STY06);
AddGlobalSXSToFiles(Folder,Session.LocalPoints.SXS);
clear STY06 SXSlocal;
disp(' ');

% -------------------------------------------------------------------------
% FORCE SENSOR CALIBRATION
% -------------------------------------------------------------------------
disp('Calibrage du capteur de force');
mass = 4; % (kg) Mass used for calibration
CalibrateForce(Folder,mass);
clear mass;
disp(' ');

% -------------------------------------------------------------------------
% ACM CALIBRATION
% -------------------------------------------------------------------------
disp('Calibrage des clusters acromiaux');
CalibrateACM(Session,Folder);
disp(' ');
addpath(Folder.toolbox);

% -------------------------------------------------------------------------
% COMPUTE KINEMATICS
% CUT CYCLES
% -------------------------------------------------------------------------
% Get user commands
cd(Folder.preprocessing);
txtFile      = 'userCommands.txt';
userCommands = fileread(txtFile);
eval(userCommands);
% Load data
cd([Folder.data,'\Processed\']);
c3dFiles   = dir('*.c3d');
trialTypes = {'STATIC','ANALYTIC','FUNCTIONAL','ISOMETRIC'};
k          = 1;
for i = 1:size(c3dFiles,1)
    for j = 1:size(trialTypes,2)
        if contains(c3dFiles(i).name,trialTypes{j})  
            % Extract data from C3D files 
            if contains(c3dFiles(i).name,'STATIC')
                Trial(k).task = c3dFiles(i).name(end-13:end-7);
            elseif contains(c3dFiles(i).name,'ANALYTIC')
                Trial(k).task = c3dFiles(i).name(end-15:end-7);
            elseif contains(c3dFiles(i).name,'FUNCTIONAL')
                Trial(k).task = c3dFiles(i).name(end-17:end-7);
            elseif contains(c3dFiles(i).name,'ISOMETRIC')
                Trial(k).task = c3dFiles(i).name(end-16:end-7);
            end
            Trial(k).file    = c3dFiles(i).name;
            Trial(k).btk     = btkReadAcquisition(c3dFiles(i).name);
            Trial(k).n0      = btkGetFirstFrame(Trial(k).btk);
            Trial(k).n1      = btkGetLastFrame(Trial(k).btk)-Trial(k).n0+1;
            Trial(k).fmarker = btkGetPointFrequency(Trial(k).btk);
            Trial(k).fanalog = btkGetAnalogFrequency(Trial(k).btk);            
            % Set units
            Units            = SetUnits(Trial);
            % Import marker trajectories
            Marker           = btkGetMarkers(Trial(k).btk);
            Trial(k).Marker  = [];
            Trial(k)         = InitialiseMarkerTrajectories(markerSet,Trial(k),Marker,Units);
            % Import EMG signals
            Emg = btkGetAnalogs(Trial(k).btk);
            Trial(k).Emg     = [];
            if ~contains(c3dFiles(i).name,'STATIC')
                Trial(k)     = InitialiseEmgSignals(emgSet,Trial(k),Emg);                
            end
            % Initialise virtual marker trajectories
            Trial(k).Vmarker = [];
            Trial(k)         = InitialiseVmarkerTrajectories(Trial(k));
            % Initialise segments
            Trial(k).Segment = [];
            Trial(k)         = InitialiseSegments(Trial(k));
            % Initialise joints
            Trial(k).Joint   = [];
            Trial(k)         = InitialiseJoints(Trial(k));
            % Define body segments (and joint centres)
            Trial(k)         = DefineSegments(c3dFiles(i),Session,Trial(k));
            % Compute inverse kinematics
            Trial(k)         = ComputeKinematics(c3dFiles(i),Trial(k));              
            % Import force data
            Trial(k).Fsensor = [];
            Trial(k)         = InitialiseForceSignals(c3dFiles(i),Trial(k));
            % Define and cut movement cycles
            % Based on humerothoracic kinematics     
            Trial(k)         = CutCycles(c3dFiles(i),Trial(k));
            % Compute SHR
            Trial(k).SHR     = [];
            Trial(k)         = ComputeSHR(c3dFiles(i),Trial(k));
            % Increment trial index
            k                = k+1;
        end
    end
end

% -------------------------------------------------------------------------
% GENERATE REPORT
% -------------------------------------------------------------------------
disp('G�n�ration du rapport');
cd(Folder.data);
mkdir('Report');
cd('Report');
close all;
if isempty(dir('*.docx'))
    copyfile([Folder.toolbox,'Report\KLAB - Analyse quantifi�e du membre sup�rieur - Rapport - Template.docx'],[Folder.data,'\Report\',num2str(Patient.ID),'-',Session.ID,'-',datestr(Session.date,'YYYYmmDD'),'-Rapport.docx']);
    copyfile([Folder.toolbox,'Report\Skeleton_left_shoulder.png'],[Folder.data,'\Report\Skeleton_left_shoulder.png']);
    copyfile([Folder.toolbox,'Report\Skeleton_right_shoulder.png'],[Folder.data,'\Report\Skeleton_right_shoulder.png']);
    copyfile([Folder.toolbox,'Report\Skeleton_top.png'],[Folder.data,'\Report\Skeleton_top.png']);
end
Report = GenerateReportData(Trial);
Normal = LoadNormativeData(Folder,Session,Patient);
GenerateReportPlots(Folder,Session,Report,Normal);
save([Folder.data,'\Report\',num2str(Patient.ID),'-',Session.ID,'-',datestr(Session.date,'YYYYmmDD'),'-Backup.mat']);

% -------------------------------------------------------------------------
% STOP ALL PROCESSES
% -------------------------------------------------------------------------
close all;
cd([Folder.data,'\']);
system('taskkill /F /IM EXCEL.EXE'); 
toc