function loadSett1(aa,s2)
% s2 - serial port object
% aa is expcted to be the following array format:
% aa={'0C'	 '71'	 'CA'	 '1149'	 '10C0'	 '010F'	 '0003'	 '02'};
setAdcDly(aa{1},s2);
setHoriDly2(aa{2},s2);
setPgaDly2(aa{3},s2);

writeSensorReg( ['0210',aa{4}], s2);  % RSM_asample1_LE
writeSensorReg( ['0212',aa{4}], s2);  % RSM_asample2_LE
writeSensorReg( ['0211',aa{6}], s2);  % RSM_asample1_TE
writeSensorReg( ['0213',aa{6}], s2);  % RSM_asample2_TE

writeSensorReg( ['020c',aa{5}], s2);  % RSM_asample_gnd1_LE
writeSensorReg( ['020e',aa{5}], s2);  % RSM_asample_gnd2_LE
writeSensorReg( ['020d',aa{7}], s2);  % RSM_asample_gnd1_TE
writeSensorReg( ['020f',aa{7}], s2);  % RSM_asample_gnd2_TE

writeSensorReg( ['009002',aa{8}], s2);  % regs.x90

end