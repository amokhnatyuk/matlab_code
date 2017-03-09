readRegsFromFile( fn2, s2);

writeSensorReg( '00350000', s2);   % Post-DP test pattern off
writeSensorReg( '01560000', s2);   % pre-DP test pattern off  
writeSensorReg( '01500000', s2);   % line noise, hot pix correction
writeSensorReg( '015e0000', s2);   % FPN correction
writeSensorReg( '01610000', s2);   % FPN BIST test
writeSensorReg( '01800000', s2);   % hot clip 0
writeSensorReg( '017c0000', s2);   % ref LN correction
writeSensorReg( '01970000', s2);   % OB clamp correction
writeSensorReg( '00730000', s2);   % dig PGA

% ADC adjustments
writeSensorReg( '091c00a5', s2);   % adc current 10
setPgaDly('3C', s2);
setAdcDly('00', s2);
% LD test
writeSensorReg( '00900200', s2);   % coltest enable (output of column buffer)
writeSensorReg( '090f0010', s2);   % vref_con: vref_colbuf is connected to CB output
writeSensorReg( '00600180', s2);   % CB PD
writeSensorReg( '00950000', s2);   % sel_testpga = 0 (ldbus enable)
%writeSensorReg( '090800F0', s2);   % refgen default
%writeSensorReg( '090800F2', s2);   % select colbuf connect to AnalogTest1

%writeSensorReg( '0909001d', s2);    % set vrefld for AnalogTest1  default '0909001c'
writeSensorReg( '093100e3', s2); % set vref_ld=1.7V % default '0044' (3.3V), adjust vref_ld
%writeSensorReg( '0909001f', s2); % (1c default) Select vref_colbuf for analogtest1, set to 1 to enable testing connection
writeSensorReg( '02b40000', s2);  % pga_read_cal_invert=0
%writeSensorReg('02d80000',s2);  % Invert con_pga_adc in ro_rsm
% writeSensorReg( '0909001D', s2)  % Select vref_ldbus_pc for analogtest1, set to 1 to enable testing connection
% writeSensorReg( '09320035', s2)
% writeSensorReg( '090e0004', s2) % 
%v = evksetDac ('5800', s2)
%writeSensorReg( '09320035', s2)
% writeSensorReg( '02021000', s2);  % Invert az_config in ro_rsm