dirSave = 'C:\data\lot1_\sweep_hist\1\';
if ~exist(dirSave, 'dir') mkdir(dirSave); end
copyfile('sweep_hist1.m',dirSave);  % copy this file to dst folder

writeEvkDacReset( s2);
prefix_ = ['pga_sweep'];

% sweep
dac_start = hex2dec('3bb0');
dac_end = hex2dec('3a40');
dac_step=-1;
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
avi_fn= [dirSave,prefix,'.avi'];
while exist(avi_fn, 'file') 
    avi_fnNum = avi_fnNum+1;
    prefix = [prefix_,num2str(avi_fnNum)];
    avi_fn= [dirSave,prefix,'.avi'];
end

hsumm(1:16385) = 0;
clear arr;
arr(1:dac_seq_sz)=struct;
aviobj = avifile(avi_fn,'compression','None','quality',100,'fps',8);
for ii = 1:dac_seq_sz
%    dacCode = [dec2hex(dac_seq(ii),2),'0'];
    dacCode = dec2hex(dac_seq(ii),4);
    x11 = evksetDac (dacCode, s2); pause(.5); 

            a1 = grab56_4links;
            sz=size(a1);

            iadc = 6;
            ishift = 202;
            iend = ishift+7+640*(iadc-1);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out1 = a1(ishift+640*(iadc-1):2:iend,1001:2:3500)';  % even columns, odd rows
            
            f2=out1;
            f2_sz1=size(f2);
            f4=reshape(f2,1,f2_sz1(1)*f2_sz1(2));
            f2((rem(out1,4)==0 | rem(out1,4)==3))=0;
            f2_sz=size(f2);
            f3=reshape(f2,1,f2_sz(1)*f2_sz(2));
            f3((rem(f3,4)==0 | rem(f3,4)==3))=[];
            mval=floor(double(mean(f3))/10)*10;   
            m_area = 500; % area around mval where we expect histogram to show
            f4(f4<mval-m_area | f4>mval+m_area)=[];

            figure(fig); clf; colormap('gray'); 
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];
%            mval = 14200;
%            hist(double(f3-1),0:16384);
            [nout,xout] = hist(double(f4),0:16384);
            
%            bar(xout,nout); grid on;
            ax=gca; % 
            xmin = 14100; xmax = 14490; 
            ymax = 600; 
            bar(xout,nout); grid on;
            axis tight; axis([xmin xmax 0 ymax]); 
            xlim([xmin,xmax]); 
            ylim([0,ymax]);
            set(ax,'xtick',[mval-500:10:mval+500]);
            
            sTitle12 = sprintf([sTitle11,' std=%5.2f lsb'],std(double(f4)));
            title(sTitle12,'FontWeight','bold');
            xstr = xnCode(8,xmin,xmax-100); text(xmin+5,ymax-22,xstr); % x8
            xstr = xnCode(16,xmin,xmax); text(xmin+5,ymax-44,xstr); % x16
            xstr = xnCode(32,xmin,xmax); text(xmin+5,ymax-66,xstr); % x32
            xstr = xnCode(64,xmin,xmax); text(xmin+5,ymax-88,xstr); % x64
            xstr = xnCode(128,xmin,xmax); text(xmin+5,ymax-110,xstr); % x128
%            drawnow;
            aviobj = addframe(aviobj,fig);
            arr(ii).x = xout;
            arr(ii).n = nout;
            arr(ii).mval = mval;
            hsumm = hsumm + nout;
            pause (1.5);
end
A.arr=arr;
A.hsumm=hsumm;
ffobj =  close(aviobj);

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
