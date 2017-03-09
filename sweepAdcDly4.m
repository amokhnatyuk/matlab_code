dirSave = 'C:\data\lot1_\adcbias_oldBG\multiFrame\bias10\';
writeSensorReg( '090a0000', s2);  pause(0.1);  % % set old adc bias generator    

adcbias=10; hexBias = dec2hex(adcbias);
writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % set adc bias current
adcdly =0;
pgadly=0;

% sweep adc dly
%for adcdly=0:8:255  % default 0:15
    prefix = ['bias=', num2str(adcbias),' adcdly=', num2str(adcdly),' pgadly=', num2str(pgadly)];
    dirSaveImgWithPrefix = [dirSave, 'imgs\', prefix,' ' ];

    if ((adcdly>=0) && (adcdly<16)) 
        hexBias = ['0',dec2hex(adcdly)];
    elseif (adcdly<255) 
        hexBias = dec2hex(adcdly);
    end
    setAdcDly(hexBias, s2);

    swp1 = vsweep21('2000', '9000', 512, s2, dirSaveImgWithPrefix);
    save ([dirSave, prefix, '.mat'], 'swp1');
    figNum = 88;
    sweepPlot41(swp1, adcbias,  adcdly,pgadly, figNum, dirSave);
%end

