writeSensorReg( '00350000', s2);   % Post-DP test pattern
writeSensorReg( '01560000', s2);   % pre-DP test pattern   writeSensorReg( '01560002', s3);
writeSensorReg( '01500000', s2);   % line noise, hot pix correction
writeSensorReg( '015e0000', s2);   % FPN correction
writeSensorReg( '01610000', s2);   % FPN BIST test
writeSensorReg( '01800000', s2);   % hot clip 0
writeSensorReg( '017c0000', s2);   % ref LN correction
writeSensorReg( '01970000', s2);   % OB clamp correction
writeSensorReg( '00730000', s2);   % dig PGA
