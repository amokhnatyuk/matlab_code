
dirSave = 'C:\data\lot1_\all_adc\adcbias_oldBG\';
writeSensorReg( '090a0000', s2);  % set old adc bias generator    
% sweep adc bias
for adcbias=1:15  % default 0:15
    swp1=[];
    dirSaveWithBias = [dirSave, 'ADCbias=' , num2str(adcbias),' ' ];
    dirSaveImgWithBias = [dirSave, 'imgs\', 'ADCbias=' , num2str(adcbias),' ' ];

    if ((adcbias>=0) && (adcbias<16)) 
        hexBias = dec2hex(adcbias);
    end
    
    writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % adc current
    swp1 = vsweep2('7000', 'f000', 256, s2, dirSaveImgWithBias);
    save ([dirSaveWithBias, 'alladc_bias',num2str(adcbias),'.mat'], 'swp1');
    figNum = 88;
    sweepPlot2(swp1, adcbias, figNum, dirSave);
end