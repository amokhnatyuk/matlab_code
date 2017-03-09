function out = vsweep3(start1, end1, step1, s2, dirSave,iadc)
% start1 = '7000', end1='f000'; % - hex dac code start and end of sweep
% step = 256; decimal value of step 
%dirSave = 'C:\data\lot1_\all_adc\';
% iadc=7;
% C = {':y',':r',':g',':b','-m','-k','-r','-g','-m','-b','-c','--r','--c','--m','--b','--y'}; % Cell array of colros
%refB = {'2','6','A','E'};
refB = {'A'};
refsz = length(refB);

    startDec = hex2dec(start1);
    endDec = hex2dec(end1);
    cTmp = startDec;
    swap_len = ceil(double(endDec - startDec)/step1); % number of sweep steps
%    v(1:swap_len)=0; 
%    h1(1:swap_len)=0; h1_cor(1:swap_len)=0; h2(1:swap_len)=0; h2_cor(1:swap_len)=0;
    d(1:swap_len,1:9,1:refsz)=0; 
    nFrm = 0;
    
    %
  for ii=1: swap_len
    x11 = evksetDac (dec2hex(cTmp), s2); 
    
    for adcRef = 1:refsz   % sweep ADC reference
      rb =   refB{adcRef};
      writeSensorReg( ['009400',rb,'A'], s2); pause(0.1);   % sweep ADC reference, ANALOG_CONTROL4 x00AA
        igrab4(1); pause (1.5);% skip image
        a1 = igrab4(1);  % grab
        sz=size(a1);

        iend = 98-1+640*(iadc);
        if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
        c1 = a1(98+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
        sTitle11 = ['ADC#',num2str(iadc), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' even-cols odd-rows adcRef#',num2str(adcRef)];

        d(ii,1,adcRef) = x11;
            
        figure(132); clf
        colormap('gray'); 
        gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);

        subplot(6,1,[1:4])
        imshow(c1,[0 16384],'InitialMagnification',200);
        title(sTitle11);
        subplot(6,1,5); h1_cor(ii,adcRef) = ihistCor(c1);
        sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor(ii,adcRef).pctPixCorr,'%5.1f'),'%' ];
        title(sTitle12);
        d(ii,2,adcRef) = h1_cor(ii,adcRef).meanVal;
        d(ii,3,adcRef) = h1_cor(ii,adcRef).stdVal;

        subplot(6,1,6); h1(ii,adcRef) = ihist(c1);
        title(['Histogram Image #',num2str(nFrm)]);
        d(ii,4,adcRef) = h1(ii,adcRef).meanVal;
        d(ii,5,adcRef) = h1(ii,adcRef).stdVal;

        if (ii==floor(swap_len/2))  % save image with hist for reference
            saveas(figure(132),[dirSave, sTitle11, '.jpg']);
        end
    end
    pause (1.5);
    cTmp = cTmp + step1;
    nFrm = nFrm +1;
  end
  out.h1adc = h1; out.h1adc_cor = h1_cor; 
  out.dadc = d;
end

