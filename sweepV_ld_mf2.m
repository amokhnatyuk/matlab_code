dirSave = 'C:\data\lot1_\ld_test\5\';
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
prefix = ['meas_miss_code'];

% sweep
dac_start = hex2dec('5100');
dac_end = hex2dec('5000');
dac_step=-4;
dac_seq = dac_start:dac_step:dac_end;
dac_seq_sz = length(dac_seq);
vpga(1:dac_seq_sz)=0;
out1=struct;  % output array
adcList = uint16([0,1,5:9]);
adc_seq = uint16(1:length(adcList));
hsumm(adc_seq,1:16384) = 0;
iOddCol=2;
%h1{adc_seq,1:iOddCol}=struct;

for ii = 1:dac_seq_sz
%    dacCode = [dec2hex(dac_seq(ii),2),'0'];
    dacCode = dec2hex(dac_seq(ii),2);

    swp1 = vsweep42(dacCode, s2, adcList);
    vpga = swp1.d(1,1,2);
    v_measur = measVolt(g1);

    out1=setfield(out1,{ii},'h1',swp1.h1);
    out1=setfield(out1,{ii},'d',swp1.d);
    out1=setfield(out1,{ii},'v_dac',vpga);
    out1=setfield(out1,{ii},'v_measur',v_measur);
    out1=setfield(out1,{ii},'adcList',swp1.adcList);
    
    for iadcList=adc_seq
%        h1=setfield(h1,{iadcList,iOddCol},'h',aa);
        hsumm(iadcList,:) = hsumm(iadcList,:) + swp1.h1(iadcList,iOddCol).h.h;
    end
end
save ([dirSave, prefix, '.mat'], 'out1');
save ([dirSave, 'hsumm.mat'], 'hsumm');

figNum = 190;
%sweepPlot49(out1, figNum, dirSave, prefix);

