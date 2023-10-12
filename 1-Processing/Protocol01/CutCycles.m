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

function Trial = CutCycles(c3dFiles,Trial,btype)

% Initialisation
disp('  - Découpage des cycles de mouvement');
Rcycles = [];
Lcycles = [];

if contains(c3dFiles.name,'ANALYTIC')
    % Set cycles
    start = [];
    stop = [];
    value = [];
    % Right side
    if contains(c3dFiles.name,'ANALYTIC2')
        value = abs(squeeze(Trial.Joint(1).Euler.full(:,1,:))');
    elseif contains(c3dFiles.name,'ANALYTIC1')
        value = abs(squeeze(Trial.Joint(1).Euler.full(:,3,:))');
    elseif contains(c3dFiles.name,'ANALYTIC3')
        value = -squeeze(Trial.Joint(1).Euler.full(:,2,:))';
    elseif contains(c3dFiles.name,'ANALYTIC4')
        value = squeeze(Trial.Joint(1).Euler.full(:,2,:))';
    end
    if ~isempty(value)
        figure('Position',[200 300 1200 400]);
        hold on; title(c3dFiles.name);
        value = unwrap(value);
        plot(1:size(value,2),value,'red');
        rectangle('Position',[0 -10 length(value) 10],'FaceColor',[1 0 0 0.2],'EdgeColor','none');
        localmin = ginput(6); % If nothing to select, click in the red rectangle
        index = [];
        for imin = 1:2:size(localmin,1)
            if localmin(imin,2) > 0
                index = [index fix(localmin(imin,1)) fix(localmin(imin+1,1))]; % Store current and next mins
            end
        end
        plot(index,value(index),'Marker','+','Linestyle','none','Color','green');
        icycle = 1;
        for iindex = 1:2:size(index,2)-1
            Rcycles(icycle).range = (index(iindex):index(iindex+1))';
            icycle = icycle+1;
        end 
        close gcf;
    end
    % Left side
    if contains(c3dFiles.name,'ANALYTIC2')
        value = abs(squeeze(Trial.Joint(6).Euler.full(:,1,:))');
    elseif contains(c3dFiles.name,'ANALYTIC1')
        value = abs(squeeze(Trial.Joint(6).Euler.full(:,3,:))');
    elseif contains(c3dFiles.name,'ANALYTIC3')
        value = -squeeze(Trial.Joint(6).Euler.full(:,2,:))';
    elseif contains(c3dFiles.name,'ANALYTIC4')
        value = squeeze(Trial.Joint(6).Euler.full(:,2,:))';
    end
    if ~isempty(value)
        figure('Position',[200 300 1200 400]);
        hold on; title(c3dFiles.name);
        value = unwrap(value);
        plot(1:size(value,2),value,'red');
        rectangle('Position',[0 -10 length(value) 10],'FaceColor',[1 0 0 0.2],'EdgeColor','none');       
        localmin = ginput(6); % If nothing to select, click in the red rectangle
        index = [];
        for imin = 1:2:size(localmin,1)
            if localmin(imin,2) > 0
                index = [index fix(localmin(imin,1)) fix(localmin(imin+1,1))]; % Store current and next mins
            end
        end
        plot(index,value(index),'Marker','+','Linestyle','none','Color','green');
        icycle = 1;
        for iindex = 1:2:size(index,2)-1
            Lcycles(icycle).range = (index(iindex):index(iindex+1))';
            icycle = icycle+1;
        end 
        close gcf;
    end

    % Cut cycles
    % Cycle
    Trial.Rcycle = Rcycles;
    Trial.Lcycle = Lcycles;
    % Markers
    for imarker = 1:size(Trial.Marker,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isnan(sum(Trial.Marker(imarker).Trajectory.full(1,1,:)))
                    Trial.Marker(imarker).Trajectory.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Marker(imarker).Trajectory.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                    
                else
                    Trial.Marker(imarker).Trajectory.rcycle(:,:,:,icycle) = nan(3,1,101,1);
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isnan(sum(Trial.Marker(imarker).Trajectory.full(1,1,:)))
                    Trial.Marker(imarker).Trajectory.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Marker(imarker).Trajectory.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Marker(imarker).Trajectory.lcycle(:,:,:,icycle) = nan(3,1,101,1);
                end
            end
        end
    end
    % Vmarkers
    for ivmarker = 1:size(Trial.Vmarker,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                Trial.Vmarker(ivmarker).Trajectory.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Vmarker(ivmarker).Trajectory.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                Trial.Vmarker(ivmarker).Trajectory.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Vmarker(ivmarker).Trajectory.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            end
        end
    end
    % Segments
    for isegment = 1:size(Trial.Segment,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Segment(isegment).rM.full)
                    Trial.Segment(isegment).rM.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).rM.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).rM.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Q.full)
                    Trial.Segment(isegment).Q.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Q.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Q.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).T.full)
                    Trial.Segment(isegment).T.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).T.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).T.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Euler.full)
                    Trial.Segment(isegment).Euler.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Euler.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Euler.rcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).dj.full)
                    Trial.Segment(isegment).dj.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).dj.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).dj.rcycle = [];
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Segment(isegment).rM.full)
                    Trial.Segment(isegment).rM.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).rM.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).rM.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Q.full)
                    Trial.Segment(isegment).Q.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Q.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Q.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).T.full)
                    Trial.Segment(isegment).T.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).T.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).T.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).Euler.full)
                    Trial.Segment(isegment).Euler.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Euler.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).Euler.lcycle = [];
                end
                if ~isempty(Trial.Segment(isegment).dj.full)
                    Trial.Segment(isegment).dj.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).dj.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Segment(isegment).dj.lcycle = [];
                end
            end
        end
    end
    % Joints
    for ijoint = 1:size(Trial.Joint,2)
        % Right side
        if ~isempty(Rcycles)
            for icycle = 1:size(Rcycles,2)
                n  = size(Rcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Joint(ijoint).T.full)
                    Trial.Joint(ijoint).T.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).T.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).T.rcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).Euler.full)
                    Trial.Joint(ijoint).Euler.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).Euler.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                    if ijoint == 1 || ijoint == 6
                        if ~isempty(Trial.Joint(ijoint).ElevationPlane.full)
                            Trial.Joint(ijoint).ElevationPlane.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).ElevationPlane.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                        else
                            Trial.Joint(ijoint).ElevationPlane.rcycle = [];
                        end
                    end
                else
                    Trial.Joint(ijoint).Euler.rcycle = [];
                    Trial.Joint(ijoint).ElevationPlane.rcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).dj.full)
                    Trial.Joint(ijoint).dj.rcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).dj.full(:,:,Rcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).dj.rcycle = [];
                end
            end
        end
        % Left side
        if ~isempty(Lcycles)
            for icycle = 1:size(Lcycles,2)
                n  = size(Lcycles(icycle).range,1);
                k0 = (1:n)';
                k1 = (linspace(1,n,101))';
                if ~isempty(Trial.Joint(ijoint).T.full)
                    Trial.Joint(ijoint).T.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).T.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).T.lcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).Euler.full)
                    Trial.Joint(ijoint).Euler.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).Euler.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                    if ijoint == 1 || ijoint == 6
                        if ~isempty(Trial.Joint(ijoint).ElevationPlane.full)
                            Trial.Joint(ijoint).ElevationPlane.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).ElevationPlane.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                        else
                            Trial.Joint(ijoint).ElevationPlane.lcycle = [];
                        end
                    end
                else
                    Trial.Joint(ijoint).Euler.lcycle = [];
                    Trial.Joint(ijoint).ElevationPlane.lcycle = [];
                end
                if ~isempty(Trial.Joint(ijoint).dj.full)
                    Trial.Joint(ijoint).dj.lcycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).dj.full(:,:,Lcycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                else
                    Trial.Joint(ijoint).dj.lcycle = [];
                end
            end
        end
    end
    % Emg
    fratio = Trial.fanalog/Trial.fmarker;
    manualCheck = 0;
    Trial  = OnsetDetection(Trial,Rcycles,Lcycles,btype,manualCheck);
    if ~isempty(Trial.Emg)
        for iemg = 1:size(Trial.Emg,2)
            % Right side
            if ~isempty(Rcycles)
                if ~isempty(Trial.Emg(iemg).Signal.full)
                    for icycle = 1:size(Rcycles,2)
                        n  = length(Rcycles(icycle).range(1)*fratio:Rcycles(icycle).range(end)*fratio);
                        k0 = (1:n)';
                        k1 = (linspace(1,n,101))';
                        Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.onset(:,:,Rcycles(icycle).range(1)*fratio:Rcycles(icycle).range(end)*fratio),[3,1,2]),k1,'spline'),[2,3,1]);
                        Trial.Emg(iemg).Signal.rcycle.envelop(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.envelop(:,:,Rcycles(icycle).range(1)*fratio:Rcycles(icycle).range(end)*fratio),[3,1,2]),k1,'spline'),[2,3,1]);
                        Trial.Emg(iemg).Signal.rcycle.onset(:,:,find(Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle)<0.5),icycle) = 0;
                        Trial.Emg(iemg).Signal.rcycle.onset(:,:,find(Trial.Emg(iemg).Signal.rcycle.onset(:,:,:,icycle)>0.5),icycle) = 1;
                    end
                end
            end
            % Left side
            if ~isempty(Lcycles)
                if ~isempty(Trial.Emg(iemg).Signal.full)
                    for icycle = 1:size(Lcycles,2)
                        n  = length(Lcycles(icycle).range(1)*fratio:Lcycles(icycle).range(end)*fratio);
                        k0 = (1:n)';
                        k1 = (linspace(1,n,101))';
                        Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.onset(:,:,Lcycles(icycle).range(1)*fratio:Lcycles(icycle).range(end)*fratio),[3,1,2]),k1,'spline'),[2,3,1]);
                        Trial.Emg(iemg).Signal.lcycle.envelop(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.envelop(:,:,Lcycles(icycle).range(1)*fratio:Lcycles(icycle).range(end)*fratio),[3,1,2]),k1,'spline'),[2,3,1]);
                        Trial.Emg(iemg).Signal.lcycle.onset(:,:,find(Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle)<0.5),icycle) = 0;
                        Trial.Emg(iemg).Signal.lcycle.onset(:,:,find(Trial.Emg(iemg).Signal.lcycle.onset(:,:,:,icycle)>0.5),icycle) = 1;
                    end
                end
            end
        end
    end

    % Export cycles
    Trial.Rcycle = Rcycles; 
    Trial.Lcycle = Lcycles;     
end