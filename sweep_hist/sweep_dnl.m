dirSave = 'C:\data\raijin_lot3\hist\';
prog_path='./sweep_hist/';
if ~exist(dirSave, 'dir') mkdir(dirSave); end
addpath('./sweep_hist');
copyfile([prog_path,'sweep_dnl.m'],dirSave);  % copy this file to dst folder

writeEvkDacReset( s2);
prefix_ = ['ld_swp_dnl'];

% sweep
dac_start = hex2dec('6700');
dac_end = hex2dec('0e00');
dac_step=-2;
dac_seq = dac_start:dac_step:dac_end;
dac_seq_sz = length(dac_seq);
%vpga(1:dac_seq_sz)=0;
out1=struct;  % output array
adcList = uint16([0,1,5:9]);
adc_seq = uint16(1:length(adcList));

figNum = 29;
fig = figure(figNum);
% Set up the movie.

avi_fnNum=9;
prefix = [prefix_,num2str(avi_fnNum)];

hsumm(1:16385) = 0;
clear arr;
arr(1:dac_seq_sz)=struct;
for ii = 1:dac_seq_sz
%    dacCode = [dec2hex(dac_seq(ii),2),'0'];
    dacCode = dec2hex(dac_seq(ii),4);
    x11 = evksetDac (dacCode, s2); pause(.5); 

      nFrm = 0;
        a1 = grab56_4links;
        sz=size(a1);

        iadc = 6;
        ishift = 202;
        iend = ishift+7+640*(iadc-1);
        if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
        out = a1(ishift+640*(iadc-1):2:iend,1001:2:3500)';  % even columns, odd rows
        f2=out;

        sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];
        figure(22); clf; colormap('gray'); 
        subplot(5,1,[1:4])
        imshow(f2,[0 16384],'InitialMagnification',200);
        title(sTitle11);
        subplot(5,1,5); h1 = ihist(out);
        title(['Histogram Image #',num2str(nFrm)]);

        nFrm = nFrm +1;
        pause (1.5);    
%%%%%    
            f2_sz1=size(f2);
            f4=reshape(f2,1,f2_sz1(1)*f2_sz1(2));
            f2_sz=size(f2);
            f3=reshape(f2,1,f2_sz(1)*f2_sz(2));
            mval=floor(double(mean(f3))/10)*10;   
%            m_area = 500; % area around mval where we expect histogram to show
%            f4(f4<mval-m_area | f4>mval+m_area)=[];

            [nout,xout] = hist(double(f4),0:16384);
            
            arr(ii).x = xout;
            arr(ii).n = nout;
            arr(ii).mval = mval;
            hsumm = hsumm + nout;
end
A.arr=arr;
A.hsumm=hsumm;

% DNL
xdnl = uint32(arr(1).mval) :1: uint32(arr(end).mval);
hmean = mean(double(hsumm(xdnl)));
hsumm_m = (hsumm-hmean)/hmean;
dnl(1:length(xdnl))=hsumm_m(xdnl);
A.xdnl = xdnl;
A.dnl = dnl;
save ([dirSave, prefix, '.mat'], 'A');
figure(figNum+1); clf; 
subplot(2,1,1);
bar(xdnl,dnl); grid on;
xlabel('code, lsb'); ylabel('Output, rel.units');
title({[sTitle11,' DNL, calc. from Normalized Historgam with offset']; ...
    ['out=-1 means missing code; out>0 means repeating code']})
subplot(2,1,2);
bar(xdnl,hsumm(xdnl)); grid on;
xlabel('code, lsb'); ylabel('Occurrence');
title([sTitle11,' Histogram'])
saveas(figNum+1,[dirSave, prefix, '.jpg']) 
