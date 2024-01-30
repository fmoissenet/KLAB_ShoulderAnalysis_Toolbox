function [] = ContactREDCap(Patient,Session,Trial,action)

% Init command
URL      = 'https://qualite.hug.ch/redcap_v14.0.7/API/';
token    = '5A963DAF4EBDBABA40107A4B0F2B6DF0';
response = REDCap('init','url',URL,'token',token);

if strcmp(action,'read_patient_field')

    record     = 668;
    event      = 'pre_operative_arm_1';
    field      = 'klab_session_comments';
    ops        = weboptions('CertificateFilename','','Debug',false);
    record_num = sprintf('%d',record);
    response   = webwrite(URL,'token',token,'content','record','format','csv','type','flat', ...
                          'records',record_num,'fields',field,'events',event, ...
                          'rawOrLabel','raw','rawOrLabelHeaders','raw','exportCheckboxLabel','false','exportSurveyFields','false', ...
                          'exportDataAccessGroups','false','returnFormat','csv',ops)

elseif strcmp(action,'read_patient_fields')

    record     = 668;
    form       = 'klab_evaluation_membre_sup';
    field      = 'klab_session_mass';
    event      = 'pre_operative_arm_1';
    ops        = weboptions('CertificateFilename','','Debug',false);
    record_num = sprintf('%d',record);
    response   = webwrite(URL,'token',token,'content','record','format','csv','type','flat', ...
                          'records',record_num,'forms',form,'events',event, ...
                          'rawOrLabel','raw','rawOrLabelHeaders','raw','exportCheckboxLabel','false','exportSurveyFields','false', ...
                          'exportDataAccessGroups','false','returnFormat','csv',ops)

elseif strcmp(action,'read_patients_fields')

    record     = 668;
    form       = 'klab_evaluation_membre_sup';
    field      = 'klab_session_mass';
    event      = 'pre_operative_arm_1';
    ops        = weboptions('CertificateFilename','','Debug',false);
    response   = webwrite(URL,'token',token,'content','record','format','csv','type','flat', ...
                          'forms',form,'events',event, ...
                          'rawOrLabel','raw','rawOrLabelHeaders','raw','exportCheckboxLabel','false','exportSurveyFields','false', ...
                          'exportDataAccessGroups','false','returnFormat','csv',ops)

elseif strcmp(action,'write_patient_field')

    record   = 668;
    event    = 'pre_operative_arm_1';
    field    = 'klab_session_comments';
    content  = 'clear';
    response = REDCap('write',record,event,field,content)

end