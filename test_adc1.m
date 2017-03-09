writeSensorReg( '02b41000', s2);   % pga_read_cal_invert
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
% writeSensorReg( '090a0000', s2);   % % set old adc bias generator
% writeSensorReg( '00600020', s2); % ADC PD
