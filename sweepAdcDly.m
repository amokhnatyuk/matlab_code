dirSave = 'C:\data\lot1_\adcbias_oldBG\multiFrame\';
writeSensorReg( '090a0000', s2);  % set old adc bias generator    
% sweep adc bias

 % adcdly,pgadly,  -- TBD
 adcdly =0;pgadly=0;

for adcbias=8:2:10  % default 0:15
    dirSaveWithBias = [dirSave, 'ADCbias=' , num2str(adcbias) ];
    dirSaveImgWithBias = [dirSave, 'imgs\', 'ADCbias=' , num2str(adcbias),' ' ];

    if ((adcbias>=0) && (adcbias<16)) 
        hexBias = dec2hex(adcbias);
    end
    
    writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % adc current
    swp1 = vsweep21('2000', '9000', 512, s2, dirSaveImgWithBias);
    save ([dirSaveWithBias, '.mat'], 'swp1');
    figNum = 88;
    sweepPlot41(swp1, adcbias,  adcdly,pgadly, figNum, dirSave);
end