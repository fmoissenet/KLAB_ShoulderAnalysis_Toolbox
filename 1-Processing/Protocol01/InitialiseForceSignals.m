% Author       : F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : To be defined
% Reference    : To be defined
% Date         : July 2022
% -------------------------------------------------------------------------
% Description  : To be defined
% Inputs       : To be defined
% Outputs      : To be defined
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - icycle
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = InitialiseForceSignals(c3dFiles,Trial)

if contains(c3dFiles.name,'ISOMETRIC1') || contains(c3dFiles.name,'ISOMETRIC2') % Isometric tasks only
    Scalar = btkGetScalars(Trial.btk);
    Event  = btkGetEvents(Trial.btk);
    subForce = [];
    subAngle = []; 
    if isfield(Scalar,'Force') % Force field may be missing if the force sensor was not available or not working
        for icycle = 1:length(Event.Remote)
            if icycle < 4
                Event.Remote(icycle) = fix(Event.Remote(icycle)*Trial.fmarker);
                if Event.Remote(icycle)+Trial.fmarker-1 < size(Scalar.Force,1)
                    subForce = [subForce mean(Scalar.Force(Event.Remote(icycle):Event.Remote(icycle)+Trial.fmarker-1,1))]; % Mean value during 1s analog acquisition 
                else
                    subForce = [subForce mean(Scalar.Force(Event.Remote(icycle):end,1))];
                    endubForce = [];
                end
                if contains(c3dFiles.name,'ISOMETRIC1') % Right
                    if Event.Remote(icycle)+Trial.fmarker-1 < size(Scalar.Force,1)
                        subAngle = [subAngle mean(abs(Trial.Joint(1).Euler.full(:,1,Event.Remote(icycle):Event.Remote(icycle)+Trial.fmarker-1)),3)]; % Mean value during 1s analog acquisition 
                    else
                        subAngle = [subAngle mean(abs(Trial.Joint(1).Euler.full(:,1,Event.Remote(icycle):end)),3)];
                    end
                elseif contains(c3dFiles.name,'ISOMETRIC2') % Left
                    if Event.Remote(icycle)+Trial.fmarker-1 < size(Scalar.Force,1)
                        subAngle = [subAngle mean(abs(Trial.Joint(6).Euler.full(:,1,Event.Remote(icycle):Event.Remote(icycle)+Trial.fmarker-1)),3)]; % Mean value during 1s analog acquisition 
                    else
                        subAngle = [subAngle mean(abs(Trial.Joint(6).Euler.full(:,1,Event.Remote(icycle):end)),3)];
                    end
                end
            end
        end
        Trial.Fsensor.label = 'Force sensor';
        Trial.Fsensor.Force.value = subForce; % (N)
        Trial.Fsensor.Force.units = 'N';
        Trial.Fsensor.Angle.value = subAngle; % (°deg)
        Trial.Fsensor.Angle.units = '°deg';
        clear temp;
    else
        Trial.Fsensor.label = 'Force sensor';
        Trial.Fsensor.Force.value = []; % (N)
        Trial.Fsensor.Force.units = 'N';
        Trial.Fsensor.Angle.value = []; % (°deg)
        Trial.Fsensor.Angle.units = '°deg';
    end
else
    Trial.Fsensor.label = 'Force sensor';
    Trial.Fsensor.Force.value = []; % (N)
    Trial.Fsensor.Force.units = 'N';
    Trial.Fsensor.Angle.value = []; % (°deg)
    Trial.Fsensor.Angle.units = '°deg';
end  