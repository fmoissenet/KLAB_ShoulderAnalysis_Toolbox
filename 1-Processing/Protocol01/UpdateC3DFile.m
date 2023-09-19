% Author     :   F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License    :   Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code:   To be defined
% Reference  :   To be defined
% Date       :   June 2023
% -------------------------------------------------------------------------
% Description:   Update C3D file
% -------------------------------------------------------------------------
% Dependencies : To be defined
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function [] = UpdateC3DFile(Trial)

for ivmarker = 1:4
    try
        btkAppendPoint(Trial.btk,'marker',Trial.Vmarker(ivmarker).label,permute(Trial.Vmarker(ivmarker).Trajectory.full,[3,2,1]),zeros(size(permute(Trial.Vmarker(ivmarker).Trajectory.full,[3,2,1]),1),1),['Units: ',Trial.Vmarker(ivmarker).Trajectory.units]);
    catch ME
        btkSetPoint(Trial.btk,Trial.Vmarker(ivmarker).label,permute(Trial.Vmarker(ivmarker).Trajectory.full,[3,2,1]),zeros(size(permute(Trial.Vmarker(ivmarker).Trajectory.full,[3,2,1]),1),1),['Units: ',Trial.Vmarker(ivmarker).Trajectory.units]);            
    end
end
for ijoint = [1,2,3,6,7,8]
    try
        btkAppendPoint(Trial.btk,'angle',Trial.Joint(ijoint).label,permute(Trial.Joint(ijoint).Euler.full,[3,2,1]),zeros(size(permute(Trial.Joint(ijoint).Euler.full,[3,2,1]),1),1),['Units: ',Trial.Joint(ijoint).Euler.units,', Euler sequence: ',Trial.Joint(ijoint).sequence]);
    catch ME
        if ~isempty(Trial.Joint(ijoint).Euler.full)
            btkSetPoint(Trial.btk,Trial.Joint(ijoint).label,permute(Trial.Joint(ijoint).Euler.full,[3,2,1]),zeros(size(permute(Trial.Joint(ijoint).Euler.full,[3,2,1]),1),1),['Units: ',Trial.Joint(ijoint).Euler.units,', Euler sequence: ',Trial.Joint(ijoint).sequence]);
        end
    end
end
for icycle = 1:size(Trial.Cycle,2)
    if contains(Trial.task,'ANALYTIC1')
        ieuler = 3;
        sign   = 1; 
    elseif contains(Trial.task,'ANALYTIC2')
        ieuler = 1;
        sign   = -1; 
    elseif contains(Trial.task,'ANALYTIC3')
        ieuler = 2;
        sign   = -1; 
    elseif contains(Trial.task,'ANALYTIC4')
        ieuler = 2;
        sign   = 1; 
    end    
    btkAppendEvent(Trial.btk,'Start',Trial.Cycle(icycle).range(1)/Trial.fmarker,''); % Start frame
    [~,ind]  = max(sign*Trial.Joint(1).Euler.full(1,ieuler,Trial.Cycle(icycle).range));
    maxAngle = ind+Trial.Cycle(icycle).range(1)-1;
    btkAppendEvent(Trial.btk,'Max right',maxAngle/Trial.fmarker,''); % Max right angle frame
    [~,ind]  = max(sign*Trial.Joint(6).Euler.full(1,ieuler,Trial.Cycle(icycle).range));
    maxAngle = ind+Trial.Cycle(icycle).range(1)-1;
    btkAppendEvent(Trial.btk,'Max left',maxAngle/Trial.fmarker,''); % Max left angle frame
    btkAppendEvent(Trial.btk,'Stop',Trial.Cycle(icycle).range(end)/Trial.fmarker,''); % Stop frame
end
btkWriteAcquisition(Trial.btk,Trial.file);   