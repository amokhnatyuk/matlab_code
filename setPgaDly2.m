function out = setPgaDly2(hexBias, s2)
    writeSensorReg( ['0098', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['0099', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['009a', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['009b', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['009c', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['009d', hexBias,hexBias], s2);  % pga dly
    writeSensorReg( ['009e', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['009f', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a0', hexBias,hexBias], s2);   % pga dly
    out = writeSensorReg( ['00a1', hexBias,hexBias], s2); 
end
