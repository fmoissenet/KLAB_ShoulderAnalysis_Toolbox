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

function Trial = ComputeSHR(c3dFiles,Trial)

disp('  - Calcul du rythme scapulaire');

if contains(c3dFiles.name,'ANALYTIC2') || contains(c3dFiles.name,'ANALYTIC1') % Only applied on elevation tasks only
    % Right scapulo humeral rhythm computation (mean across cycles)
    tSHR = [];                
%     figure; hold on;
    for icycle = 1:size(Trial.Joint(1).Euler.rcycle,4)
        theta_ST_GH = [];
        theta_GH    = [];
        theta_ST    = [];
        if contains(c3dFiles.name,'ANALYTIC2')
            % Elevation
            itemp      = find(abs(Trial.Joint(1).Euler.rcycle(:,1,:,icycle))==max(abs(Trial.Joint(1).Euler.rcycle(:,1,:,icycle))));
            iframe1    = find(abs(Trial.Joint(1).Euler.rcycle(:,1,1:itemp,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
            % Return
            itemp      = find(abs(Trial.Joint(1).Euler.rcycle(:,1,:,icycle))==max(abs(Trial.Joint(1).Euler.rcycle(:,1,:,icycle))));
            iframe2    = find(abs(Trial.Joint(1).Euler.rcycle(:,1,itemp:end,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
        elseif contains(c3dFiles.name,'ANALYTIC1')
            % Elevation
            itemp      = find(abs(Trial.Joint(1).Euler.rcycle(:,3,:,icycle))==max(abs(Trial.Joint(1).Euler.rcycle(:,3,:,icycle))));
            iframe1    = find(abs(Trial.Joint(1).Euler.rcycle(:,3,1:itemp,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
            % Return
            itemp      = find(abs(Trial.Joint(1).Euler.rcycle(:,3,:,icycle))==max(abs(Trial.Joint(1).Euler.rcycle(:,3,:,icycle))));
            iframe2    = find(abs(Trial.Joint(1).Euler.rcycle(:,3,itemp:end,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
        end
        for iframe = 1:101 % Cycle frames (%)
            istatic = 1; % Assume that the Trial(1) corresponds to the anatomical reference static record
            % Define rotation matrices
            R_T_ICS    = inv(Trial.Segment(4).T.rcycle(1:3,1:3,iframe,icycle));
            R_S_ICS    = inv(Trial.Segment(2).T.rcycle(1:3,1:3,iframe,icycle));
            R_H_ICS    = inv(Trial.Segment(1).T.rcycle(1:3,1:3,iframe,icycle));
            R_Tref_ICS = inv(Trial(istatic).Segment(4).T.full(1:3,1:3,1));
            R_Sref_ICS = inv(Trial(istatic).Segment(2).T.full(1:3,1:3,1));
            R_Href_ICS = inv(Trial(istatic).Segment(1).T.full(1:3,1:3,1));
            R_T_S      = R_T_ICS*inv(R_S_ICS);
            R_S_H      = R_S_ICS*inv(R_H_ICS);
            R_T_H      = R_T_S*R_S_H;
            % Methodology proposed by Robert-Lachaine et al. 2015
            R_T_H_2             = R_T_S*R_S_H;
            R_T_S_2             = R_T_S*eye(3);
            theta_ST_GH(iframe) = acosd(R_T_H_2(2,2)); % YXY Euler sequence
            theta_ST(iframe)    = acosd(R_T_S_2(2,2)); % YXY Euler sequence
            theta_GH(iframe)    = theta_ST_GH(iframe) - theta_ST(iframe);
        end
%         plot(theta_ST_GH,theta_ST_GH,'Color','black','Linestyle','-');
%         plot(theta_ST_GH,theta_ST,'Color','red','Linestyle','-');
%         plot(theta_ST_GH,theta_GH,'Color','blue','Linestyle','-');
%         legend({'HT','ST','GH'});
        % Mean SHR computation proposed by Bruttel et al. 2020
        % Elevation
        AUC_ST  = []; AUC_HT = []; cST = [];
        AUC_ST  = trapz(theta_ST_GH(iframe1),theta_ST(iframe1));
        AUC_HT  = trapz(theta_ST_GH(iframe1),theta_ST_GH(iframe1));
        cST     = AUC_ST/AUC_HT;
        tSHR1   = (1-cST)/cST;
        % Return
        AUC_ST  = []; AUC_HT = []; cST = [];
        AUC_ST  = trapz(theta_ST_GH(iframe2),theta_ST(iframe2));
        AUC_HT  = trapz(theta_ST_GH(iframe2),theta_ST_GH(iframe2));
        cST     = AUC_ST/AUC_HT;
        tSHR2   = (1-cST)/cST;
        % Store results
        Trial.SHR(1).label                           = 'Right scapulo-humeral rhythm';
        Trial.SHR(1).value1.rcycle(1,1,1,icycle)      = tSHR1; % Elevation
        Trial.SHR(1).value2.rcycle(1,1,1,icycle)      = tSHR2; % Return
        Trial.SHR(1).tvalue.rcycle(1,1,:,icycle)      = permute(interp1((1:size(theta_ST_GH,2))',theta_GH,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2])./permute(interp1((1:size(theta_ST_GH,2))',theta_ST,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
        Trial.SHR(1).theta_ST_GH.rcycle(1,1,:,icycle) = permute(interp1((1:size(theta_ST_GH,2))',theta_ST_GH,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
        Trial.SHR(1).theta_ST.rcycle(1,1,:,icycle)    = permute(interp1((1:size(theta_ST_GH,2))',theta_ST,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
        Trial.SHR(1).theta_GH.rcycle(1,1,:,icycle)    = permute(interp1((1:size(theta_ST_GH,2))',theta_GH,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
    end
    % Left scapulo humeral rhythm computation (mean across cycles)
    tSHR = [];                
%     figure; hold on;
    for icycle = 1:size(Trial.Joint(6).Euler.lcycle,4)
        theta_ST_GH = [];
        theta_GH    = [];
        theta_ST    = [];
        if contains(c3dFiles.name,'ANALYTIC2')
            % Elevation
            itemp      = find(abs(Trial.Joint(6).Euler.lcycle(:,1,:,icycle))==max(abs(Trial.Joint(6).Euler.lcycle(:,1,:,icycle))));
            iframe1    = find(abs(Trial.Joint(6).Euler.lcycle(:,1,1:itemp,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
            % Return
            itemp      = find(abs(Trial.Joint(6).Euler.lcycle(:,1,:,icycle))==max(abs(Trial.Joint(6).Euler.lcycle(:,1,:,icycle))));
            iframe2    = find(abs(Trial.Joint(6).Euler.lcycle(:,1,itemp:end,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
        elseif contains(c3dFiles.name,'ANALYTIC1')
            % Elevation
            itemp      = find(abs(Trial.Joint(6).Euler.lcycle(:,3,:,icycle))==max(abs(Trial.Joint(6).Euler.lcycle(:,3,:,icycle))));
            iframe1    = find(abs(Trial.Joint(6).Euler.lcycle(:,3,1:itemp,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
            % Return
            itemp      = find(abs(Trial.Joint(6).Euler.lcycle(:,3,:,icycle))==max(abs(Trial.Joint(6).Euler.lcycle(:,3,:,icycle))));
            iframe2    = find(abs(Trial.Joint(6).Euler.lcycle(:,3,itemp:end,icycle))<120); % Only frames related to humerus elevated under 120°
            clear itemp;
        end
        for iframe = 1:101 % Cycle frames (%)
            istatic    = 1; % Assume that the Trial(1) corresponds to the anatomical reference static record
            % Define rotation matrices
            R_T_ICS    = inv(Trial.Segment(4).T.lcycle(1:3,1:3,iframe,icycle));
            R_S_ICS    = inv(Trial.Segment(6).T.lcycle(1:3,1:3,iframe,icycle));
            R_H_ICS    = inv(Trial.Segment(5).T.lcycle(1:3,1:3,iframe,icycle));
            R_Tref_ICS = inv(Trial(istatic).Segment(4).T.full(1:3,1:3,1));
            R_Sref_ICS = inv(Trial(istatic).Segment(6).T.full(1:3,1:3,1));
            R_Href_ICS = inv(Trial(istatic).Segment(5).T.full(1:3,1:3,1));
            R_T_S      = R_T_ICS*inv(R_S_ICS);
            R_S_H      = R_S_ICS*inv(R_H_ICS);
            R_T_H      = R_T_S*R_S_H;
            % Methodology proposed by Robert-Lachaine et al. 201
            R_T_H_2             = R_T_S*R_S_H;
            R_T_S_2             = R_T_S*eye(3);
            theta_ST_GH(iframe) = acosd(R_T_H_2(2,2)); % YXY Euler sequence
            theta_ST(iframe)    = acosd(R_T_S_2(2,2)); % YXY Euler sequence
            theta_GH(iframe)    = theta_ST_GH(iframe) - theta_ST(iframe);
        end
%         plot(theta_ST_GH,theta_ST_GH,'Color','black','Linestyle','-');
%         plot(theta_ST_GH,theta_ST,'Color','red','Linestyle','-');
%         plot(theta_ST_GH,theta_GH,'Color','blue','Linestyle','-');
%         legend({'HT','ST','GH'});
        % Mean SHR computation proposed by Bruttel et al. 2020
        % Elevation
        AUC_ST = []; AUC_HT = []; cST = [];
        AUC_ST = trapz(theta_ST_GH(iframe1),theta_ST(iframe1));
        AUC_HT = trapz(theta_ST_GH(iframe1),theta_ST_GH(iframe1));
        cST    = AUC_ST/AUC_HT;
        tSHR1  = (1-cST)/cST;
        % Return
        AUC_ST = []; AUC_HT = []; cST = [];
        AUC_ST = trapz(theta_ST_GH(iframe2),theta_ST(iframe2));
        AUC_HT = trapz(theta_ST_GH(iframe2),theta_ST_GH(iframe2));
        cST    = AUC_ST/AUC_HT;
        tSHR2  = (1-cST)/cST;
        % Store results
        Trial.SHR(2).label                           = 'Left scapulo-humeral rhythm';
        Trial.SHR(2).value1.lcycle(1,1,1,icycle)      = tSHR1; % Elevation
        Trial.SHR(2).value2.lcycle(1,1,1,icycle)      = tSHR2; % Return
        Trial.SHR(2).tvalue.lcycle(1,1,:,icycle)      = permute(interp1((1:size(theta_ST_GH,2))',theta_GH,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2])./permute(interp1((1:size(theta_ST_GH,2))',theta_ST,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
        Trial.SHR(2).theta_ST_GH.lcycle(1,1,:,icycle) = permute(interp1((1:size(theta_ST_GH,2))',theta_ST_GH,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
        Trial.SHR(2).theta_ST.lcycle(1,1,:,icycle)    = permute(interp1((1:size(theta_ST_GH,2))',theta_ST,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
        Trial.SHR(2).theta_GH.lcycle(1,1,:,icycle)    = permute(interp1((1:size(theta_ST_GH,2))',theta_GH,(linspace(1,size(theta_ST_GH,2),101))','spline'),[1,3,2]);
    end
end