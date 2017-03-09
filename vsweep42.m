function out = vsweep42(dacCode, s2, adcList)
%  dacCode = '6000', % - hex dac code start and end of sweep
%dirSave = 'C:\data\lot1_\all_adc\';

adc_seq = uint16(1:length(adcList));
x11 = evksetDac (dacCode, s2); pause(.5); 
% igrab4(1);pause(1.5);   % take frame to dump it
    
    h1(adc_seq,1:2) = struct;
    h2(adc_seq,1:2) = struct;
    d(1:4,adc_seq,1:2)=0; 
    %
    a8 = igrab4(2);  % grab
    sz=size(a8);  %% 6400x4232x8
    oddColumn = 1; % this determines if we selecting odd or even columns (oddCol = 1; means odd column; oddCol = 2; means even column;)
    
    for iadcList = adc_seq   % adc index in array adcList
        adcNum = adcList(iadcList);
        if (adcNum < 10)
            iend = 98-1+640*(adcNum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a8(98+2+640*adcNum:2:iend,101:2:4100,:);
            oddColumn = 2;
            sTitle11 = ['ADC#',num2str(adcNum), ' V=',num2str(x11,'%5.1f'),'mV', ' evenC oddR'];
        else if (adcNum >= 10) && (adcNum < 20)
            anum=adcNum-10;
            iend = 98-1+640*(anum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a8(98+2+640*anum:2:iend,102:2:4100,:);
            sTitle11 = ['ADC#',num2str(adcNum), ' V=',num2str(x11,'%5.1f'),'mV', ' evenC evenR'];
            oddColumn = 1;
            end
        end

        aa = ihistFn(b1);
        h1=setfield(h1,{iadcList,oddColumn},'h',aa);
        d(1,iadcList,oddColumn) = x11;
    end
  pause (1.5);
  out.h1 = h1; out.h2 = h2; 
  out.d = d;
  out.adcList = adcList;
end

