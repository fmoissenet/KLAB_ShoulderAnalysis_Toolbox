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
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F5:F5'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G5:G5'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D5:D5'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E5:E5'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H5:H5'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I5:I5'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J5:J5'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K5:K5'));
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F6:F6'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G6:G6'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D6:D6'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E6:E6'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H6:H6'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I6:I6'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J6:J6'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K6:K6'));
    end
end
if patientAge >= 31 && patientAge < 41
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F7:F7'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G7:G7'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D7:D7'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E7:E7'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H7:H7'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I7:I7'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J7:J7'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K7:K7'));
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F8:F8'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G8:G8'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D8:D8'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E8:E8'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H8:H8'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I8:I8'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J8:J8'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K8:K8'));
    end
end
if patientAge >= 41 && patientAge < 51
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F9:F9'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G9:G9'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D9:D9'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E9:E9'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H9:H9'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I9:I9'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J9:J9'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K9:K9'));
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F10:F10'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G10:G10'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D10:D10'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E10:E10'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H10:H10'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I10:I10'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J10:J10'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K10:K10'));
    end
end
if patientAge >= 51 && patientAge < 61
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F11:F11'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G11:G11'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D11:D11'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E11:E11'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H11:H11'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I11:I11'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J11:J11'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K11:K11'));
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F12:F12'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G12:G12'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D12:D12'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E12:E12'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H12:H12'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I12:I12'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J12:J12'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K12:K12'));
    end
end
if patientAge >= 61 && patientAge < 71
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F13:F13'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G13:G13'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D13:D13'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E13:E13'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H13:H13'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I13:I13'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J13:J13'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K13:K13'));
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F14:F14'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G14:G14'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D14:D14'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E14:E14'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H14:H14'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I14:I14'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J14:J14'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K14:K14'));
    end
end
if patientAge >= 71
    if strcmp(patientGender,'Homme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F15:F15'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G15:G15'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D15:D15'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E15:E15'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H15:H15'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I15:I15'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J15:J15'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K15:K15'));
    elseif strcmp(patientGender,'Femme')
        Normal.Analytic(2).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F16:F16'));
        Normal.Analytic(2).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G16:G16'));
        Normal.Analytic(1).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D16:D16'));
        Normal.Analytic(1).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E16:E16'));
        Normal.Analytic(3).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','H16:H16'));
        Normal.Analytic(3).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','I16:I16'));
        Normal.Analytic(4).mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','J16:J16'));
        Normal.Analytic(4).std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','K16:K16'));
    end
end
Normal.Analytic(2).SHR.mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','F22:F22'));
Normal.Analytic(2).SHR.std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','G22:G22'));
Normal.Analytic(1).SHR.mean = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','D22:D22'));
Normal.Analytic(1).SHR.std = table2array(readtable([Folder.dependencies,'ConstantNormatives.xlsx'],'Range','E22:E22'));