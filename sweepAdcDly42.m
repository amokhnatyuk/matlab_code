dirSave = 'C:\data\lot1_\adcbias_oldBG\adc_delay\adcdly\';
writeSensorReg( '090a0000', s2);  pause(0.1);  % % set old adc bias generator    
writeEvkDacReset( s2);

adcbias=10; hexBias = dec2hex(adcbias);
writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % set adc bias current
%adcdly =0;
pgadly=0;
seq = 0:8:255;
seqsz = length(seq);
dac_seq = { '5000', '5800','6800'};  % '4800',
dac_seq_sz = length(dac_seq);

for ii = 1:dac_seq_sz
    out1=struct;  % output array
    dacCode = dac_seq{ii};
    for jj=1:seqsz % sweep adc dly; default 0, range 0:255
        adcdly = seq(jj);
        prefix = ['bias=', num2str(adcbias),' adcdly=', num2str(adcdly),' pgadly=', num2str(pgadly)];
        dirSaveImgWithPrefix = [dirSave, 'imgs\', prefix,' ' ];

        if ((adcdly>=0) && (adcdly<16)) 
            hexBias = ['0',dec2hex(adcdly)];
        elseif (adcdly<255) 
            hexBias = dec2hex(adcdly);
        end
        setAdcDly(hexBias, s2);

        swp1 = vsweep4(dacCode, s2, dirSaveImgWithPrefix);
        vpga = swp1.d(1,1,1);
        prefix1 = [prefix, 'Vpga=',num2str(vpga,'%5.1f'),'mV'];
    %    save ([dirSave, prefix1, '.mat'], 'swp1');

        out1=setfield(out1,{jj},'h1',swp1.h1);
        out1=setfield(out1,{jj},'h2',swp1.h2);
        out1=setfield(out1,{jj},'d',swp1.d);
        out1=setfield(out1,{jj},'adcdly',adcdly);
        out1=setfield(out1,{jj},'pgadly',pgadly);
        out1=setfield(out1,{jj},'bias',adcbias);
        out1=setfield(out1,{jj},'vpga',vpga);
    end
    prefix2 = ['bias=', num2str(adcbias),' adcdly_swp', ' pgadly=', num2str(pgadly),' Vpga=',num2str(vpga,'%5.1f'),'mV'];
    save ([dirSave, prefix2, '.mat'], 'out1');
    figNum = 90;
    sweepPlot42(out1, figNum, dirSave, prefix2);
end

