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

function Trial = CutCycles(Session,c3dFiles,Trial)

% Initialisation
Cycles = [];
Lcycles = [];
trialsubTypes = {'ANALYTIC1','ANALYTIC2','ANALYTIC3','ANALYTIC4', ...
                 'FUNCTIONAL1','FUNCTIONAL2','FUNCTIONAL3','FUNCTIONAL4'}; % Only during cyclic movements

% Use the side with highest amplitude to cut cycles
for j2 = 1:size(trialsubTypes,2)
    if contains(c3dFiles.name,trialsubTypes{j2})
        start = [];
        stop = [];
        value = [];
        if contains(c3dFiles.name,'ANALYTIC2')
            if max(abs(squeeze(Trial.Joint(1).Euler.full(:,1,:))')) > max(abs(squeeze(Trial.Joint(6).Euler.full(:,1,:))'))
                value = abs(squeeze(Trial.Joint(1).Euler.full(:,1,:))');
            else
                value = abs(squeeze(Trial.Joint(6).Euler.full(:,1,:))');
            end
        elseif contains(c3dFiles.name,'ANALYTIC1')
            if max(abs(squeeze(Trial.Joint(1).Euler.full(:,3,:))')) > max(abs(squeeze(Trial.Joint(6).Euler.full(:,3,:))'))
                value = abs(squeeze(Trial.Joint(1).Euler.full(:,3,:))');
            else
                value = abs(squeeze(Trial.Joint(6).Euler.full(:,3,:))');
            end
        elseif contains(c3dFiles.name,'ANALYTIC3')
%             figure; hold on;
%             plot(squeeze(Trial.Joint(1).Euler.full(:,2,:)),'blue')
%             plot(unwrap(squeeze(Trial.Joint(6).Euler.full(:,2,:)))+360,'red')
            if max(-(squeeze(Trial.Joint(1).Euler.full(:,2,:))')) > max(-(squeeze(Trial.Joint(6).Euler.full(:,2,:))'))
                value = -squeeze(Trial.Joint(1).Euler.full(:,2,:))';
            else
                value = -squeeze(Trial.Joint(6).Euler.full(:,2,:))';
            end
        elseif contains(c3dFiles.name,'ANALYTIC4')
%             figure; hold on;
%             plot(squeeze(Trial.Joint(1).Euler.full(:,2,:)),'blue')
%             plot(squeeze(Trial.Joint(6).Euler.full(:,2,:)),'red')
            if max(abs(squeeze(Trial.Joint(1).Euler.full(:,2,:))')) > max(abs(squeeze(Trial.Joint(6).Euler.full(:,2,:))'))
                value = squeeze(Trial.Joint(1).Euler.full(:,2,:))';
            else
                value = squeeze(Trial.Joint(6).Euler.full(:,2,:))';
            end
        end
        if ~isempty(value)
            figure; hold on; title(c3dFiles.name);
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
                Cycles(icycle).range = (index(iindex):index(iindex+1))';
                icycle = icycle+1;
            end 
        end
    end
end
% Cut cycles
% Markers
for imarker = 1:size(Trial.Marker,2)
    if ~isempty(Cycles)
        for icycle = 1:size(Cycles,2)
            n  = size(Cycles(icycle).range,1);
            k0 = (1:n)';
            k1 = (linspace(1,n,101))';
            if ~isnan(sum(Trial.Marker(imarker).Trajectory.full(1,1,:)))
                Trial.Marker(imarker).Trajectory.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Marker(imarker).Trajectory.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Marker(imarker).Trajectory.cycle(:,:,:,icycle) = nan(3,1,101,1);
            end
        end
    end
end
% Vmarkers
for ivmarker = 1:size(Trial.Vmarker,2)
    if ~isempty(Cycles)
        for icycle = 1:size(Cycles,2)
            n  = size(Cycles(icycle).range,1);
            k0 = (1:n)';
            k1 = (linspace(1,n,101))';
            Trial.Vmarker(ivmarker).Trajectory.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Vmarker(ivmarker).Trajectory.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
        end
    end
end
% Segments
for isegment = 1:size(Trial.Segment,2)
    if ~isempty(Cycles)
        for icycle = 1:size(Cycles,2)
            n  = size(Cycles(icycle).range,1);
            k0 = (1:n)';
            k1 = (linspace(1,n,101))';
            if ~isempty(Trial.Segment(isegment).rM.full)
                Trial.Segment(isegment).rM.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).rM.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Segment(isegment).rM.cycle = [];
            end
            if ~isempty(Trial.Segment(isegment).Q.full)
                Trial.Segment(isegment).Q.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Q.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Segment(isegment).Q.cycle = [];
            end
            if ~isempty(Trial.Segment(isegment).T.full)
                Trial.Segment(isegment).T.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).T.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Segment(isegment).T.cycle = [];
            end
            if ~isempty(Trial.Segment(isegment).Euler.full)
                Trial.Segment(isegment).Euler.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).Euler.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Segment(isegment).Euler.cycle = [];
            end
            if ~isempty(Trial.Segment(isegment).dj.full)
                Trial.Segment(isegment).dj.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Segment(isegment).dj.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Segment(isegment).dj.cycle = [];
            end
        end
    end
end
% Joints
for ijoint = 1:size(Trial.Joint,2)
    if ~isempty(Cycles)
        for icycle = 1:size(Cycles,2)
            n  = size(Cycles(icycle).range,1);
            k0 = (1:n)';
            k1 = (linspace(1,n,101))';
            if ~isempty(Trial.Joint(ijoint).T.full)
                Trial.Joint(ijoint).T.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).T.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Joint(ijoint).T.cycle = [];
            end
            if ~isempty(Trial.Joint(ijoint).Euler.full)
                Trial.Joint(ijoint).Euler.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).Euler.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                if ijoint == 1 || ijoint == 6
                    if ~isempty(Trial.Joint(ijoint).ElevationPlane.full)
                        Trial.Joint(ijoint).ElevationPlane.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).ElevationPlane.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
                    else
                        Trial.Joint(ijoint).ElevationPlane.cycle = [];
                    end
                end
            else
                Trial.Joint(ijoint).Euler.cycle = [];
                Trial.Joint(ijoint).ElevationPlane.cycle = [];
            end
            if ~isempty(Trial.Joint(ijoint).dj.full)
                Trial.Joint(ijoint).dj.cycle(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Joint(ijoint).dj.full(:,:,Cycles(icycle).range),[3,1,2]),k1,'spline'),[2,3,1]);
            else
                Trial.Joint(ijoint).dj.cycle = [];
            end
        end
    end
