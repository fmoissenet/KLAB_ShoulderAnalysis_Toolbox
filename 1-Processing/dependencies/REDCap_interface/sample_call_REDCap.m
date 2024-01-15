% %%%%%%%%%%%%%%%%%%%%%%%% Example code for REDCap.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  General notes:
%  ==============
%
%  (1) The user needs an API token to communicate with REDCap server.
%  Inquire with your administrator about obtaining a token.
%
%  (2) The user needs to have proper User Rights within the Project, such
%  as 'Data Export Tool' ('Full Data Set'), 'API' ('Export', 'Import')
%
%  (3) The user may have to be on the database network or via VPN
%
%  (4) Read the examples provided, the REDCap manual and use the API
%      playground.  REDCap is very useful but under reported via google etc
%
%
%  See the main function REDCap.m for additional information.
%  ==========================================================
%
%  Below find an example for each currently available command of REDCap.m.
%  The examples presuppose that the user has REDCap access and a database
%  structure in place.  
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Oliver D. Kripfgans, University of Michigan, 2019-2021
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Init command

my_REDCap_URL = 'https://----your REDCap server URL----/api/';
my_REDCap_token = '----your RDCap token----';

REDCap_response = REDCap('init', 'url', my_REDCap_URL, 'token', my_REDCap_token);


%% Export field names

export_field_names_as_table = REDCap('exportfieldnames');


%% Read REDCap field

this_ID         =  1; % record number where field resides
this_event      =  'first_event'; % event where record resides
                                  % 'first_event' is an allowable event name
this_field_name = '---your REDCap field name---'; % name of field to be read
if ismac
    this_output_path = '~/Downloads'; % macOS
elseif ispc
    this_output_path = 'C:\Users\---your user name---\Downloads'; % Windows
else
    fprintf(2,'Work out your own path name for a non-macOS and non-PC system.\n');
end
this_dicom = REDCap('read', this_ID, this_event, this_field_name, this_output_path);


%% Read filename of a REDCap file field

this_ID         =  1; % record number where field resides
this_event      =  '---your REDCap event name---'; % event where record resides
                                  % 'first_event' is an allowable event name
this_field_name = '---your REDCap field name---'; % name of field to be read

this_filename = REDCap('filename', this_ID, this_event, this_field_name);


%% read ARM from REDCap

arms_available = REDCap('arm');


%% read EVENTS from REDCap

events_available = REDCap('event');


%% next record ID (when generated)

next_record_name = REDCap('generateNextRecordName');


%% reads report with number # from REDCap

this_report_number = '---your REDCap report number---';
this_report = REDCap('report', this_report_number);


%% Write data to a REDCap field

this_ID         =  1; % record number where field resides
this_event      =  '---your REDCap event name---'; % event where record resides
                                  % 'first_event' is an allowable event name
this_field_name = '---your REDCap field name---'; % name of field to be written
this_field_content = '123';

REDCap_write_response = REDCap('write', this_ID, this_event, this_field_name, this_field_content);


