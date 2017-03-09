function loadASample(aa,s2)
% s2 - serial port object
% aa is expcted to be the following array format:
% aa={'1149' '10C0' '010F' '0003'};
writeSensorReg( ['0210',aa{1}], s2);  % RSM_asample1_LE
writeSensorReg( ['0212',aa{1}], s2);  % RSM_asample2_LE
writeSensorReg( ['0211',aa{3}], s2);  % RSM_asample1_TE
writeSensorReg( ['0213',aa{3}], s2);  % RSM_asample2_TE

writeSensorReg( ['020c',aa{2}], s2);  % RSM_asample_gnd1_LE
writeSensorReg( ['020e',aa{2}], s2);  % RSM_asample_gnd2_LE
writeSensorReg( ['020d',aa{4}], s2);  % RSM_asample_gnd1_TE
writeSensorReg( ['020f',aa{4}], s2);  % RSM_asample_gnd2_TE

end

%{
LE = x0001;	 TE=x0140
LE = x1001;	 TE=x0000
%}