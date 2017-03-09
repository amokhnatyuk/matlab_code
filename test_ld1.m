% LD test
writeSensorReg( '00900200', s2);   % coltest enable (output of column buffer)
writeSensorReg( '090f0020', s2);   % coltest_padcon=1
writeSensorReg( '00600000', s2);   % CB PD  % writeSensorReg( '00600180', s2);
writeSensorReg( '00950000', s2);   % sel_testpga = 0 (ldbus enable)
writeSensorReg( '090800F0', s2);   % refgen default
writeSensorReg( '091c00a5', s2);   % adc current 10
%writeSensorReg( '090800F2', s2);   % select colbuf connect to AnalogTest1
%writeSensorReg( '0909001d', s2);    % set vrefld for AnalogTest1
%writeSensorReg( '0909001f', s2); % (1c default) Select vref_colbuf for analogtest1, set to 1 to enable testing connection
writeSensorReg( '02b40000', s2);  % pga_read_cal_invert=0
%writeSensorReg('02d80000',s2);  % Invert con_pga_adc in ro_rsm
% writeSensorReg( '0909001D', s2)  % Select vref_ldbus_pc for analogtest1, set to 1 to enable testing connection
% writeSensorReg( '090e0004', s2) % 
%v = evksetDac ('5800', s2)
%writeSensorReg( '09320035', s2)
% writeSensorReg( '02021000', s2);  % Invert az_config in ro_rsm

%fn='C:\data\regs\Book3.csv';
%fnOut='C:\data\regs\ld_in_test_move.csv';
%listPass = sensorState( fn, s2, fnOut);

aa={'0001' '0001' '0140' '0000'}; loadASample(aa,s2);
% aa={'00' 'ff' '20' '00'};loadSett2(aa,s2);
aa={'00' 'ff' '66'};loadSett3(aa,s2);
writeSensorReg( '08369699',s2);  % writeSensorReg( '08369669',s2);
writeSensorReg( '083b6665',s2);  % writeSensorReg( '083b69A5',s2)   
writeSensorReg( '00900200',s2);
writeSensorReg( '090f0020',s2);
writeSensorReg( '09310070',s2);  % '0068'
writeSensorReg( '09320080',s2);

writeSensorReg( '093b0000',s2);  % set vrefpga1, when 0x00 vrefpga1=1.2V, when 0xff vrefpga1=1.8V, default is 1.7V '093b00d4'
writeSensorReg( '093d0000',s2);  % set vrefpga3, when 0x00 vrefpga1=1.2V, when 0xff vrefpga1=1.8V, default is 1.7V '093d00d4'

% writeSensorReg( '002b10a1', s2); % set number of lines to ger VSYNC pulse correctly