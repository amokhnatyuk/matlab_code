
dirSave = 'C:\data\lot1_\all_adc\inl\';
adc=[6,10;8,6]; % adc#, adc_bias
adcsz = size(adc);
% sweep adc#
for ii= 2: adcsz(1) 
    iadc=adc(ii,1);
    adcbias = adc(ii,2);
    if ((adcbias>=0) && (adcbias<16)) 
        hexBias = dec2hex(adcbias);
    end
    
    writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % adc current
    swp3 = vsweep3('7000', 'f000', 256, s2, dirSave,iadc);
%    save ([dirSave, 'adc#',num2str(iadc),' adcbias=',num2str(adcbias),'.mat'], 'swp3');
    figNum = 148;
    sweepPlot3(swp3, iadc, adcbias, figNum, dirSave);
end