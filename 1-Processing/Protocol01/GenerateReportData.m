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

function Report = GenerateReportData(Trial)

for itrial = 1:size(Trial,2)
    if strcmp(Trial(itrial).task,'ANALYTIC1')      
        Report.Analytic(1).label                              = Trial(itrial).task;
        % --
        Report.Analytic(1).Kinematics.Joint(1).label          = 'Articulation huméro-thoracique';
        Report.Analytic(1).Kinematics.Joint(1).side           = 'Droite';
        Report.Analytic(1).Kinematics.Joint(1).Euler          = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(1).Euler,3)
            [~,ind] = max(Report.Analytic(1).Kinematics.Joint(1).Euler(:,3,icycle));
            temp    = permute(Trial(itrial).Joint(1).ElevationPlane.cycle,[3,2,4,1]); 
            if max(temp) > 360
                temp = temp-360;
            end
            if ind == 1 % Special case
                Report.Analytic(1).Kinematics.Joint(1).ElevationPlane.value1(1,1,icycle) = temp(fix(ind),1,icycle); % Elevation
            else
                Report.Analytic(1).Kinematics.Joint(1).ElevationPlane.value1(1,1,icycle) = temp(fix(ind/2),1,icycle); % Elevation
            end
            if ind+ind/2 >= 101 % Special case
                Report.Analytic(1).Kinematics.Joint(1).ElevationPlane.value2(1,1,icycle) = temp(fix((ind+101)/2),1,icycle); % Return
            elseif ind == 101 % Special case
                Report.Analytic(1).Kinematics.Joint(1).ElevationPlane.value2(1,1,icycle) = temp(fix((ind)/2),1,icycle); % Return
            else
                Report.Analytic(1).Kinematics.Joint(1).ElevationPlane.value2(1,1,icycle) = temp(fix(ind+ind/2),1,icycle); % Return
            end            
            clear ind temp;
        end
        Report.Analytic(1).Kinematics.Joint(1).legend         = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(1).Kinematics.Joint(1).units          = Trial(itrial).Joint(1).Euler.units;
        Report.Analytic(1).Kinematics.Joint(2).label          = 'Articulation gléno-humérale';
        Report.Analytic(1).Kinematics.Joint(2).side           = 'Droite';
        Report.Analytic(1).Kinematics.Joint(2).Euler          = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(1).Kinematics.Joint(2).legend         = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(1).Kinematics.Joint(2).units          = Trial(itrial).Joint(2).Euler.units;
        Report.Analytic(1).Kinematics.Joint(3).label          = 'Articulation scapulo-thoracique';
        Report.Analytic(1).Kinematics.Joint(3).side           = 'Droite';
        Report.Analytic(1).Kinematics.Joint(3).Euler          = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(1).Kinematics.Joint(3).legend         = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(1).Kinematics.Joint(3).units          = Trial(itrial).Joint(3).Euler.units;
        Report.Analytic(1).Kinematics.SHR(1).label            = Trial(itrial).SHR(1).label;
        Report.Analytic(1).Kinematics.SHR(1).value1           = permute(Trial(itrial).SHR(1).value1.cycle,[3,1,4,2]); % Elevation
        Report.Analytic(1).Kinematics.SHR(1).value2           = permute(Trial(itrial).SHR(1).value2.cycle,[3,1,4,2]); % Return
        Report.Analytic(1).Kinematics.SHR(1).tvalue           = permute(Trial(itrial).SHR(1).tvalue.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.SHR(1).theta_ST_GH      = permute(Trial(itrial).SHR(1).theta_ST_GH.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.SHR(1).theta_ST         = permute(Trial(itrial).SHR(1).theta_ST.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.SHR(1).theta_GH         = permute(Trial(itrial).SHR(1).theta_GH.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.Joint(6).label          = 'Articulation huméro-thoracique';
        Report.Analytic(1).Kinematics.Joint(6).side           = 'Gauche';
        Report.Analytic(1).Kinematics.Joint(6).Euler          = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        for icycle = 1:size(Report.Analytic(1).Kinematics.Joint(6).Euler,3)
            [~,ind] = max(Report.Analytic(1).Kinematics.Joint(6).Euler(:,3,icycle));
            temp    = permute(Trial(itrial).Joint(6).ElevationPlane.cycle,[3,2,4,1]); 
            if max(temp) > 360
                temp = temp-360;
            end
            if ind == 1 % Special case
                Report.Analytic(1).Kinematics.Joint(6).ElevationPlane.value1(1,1,icycle) = temp(fix(ind),1,icycle); % Elevation
            else
                Report.Analytic(1).Kinematics.Joint(6).ElevationPlane.value1(1,1,icycle) = temp(fix(ind/2),1,icycle); % Elevation
            end
            if ind+ind/2 >= 101 % Special case
                Report.Analytic(1).Kinematics.Joint(6).ElevationPlane.value2(1,1,icycle) = temp(fix((ind+101)/2),1,icycle); % Return
            elseif ind == 101 % Special case
                Report.Analytic(1).Kinematics.Joint(6).ElevationPlane.value2(1,1,icycle) = temp(fix((ind)/2),1,icycle); % Return
            else
                Report.Analytic(1).Kinematics.Joint(6).ElevationPlane.value2(1,1,icycle) = temp(fix(ind+ind/2),1,icycle); % Return
            end   
            clear ind temp;
        end
        Report.Analytic(1).Kinematics.Joint(6).legend         = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(1).Kinematics.Joint(6).units          = Trial(itrial).Joint(6).Euler.units;
        Report.Analytic(1).Kinematics.Joint(7).label          = 'Articulation gléno-humérale';
        Report.Analytic(1).Kinematics.Joint(7).side           = 'Gauche';
        Report.Analytic(1).Kinematics.Joint(7).Euler          = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(1).Kinematics.Joint(7).legend         = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(1).Kinematics.Joint(7).units          = Trial(itrial).Joint(7).Euler.units;
        Report.Analytic(1).Kinematics.Joint(8).label          = 'Articulation scapulo-thoracique';
        Report.Analytic(1).Kinematics.Joint(8).side           = 'Gauche';
        Report.Analytic(1).Kinematics.Joint(8).Euler          = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(1).Kinematics.Joint(8).legend         = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(1).Kinematics.Joint(8).units          = Trial(itrial).Joint(8).Euler.units;
        Report.Analytic(1).Kinematics.SHR(2).label            = Trial(itrial).SHR(2).label;
        Report.Analytic(1).Kinematics.SHR(2).value1           = permute(Trial(itrial).SHR(2).value1.cycle,[3,1,4,2]); % Elevation
        Report.Analytic(1).Kinematics.SHR(2).value2           = permute(Trial(itrial).SHR(2).value2.cycle,[3,1,4,2]); % Return
        Report.Analytic(1).Kinematics.SHR(2).tvalue           = permute(Trial(itrial).SHR(2).tvalue.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.SHR(2).theta_ST_GH      = permute(Trial(itrial).SHR(2).theta_ST_GH.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.SHR(2).theta_ST         = permute(Trial(itrial).SHR(2).theta_ST.cycle,[3,1,4,2]);
        Report.Analytic(1).Kinematics.SHR(2).theta_GH         = permute(Trial(itrial).SHR(2).theta_GH.cycle,[3,1,4,2]);  
        % --        
        for iemg                                         = 1:7
            Report.Analytic(1).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(1).Emg.Envelop(iemg).side    = 'Droite';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(1).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(1).Emg.Envelop(iemg).value = [];
            end
            Report.Analytic(1).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end      
        for iemg                                         = 8:14
            Report.Analytic(1).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(1).Emg.Envelop(iemg).side    = 'Gauche';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(1).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(1).Emg.Envelop(iemg).value = [];
            end
            Report.Analytic(1).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end
    elseif strcmp(Trial(itrial).task,'ANALYTIC2')
        Report.Analytic(2).label                         = Trial(itrial).task;
        % --
        Report.Analytic(2).Kinematics.Joint(1).label     = 'Articulation huméro-thoracique';
        Report.Analytic(2).Kinematics.Joint(1).side      = 'Droite';
        Report.Analytic(2).Kinematics.Joint(1).Euler     = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(1).Euler,3)
            [~,ind] = max(Report.Analytic(2).Kinematics.Joint(1).Euler(:,3,icycle));
            temp    = permute(Trial(itrial).Joint(1).ElevationPlane.cycle,[3,2,4,1]); 
            if max(temp) > 360
                temp = temp-360;
            end
            if ind == 1 % Special case
                Report.Analytic(2).Kinematics.Joint(1).ElevationPlane.value1(1,1,icycle) = temp(fix(ind),1,icycle); % Elevation
            else
                Report.Analytic(2).Kinematics.Joint(1).ElevationPlane.value1(1,1,icycle) = temp(fix(ind/2),1,icycle); % Elevation
            end
            if ind+ind/2 >= 101 % Special case
                Report.Analytic(2).Kinematics.Joint(1).ElevationPlane.value2(1,1,icycle) = temp(fix((ind+101)/2),1,icycle); % Return
            elseif ind == 101 % Special case
                Report.Analytic(2).Kinematics.Joint(1).ElevationPlane.value2(1,1,icycle) = temp(fix((ind)/2),1,icycle); % Return
            else
                Report.Analytic(2).Kinematics.Joint(1).ElevationPlane.value2(1,1,icycle) = temp(fix(ind+ind/2),1,icycle); % Return
            end
            clear ind temp;
        end        
        Report.Analytic(2).Kinematics.Joint(1).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(2).Kinematics.Joint(1).units     = Trial(itrial).Joint(1).Euler.units;
        Report.Analytic(2).Kinematics.Joint(2).label     = 'Articulation gléno-humérale';
        Report.Analytic(2).Kinematics.Joint(2).side      = 'Droite';
        Report.Analytic(2).Kinematics.Joint(2).Euler     = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(2).Kinematics.Joint(2).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(2).Kinematics.Joint(2).units     = Trial(itrial).Joint(2).Euler.units;
        Report.Analytic(2).Kinematics.Joint(3).label     = 'Articulation scapulo-thoracique';
        Report.Analytic(2).Kinematics.Joint(3).side      = 'Droite';
        Report.Analytic(2).Kinematics.Joint(3).Euler     = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(2).Kinematics.Joint(3).legend    = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(2).Kinematics.Joint(3).units     = Trial(itrial).Joint(3).Euler.units;
        Report.Analytic(2).Kinematics.SHR(1).label       = Trial(itrial).SHR(1).label;
        Report.Analytic(2).Kinematics.SHR(1).value1      = permute(Trial(itrial).SHR(1).value1.cycle,[3,1,4,2]); % Elevation
        Report.Analytic(2).Kinematics.SHR(1).value2      = permute(Trial(itrial).SHR(1).value2.cycle,[3,1,4,2]); % Return
        Report.Analytic(2).Kinematics.SHR(1).tvalue      = permute(Trial(itrial).SHR(1).tvalue.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.SHR(1).theta_ST_GH = permute(Trial(itrial).SHR(1).theta_ST_GH.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.SHR(1).theta_ST    = permute(Trial(itrial).SHR(1).theta_ST.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.SHR(1).theta_GH    = permute(Trial(itrial).SHR(1).theta_GH.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.Joint(6).label     = 'Articulation huméro-thoracique';
        Report.Analytic(2).Kinematics.Joint(6).side      = 'Gauche';
        Report.Analytic(2).Kinematics.Joint(6).Euler     = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        for icycle = 1:size(Report.Analytic(2).Kinematics.Joint(6).Euler,3)
            [~,ind] = max(Report.Analytic(2).Kinematics.Joint(6).Euler(:,3,icycle));
            temp    = permute(Trial(itrial).Joint(6).ElevationPlane.cycle,[3,2,4,1]); 
            if max(temp) > 360
                temp = temp-360;
            end
            if ind == 1 % Special case
                Report.Analytic(2).Kinematics.Joint(6).ElevationPlane.value1(1,1,icycle) = temp(fix(ind),1,icycle); % Elevation
            else
                Report.Analytic(2).Kinematics.Joint(6).ElevationPlane.value1(1,1,icycle) = temp(fix(ind/2),1,icycle); % Elevation
            end
            if ind+ind/2 >= 101 % Special case
                Report.Analytic(2).Kinematics.Joint(6).ElevationPlane.value2(1,1,icycle) = temp(fix((ind+101)/2),1,icycle); % Return
            elseif ind == 101 % Special case
                Report.Analytic(2).Kinematics.Joint(6).ElevationPlane.value2(1,1,icycle) = temp(fix((ind)/2),1,icycle); % Return
            else
                Report.Analytic(2).Kinematics.Joint(6).ElevationPlane.value2(1,1,icycle) = temp(fix(ind+ind/2),1,icycle); % Return
            end   
            clear ind temp;
        end        
        Report.Analytic(2).Kinematics.Joint(6).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(2).Kinematics.Joint(6).units     = Trial(itrial).Joint(6).Euler.units;
        Report.Analytic(2).Kinematics.Joint(7).label     = 'Articulation gléno-humérale';
        Report.Analytic(2).Kinematics.Joint(7).side      = 'Gauche';
        Report.Analytic(2).Kinematics.Joint(7).Euler     = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(2).Kinematics.Joint(7).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(2).Kinematics.Joint(7).units     = Trial(itrial).Joint(7).Euler.units;
        Report.Analytic(2).Kinematics.Joint(8).label     = 'Articulation scapulo-thoracique';
        Report.Analytic(2).Kinematics.Joint(8).side      = 'Gauche';
        Report.Analytic(2).Kinematics.Joint(8).Euler     = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(2).Kinematics.Joint(8).legend    = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(2).Kinematics.Joint(8).units     = Trial(itrial).Joint(8).Euler.units;
        Report.Analytic(2).Kinematics.SHR(2).label       = Trial(itrial).SHR(2).label;
        Report.Analytic(2).Kinematics.SHR(2).value1      = permute(Trial(itrial).SHR(2).value1.cycle,[3,1,4,2]); % Elevation
        Report.Analytic(2).Kinematics.SHR(2).value2      = permute(Trial(itrial).SHR(2).value2.cycle,[3,1,4,2]); % Return
        Report.Analytic(2).Kinematics.SHR(2).tvalue      = permute(Trial(itrial).SHR(2).tvalue.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.SHR(2).theta_ST_GH = permute(Trial(itrial).SHR(2).theta_ST_GH.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.SHR(2).theta_ST    = permute(Trial(itrial).SHR(2).theta_ST.cycle,[3,1,4,2]);
        Report.Analytic(2).Kinematics.SHR(2).theta_GH    = permute(Trial(itrial).SHR(2).theta_GH.cycle,[3,1,4,2]);
        % --        
        for iemg = 1:7
            Report.Analytic(2).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(2).Emg.Envelop(iemg).side    = 'Droite';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(2).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(2).Emg.Envelop(iemg).value = [];
            end
            Report.Analytic(2).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end      
        for iemg = 8:14
            Report.Analytic(2).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(2).Emg.Envelop(iemg).side    = 'Gauche';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(2).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(2).Emg.Envelop(iemg).value = [];
            end
            Report.Analytic(2).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end
    elseif strcmp(Trial(itrial).task,'ANALYTIC3')
        Report.Analytic(3).label                         = Trial(itrial).task;
        % --
        Report.Analytic(3).Kinematics.Joint(1).label     = 'Articulation huméro-thoracique';
        Report.Analytic(3).Kinematics.Joint(1).side      = 'Droite';
        Report.Analytic(3).Kinematics.Joint(1).Euler     = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(3).Kinematics.Joint(1).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(3).Kinematics.Joint(1).units     = Trial(itrial).Joint(1).Euler.units;
        Report.Analytic(3).Kinematics.Joint(2).label     = 'Articulation gléno-humérale';
        Report.Analytic(3).Kinematics.Joint(2).side      = 'Droite';
        Report.Analytic(3).Kinematics.Joint(2).Euler     = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(3).Kinematics.Joint(2).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(3).Kinematics.Joint(2).units     = Trial(itrial).Joint(2).Euler.units;
        Report.Analytic(3).Kinematics.Joint(3).label     = 'Articulation scapulo-thoracique';
        Report.Analytic(3).Kinematics.Joint(3).side      = 'Droite';
        Report.Analytic(3).Kinematics.Joint(3).Euler     = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(3).Kinematics.Joint(3).legend    = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(3).Kinematics.Joint(3).units     = Trial(itrial).Joint(3).Euler.units;
        Report.Analytic(3).Kinematics.Joint(6).label     = 'Articulation huméro-thoracique';
        Report.Analytic(3).Kinematics.Joint(6).side      = 'Gauche';
        Report.Analytic(3).Kinematics.Joint(6).Euler     = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(3).Kinematics.Joint(6).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(3).Kinematics.Joint(6).units     = Trial(itrial).Joint(6).Euler.units;
        Report.Analytic(3).Kinematics.Joint(7).label     = 'Articulation gléno-humérale';
        Report.Analytic(3).Kinematics.Joint(7).side      = 'Gauche';
        Report.Analytic(3).Kinematics.Joint(7).Euler     = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(3).Kinematics.Joint(7).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(3).Kinematics.Joint(7).units     = Trial(itrial).Joint(7).Euler.units;
        Report.Analytic(3).Kinematics.Joint(8).label     = 'Articulation scapulo-thoracique';
        Report.Analytic(3).Kinematics.Joint(8).side      = 'Gauche';
        Report.Analytic(3).Kinematics.Joint(8).Euler     = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        Report.Analytic(3).Kinematics.Joint(8).legend    = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(3).Kinematics.Joint(8).units     = Trial(itrial).Joint(8).Euler.units;   
        % --        
        for iemg = 1:7
            Report.Analytic(3).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(3).Emg.Envelop(iemg).side    = 'Droite';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(3).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(3).Emg.Envelop(iemg).value = [];
            end
            Report.Analytic(3).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end      
        for iemg = 8:14
            Report.Analytic(3).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(3).Emg.Envelop(iemg).side    = 'Gauche';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(3).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(3).Emg.Envelop(iemg).value = [];
            end
            Report.Analytic(3).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end 
    elseif strcmp(Trial(itrial).task,'ANALYTIC4')
        Report.Analytic(4).label                         = Trial(itrial).task;
        Report.Analytic(4).Kinematics.Joint(1).label     = 'Articulation huméro-thoracique';
        Report.Analytic(4).Kinematics.Joint(1).side      = 'Droite';
        if ~isempty(Trial(itrial).Joint(1).Euler.cycle)
            Report.Analytic(4).Kinematics.Joint(1).Euler = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        else
            Report.Analytic(4).Kinematics.Joint(1).Euler = permute(Trial(itrial).Joint(1).Euler.full,[3,2,4,1]).*[-1,1,1];
        end
        Report.Analytic(4).Kinematics.Joint(1).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(4).Kinematics.Joint(1).units     = Trial(itrial).Joint(1).Euler.units;
        Report.Analytic(4).Kinematics.Joint(2).label     = 'Articulation gléno-humérale';
        Report.Analytic(4).Kinematics.Joint(2).side      = 'Droite';
        if ~isempty(Trial(itrial).Joint(2).Euler.cycle)
            Report.Analytic(4).Kinematics.Joint(2).Euler = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        else
            Report.Analytic(4).Kinematics.Joint(2).Euler = permute(Trial(itrial).Joint(2).Euler.full,[3,2,4,1]).*[-1,1,1];
        end
        Report.Analytic(4).Kinematics.Joint(2).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(4).Kinematics.Joint(2).units     = Trial(itrial).Joint(2).Euler.units;
        Report.Analytic(4).Kinematics.Joint(3).label     = 'Articulation scapulo-thoracique';
        Report.Analytic(4).Kinematics.Joint(3).side      = 'Droite';
        if ~isempty(Trial(itrial).Joint(3).Euler.cycle)
            Report.Analytic(4).Kinematics.Joint(3).Euler = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        else
            Report.Analytic(4).Kinematics.Joint(3).Euler = permute(Trial(itrial).Joint(3).Euler.full,[3,2,4,1]).*[-1,1,1];
        end
        Report.Analytic(4).Kinematics.Joint(3).legend    = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(4).Kinematics.Joint(3).units     = Trial(itrial).Joint(3).Euler.units;
        Report.Analytic(4).Kinematics.Joint(6).label     = 'Articulation huméro-thoracique';
        Report.Analytic(4).Kinematics.Joint(6).side      = 'Gauche';
        if ~isempty(Trial(itrial).Joint(6).Euler.cycle)
            Report.Analytic(4).Kinematics.Joint(6).Euler = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        else
            Report.Analytic(4).Kinematics.Joint(6).Euler = permute(Trial(itrial).Joint(6).Euler.full,[3,2,4,1]).*[-1,1,1];
        end
        Report.Analytic(4).Kinematics.Joint(6).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(4).Kinematics.Joint(6).units     = Trial(itrial).Joint(6).Euler.units;
        Report.Analytic(4).Kinematics.Joint(7).label     = 'Articulation gléno-humérale';
        Report.Analytic(4).Kinematics.Joint(7).side      = 'Gauche';
        if ~isempty(Trial(itrial).Joint(7).Euler.cycle)
            Report.Analytic(4).Kinematics.Joint(7).Euler = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        else
            Report.Analytic(4).Kinematics.Joint(7).Euler = permute(Trial(itrial).Joint(7).Euler.full,[3,2,4,1]).*[-1,1,1];
        end
        Report.Analytic(4).Kinematics.Joint(7).legend    = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
        Report.Analytic(4).Kinematics.Joint(7).units     = Trial(itrial).Joint(7).Euler.units;
        Report.Analytic(4).Kinematics.Joint(8).label     = 'Articulation scapulo-thoracique';
        Report.Analytic(4).Kinematics.Joint(8).side      = 'Gauche';
        if ~isempty(Trial(itrial).Joint(8).Euler.cycle)
            Report.Analytic(4).Kinematics.Joint(8).Euler = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
        else
            Report.Analytic(4).Kinematics.Joint(8).Euler = permute(Trial(itrial).Joint(8).Euler.full,[3,2,4,1]).*[-1,1,1];
        end
        Report.Analytic(4).Kinematics.Joint(8).legend    = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
        Report.Analytic(4).Kinematics.Joint(8).units     = Trial(itrial).Joint(8).Euler.units;
        % --        
        for iemg                                         = 1:7
            Report.Analytic(4).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(4).Emg.Envelop(iemg).side    = 'Droite';
            Report.Analytic(4).Emg.Envelop(iemg).value   = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(4).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(4).Emg.Envelop(iemg).value = [];
            end          
            Report.Analytic(4).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end      
        for iemg                                         = 8:14
            Report.Analytic(4).Emg.Envelop(iemg).label   = Trial(itrial).Emg(iemg).label;
            Report.Analytic(4).Emg.Envelop(iemg).side    = 'Gauche';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Analytic(4).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Analytic(4).Emg.Envelop(iemg).value = [];
            end     
            Report.Analytic(4).Emg.Envelop(iemg).unit    = Trial(itrial).Emg(iemg).Signal.units;
        end     
%     elseif strcmp(Trial(itrial).task,'FUNCTIONAL1')
%         Report.Functional(1).label                       = Trial(itrial).task;
%         Report.Functional(1).Kinematics.Joint(1).label   = 'Articulation huméro-thoracique';
%         Report.Functional(1).Kinematics.Joint(1).side    = 'Droite';
%         Report.Functional(1).Kinematics.Joint(1).Euler   = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(1).Kinematics.Joint(1).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(1).Kinematics.Joint(1).units   = Trial(itrial).Joint(1).Euler.units;
%         Report.Functional(1).Kinematics.Joint(2).label   = 'Articulation gléno-humérale';
%         Report.Functional(1).Kinematics.Joint(2).side    = 'Droite';
%         Report.Functional(1).Kinematics.Joint(2).Euler   = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(1).Kinematics.Joint(2).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(1).Kinematics.Joint(2).units   = Trial(itrial).Joint(2).Euler.units;
%         Report.Functional(1).Kinematics.Joint(3).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(1).Kinematics.Joint(3).side    = 'Droite';
%         Report.Functional(1).Kinematics.Joint(3).Euler   = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(1).Kinematics.Joint(3).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(1).Kinematics.Joint(3).units   = Trial(itrial).Joint(3).Euler.units;
%         Report.Functional(1).Kinematics.Joint(6).label   = 'Articulation huméro-thoracique';
%         Report.Functional(1).Kinematics.Joint(6).side    = 'Gauche';
%         Report.Functional(1).Kinematics.Joint(6).Euler   = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(1).Kinematics.Joint(6).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(1).Kinematics.Joint(6).units   = Trial(itrial).Joint(6).Euler.units;
%         Report.Functional(1).Kinematics.Joint(7).label   = 'Articulation gléno-humérale';
%         Report.Functional(1).Kinematics.Joint(7).side    = 'Gauche';
%         Report.Functional(1).Kinematics.Joint(7).Euler   = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(1).Kinematics.Joint(7).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(1).Kinematics.Joint(7).units   = Trial(itrial).Joint(7).Euler.units;
%         Report.Functional(1).Kinematics.Joint(8).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(1).Kinematics.Joint(8).side    = 'Gauche';
%         Report.Functional(1).Kinematics.Joint(8).Euler   = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(1).Kinematics.Joint(8).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(1).Kinematics.Joint(8).units   = Trial(itrial).Joint(8).Euler.units;
%         % --        
%         for iemg = 1:7
%             Report.Functional(1).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(1).Emg.Envelop(iemg).side  = 'Droite';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(1).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(1).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(1).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end      
%         for iemg = 8:14
%             Report.Functional(1).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(1).Emg.Envelop(iemg).side  = 'Gauche';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(1).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(1).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(1).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end      
%     elseif strcmp(Trial(itrial).task,'FUNCTIONAL2')
%         Report.Functional(2).label                       = Trial(itrial).task;
%         Report.Functional(2).Kinematics.Joint(1).label   = 'Articulation huméro-thoracique';
%         Report.Functional(2).Kinematics.Joint(1).side    = 'Droite';
%         Report.Functional(2).Kinematics.Joint(1).Euler   = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(2).Kinematics.Joint(1).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(2).Kinematics.Joint(1).units   = Trial(itrial).Joint(1).Euler.units;
%         Report.Functional(2).Kinematics.Joint(2).label   = 'Articulation gléno-humérale';
%         Report.Functional(2).Kinematics.Joint(2).side    = 'Droite';
%         Report.Functional(2).Kinematics.Joint(2).Euler   = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(2).Kinematics.Joint(2).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(2).Kinematics.Joint(2).units   = Trial(itrial).Joint(2).Euler.units;
%         Report.Functional(2).Kinematics.Joint(3).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(2).Kinematics.Joint(3).side    = 'Droite';
%         Report.Functional(2).Kinematics.Joint(3).Euler   = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(2).Kinematics.Joint(3).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(2).Kinematics.Joint(3).units   = Trial(itrial).Joint(3).Euler.units;
%         Report.Functional(2).Kinematics.Joint(6).label   = 'Articulation huméro-thoracique';
%         Report.Functional(2).Kinematics.Joint(6).side    = 'Gauche';
%         Report.Functional(2).Kinematics.Joint(6).Euler   = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(2).Kinematics.Joint(6).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(2).Kinematics.Joint(6).units   = Trial(itrial).Joint(6).Euler.units;
%         Report.Functional(2).Kinematics.Joint(7).label   = 'Articulation gléno-humérale';
%         Report.Functional(2).Kinematics.Joint(7).side    = 'Gauche';
%         Report.Functional(2).Kinematics.Joint(7).Euler   = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(2).Kinematics.Joint(7).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(2).Kinematics.Joint(7).units   = Trial(itrial).Joint(7).Euler.units;
%         Report.Functional(2).Kinematics.Joint(8).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(2).Kinematics.Joint(8).side    = 'Gauche';
%         Report.Functional(2).Kinematics.Joint(8).Euler   = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(2).Kinematics.Joint(8).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(2).Kinematics.Joint(8).units   = Trial(itrial).Joint(8).Euler.units;
%         % --        
%         for iemg = 1:7
%             Report.Functional(2).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(2).Emg.Envelop(iemg).side  = 'Droite';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(2).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(2).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(2).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end      
%         for iemg = 8:14
%             Report.Functional(2).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(2).Emg.Envelop(iemg).side  = 'Gauche';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(2).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(2).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(2).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end     
%     elseif strcmp(Trial(itrial).task,'FUNCTIONAL3')
%         Report.Functional(3).label                       = Trial(itrial).task;
%         Report.Functional(3).Kinematics.Joint(1).label   = 'Articulation huméro-thoracique';
%         Report.Functional(3).Kinematics.Joint(1).side    = 'Droite';
%         Report.Functional(3).Kinematics.Joint(1).Euler   = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(3).Kinematics.Joint(1).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(3).Kinematics.Joint(1).units   = Trial(itrial).Joint(1).Euler.units;
%         Report.Functional(3).Kinematics.Joint(2).label   = 'Articulation gléno-humérale';
%         Report.Functional(3).Kinematics.Joint(2).side    = 'Droite';
%         Report.Functional(3).Kinematics.Joint(2).Euler   = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(3).Kinematics.Joint(2).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(3).Kinematics.Joint(2).units   = Trial(itrial).Joint(2).Euler.units;
%         Report.Functional(3).Kinematics.Joint(3).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(3).Kinematics.Joint(3).side    = 'Droite';
%         Report.Functional(3).Kinematics.Joint(3).Euler   = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(3).Kinematics.Joint(3).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(3).Kinematics.Joint(3).units   = Trial(itrial).Joint(3).Euler.units;
%         Report.Functional(3).Kinematics.Joint(6).label   = 'Articulation huméro-thoracique';
%         Report.Functional(3).Kinematics.Joint(6).side    = 'Gauche';
%         Report.Functional(3).Kinematics.Joint(6).Euler   = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(3).Kinematics.Joint(6).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(3).Kinematics.Joint(6).units   = Trial(itrial).Joint(6).Euler.units;
%         Report.Functional(3).Kinematics.Joint(7).label   = 'Articulation gléno-humérale';
%         Report.Functional(3).Kinematics.Joint(7).side    = 'Gauche';
%         Report.Functional(3).Kinematics.Joint(7).Euler   = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(3).Kinematics.Joint(7).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(3).Kinematics.Joint(7).units   = Trial(itrial).Joint(7).Euler.units;
%         Report.Functional(3).Kinematics.Joint(8).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(3).Kinematics.Joint(8).side    = 'Gauche';
%         Report.Functional(3).Kinematics.Joint(8).Euler   = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(3).Kinematics.Joint(8).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(3).Kinematics.Joint(8).units   = Trial(itrial).Joint(8).Euler.units;
%         % --        
%         for iemg = 1:7
%             Report.Functional(3).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(3).Emg.Envelop(iemg).side  = 'Droite';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(3).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(3).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(3).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end      
%         for iemg = 8:14
%             Report.Functional(3).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(3).Emg.Envelop(iemg).side  = 'Gauche';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(3).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(3).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(3).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end     
%     elseif strcmp(Trial(itrial).task,'FUNCTIONAL4')
%         Report.Functional(4).label                       = Trial(itrial).task;
%         Report.Functional(4).Kinematics.Joint(1).label   = 'Articulation huméro-thoracique';
%         Report.Functional(4).Kinematics.Joint(1).side    = 'Droite';
%         Report.Functional(4).Kinematics.Joint(1).Euler   = permute(Trial(itrial).Joint(1).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(4).Kinematics.Joint(1).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(4).Kinematics.Joint(1).units   = Trial(itrial).Joint(1).Euler.units;
%         Report.Functional(4).Kinematics.Joint(2).label   = 'Articulation gléno-humérale';
%         Report.Functional(4).Kinematics.Joint(2).side    = 'Droite';
%         Report.Functional(4).Kinematics.Joint(2).Euler   = permute(Trial(itrial).Joint(2).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(4).Kinematics.Joint(2).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(4).Kinematics.Joint(2).units   = Trial(itrial).Joint(2).Euler.units;
%         Report.Functional(4).Kinematics.Joint(3).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(4).Kinematics.Joint(3).side    = 'Droite';
%         Report.Functional(4).Kinematics.Joint(3).Euler   = permute(Trial(itrial).Joint(3).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(4).Kinematics.Joint(3).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(4).Kinematics.Joint(3).units   = Trial(itrial).Joint(3).Euler.units;
%         Report.Functional(4).Kinematics.Joint(6).label   = 'Articulation huméro-thoracique';
%         Report.Functional(4).Kinematics.Joint(6).side    = 'Gauche';
%         Report.Functional(4).Kinematics.Joint(6).Euler   = permute(Trial(itrial).Joint(6).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(4).Kinematics.Joint(6).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(4).Kinematics.Joint(6).units   = Trial(itrial).Joint(6).Euler.units;
%         Report.Functional(4).Kinematics.Joint(7).label   = 'Articulation gléno-humérale';
%         Report.Functional(4).Kinematics.Joint(7).side    = 'Gauche';
%         Report.Functional(4).Kinematics.Joint(7).Euler   = permute(Trial(itrial).Joint(7).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(4).Kinematics.Joint(7).legend  = {'Abduction (+) / Adduction (-)','Rotation int. (+) / ext. (-)','Flexion (+) / Extension (-)'};
%         Report.Functional(4).Kinematics.Joint(7).units   = Trial(itrial).Joint(7).Euler.units;
%         Report.Functional(4).Kinematics.Joint(8).label   = 'Articulation scapulo-thoracique';
%         Report.Functional(4).Kinematics.Joint(8).side    = 'Gauche';
%         Report.Functional(4).Kinematics.Joint(8).Euler   = permute(Trial(itrial).Joint(8).Euler.cycle,[3,2,4,1]).*[-1,1,1];
%         Report.Functional(4).Kinematics.Joint(8).legend  = {'Rotation lat. (+) / méd. (-)','Rétraction (-) / Protraction (+)','Inclinaison ant. (-) / post. (+)'};
%         Report.Functional(4).Kinematics.Joint(8).units   = Trial(itrial).Joint(8).Euler.units;
%         % --        
%         for iemg = 1:7
%             Report.Functional(4).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(4).Emg.Envelop(iemg).side  = 'Droite';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(4).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(4).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(4).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end      
%         for iemg = 8:14
%             Report.Functional(4).Emg.Envelop(iemg).label = Trial(itrial).Emg(iemg).label;
%             Report.Functional(4).Emg.Envelop(iemg).side  = 'Gauche';
% %             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
%             if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
%                 Report.Functional(4).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
%             else
%                 Report.Functional(4).Emg.Envelop(iemg).value = [];
%             end
%             Report.Functional(4).Emg.Envelop(iemg).unit  = Trial(itrial).Emg(iemg).Signal.units;
%         end   
    elseif strcmp(Trial(itrial).task,'ISOMETRIC1')
        Report.Isometric(1).label                        = Trial(itrial).task;
        Report.Isometric(1).side                         = 'Droite';
        Report.Isometric(1).Force.value                  = Trial(itrial).Fsensor.Force.value;
        Report.Isometric(1).Force.unit                   = Trial(itrial).Fsensor.Force.units;
        Report.Isometric(1).Angle.value                  = Trial(itrial).Fsensor.Angle.value;
        Report.Isometric(1).Angle.unit                   = Trial(itrial).Fsensor.Angle.units;
        % --        
        for iemg = 1:7
            Report.Isometric(1).Emg.Envelop(iemg).label  = Trial(itrial).Emg(iemg).label;
            Report.Isometric(1).Emg.Envelop(iemg).side   = 'Droite';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Isometric(1).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Isometric(1).Emg.Envelop(iemg).value = [];
            end
            Report.Isometric(1).Emg.Envelop(iemg).unit   = Trial(itrial).Emg(iemg).Signal.units;
        end      
        for iemg = 8:14
            Report.Isometric(1).Emg.Envelop(iemg).label  = Trial(itrial).Emg(iemg).label;
            Report.Isometric(1).Emg.Envelop(iemg).side   = 'Gauche';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Isometric(1).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Isometric(1).Emg.Envelop(iemg).value = [];
            end
            Report.Isometric(1).Emg.Envelop(iemg).unit   = Trial(itrial).Emg(iemg).Signal.units;
        end
    elseif strcmp(Trial(itrial).task,'ISOMETRIC2')
        Report.Isometric(2).label                        = Trial(itrial).task;
        Report.Isometric(2).side                         = 'Gauche';
        Report.Isometric(2).Force.value                  = Trial(itrial).Fsensor.Force.value;
        Report.Isometric(2).Force.unit                   = Trial(itrial).Fsensor.Force.units;
        Report.Isometric(2).Angle.value                  = Trial(itrial).Fsensor.Angle.value;
        Report.Isometric(2).Angle.unit                   = Trial(itrial).Fsensor.Angle.units;
        % --        
        for iemg = 1:7
            Report.Isometric(2).Emg.Envelop(iemg).label  = Trial(itrial).Emg(iemg).label;
            Report.Isometric(2).Emg.Envelop(iemg).side   = 'Droite';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Isometric(2).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Isometric(2).Emg.Envelop(iemg).value = [];
            end
            Report.Isometric(2).Emg.Envelop(iemg).unit   = Trial(itrial).Emg(iemg).Signal.units;
        end      
        for iemg = 8:14
            Report.Isometric(2).Emg.Envelop(iemg).label  = Trial(itrial).Emg(iemg).label;
            Report.Isometric(2).Emg.Envelop(iemg).side   = 'Gauche';
%             if ~isempty(Trial(itrial).Emg(iemg).Signal.cycle)
            if length(find(isnan(Trial(itrial).Emg(iemg).Signal.cycle))) < length(Trial(itrial).Emg(iemg).Signal.cycle)
                Report.Isometric(2).Emg.Envelop(iemg).value = permute(Trial(itrial).Emg(iemg).Signal.cycle,[3,1,4,2]);
            else
                Report.Isometric(2).Emg.Envelop(iemg).value = [];
            end
            Report.Isometric(2).Emg.Envelop(iemg).unit   = Trial(itrial).Emg(iemg).Signal.units;
        end
    end
end