% Author     :   F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   June 2022
% -------------------------------------------------------------------------
% Description:   To be defined
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Normal = LoadNormativeData(Folder,Session,Patient)

% Maximal angles
% -------------------------------------------------------------------------
% Get normals adjusted by age and gender
patientAge = str2num(datestr(datenum(Session.date)-datenum(Patient.dob),'YYYY'));
patientGender = Patient.gender;
if patientAge < 31
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F5');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G5');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D5');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E5');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H5');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I5');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J5');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K5');
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F6');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G6');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D6');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E6');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H6');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I6');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J6');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K6');
    end
end
if patientAge >= 31 && patientAge < 41
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F7');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G7');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D7');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E7');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H7');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I7');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J7');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K7');
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F8');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G8');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D8');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E8');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H8');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I8');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J8');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K8');
    end
end
if patientAge >= 41 && patientAge < 51
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F9');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G9');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D9');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E9');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H9');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I9');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J9');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K9');
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F10');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G10');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D10');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E10');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H10');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I10');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J10');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K10');
    end
end
if patientAge >= 51 && patientAge < 61
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F11');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G11');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D11');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E11');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H11');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I11');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J11');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K11');
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F12');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G12');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D12');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E12');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H12');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I12');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J12');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K12');
    end
end
if patientAge >= 61 && patientAge < 71
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F13');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G13');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D13');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E13');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H13');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I13');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J13');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K13');
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F14');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G14');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D14');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E14');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H14');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I14');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J14');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K14');
    end
end
if patientAge >= 71
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F15');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G15');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D15');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E15');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H15');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I15');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J15');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K15');
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F16');
        Normal.Analytic(2).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G16');
        Normal.Analytic(1).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D16');
        Normal.Analytic(1).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E16');
        Normal.Analytic(3).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'H16');
        Normal.Analytic(3).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'I16');
        Normal.Analytic(4).mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'J16');
        Normal.Analytic(4).std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'K16');
    end
end
Normal.Analytic(2).SHR.mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'F22');
Normal.Analytic(2).SHR.std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'G22');
Normal.Analytic(1).SHR.mean = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'D22');
Normal.Analytic(1).SHR.std = xlsread([Folder.dependencies,'ConstantNormatives.xlsx'],1,'E22');