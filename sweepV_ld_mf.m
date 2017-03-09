dirSave = 'C:\data\lot1_\ld_test\1\';
copyfile('sweepV_ld_mf.m',dirSave);  % copy this file to dst folder

% initial setup
aa={'0001' '0001' '0140' '0000'}; loadASample(aa,s2);
% aa={'00' 'ff' '20' '00'};loadSett2(aa,s2);
aa={'00' 'ff' '66'};loadSett3(aa,s2);  % set ADC, PGA delays
writeSensorReg( '08369699',s2);  % writeSensorReg( '08369669',s2);
writeSensorReg( '083b6665',s2);  % writeSensorReg( '083b69A5',s2)   
writeSensorReg( '00900200',s2);
writeSensorReg( '090f0020',s2);
writeSensorReg( '09310070',s2);  % '0068'
writeSensorReg( '09320080',s2);

writeSensorReg( '093b0000',s2);  % set vrefpga1, when 0x00 vrefpga1=1.2V, when 0xff vrefpga1=1.8V, default is 1.7V
writeSensorReg( '093d0000',s2);  % set vrefpga3, when 0x00 vrefpga1=1.2V, when 0xff vrefpga1=1.8V, default is 1.7V

writeEvkDacReset( s2);
adcbias=10; hexBias = dec2hex(adcbias);
writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % set adc bias current
prefix = ['dly=[',aa{1},',',aa{2},',',aa{3},']'];
dirSaveImgWithPrefix = [dirSave, 'imgs\', prefix,' ' ];

% sweep
dac_start = hex2dec('00');
dac_end = hex2dec('70');
dac_step=1;
dac_seq = dac_start:dac_step:dac_end;
dac_seq_sz = length(dac_seq);
h1(1:dac_seq_sz)=struct;
h2(1:dac_seq_sz)=struct;
vpga(1:dac_seq_sz)=0;
out1=struct;  % output array

for ii = 1:dac_seq_sz
    dacCode = [dec2hex(dac_seq(ii),2),'00'];

    swp1 = vsweep41(dacCode, s2, dirSaveImgWithPrefix);
    vpga = swp1.d(1,1,2);
    prefix1 = [prefix, 'Vld=',num2str(vpga,'%5.1f'),'mV'];
    v_measur = measVolt(g1);
%    save ([dirSave, prefix1, '.mat'], 'swp1');

    out1=setfield(out1,{ii},'h1',swp1.h1);
%    out1=setfield(out1,{ii},'h2',swp1.h2);
    out1=setfield(out1,{ii},'d',swp1.d);
    out1=setfield(out1,{ii},'v_dac',vpga);
    out1=setfield(out1,{ii},'v_measur',v_measur);
    out1=setfield(out1,{ii},'adcList',swp1.adcList);
end
save ([dirSave, prefix, '.mat'], 'out1');

figNum = 190;
sweepPlot49(out1, figNum, dirSave, prefix);

