% Author       : F. Moissenet
%                Kinesiology Laboratory (K-LAB)
%                University of Geneva
%                https://www.unige.ch/medecine/kinesiology
% License      : Creative Commons Attribution-NonCommercial 4.0 International License 
%                https://creativecommons.org/licenses/by-nc/4.0/legalcode
% Source code  : https://github.com/fmoissenet/NSLBP-BIOToolbox
% Reference    : To be defined
% Date         : June 2020
% -------------------------------------------------------------------------
% Description  : Initialise the Segment structure
% Inputs       : Trial (structure)
% Outputs      : Trial (structure)
% -------------------------------------------------------------------------
% Dependencies : None
% -------------------------------------------------------------------------
% This work is licensed under the Creative Commons Attribution - 
% NonCommercial 4.0 International License. To view a copy of this license, 
% visit http://creativecommons.org/licenses/by-nc/4.0/ or send a letter to 
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
% -------------------------------------------------------------------------

function Trial = InitialiseSegments(Trial)

segmentLabels = {'RHumerus','RScapula','RClavicle','Thorax', ...
                 'LHumerus','LScapula','LClavicle'};
             
for i = 1:length(segmentLabels)
    Trial.Segment(i).label        = segmentLabels{i};
    Trial.Segment(i).rM.full      = [];
    Trial.Segment(i).rM.cycle     = [];
    Trial.Segment(i).rM.units     = 'm';
    Trial.Segment(i).Q.full       = [];
    Trial.Segment(i).Q.cycle      = [];
    Trial.Segment(i).T.full       = [];
    Trial.Segment(i).T.cycle      = [];
    Trial.Segment(i).Euler.full   = [];
    Trial.Segment(i).Euler.cycle  = [];
    Trial.Segment(i).Euler.units  = 'rad';
    Trial.Segment(i).dj.full      = [];
    Trial.Segment(i).dj.cycle     = [];
    Trial.Segment(i).dj.units     = 'mm';
    Trial.Segment(i).sequence     = '';
end