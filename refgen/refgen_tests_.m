% initial setup
%g1=gpib('ni',0,22);
%fopen(g1);
writeSensorReg( '00330000', s2);  % disable SDO waveforms
writeSensorReg( '00900000', s2);  % disconnect coltest from CB output
writeSensorReg( '090f0000', s2);  % disconnect coltest_padcon and coltest_refcon
writeSensorReg( '090800F0', s2);  % disconnect vref_colbuf

% testing vclamp_pixsf_rst and vclamp_pixsf_sig dacs and buffers
% writeSensorReg( '09060028', s2); % vclamp_pixsf_rst, [5]=1 power-up buffer, and [3]=1connect to analogtest0
% writeSensorReg( '09350077', s2); % Set vclamp_pixsf_rst voltage, when set to 0x0, vclamp_pixsf_rst is 3.5V, when set to 0xff, vclamp_pixsf_rst is 1.5V, default setup is 1.9V
% writeSensorReg( '090d0002', s2); % 0x90d[1]=1	St vclamp_pixsf_rst_in for analogtest0 to enable testing connection

% vclamp_pixsf_rst
writeSensorReg( '09060000', s2); % vclamp_pixsf_rst, [5]=0 power-down buffer, and [3]=0 disconnect from analogtest0
writeSensorReg( '090d0002', s2); % 0x90d[1]=1, Set vclamp_pixsf_rst_in for analogtest0 to enable testing connection
measVref(g2,s2,'0935','vref\_az\_bufin');  % 0x930[7:0]
writeSensorReg( '090d0000', s2);  % return to default


writeSensorReg( '090d0080',s2);  % dflt='0000'; connect vref_az_bufin to analogtest1 pad
measVref(g2,s2,'0930','vref\_az\_bufin');  % 0x930[7:0]
writeSensorReg( '090d0000', s2);  % return to default
% vref_az
writeSensorReg( '090800F8', s2);  % dflt='00F0';% connect vref_az to analogtest1 pad
%writeSensorReg( '09300044', s2);  % change vref_az
measVref(g2,s2,'0930','vref\_az');  % 0x930[7:0]
writeSensorReg( '090800F0', s2);  % return to default

% test_vrefpga1_in, 0x90c[2]=1 to enable connection for testin
writeSensorReg( '090C0004',s2); % dflt='0000', connect test_vrefpga1_in to analogtest1 pad
measVref(g2,s2,'093b','vrefpga1\_in');  % 0x93b[7:0]
writeSensorReg( '090C0000', s2);  % return to default
% test_vrefpga2, 0x905[1]=1 to enable connection for testin
writeSensorReg( '090500BA',s2); % dflt='00B8', connect test_vrefpga2 to analogtest1 pad
measVref(g2,s2,'093b','vrefpga1');  % 0x93b[7:0]
writeSensorReg( '090500B8', s2);  % return to default

