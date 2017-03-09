dirSave = 'C:\data\raijin_lot3\tr2\';
if ~exist(dirSave, 'dir') mkdir(dirSave); end
scriptpath = [ mfilename('fullpath'),'.m'];
copyfile(scriptpath,dirSave);  % copy this file to dst folder

% initial setup
%testrow;
prefix = ['tr_inp_sweep'];

% sweep
dac_start = hex2dec('50');
dac_end = hex2dec('20');
dac_step=-1;
dac_seq = dac_start:dac_step:dac_end;
dac_seq_sz = length(dac_seq);
h1(1:dac_seq_sz)=struct;
h2(1:dac_seq_sz)=struct;
vpga(1:dac_seq_sz)=0;
out1=struct;  % output array
h=waitbar(0,'Collecting data, please wait...');

for ii = 1:dac_seq_sz
    dacCode = [dec2hex(dac_seq(ii),2),'00'];

    swp1 = vsweep45(dacCode, s2, dirSave);
    vpga = swp1.d(1,1,2);
    prefix1 = [prefix, 'Vld=',num2str(vpga,'%5.1f'),'mV'];
%    v_measur = measVolt(g1);
%    save ([dirSave, prefix1, '.mat'], 'swp1');

    out1=setfield(out1,{ii},'h1',swp1.h1);
%    out1=setfield(out1,{ii},'h2',swp1.h2);
    out1=setfield(out1,{ii},'d',swp1.d);
    out1=setfield(out1,{ii},'v_dac',vpga);
%    out1=setfield(out1,{ii},'v_measur',v_measur);
    out1=setfield(out1,{ii},'adcList',swp1.adcList);
    waitbar(ii/dac_seq_sz,h);
end
save ([dirSave, prefix, '.mat'], 'out1');
close(h);

figNum = 190;
sweepPlot60(out1, figNum, dirSave, prefix);

