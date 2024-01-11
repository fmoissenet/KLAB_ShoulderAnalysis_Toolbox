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

function Trial = ComputeSHR(c3dFiles,Trial,Reference)

if contains(c3dFiles.name,'ANALYTIC2') || contains(c3dFiles.name,'ANALYTIC1') % Only applied on elevation tasks
    % Right scapulo humeral rhythm computation (mean across cycles)        
    for icycle = 1:size(Trial.Joint(1).Euler.cycle,4)
        theta_HT = [];
        theta_GH = [];
        theta_ST = [];
        if contains(c3dFiles.name,'ANALYTIC2')
            % Elevation
            itemp = find(abs(Trial.Joint(1).Euler.cycle(:,1,:,icycle))==max(abs(Trial.Joint(1).Euler.cycle(:,1,:,icycle))));
            iframe1 = find(abs(Trial.Joint(1).Euler.cycle(:,1,1:itemp,icycle))>=30 & abs(Trial.Joint(1).Euler.cycle(:,1,1:itemp,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
            % Return
            itemp = find(abs(Trial.Joint(1).Euler.cycle(:,1,:,icycle))==max(abs(Trial.Joint(1).Euler.cycle(:,1,:,icycle))));
            iframe2 = find(abs(Trial.Joint(1).Euler.cycle(:,1,itemp:end,icycle))>=30 & abs(Trial.Joint(1).Euler.cycle(:,1,itemp:end,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
        elseif contains(c3dFiles.name,'ANALYTIC1')
            % Elevation
            itemp = find(abs(Trial.Joint(1).Euler.cycle(:,3,:,icycle))==max(abs(Trial.Joint(1).Euler.cycle(:,3,:,icycle))));
            iframe1 = find(abs(Trial.Joint(1).Euler.cycle(:,3,1:itemp,icycle))>=30 & abs(Trial.Joint(1).Euler.cycle(:,3,1:itemp,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
            % Return
            itemp = find(abs(Trial.Joint(1).Euler.cycle(:,3,:,icycle))==max(abs(Trial.Joint(1).Euler.cycle(:,3,:,icycle))));
            iframe2 = find(abs(Trial.Joint(1).Euler.cycle(:,3,itemp:end,icycle))>=120 & abs(Trial.Joint(1).Euler.cycle(:,3,itemp:end,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
        end
        for iframe = 1:101 % Cycle frames (%)
            % Define rotation matrices
            R_ICS_T     = Trial.Segment(4).T.cycle(1:3,1:3,iframe,icycle);
            R_ICS_S     = Trial.Segment(2).T.cycle(1:3,1:3,iframe,icycle);
            R_ICS_H     = Trial.Segment(1).T.cycle(1:3,1:3,iframe,icycle);
            R_T_S       = inv(R_ICS_T)*R_ICS_S;
            R_S_H       = inv(R_ICS_S)*R_ICS_H;
            % Define reference rotation matrices
            R_ICS_T_ref = Reference.Segment(4).T.full(1:3,1:3,1);
            R_ICS_S_ref = Reference.Segment(2).T.full(1:3,1:3,1);
            R_ICS_H_ref = Reference.Segment(1).T.full(1:3,1:3,1);
            R_T_S_ref   = inv(R_ICS_T_ref)*R_ICS_S_ref;
            R_S_H_ref   = inv(R_ICS_S_ref)*R_ICS_H_ref;
            % Compute 3D joint contributions (Robert-Lachaine et al., 2015)
            C_HT        = inv(R_T_S_ref)*R_T_S*inv(R_S_H_ref)*R_S_H;
            C_ST        = inv(R_T_S_ref)*R_T_S*inv(R_S_H_ref)*eye(3);
            % Store resulting angles
            theta_HT(iframe) = acosd(C_HT(2,2)); % YXY Euler sequence
            theta_ST(iframe) = acosd(C_ST(2,2)); % YXY Euler sequence
            theta_GH(iframe) = theta_HT(iframe)-theta_ST(iframe);
            SHR(iframe)      = theta_GH(iframe)/theta_ST(iframe);
        end     
        % Mean SHR computation proposed by Bruttel et al. 2020
        % Elevation
        AUC_ST = []; AUC_HT = []; cST = [];
        AUC_ST = trapz(theta_ST(iframe1));
        AUC_HT = trapz(theta_HT(iframe1));
        cST = AUC_ST/AUC_HT;
        tSHR1 = (1-cST)/cST;
        % Return
        AUC_ST = []; AUC_HT = []; cST = [];
        AUC_ST = trapz(theta_ST(iframe2));
        AUC_HT = trapz(theta_HT(iframe2));
        cST = AUC_ST/AUC_HT;
        tSHR2 = (1-cST)/cST;
        % Store results
        Trial.SHR(1).label                        = 'Right scapulo-humeral rhythm';
        Trial.SHR(1).value1.cycle(1,1,1,icycle)   = tSHR1; % Elevation
        Trial.SHR(1).value2.cycle(1,1,1,icycle)   = tSHR2; % Return
        Trial.SHR(1).tvalue.cycle(1,1,:,icycle)   = permute(interp1((1:size(theta_HT,2))',SHR,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
        Trial.SHR(1).theta_HT.cycle(1,1,:,icycle) = permute(interp1((1:size(theta_HT,2))',theta_HT,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
        Trial.SHR(1).theta_ST.cycle(1,1,:,icycle) = permute(interp1((1:size(theta_HT,2))',theta_ST,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
        Trial.SHR(1).theta_GH.cycle(1,1,:,icycle) = permute(interp1((1:size(theta_HT,2))',theta_GH,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
%         figure; hold on;
%         plot(theta_ST_GH,theta_ST_GH,'Color','black','Linestyle','-');
%         plot(theta_ST_GH,theta_ST,'Color','red','Linestyle','-');
%         plot(theta_ST_GH,theta_GH,'Color','blue','Linestyle','-');
%         legend({'HT','ST','GH'});
    end
    % Left scapulo humeral rhythm computation (mean across cycles)             
    for icycle = 1:size(Trial.Joint(6).Euler.cycle,4)
        theta_HT = [];
        theta_GH = [];
        theta_ST = [];
        if contains(c3dFiles.name,'ANALYTIC2')
            % Elevation
            itemp = find(abs(Trial.Joint(6).Euler.cycle(:,1,:,icycle))==max(abs(Trial.Joint(6).Euler.cycle(:,1,:,icycle))));
            iframe1 = find(abs(Trial.Joint(6).Euler.cycle(:,1,1:itemp,icycle))>=30 & abs(Trial.Joint(6).Euler.cycle(:,1,1:itemp,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
            % Return
            itemp = find(abs(Trial.Joint(6).Euler.cycle(:,1,:,icycle))==max(abs(Trial.Joint(6).Euler.cycle(:,1,:,icycle))));
            iframe2 = find(abs(Trial.Joint(6).Euler.cycle(:,1,itemp:end,icycle))>=30 & abs(Trial.Joint(6).Euler.cycle(:,1,itemp:end,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
        elseif contains(c3dFiles.name,'ANALYTIC1')
            % Elevation
            itemp = find(abs(Trial.Joint(6).Euler.cycle(:,3,:,icycle))==max(abs(Trial.Joint(6).Euler.cycle(:,3,:,icycle))));
            iframe1 = find(abs(Trial.Joint(6).Euler.cycle(:,3,1:itemp,icycle))>=30 & abs(Trial.Joint(6).Euler.cycle(:,3,1:itemp,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
            % Return
            itemp = find(abs(Trial.Joint(6).Euler.cycle(:,3,:,icycle))==max(abs(Trial.Joint(6).Euler.cycle(:,3,:,icycle))));
            iframe2 = find(abs(Trial.Joint(6).Euler.cycle(:,3,itemp:end,icycle))>=30 & abs(Trial.Joint(6).Euler.cycle(:,3,itemp:end,icycle))<=120); % Only frames related to humerus elevated between 30° and 120°
            clear itemp;
        end
        for iframe = 1:101 % Cycle frames (%)
            % Define rotation matrices
            R_ICS_T     = Trial.Segment(4).T.cycle(1:3,1:3,iframe,icycle);
            R_ICS_S     = Trial.Segment(6).T.cycle(1:3,1:3,iframe,icycle);
            R_ICS_H     = Trial.Segment(5).T.cycle(1:3,1:3,iframe,icycle);
            R_T_S       = inv(R_ICS_T)*R_ICS_S;
            R_S_H       = inv(R_ICS_S)*R_ICS_H;
            % Define reference rotation matrices
            R_ICS_T_ref = Reference.Segment(4).T.full(1:3,1:3,1);
            R_ICS_S_ref = Reference.Segment(6).T.full(1:3,1:3,1);
            R_ICS_H_ref = Reference.Segment(5).T.full(1:3,1:3,1);
            R_T_S_ref   = inv(R_ICS_T_ref)*R_ICS_S_ref;
            R_S_H_ref   = inv(R_ICS_S_ref)*R_ICS_H_ref;
            % Compute 3D joint contributions (Robert-Lachaine et al., 2015)
            C_HT        = inv(R_T_S_ref)*R_T_S*inv(R_S_H_ref)*R_S_H;
            C_ST        = inv(R_T_S_ref)*R_T_S*inv(R_S_H_ref)*eye(3);
            % Store resulting angles
            theta_HT(iframe) = acosd(C_HT(2,2)); % YXY Euler sequence
            theta_ST(iframe) = acosd(C_ST(2,2)); % YXY Euler sequence
            theta_GH(iframe) = theta_HT(iframe)-theta_ST(iframe);
            SHR(iframe)      = theta_GH(iframe)/theta_ST(iframe);
        end
        % Mean SHR computation proposed by Bruttel et al. 2020
        % Elevation
        AUC_ST = []; AUC_HT = []; cST = [];
        AUC_ST = trapz(theta_ST(iframe1));
        AUC_HT = trapz(theta_HT(iframe1));
        cST = AUC_ST/AUC_HT;
        tSHR1 = (1-cST)/cST;
        % Return
        AUC_ST = []; AUC_HT = []; cST = [];
        AUC_ST = trapz(theta_ST(iframe2));
        AUC_HT = trapz(theta_HT(iframe2));
        cST = AUC_ST/AUC_HT;
        tSHR2 = (1-cST)/cST;
        % Store results
        Trial.SHR(2).label                        = 'Left scapulo-humeral rhythm';
        Trial.SHR(2).value1.cycle(1,1,1,icycle)   = tSHR1; % Elevation
        Trial.SHR(2).value2.cycle(1,1,1,icycle)   = tSHR2; % Return
        Trial.SHR(2).tvalue.cycle(1,1,:,icycle)   = permute(interp1((1:size(theta_HT,2))',SHR,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
        Trial.SHR(2).theta_HT.cycle(1,1,:,icycle) = permute(interp1((1:size(theta_HT,2))',theta_HT,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
        Trial.SHR(2).theta_ST.cycle(1,1,:,icycle) = permute(interp1((1:size(theta_HT,2))',theta_ST,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
        Trial.SHR(2).theta_GH.cycle(1,1,:,icycle) = permute(interp1((1:size(theta_HT,2))',theta_GH,(linspace(1,size(theta_HT,2),101))','spline'),[1,3,2]);
%         figure; hold on;
%         plot(theta_ST_GH,theta_ST_GH,'Color','black','Linestyle','-');
%         plot(theta_ST_GH,theta_ST,'Color','red','Linestyle','-');
%         plot(theta_ST_GH,theta_GH,'Color','blue','Linestyle','-');
%         legend({'HT','ST','GH'});
    end
end