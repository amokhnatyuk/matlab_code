function out = vsweep4(dacCode, s2, dirSave)
%  dacCode = '6000', % - hex dac code start and end of sweep
%dirSave = 'C:\data\lot1_\all_adc\';

adcNumMax = 9;  % only one hemisphere
adc_selection = uint16([0,1,3,5:9]);
adc_seq = uint16(1:adcNumMax+1);
x11 = evksetDac (dacCode, s2); pause(.5); 
igrab4(1);pause(1.5);   % take frame to dump it
    
    h1(adc_seq,1:2) = struct;
    h2(adc_seq,1:2) = struct;
    d(1:4,adc_seq,1:2)=0; 
    %
    a8 = igrab4(8);  % grab
    sz=size(a8);  %% 6400x4232x8
    oddColumn = 1; % this determines if we selecting odd or even columns (oddCol = 1; means odd column; oddCol = 2; means even column;)
    
%    for adcNum =0: adcNumMax
    for adcNum = adc_selection
        iadc = adcNum+1;  % index in matlab arrays started with 1
        if (adcNum < 10)
            iend = 98-1+640*(iadc);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            b1 = a8(98+2+640*adcNum:2:iend,1001:2:1400,:);
            oddColumn = 2;
            sTitle11 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' evenC oddR'];
        else if (adcNum >= 10) && (adcNum < 20)
            anum=adcNum-10;
            iend = 98-1+640*(anum+1);
            if (98-1+640*(anum+1) > sz(1)) iend = sz(1); end
            b1 = a8(98+2+640*anum:2:iend,1002:2:1400,:);
            sTitle11 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' evenC evenR'];
            oddColumn = 1;
            end
        end

        figure(122); clf
        [aa, out3] = plotFn(b1,sTitle11);
        h1=setfield(h1,{iadc,oddColumn},'h',aa);
        d(1,iadc,oddColumn) = x11;
        d(2,iadc,oddColumn) = out3.avg;
        d(3,iadc,oddColumn) = out3.tn;
        d(4,iadc,oddColumn) = out3.pctGood;

        if (adcNum < 10)
            iend = 96+640*(iadc);
            if (96+640*(iadc) > sz(1)) iend = sz(1); end
            b1 = a8(96+1+640*adcNum:2:iend,1002:2:1400,:);  % odd columns, even rows
            sTitle21 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' oddC evenR'];
            oddColumn = 1;
        else if (adcNum >= 10) && (adcNum < 20)
            anum=adcNum-10;
            iend = 96+640*(anum+1);
            if (96+640*(anum+1) > sz(1)) iend = sz(1); end
            b1 = a8(96+1+640*anum:2:iend,1001:2:1400,:);  % odd columns, odd rows
            sTitle21 = ['ADC#',num2str(adcNum), ', Vpga=',num2str(x11,'%5.1f'),'mV', ' oddC oddR'];
            oddColumn = 2;
            end
        end

        figure(123); clf
        [aa, out3] = plotFn(b1,sTitle21);
        h2=setfield(h2,{iadc,oddColumn},'h',aa);
        d(1,iadc,oddColumn) = x11;
        d(2,iadc,oddColumn) = out3.avg;
        d(3,iadc,oddColumn) = out3.tn;
        d(4,iadc,oddColumn) = out3.pctGood;

        saveas(figure(122),[dirSave, sTitle11, '.jpg']);
        saveas(figure(123),[dirSave, sTitle21, '.jpg']);
    end
  pause (1.5);
  out.h1 = h1; out.h2 = h2; 
  out.d = d;
end

function [hist, out3] = plotFn(c1,sTitle11)
            colormap('gray'); 
%            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);
            out3 = stdcor2(c1);
            c1 = out3.ar_avg;
            
            subplot(2,2,1)
            subplot('Position',[0.03 0.53 0.45 0.4]);
            imshow(c1',[0 16384],'InitialMagnification',200);
            title(sTitle11);  colorbar
            subplot(2,2,2); 
            subplot('Position',[0.53 0.53 0.45 0.4]);
            hist = ihistSeq(c1);
            sTitle12 = ['Histogram "good pixels"=', num2str(out3.pctGood,'%5.1f'),'%' ];
            title(sTitle12);
            subplot(2,2,3)
            subplot('Position',[0.03 0.02 0.45 0.45]);
            imshow(out3.ar_tn',[0 50],'InitialMagnification',200);
            title('Temp Noise'); colorbar
            subplot(2,2,4)
            subplot('Position',[0.52 0.02 0.45 0.45]);
            imshow(out3.ar_fpn',[0 256],'InitialMagnification',200);
            title('Fix Pattern Offset'); colorbar
end


