dirSave = 'C:\data\lot1_\adcbias_oldBG\inl1\';
copyfile('sweepV_mf.m',dirSave);  % copy this file to dst folder

% initial setup
writeSensorReg( '090a0000', s2);  pause(0.1);  % % set old adc bias generator    
writeEvkDacReset( s2);
adcbias=10; hexBias = dec2hex(adcbias);
writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % set adc bias current
setPgaDly('3C', s2);
setAdcDly('00', s2);
adcdly =0;
pgadly=60;
prefix = ['bias=', num2str(adcbias),' adcdly=', num2str(adcdly),' pgadly=', num2str(pgadly)];
dirSaveImgWithPrefix = [dirSave, 'imgs\', prefix,' ' ];

dac_start = hex2dec('20');
dac_end = hex2dec('90');
dac_step=1;
dac_seq = dac_start:dac_step:dac_end;
dac_seq_sz = length(dac_seq);
h1(1:dac_seq_sz)=struct;
h2(1:dac_seq_sz)=struct;
vpga(1:dac_seq_sz)=0;
out1=struct;  % output array

for ii = 1:dac_seq_sz
    dacCode = [dec2hex(dac_seq(ii)),'00'];

    swp1 = vsweep41(dacCode, s2, dirSaveImgWithPrefix);
    vpga = swp1.d(1,1,1);
    prefix1 = [prefix, 'Vpga=',num2str(vpga,'%5.1f'),'mV'];
%    save ([dirSave, prefix1, '.mat'], 'swp1');

    out1=setfield(out1,{ii},'h1',swp1.h1);
    out1=setfield(out1,{ii},'h2',swp1.h2);
    out1=setfield(out1,{ii},'d',swp1.d);
    out1=setfield(out1,{ii},'vpga',vpga);
    out1=setfield(out1,{ii},'adcList',swp1.adcList);
end
save ([dirSave, prefix, '.mat'], 'out1');

figNum = 190;
sweepPlot44(out1, figNum, dirSave, prefix);

