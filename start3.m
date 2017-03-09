writeSensorReg( '020c1001', s2);  % asample_gnd1_LE
writeSensorReg( '020d0000', s2);  % asample_gnd1_TE
writeSensorReg( '020e1001', s2);  % asample_gnd2_LE
writeSensorReg( '020f0000', s2);  % asample_gnd2_TE
writeSensorReg( '02100003', s2);  % asample1_LE 
writeSensorReg( '02110140', s2);  % asample1_TE
writeSensorReg( '02120003', s2);  % asample2_LE 
writeSensorReg( '02130140', s2);  % asample2_TE

% Output clock to SDO
%writeSensorReg( '00340001', s2);
%getSDO ('1e',s2);  % 1e asample1, 1f asample2, 20 asample_gnd1, 21 asample_gnd2

%writeSensorReg( '083b60a5', s2);
%writeSensorReg( '090f0010', s2); 
