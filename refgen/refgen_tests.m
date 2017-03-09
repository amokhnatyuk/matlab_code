% initial setup
writeSensorReg( '00330000', s2);  % disable SDO waveforms
writeSensorReg( '00900000', s2);  % disconnect coltest from CB output
writeSensorReg( '090f0000', s2);  % disconnect coltest_padcon and coltest_refcon
writeSensorReg( '090800F0', s2);  % disconnect vref_colbuf
%g1=gpib('ni',0,22);
%fopen(g1);

% vref_az_bufin
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

% test_vrefpga2_in, 0x90c[1]=1 to enable connection for testin
writeSensorReg( '090C0002',s2); % dflt='0000', connect test_vrefpga2_in to analogtest1 pad
measVref(g2,s2,'093c','vrefpga2\_in');  % 0x93c[7:0]
writeSensorReg( '090C0000', s2);  % return to default
% test_vrefpga2, 0x905[2]=1 to enable connection for testin
writeSensorReg( '090500BC',s2); % dflt='00B8', connect test_vrefpga2 to analogtest1 pad
measVref(g2,s2,'093c','vrefpga2');  % 0x93c[7:0]
writeSensorReg( '090500B8', s2);  % return to default

% vrefpga<3>, set register x0905[6] bit to 1 to enable connection for testing
writeSensorReg( '090500F8',s2);  % dflt='00B8' connect vrefpga3 to analogtest1 pad
measVref(g2,s2,'093d','vrefpga3');  % 0x93d[7:0]
writeSensorReg( '090500B8', s2);  % return to default

% vbgb_in, 0x90c[3]=1 to enable connection for testin
writeSensorReg( '090C0008',s2); % dflt='0000', connect vbgb_in to analogtest1 pad
measVref(g2,s2,'093a','vbgb\_in');  % 0x93a[7:0]
writeSensorReg( '090C0000', s2);  % return to default
% test_adcvbgb, 0x905[0]=1 to enable connection for testin
writeSensorReg( '090500B9',s2); % dflt='00B8', connect test_vrefpga2 to analogtest1 pad
measVref(g2,s2,'093a','vbgb');  % 0x93a[7:0]
writeSensorReg( '090500B8', s2);  % return to default
%{
% vref_cb_in<1>, 0x90d[5]=1 to enable connection for test
writeSensorReg( '090D0020',s2); % dflt='0000', connect vref_cb_in<1> to analogtest1 pad
measVref(g2,s2,'0934','vref\_cb\_in1');  % 0x934[7:4], refsel_refp_az<1:0> and refsel_refn_az<1:0>
writeSensorReg( '090D0000', s2);  % return to default
%}

% vref_sample_bufin, 0x90d[4]=1 to enable connection for testin
writeSensorReg( '090d0010',s2); % dflt='0000', connect vref_sample_bufin to analogtest1 pad
measVref(g2,s2,'0933','vref\_sample\_bufin');  % 0x933[7:0]
writeSensorReg( '090d0000', s2);  % return to default
% vref_sample, 0x908[0]=1 to enable connection for testin
writeSensorReg( '090800F1',s2); % dflt='00F0', connect vref_sample to analogtest1 pad
measVref(g2,s2,'0933','vref\_sample');  % 0x933[7:0]
writeSensorReg( '090800F0', s2);  % return to default

% ld_vref_in, 0x90d[3]=1 to enable connection for test
writeSensorReg( '090d0008',s2); % dflt='0000', connect vref_sample_bufin to analogtest1 pad
measVref(g2,s2,'0931','vref\_ld\_in');  % 0x931[7:0]
writeSensorReg( '090d0000', s2);  % return to default
% vref_sample, 0x909[1]=1 to enable connection for test
writeSensorReg( '0909001E',s2); % dflt='001C', connect vref_sample to analogtest1 pad
measVref(g2,s2,'0931','vref\_ld');  % 0x931[7:0]
writeSensorReg( '0909001C', s2);  % return to default

% vref_ldbus_pc_bufin, 0x90d[2]=1 to enable connection for test
writeSensorReg( '090d0004',s2); % dflt='0000', connect vref_ldbus_pc_bufin to analogtest1 pad
measVref(g2,s2,'0932','vref\_ldbus\_pc\_bufin');  % 0x932[7:0]
writeSensorReg( '090d0000', s2);  % return to default
% vref_ldbus_pc, 0x909[0]=1 to enable connection for test
writeSensorReg( '0909001D',s2); % dflt='001C', connect vref_ldbus_pc to analogtest1 pad
measVref(g2,s2,'0932','vref\_ldbus\_pc');  % 0x932[7:0]
writeSensorReg( '0909001C', s2);  % return to default


