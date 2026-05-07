% Author     :   H. Francalanci
%                Biomechanics and Translational Research in Surgery Group
%                University of Geneva
%                https://www.unige.ch/medecine/chiru/en/research-groups/nicolas-holzer-et-florent-moissenet
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   Mai 2026
% -------------------------------------------------------------------------
% Description: (1) Research & Development Branch. 
%              (2) Extension of the KLAB_ShoulderAnalysis_Toolbox (F. Moissenet)
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% INIT WORKSPACE
% -------------------------------------------------------------------------
clearvars;
close all;
warning off;
clc;
disp('------------------------------------------------------------------');
disp('KLAB_UpperLimb_toolbox_Research_Development_Branch_Hugo_Dev');
disp('------------------------------------------------------------------');
disp(' ');

% -------------------------------------------------------------------------
% SET FOLDERS
% ------------------------------------------------------------------------
MainFolder           = 'C:\Users\franc\Desktop';
Folder.toolbox       = [MainFolder,'\KLAB_ShoulderAnalysis_Toolbox\1-Processing\Protocol01'];
Folder.data          = uigetdir(); 
Folder.dependencies  = [MainFolder,'\KLAB_ShoulderAnalysis_Toolbox\1-Processing\dependencies'];
addpath(Folder.toolbox);
addpath(genpath(Folder.dependencies));
addpath(fullfile(Folder.toolbox, 'Core'));
addpath(fullfile(Folder.toolbox, 'Init'));
addpath(fullfile(Folder.toolbox, 'IO'));
addpath(fullfile(Folder.toolbox, 'Plot'));
addpath(fullfile(Folder.toolbox, 'Templates'));
addpath(fullfile(Folder.toolbox, 'Tests'));
disp(' ');

% -------------------------------------------------------------------------
% GET SESSION DATA
% -------------------------------------------------------------------------
disp('Get session information');
disp('-----------------------');
cd([Folder.data,'\']);
[Patient,Session,Pathology] = ImportSessionData();
disp(' ');

% -------------------------------------------------------------------------
% PROCESS DATA
% -------------------------------------------------------------------------
cd(Folder.toolbox);
txtFile      = 'userCommands.txt';
userCommands = fileread(txtFile);
eval(userCommands);
% Load data
cd([Folder.data,'\Processed\']);
c3dFiles   = dir('*.c3d');
trialTypes = {'CALIBRATION','ANALYTIC','FUNCTIONAL'};
k          = 1;

%%
trialOrder = {'CALIBRATION3','CALIBRATION1','CALIBRATION2','CALIBRATION4', ...
              'CALIBRATION5','CALIBRATION6', ...
              'ANALYTIC1','ANALYTIC2','ANALYTIC3','ANALYTIC4','ANALYTIC5', ...
              'FUNCTIONAL1','FUNCTIONAL2','FUNCTIONAL3','FUNCTIONAL4'};
% Robust alternative for i = [7,5,6,8,9,10,1,2,3,4,11,12,13,14]
% Order is same but can handle patient having more or less files 

orderedIdx = zeros(1, length(c3dFiles));
nIdx = 0;
for itype = 1:length(trialOrder)
    for ifile = 1:length(c3dFiles)
        if contains(c3dFiles(ifile).name, trialOrder{itype})
            nIdx = nIdx + 1;
            orderedIdx(nIdx) = ifile;
        end
    end
end
orderedIdx = orderedIdx(1:nIdx);

for i = orderedIdx
    for j = 1:size(trialTypes,2)
        if contains(c3dFiles(i).name, trialTypes{j}) 
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
            disp(['File loading : ',Trial(k).task]);
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
            % Manage kinematics
            Trial(k).Segment     = [];
            Trial(k).Joint       = [];
            Trial(k).Rcycle      = [];
            Trial(k).Lcycle      = [];
            Trial(k).SHR         = [];
            if i ~= 8 % Not applicable
                % Initialise segments
                Trial(k)         = InitialiseSegments(Trial(k));
                % Initialise joints
                Trial(k)         = InitialiseJoints(Trial(k));
                % Define body segments (and joint centres)
                Trial(k)         = DefineSegments(c3dFiles(i),Session,Trial(k));   
                % Compute inverse kinematics
                Trial(k)         = ComputeKinematics(c3dFiles(i),Trial(k));
                % Compute Thorax
                Trial(k)         = ComputeThoraxPosture(Trial(k));
                % Movement cycles (based on .mat)   
                Trial(k)         = CutCycles(c3dFiles(i), Trial(k), Folder.data);
                % Compute SHR
                Trial(k)         = ComputeSHR(c3dFiles(i),Trial(k),Trial(k));
                close all;
            end
            % Increment trial index
            k                    = k+1;
        end
    end
end

% -------------------------------------------------------------------------
% PLOT AND COMPARAISON
% -------------------------------------------------------------------------
close all;

PlotKinematics(Trial, Pathology); % HT, GH, ST, SHR for analytics
for k_plot = 1:length(Trial)
    if contains(Trial(k_plot).task, 'ANALYTIC') % Thorax/Patient-ICS and Cobb posture for analytics
        PlotThoraxPosture(Trial(k_plot), Trial(k_plot).task);
        PlotCobbPosture(Trial(k_plot), Trial(k_plot).task, '')
    end
end
PlotComparison(Trial, Folder.data, Pathology); % Comparaison with .mat from original K-LAB toolbox
% 3rd argument : 'C:\...\auteur_data.xlsx' (for future comparaison with other study)

% -------------------------------------------------------------------------
% Export
% -------------------------------------------------------------------------
ExportPostureSummary(Trial, Patient, Session);

% -------------------------------------------------------------------------
% Validation
% -------------------------------------------------------------------------
TestICS(Trial);

% -------------------------------------------------------------------------
% END
% -------------------------------------------------------------------------
cd(Folder.toolbox);
