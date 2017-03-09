function out = vsweep1(start1, end1, step1, adcNum, s2)
% start1 = '7000', end1='f000'; % - hex dac code start and end of sweep
% step = 256; decimal value of step 
% adcNum = 5;

    startDec = hex2dec(start1);
    endDec = hex2dec(end1);
    cTmp = startDec;
    swap_len = ceil(double(endDec - startDec)/step1); % number of sweep steps
%    v(1:swap_len)=0; 
%    h1(1:swap_len)=0; h1_cor(1:swap_len)=0; h2(1:swap_len)=0; h2_cor(1:swap_len)=0;
    d(1:swap_len,1:9)=0; 
    nFrm = 0;
    %
  for ii=1: swap_len
    d(ii,1) = evksetDac (dec2hex(cTmp), s2);
    igrab4(1); pause (1.5);% skip image
    a1 = igrab4(1);  % grab
            if (adcNum < 10)
                out = a1(98+1+640*adcNum:2:98-1+640*(adcNum+1),1:2:500)';  % odd columns
            else if (adcNum >= 10) && (adcNum < 20)
                anum=adcNum-10;
                out = a1(98+2+640*anum:2:98-1+640*(anum+1),1:2:500)';  % even columns
                end
            end
            figure(22); colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);
            
            subplot(6,1,[1:4])
            imshow(out,[0 16384],'InitialMagnification',200);
            title(['Odd rows Image #',num2str(nFrm)]);
            subplot(6,1,5); h1_cor(ii) = ihistCor(out);
%            title(['Corrected histogram Image #',num2str(nFrm)]);
            title(['Corrected histogram Image #',num2str(nFrm), '; "goood pixels"=', num2str(h1_cor(ii).pctPixCorr,'%5.1f'),'%' ]);
            d(ii,2) = h1_cor(ii).meanVal;
            d(ii,3) = h1_cor(ii).stdVal;

            subplot(6,1,6); h1(ii) = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            d(ii,4) = h1(ii).meanVal;
            d(ii,5) = h1(ii).stdVal;

            figure(24); colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);

            if (adcNum < 10)
                b1 = a1(96+1+640*adcNum:2:96+640*(adcNum+1),2:2:500)';  % odd columns
            else if (adcNum >= 10) && (adcNum < 20)
                anum=adcNum-10;
                b1 = a1(96+2+640*anum:2:96+640*(anum+1),2:2:500)';  % even columns
                end
            end
            subplot(6,1,[1:4])
            imshow(b1,[0 16384],'InitialMagnification',200);
            title(['Even Rows Image #',num2str(nFrm)]);
            subplot(6,1,5); h2_cor(ii) = ihistCor(b1);
            
            d(ii,6) = h2_cor(ii).meanVal;
            d(ii,7) = h2_cor(ii).stdVal;
            title(['Corrected histogram Image #',num2str(nFrm), '; "goood pixels"=', num2str(h2_cor(ii).pctPixCorr,'%5.1f'),'%' ]);
            
            subplot(6,1,6); h2(ii) = ihist(b1);
            d(ii,8) = h2(ii).meanVal;
            d(ii,9) = h2(ii).stdVal;

            title(['Histogram Image #',num2str(nFrm)]);
    
    pause (1.5);
    cTmp = cTmp + step1;
  end
  out.d = d;
  out.h1 = h1; out.h1 = h1_cor; out.h1 = h2; out.h1 = h2_cor;
end

