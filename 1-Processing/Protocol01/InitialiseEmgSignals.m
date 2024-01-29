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
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = InitialiseEmgSignals(EmgSet,Trial,Emg)

% Initialise emgs
Trial.Emg = [];
if ~strcmp(EmgSet{1},'') % Empty list
    for i = 1:length(EmgSet)
        Trial.Emg(i).label = EmgSet{i,2};
        Trial.Emg(i).type  = '';
        if isfield(Emg,EmgSet{i,2}) == 1
            if ~isnan(sum(sum(Emg.(EmgSet{i,2}))))
                Trial.Emg(i).Signal.full = permute(Emg.(EmgSet{i,2}),[2,3,1]);
            else
                Trial.Emg(i).Signal.full = [];
            end
            Trial.Emg(i).Signal.cycle = [];
            Trial.Emg(i).Signal.units = '%';
        elseif isfield(Emg,[cell2mat(EmgSet{i,2}),'_EMG_1']) == 1
            if ~isnan(sum(sum(Emg.(EmgSet{i,2}))))
                Trial.Emg(i).Signal.full = permute(Emg.([cell2mat(EmgSet{i,2}),'_EMG_1']),[2,3,1]);
            else
                Trial.Emg(i).Signal.full = [];
            end
            Trial.Emg(i).Signal.cycle = [];
            Trial.Emg(i).Signal.units = '%';
        else
            Trial.Emg(i).Signal.full  = [];
            Trial.Emg(i).Signal.cycle = [];
            Trial.Emg(i).Signal.units = '%';
        end
    end
end