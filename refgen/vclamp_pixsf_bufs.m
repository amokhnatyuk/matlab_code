% initial setup
%s2 = serial('COM3','BaudRate',9600);
%fopen(s2);
%g1=gpib('ni',0,22);
%fopen(g1);
prog_path='./refgen/';
addpath(prog_path);

writeSensorReg( '00330000', s2);  % disable SDO waveforms
writeSensorReg( '00900000', s2);  % disconnect coltest from CB output
writeSensorReg( '090f0000', s2);  % disconnect coltest_padcon and coltest_refcon
writeSensorReg( '090800F0', s2);  % disconnect vref_colbuf
writeSensorReg( '08369699', s2);  % READBUS map, in cbtest: writeSensorReg('08369999', s2);  
dirSave = 'C:\data\raijin_lot3\vclamp_pixsf_ref\';

% testing vclamp_pixsf_rst and vclamp_pixsf_sig dacs and buffers
% writeSensorReg( '09060028', s2); % vclamp_pixsf_rst, [5]=1 power-up buffer, and [3]=1connect to analogtest0
% writeSensorReg( '09350077', s2); % Set vclamp_pixsf_rst voltage, when set to 0x0, vclamp_pixsf_rst is 3.5V, when set to 0xff, vclamp_pixsf_rst is 1.5V, default setup is 1.9V
% writeSensorReg( '090d0002', s2); % 0x90d[1]=1	St vclamp_pixsf_rst_in for analogtest0 to enable testing connection

% vclamp_pixsf_rst_in
writeSensorReg( '09060000', s2); % vclamp_pixsf_rst, [5]=0 power-down buffer, and [3]=0 disconnect from analogtest0
writeSensorReg( '090d0002', s2); % 0x90d[1]=1, Set vclamp_pixsf_rst_in for analogtest0 to enable testing connection
measVref2(g1,s2,'0935','vclamp\_pixsf\_rst\_in',dirSave);  % 0x935[7:0]
writeSensorReg( '090d0000', s2);  % return to default
% vclamp_pixsf_rst
writeSensorReg( '09060028', s2); % vclamp_pixsf_rst, [5]=1 power-up buffer, and [3]=1 connect to analogtest0
measVref2(g1,s2,'0935','vclamp\_pixsf\_rst',dirSave);  % 0x935[7:0]
writeSensorReg( '09060000', s2); % vclamp_pixsf_rst, [5]=0 power-down buffer, and [3]=0 disconnect from analogtest0

% writeSensorReg( '09060014', s2); % vclamp_pixsf_sig, [4]=1 power-up buffer, and [2]=1 connect to analogtest1
% writeSensorReg( '09380077', s2); % Set vclamp_pixsf_sig voltage, when set to 0x0, vclamp_pixsf_sig is 0V, when set to 0xff, vclamp_pixsf_sig is 1.5V, default setup is 0.7V
% writeSensorReg( '090c0080', s2); % 0x90c[7]=1	Set vclamp_pixsf_sig_in for analogtest1 to enable connection

% vclamp_pixsf_sig_in
writeSensorReg( '09060000', s2); % vclamp_pixsf_sig, [4]=0 power-down buffer, and [2]=0 disconnect from analogtest1
writeSensorReg( '090c0080', s2); % 0x90c[7]=1	Set vclamp_pixsf_sig_in for analogtest1 to enable connection
measVref2(g1,s2,'0938','vclamp\_pixsf\_sig\_in',dirSave);  % 0x938[7:0]
writeSensorReg( '090c0000', s2);  % return to default
% vclamp_pixsf_sig
writeSensorReg( '09060014', s2); % vclamp_pixsf_sig, [4]=1 power-up buffer, and [2]=1 connect to analogtest1
measVref2(g1,s2,'0938','vclamp\_pixsf\_sig',dirSave);  % 0x938[7:0]
writeSensorReg( '09060000', s2); % vclamp_pixsf_sig, [4]=0 power-down buffer, and [2]=0 disconnect from analogtest1

