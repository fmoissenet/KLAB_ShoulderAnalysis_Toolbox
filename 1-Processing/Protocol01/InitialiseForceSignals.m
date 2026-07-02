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
% Modified     : Hugo Francalanci 
%                Biomechanics and Translational Research in Surgery (B-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/chiru/en/research-groups/nicolas-holzer-et-florent-moissenet
% Date         : June 2026
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

function Trial = InitialiseForceSignals(c3dFiles,Trial,Analog,Event,mass,calibration)

if contains(Trial.file,'CALIBRATION4')
    disp('  - Calibrage des données du capteur de force');
    if isfield(Event,'Remote')
        % Get calibration values 
        weight                    = mass*9.81; % (N)
        fmax                      = mean(Analog.FORCE);
        Trial.Fsensor.label       = 'Force sensor';
        Trial.Fsensor.calibration = weight/(mean(Analog.FORCE(fix(Event.Remote(1)*Trial.fanalog):fix(Event.Remote(2)*Trial.fanalog),1)));
        Trial.Fsensor.Force.value = permute(Analog.FORCE*Trial.Fsensor.calibration,[2,3,1]); % N
        Trial.Fsensor.Force.units = 'N';
    else
        Trial.Fsensor.label = 'Force sensor';
        Trial.Fsensor.calibration = 0;
        Trial.Fsensor.Force.value = []; % N
        Trial.Fsensor.Force.units = 'N';        
    end
elseif contains(c3dFiles.name,'CALIBRATION5') || contains(c3dFiles.name,'CALIBRATION6') % Isometric tasks only
    disp('  - Calibrage des données du capteur de force');

    % Automatic baseline computed from the last 5,000 frames (resting signal after muscle relaxation)
    nBase = min(5000, length(Analog.FORCE));
    baseline = [length(Analog.FORCE)-nBase+1, length(Analog.FORCE)];

    fig = figure;
    hold on;
    plot(Analog.FORCE);
    ymin = min(Analog.FORCE); ymax = max(Analog.FORCE);
    hBaseline = patch([baseline(1) baseline(2) baseline(2) baseline(1)], [ymin ymin ymax ymax], ...
          [1 0.6 0], 'FaceAlpha',0.2, 'EdgeColor','none');
    title('Baseline (5000 dernières frames) - Entrée=OK  m+Entrée=manuel');
    drawnow;

    resp = input('  - Entrée = OK, m + Entrée = manuel : ','s');
    if strcmpi(strtrim(resp), 'm')
        title('Sélectionner le début et la fin de la ligne de base');
        drawnow;
        baseline = ginput(2);
        baseline = baseline(:,1);

        delete(hBaseline);
        patch([baseline(1) baseline(2) baseline(2) baseline(1)], [ymin ymin ymax ymax], ...
              [1 0.6 0], 'FaceAlpha',0.2, 'EdgeColor','none');
        title('Baseline redéfinie manuellement');
        drawnow;
        input('  - Appuyez sur Entrée pour continuer : ','s');
    end
    close(fig);

    Trial.Fsensor.label = 'Force sensor';
    Trial.Fsensor.calibration = calibration;
    Trial.Fsensor.Force.value = permute((Analog.FORCE-mean(Analog.FORCE(baseline(1):baseline(2))))*calibration,[2,3,1]); % N
    Trial.Fsensor.Force.units = 'N';
else
    Trial.Fsensor.label = 'Force sensor';
    Trial.Fsensor.calibration = calibration;
    Trial.Fsensor.Force.value = []; % N
    Trial.Fsensor.Force.units = 'N';
end  