function out = vsweep2(start1, end1, step1, s2, dirSave)
% start1 = '7000', end1='f000'; % - hex dac code start and end of sweep
% step = 256; decimal value of step 
%dirSave = 'C:\data\lot1_\all_adc\';
adcNumMax = 19;

    startDec = hex2dec(start1);
    endDec = hex2dec(end1);
    cTmp = startDec;
    swap_len = ceil(double(endDec - startDec)/step1); % number of sweep steps
%    v(1:swap_len)=0; 
%    h1(1:swap_len)=0; h1_cor(1:swap_len)=0; h2(1:swap_len)=0; h2_cor(1:swap_len)=0;
    d(1:swap_len,1:9,1:20,1:2)=0; 
    nFrm = 0;
    %
  for ii=1: swap_len
    igrab4(1); pause (1.5);% skip image
    a1 = igrab4(1);  % grab
    sz=size(a1);
    oddColumn = 1; % this determines if we selecting odd or even columns (oddCol = 1; means odd column; oddCol = 2; means even column;)
    
    for adcNum =0: adcNumMax
        iadc = adcNum+1;  % index in matlab arrays started with 1
        x11 = evksetDac (dec2hex(cTmp), s2);
            if (adcNum < 10)
                iend = 98-1+640*(iadc);
                if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
                c1 = a1(98+2+640*adcNum:2:iend,1002:2:1500)';  % even columns, odd rows
                oddColumn = 2;
                sTitle11 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' even-cols even-rows image#',num2str(nFrm)];
            else if (adcNum >= 10) && (adcNum < 20)
                anum=adcNum-10;
                iend = 98-1+640*(anum+1);
                if (98-1+640*(anum+1) > sz(1)) iend = sz(1); end
                c1 = a1(98+2+640*anum:2:iend,1001:2:1500)';  % odd columns, even rows 
                sTitle11 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' even-cols odd-rows image#',num2str(nFrm)];
                oddColumn = 1;
                end
            end
            d(ii,1,iadc,oddColumn) = x11;
            
%            figure(122+adcNum*2); 
            figure(122); clf
            colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);
            
            subplot(6,1,[1:4])
            imshow(c1,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(6,1,5); h1_cor(ii,iadc,oddColumn) = ihistCor(c1);
%            title(['Corrected histogram Image #',num2str(nFrm)]);
            sTitle12 = ['Corrected histogram Image #',num2str(nFrm), ', "good pixels"=', num2str(h1_cor(ii,iadc,oddColumn).pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);
            d(ii,2,iadc,oddColumn) = h1_cor(ii,iadc,oddColumn).meanVal;
            d(ii,3,iadc,oddColumn) = h1_cor(ii,iadc,oddColumn).stdVal;

            subplot(6,1,6); h1(ii,iadc,oddColumn) = ihist(c1);
            title(['Histogram Image #',num2str(nFrm)]);
            d(ii,4,iadc,oddColumn) = h1(ii,iadc,oddColumn).meanVal;
            d(ii,5,iadc,oddColumn) = h1(ii,iadc,oddColumn).stdVal;
            
%            figure(123+adcNum*2); 
            figure(123); clf
            colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);

            if (adcNum < 10)
                iend = 96+640*(iadc);
                if (96+640*(iadc) > sz(1)) iend = sz(1); end
                b1 = a1(96+1+640*adcNum:2:iend,1001:2:1500)';  % odd columns, odd rows
                sTitle21 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' odd-cols odd-rows image#',num2str(nFrm)];
                oddColumn = 1;
            else if (adcNum >= 10) && (adcNum < 20)
                anum=adcNum-10;
                iend = 96+640*(anum+1);
                if (96+640*(anum+1) > sz(1)) iend = sz(1); end
                b1 = a1(96+1+640*anum:2:iend,1002:2:1500)';  % even columns, even rows
                sTitle21 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' odd-cols even-rows image#',num2str(nFrm)];
                oddColumn = 2;
                end
            end
            d(ii,1,iadc,oddColumn) = x11;
            
            subplot(6,1,[1:4])
            imshow(b1,[0 16384],'InitialMagnification',200);
            title(sTitle21);
            subplot(6,1,5); h2_cor(ii,iadc,oddColumn) = ihistCor(b1);
            
            d(ii,6,iadc,oddColumn) = h2_cor(ii,iadc,oddColumn).meanVal;
            d(ii,7,iadc,oddColumn) = h2_cor(ii,iadc,oddColumn).stdVal;
            sTitle22 = ['Corrected histogram Image #',num2str(nFrm), ', "good pixels"=', num2str(h2_cor(ii,iadc,oddColumn).pctPixCorr,'%5.1f'),'%' ];
            title(sTitle22);
            
            subplot(6,1,6); h2(ii,iadc,oddColumn) = ihist(b1);
            d(ii,8,iadc,oddColumn) = h2(ii,iadc,oddColumn).meanVal;
            d(ii,9,iadc,oddColumn) = h2(ii,iadc,oddColumn).stdVal;

            title(['Histogram Image #',num2str(nFrm)]);
            
            
            if (ii==floor(swap_len/2))  % save image with hist for reference
%                saveas(figure(122+adcNum*2),['C:\data\lot1_\all_adc\imgs\', sTitle11, '.jpg']);
%                saveas(figure(123+adcNum*2),['C:\data\lot1_\all_adc\imgs\', sTitle21, '.jpg']);
                saveas(figure(122),[dirSave, sTitle11, '.jpg']);
                saveas(figure(123),[dirSave, sTitle21, '.jpg']);
            end
    end
    pause (1.5);
    cTmp = cTmp + step1;
    nFrm = nFrm +1;
  end
  out.h1 = h1; out.h1_cor = h1_cor; out.h2 = h2; out.h2_cor = h2_cor;
  out.d = d;
end

