

dirSave = 'c:/data/lot1_/';
adcNum = 5;
    
% sweep adc bias
for adcbias=0:15
    swp1=[];
    %adcbias = 5;
    if ((adcbias>=0) && (adcbias<16)) 
        hexBias = dec2hex(adcbias);
    else hexBias = 5; % default
    end
    
    figNum = 88;
    writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % adc current
    swp1 = vsweep1('7000', 'f000', 256, adcNum, s2);
    save ([dirSave, 'adc',num2str(adcNum),'_bias',num2str(adcbias),'.mat'], 'swp1');
    sweepProc1(swp1, adcNum, adcbias, figNum,'c:/data/lot1_/');
end
