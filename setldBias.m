function setldBias(h,s2)
% h='00'; up to h = '3f'
writeSensorReg( ['092500',dec2hex(hex2dec(h)*4,2)],s2);
writeSensorReg( ['092600',h],s2);
writeSensorReg( ['092700',h],s2);
writeSensorReg( ['092800',h],s2);
end