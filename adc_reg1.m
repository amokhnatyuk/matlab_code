writeSensorReg( '02b41000', s2);  pause(0.1); % pga_read_cal_invert
%writeSensorReg( '02d81000', s2);  % con_pga_adc_invert
writeSensorReg( '091c00a5', s2);   % adc current 10
writeSensorReg( '00350000', s2);   % Post-DP test pattern
writeSensorReg( '01560000', s2);   % pre-DP test pattern   writeSensorReg( '01560002', s3);
writeSensorReg( '090f0040', s2);   % pgatestpad_en=1
writeSensorReg( '00950004', s2);   % sel_testpga
writeSensorReg( '01500000', s2);   % line noise, hot pix correction
writeSensorReg( '015e0000', s2);   % FPN correction
writeSensorReg( '01610000', s2);   % FPN BIST test
writeSensorReg( '01800000', s2);   % hot clip 0
writeSensorReg( '017c0000', s2);   % ref LN correction
writeSensorReg( '01970000', s2);   % OB clamp correction
writeSensorReg( '00730000', s2);   % dig PGA
writeSensorReg( '090a0000', s2);   % % set old adc bias generator
% writeSensorReg( '00600020', s2); % ADC PD
% LD test
writeSensorReg( '00900200', s2);   % coltest enable
writeSensorReg( '090f0020', s2);   % coltest_padcon=1
writeSensorReg( '00600180', s2);   % CB PD
writeSensorReg( '00950000', s2);   % sel_testpga = 0 (ldbus enable)
%writeSensorReg( '0909001f', s2); % (1c default) Select vref_colbuf for analogtest1, set to 1 to enable testing connection
writeSensorReg( '02b40000', s2);  % pga_read_cal_invert=0
%writeSensorReg('02d80000',s2);  % Invert con_pga_adc in ro_rsm
% writeSensorReg( '0909001D', s2)  % Select vref_ldbus_pc for analogtest1, set to 1 to enable testing connection
% writeSensorReg( '09320035', s2)
% writeSensorReg( '090e0004', s2) % 
%v = evksetDac ('5800', s2)
%writeSensorReg( '09320035', s2)