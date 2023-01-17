% Author     :   F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   May 2022
% -------------------------------------------------------------------------
% Description:   Import Session.xlsx file data
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function [Patient,Session,Pathology] = ImportSessionData()

% Extract data
[~,~,tSession]               = xlsread('Session.xlsx','Cinesiologie','A4:F57');
% Patient
Patient.ID                   = cell2mat(tSession(1,2));
Patient.lastname             = cell2mat(tSession(2,2));
Patient.firstname            = cell2mat(tSession(3,2));
Patient.gender               = cell2mat(tSession(4,2));
Patient.dob                  = datetime(cell2mat(tSession(5,2)),'InputFormat','dd.MM.yyyy');
% Pathology
Pathology.Diagnosis.side     = cell2mat(tSession(9,2));
Pathology.Diagnosis.d1       = cell2mat(tSession(10,2));
Pathology.Diagnosis.d2       = cell2mat(tSession(11,2));
Pathology.Diagnosis.d3       = cell2mat(tSession(12,2));
Pathology.Diagnosis.d4       = cell2mat(tSession(13,2));
Pathology.Diagnosis.d5       = cell2mat(tSession(14,2));
Pathology.PlanedSurgery.i1   = cell2mat(tSession(15,2));
Pathology.PlanedSurgery.i2   = cell2mat(tSession(16,2));
Pathology.PlanedSurgery.i3   = cell2mat(tSession(17,2));
Pathology.PlanedSurgery.i4   = cell2mat(tSession(18,2));
Pathology.PlanedSurgery.i5   = cell2mat(tSession(19,2));
Pathology.PreviousSurgery.i1 = cell2mat(tSession(20,2));
Pathology.PreviousSurgery.i2 = cell2mat(tSession(21,2));
Pathology.PreviousSurgery.i3 = cell2mat(tSession(22,2));
Pathology.PreviousSurgery.i4 = cell2mat(tSession(23,2));
Pathology.PreviousSurgery.i5 = cell2mat(tSession(24,2));
% Session
Session.ID                   = cell2mat(tSession(26,2));
Session.date                 = datetime(cell2mat(tSession(29,2)),'InputFormat','dd.MM.yyyy');
Session.objective            = cell2mat(tSession(30,2));
Session.physician            = cell2mat(tSession(27,2));
Session.operator             = cell2mat(tSession(28,2));
Session.protocol             = cell2mat(tSession(32,2));
Session.markerHeight1        = 0.0095; % m, related to scapular and clavicle markers
Session.markerHeight2        = 0.0140; % m, related to thorax and humerus markers
Session.patientBodyMass      = cell2mat(tSession(6,2)); % kg
Session.patientHeight        = cell2mat(tSession(7,2))*1e-2; % m
Session.comments             = cell2mat(tSession(51,1));
Session.Pain.label           = tSession(31:43,1);
Session.Pain.value           = cell2mat(tSession(35:47,2));