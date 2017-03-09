% sweep_cbgain procedure
dirSave = 'C:\data\lot1_\cb_test\g2\';
if ~exist(dirSave, 'dir') mkdir(dirSave); end
copyfile('sweep_cbgain.m',dirSave);  % copy this file to dst folder

% initial setup
test_ld1;
cb_settings;
% set gainctrl switch permanently on
writeSensorReg( '020a1001', s2);  % RO_RSM_gainctrl_LE_00
writeSensorReg( '020b0000', s2);  % RO_RSM_gainctrl_TE_00

writeEvkDacReset( s2);
adcbias=10; hexBias = dec2hex(adcbias);
writeSensorReg( ['091c00', hexBias, '5'], s2); pause(0.1);  % set adc bias current

% set CB gain
t1 = gain_table( );

h=waitbar(0,'Voltage sweep, please wait...');
h2=waitbar(0,'CB Gain sweep...');
% Change position of second bar so the is not overlap
pos_w1=get(h,'position');
pos_w2=[pos_w1(1) pos_w1(2)+pos_w1(4) pos_w1(3) pos_w1(4)];
set(h2,'position',pos_w2,'doublebuffer','on')


gain_ind=[1,2,4,5,9,14,19,24,31,36,43,48,52,56,60,64];

for kk=8:length(gain_ind)
    dir_gain = [dirSave,num2str(kk),'\'];
    if ~exist(dir_gain, 'dir') mkdir(dir_gain); end
    % sweep register x003c; x003d
    jj=gain_ind(kk);
    g= t1{jj,1};
    prefix = ['gain=',num2str(g,'%5.2f')];
    rval = t1{jj,2};
    writeSensorReg( ['003c',rval], s2);
    writeSensorReg( ['003d',rval], s2);
    if (g <= 1.1)
        dac_start = hex2dec('0a'); dac_end = hex2dec('70');
        dac_step=2;
    elseif (g <= 2)
        dac_start = hex2dec('24'); dac_end = hex2dec('6c');
        dac_step=2;
    elseif (g <= 3.1)
        dac_start = hex2dec('44'); dac_end = hex2dec('6b');
        dac_step=1;
    elseif (g <= 4.1)
        dac_start = hex2dec('4d'); dac_end = hex2dec('69');
        dac_step=1;
    elseif (g <= 6.1)
        dac_start = hex2dec('52'); dac_end = hex2dec('69');
        dac_step=1;
    elseif (g <= 10.1)
        dac_start = hex2dec('58'); dac_end = hex2dec('68');
        dac_step=1;
    else 
        dac_start = hex2dec('5d'); dac_end = hex2dec('68');
        dac_step=1;
    end
    dac_seq = dac_start:dac_step:dac_end;
    dac_seq_sz = length(dac_seq);
    h1(1:dac_seq_sz)=struct;
    %h2(1:dac_seq_sz)=struct;
    vpga(1:dac_seq_sz)=0;
    out1=struct;  % output array

    for ii = 1:dac_seq_sz
        % sweep voltage
        dacCode = [dec2hex(dac_seq(ii),2),'00'];

        swp1 = vsweep43(dacCode, s2, dir_gain);
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
        waitbar(ii/dac_seq_sz,h);
    end
    save ([dirSave, prefix, '.mat'], 'out1');

    figNum = 190;
    sweepPlot50(out1, figNum, dirSave, prefix);
    waitbar(kk/length(gain_ind),h2);
end
close(h);
close(h2);
