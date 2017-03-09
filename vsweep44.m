function out = vsweep44(dacCode, s2, dirSave)
%  dacCode = '6000', % - hex dac code start and end of sweep
%dirSave = 'C:\data\lot1_\all_adc\';

nFrm = 8; % number of grames to grab in sequence
adcList = uint16([0,1,5:9]);
adc_seq = uint16(1:length(adcList));
x11 = evksetDac (dacCode, s2); pause(.5); 
igrab4(1);pause(1.5);   % take frame to dump it
    
    h1(adc_seq,1:2) = struct;
    h2(adc_seq,1:2) = struct;
    d(1:4,adc_seq,1:2)=0; 
    ntry = 1;
    %
%    a8 = igrab4(8);  % grab
    [T, a8] = evalc('igrab4(nFrm)');
    ind=regexp(T,'\d');
    fps = str2double(T(min(ind):max(ind)));  % frame rate when grab frames
    while (fps < 25.5)  % looking for frame rate 25.5 fps or higher
        if (ntry > 4) break; end
        fps = str2double(T(min(ind):max(ind)));  % frame rate when grab frames
        ntry = ntry +1;
    end
    
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

        figure(122); clf
        [aa, out3] = plotFn(b1,sTitle11);
        h1=setfield(h1,{iadcList,oddColumn},'fpn_cavgs',out3.fpn_cavgs);  % column average of FPN Signed
        h1=setfield(h1,{iadcList,oddColumn},'h',aa);  % histogram corrected
        d(1,iadcList,oddColumn) = x11;
        d(2,iadcList,oddColumn) = out3.avg;
        d(3,iadcList,oddColumn) = out3.tn;
        d(4,iadcList,oddColumn) = out3.pctGood;
        
        saveas(figure(122),[dirSave, sTitle11, '.jpg']);
%{
        if (adcNum < 10)
            iend = 96+640*(adcNum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a8(96+1+640*adcNum:2:iend,1002:2:1400,:);  % odd columns, even rows
            sTitle21 = ['ADC#',num2str(adcNum), ' Vpga=',num2str(x11,'%5.1f'),'mV', ' oddC evenR'];
            oddColumn = 1;
        else if (adcNum >= 10) && (adcNum < 20)
            anum=adcNum-10;
            iend = 96+640*(anum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a8(96+1+640*anum:2:iend,1001:2:1400,:);  % odd columns, odd rows
            sTitle21 = ['ADC#',num2str(adcNum), ' Vpga=',num2str(x11,'%5.1f'),'mV', ' oddC oddR'];
            oddColumn = 2;
            end
        end

        figure(123); clf
        [aa, out3] = plotFn(b1,sTitle21);
        h2=setfield(h2,{iadcList,oddColumn},'h',aa);
        d(1,iadcList,oddColumn) = x11;
        d(2,iadcList,oddColumn) = out3.avg;
        d(3,iadcList,oddColumn) = out3.tn;
        d(4,iadcList,oddColumn) = out3.pctGood;

%        saveas(figure(123),[dirSave, sTitle21, '.jpg']);
%}        
    end
  pause (1.5);
  out.h1 = h1; out.h2 = h2; 
  out.d = d;
  out.adcList = adcList;
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
%            subplot('Position',[0.53 0.53 0.45 0.4]);
            hist = ihistCor(c1);
            sTitle12 = ['Histogram "good pixels"=', num2str(out3.pctGood,'%5.1f'),'%' ];
            title(sTitle12);
            subplot(2,2,3)
            subplot('Position',[0.03 0.02 0.45 0.45]);
            imshow(out3.ar_tn',[0 50],'InitialMagnification',200);
            title('Temp Noise'); colorbar
            subplot(2,2,4)
            plot(out3.fpn_cavgs); grid on
%            subplot('Position',[0.52 0.02 0.45 0.45]);
%            imshow(out3.ar_fpn',[0 256],'InitialMagnification',200); colorbar
            title('Column Average Fixed Pattern Offset Deviation'); 
end


