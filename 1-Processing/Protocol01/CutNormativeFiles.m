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
% Description:   MAIN routine to cut C3D normative files
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

% -------------------------------------------------------------------------
% SET FOLDERS
% -------------------------------------------------------------------------
MainFolder           = 'C:\Users\Florent\OneDrive - Université de Genève\';
Folder.preprocessing = [MainFolder,'_CLINIQUE\Matlab\KLAB_ShoulderAnalysis_Toolbox\0-Preprocessing\'];
Folder.toolbox       = [MainFolder,'_CLINIQUE\Matlab\KLAB_ShoulderAnalysis_Toolbox\1-Processing\Protocol01\'];
Folder.data          = [MainFolder,'_CLINIQUE\Données\KLAB-UPPERLIMB-PROTOCOL01\Data\_NORME\Lyon_STAPS\'];
Folder.dependencies  = [MainFolder,'_CLINIQUE\Matlab\KLAB_ShoulderAnalysis_Toolbox\1-Processing\dependencies\'];
addpath(genpath(Folder.dependencies));
cd(Folder.data);

% -------------------------------------------------------------------------
% GET FILE
% -------------------------------------------------------------------------
[c3dFile,c3dFolder] = uigetfile('*.c3d'); % File defined by GUI
cd(c3dFolder);
currentFolder       = pwd;
participantID       = currentFolder(end-7:end-4); clear currentFolder;
Trial.btk           = btkReadAcquisition(c3dFile);
Trial.n0            = btkGetFirstFrame(Trial.btk);
Trial.n1            = btkGetLastFrame(Trial.btk)-Trial.n0+1;
Trial.fmarker       = btkGetPointFrequency(Trial.btk);
Trial.fanalog       = btkGetAnalogFrequency(Trial.btk); 
Event               = btkGetEvents(Trial.btk);
Marker              = btkGetMarkers(Trial.btk);
Analog              = btkGetAnalogs(Trial.btk);
nMarker             = fieldnames(Marker);
nAnalog             = fieldnames(Analog);

% -------------------------------------------------------------------------
% SET MOTION/POSTURE LISTS
% -------------------------------------------------------------------------
if contains(c3dFile,'Poses') % Static
    motionList = {1,2, 'CALIBRATION1'; ... % Start event id, stop event id, motion name
                  3,4, 'CALIBRATION2'; ...
                  5,6, 'CALIBRATION3'; ...
                 };
elseif contains(c3dFile,'Mouvements_Florent_01') % Analytic motions
    motionList = {1,2, 'ANALYTIC1'; ...    % Flexion
                  3,4, 'ANALYTIC2'; ...    % Abduction
                  5,6, 'ANALYTIC5'; ...    % Scaption
                  7,8, 'ANALYTIC3'; ...    % External rotation
                  9,10,'ANALYTIC4'; ...    % Internal rotation
                 };
% elseif contains(c3dFile,'Mouvements_Florent_01') % Analytic motions
%     motionList = {1,2, 'ANALYTIC1'; ...    % Flexion
%                   3,4, 'ANALYTIC2'; ...    % Abduction
%                   5,6, 'ANALYTIC3'; ...    % External rotation
%                   7,8, 'ANALYTIC4'; ...    % Internal rotation
%                  };
elseif contains(c3dFile,'Mouvements_Florent_02') % Functional motions
    motionList = {1,2, 'FUNCTIONAL1'; ...  % Touch mouth
                  3,4, 'FUNCTIONAL2'; ...  % Touch top of the head
                  5,6, 'FUNCTIONAL3'; ...  % Reach upper point above head
                  7,8, 'FUNCTIONAL4'; ...  % Reach upper point along the spine
                 };
end
% elseif contains(c3dFile,'Mouvements_Florent_02a') % Functional motions
%     motionList = {1,2, 'FUNCTIONAL1'; ...  % Touch mouth
%                   3,4, 'FUNCTIONAL2'; ...  % Touch top of the head
%                  };
% end
% elseif contains(c3dFile,'Mouvements_Florent_02b') % Functional motions
%     motionList = {1,2, 'FUNCTIONAL3'; ...  % Reach upper point above head
%                   3,4, 'FUNCTIONAL4'; ...  % Reach upper point along the spine
%                  };
% end

% -------------------------------------------------------------------------
% CUT RECORD IN SEPARATE MOTION FILES
% -------------------------------------------------------------------------
for imotion = 1:size(motionList,1)
    start   = fix(Event.Cycle(motionList{imotion,1})*Trial.fmarker);
    stop    = fix(Event.Cycle(motionList{imotion,2})*Trial.fmarker);
    btkFile = btkNewAcquisition(0,stop-start+1,0,10);
    btkSetFrequency(btkFile,Trial.fmarker)
    for imarker = 1:size(nMarker,1)
        btkAppendPoint(btkFile,'marker',nMarker{imarker},Marker.(nMarker{imarker})(start:stop,1:3));
    end
    for ianalog = 1:size(nAnalog,1)
        if start == stop
            btkAppendAnalog(btkFile,nAnalog{ianalog},repmat(Analog.(nAnalog{ianalog})(start*10,1),[10,1]));
        else
            btkAppendAnalog(btkFile,nAnalog{ianalog},Analog.(nAnalog{ianalog})(start*10:start*10+size(Marker.(nMarker{imarker})(start:stop,1:3),1)*10-1,1));
        end
    end
    btkWriteAcquisition(btkFile,[participantID,'-',participantID,'-20240101-PROTOCOL01-',motionList{imotion,3},'-01.c3d']);
end