function setAdcDly(hexBias, s2)
    writeSensorReg( ['00ac', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00ad', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00ae', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00af', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b0', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b1', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b2', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b3', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b4', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b5', hexBias,hexBias], s2); pause(0.1);  % adc dly
    writeSensorReg( ['00b6', hexBias,hexBias], s2); pause(0.1);  % adc dly
end
