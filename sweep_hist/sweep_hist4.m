dirSave = 'C:\data\raijin_lot3\dnl_swp\';
prog_path='./sweep_hist/';
if ~exist(dirSave, 'dir') mkdir(dirSave); end
addpath('./sweep_hist');
copyfile([prog_path,'sweep_hist4.m'],dirSave);  % copy this file to dst folder

% sweep
dac_start = hex2dec('6600');
dac_end = hex2dec('6e00');
dac_step=-8;
dac_seq = dac_start:dac_step:dac_end;
dac_seq_sz = length(dac_seq);
%vpga(1:dac_seq_sz)=0;
out1=struct;  % output array
adcList = uint16([0,1,5:9]);
adc_seq = uint16(1:length(adcList));

figNum = 29;
fig = figure(figNum);
% Set up the movie.

hsumm(1:16385) = 0;
clear arr;
arr(1:maxBiasSetting+1)=struct;
stdev(1:maxBiasSetting+1)=0;

i2=[5:8:320, 6:8:320, 7:8:320,8:8:320];
i3=sort(i2);
iadc = 7; sTitle9 = ['ADC#',num2str(iadc)];
maxBiasSetting = 15;
    
for ii=1:maxBiasSetting+1 
    sbias{kk}=['Bias _glob=',num2str(ii)];

    hval = ['00b',dec2hex((ii-1),1)];
    writeSensorReg( ['0921', hval], s2);
    
    a8 = igrab4(8);  % grab
    sz=size(a8);  %% 6400x4232x8

    iend = 98-3+640*(iadc);
    if (98-3+640*(iadc) > sz(1)) iend = sz(1); end
    out = a8(98-1+640*(iadc-1):2:iend,501:2:4200,:);  % even columns, odd rows

    f1=out;
    f2=f1(i3,:,:);
    f2_sz=size(f2);
    f3=double(reshape(f2,1,f2_sz(1)*f2_sz(2)*f2_sz(3)));
    mval=11000;   
    m_area = 1000; % area around mval where we expect histogram to show
    f3(f3<mval-m_area | f3>mval+m_area)=[];
    f3_sz=length(f3);

    figure(fig); clf; colormap('gray'); 
    xrng = [10000 12000];
    [nout,xout] = hist(f3,xrng(1):xrng(2));
    xlim(xrng);

    ax=gca; % 
    xmin = mval - m_area; xmax = mval + m_area; 
    ymax = max(nout); 
    bar(xout,nout); grid on;
    axis tight; axis([xmin xmax 0 ymax]); 
    xlim([xmin,xmax]); 
    ylim([0,ymax]);
    stamp(ii) = curStamp( s2 );

    arr(ii).x = xout;
    arr(ii).n = nout;
    hnorm = nout/sum(nout);
    stdev(ii) = std(hnorm);
    sTitle10 = [sTitle9, ' Bias_glob=',num2str(ii-1)];
    sTitle11 = sprintf([sTitle10,', std=%6.5f rel.units'],stdev(ii));
    title(sTitle11,'FontWeight','bold');
    saveas(figNum,[dirSave, sTitle11, '.png']) 
    saveas(figNum,[dirSave, sTitle11, '.fig']) 
    pause (1.4);
end
A.arr=arr;
A.stdev=stdev;
A.stamp=stamp;
sTitle14 = [sTitle9,'Glob_bias sweep'];
prefix = sTitle14;

save ([dirSave, prefix, '.mat'], 'A');
figure(figNum+1); clf; 
plot(0:maxBiasSetting,1./A.stdev); grid on;
xlabel('CUrrent bias, lsb'); ylabel('Code quality parameter, rel.units');
title(sTitle14);

saveas(figNum+1,[dirSave, sTitle14, '.png']) 
saveas(figNum+1,[dirSave, sTitle14, '.fig']) 
