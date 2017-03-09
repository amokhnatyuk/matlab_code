function setLdDly(hexBias, s2)
    writeSensorReg( ['0098', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['0099', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['009a', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['009b', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['009c', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['009d', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['009e', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['009f', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['00a0', hexBias,hexBias], s2);   % LD dly
    writeSensorReg( ['00a1', hexBias,hexBias], s2);   % LD dly
end
