function out = setHoriDly2(hexBias, s2)
    writeSensorReg( ['00a2', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a3', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a4', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a5', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a6', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a7', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a8', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00a9', hexBias,hexBias], s2);   % pga dly
    writeSensorReg( ['00aa', hexBias,hexBias], s2);   % pga dly
    out = writeSensorReg( ['00ab', hexBias,hexBias], s2); 