end
% Emg
fratio = Trial.fanalog/Trial.fmarker;
if ~isempty(Cycles)
    Trial = OnsetDetection(Session,Trial,Cycles);
end
if ~isempty(Trial.Emg)
    for iemg = 1:size(Trial.Emg,2)
        if ~isempty(Cycles)
            if ~isempty(Trial.Emg(iemg).Signal.full)
                for icycle = 1:size(Cycles,2)
                    n  = size(Cycles(icycle).range,1);
                    k0 = (1:n)';
                    k1 = (linspace(1,n,101))';
                    Trial.Emg(iemg).Signal.cycle(:,:,:,icycle) = nan(1,1,101,1);
                    if length(find(isnan(Trial.Emg(iemg).Signal.full(:,:,Cycles(icycle).range*fratio)))) < length(Trial.Emg(iemg).Signal.full(:,:,Cycles(icycle).range*fratio))
                        Trial.Emg(iemg).Signal.cycle1(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.full(:,:,Cycles(icycle).range*fratio),[3,1,2]),k1,'spline'),[2,3,1]);
                        Trial.Emg(iemg).Signal.cycle2(:,:,:,icycle) = permute(interp1(k0,permute(Trial.Emg(iemg).Signal.onset(:,:,Cycles(icycle).range*fratio),[3,1,2]),k1,'spline'),[2,3,1]);
                        for iframe = 1:size(Trial.Emg(iemg).Signal.cycle2,3)
                            if Trial.Emg(iemg).Signal.cycle2(:,:,iframe,icycle) < 0.5 % Correct interpolation issues
                               Trial.Emg(iemg).Signal.cycle2(:,:,iframe,icycle) = 0;
                            elseif Trial.Emg(iemg).Signal.cycle2(:,:,iframe,icycle) > 0.5 % Correct interpolation issues
                               Trial.Emg(iemg).Signal.cycle2(:,:,iframe,icycle) = 1; 
                            end
                        end
                    end
                end
            end
        end
    end
end
% Export cycles
Trial.Cycle = Cycles;