function out = vsweep45(dacCode, s2, dirSave)
%  dacCode = '6000', % - hex dac code start and end of sweep
%dirSave = 'C:\data\raijin_lot3\tr\;

nFrm = 8; % number of grames to grab in sequence
adcList = 0:9;
adc_seq = 1:length(adcList);
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
    while (fps < 14)  % looking for frame rate 14 fps or higher
        if (ntry > 4) break; end
        fps = str2double(T(min(ind):max(ind)));  % frame rate when grab frames
        ntry = ntry +1;
    end
    
    sz=size(a8);  %% 6400x4232x8
    
    for iadcList = adc_seq   % adc index in array adcList
        adcNum = adcList(iadcList);
        if (adcNum < 10)
            iend = 98-1+640*(adcNum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a8(98+2+640*adcNum:2:iend,1,:);
            oddColumn = 2;
            sTitle11 = ['ADC#',num2str(adcNum), ' V=',num2str(x11,'%5.1f'),'mV', ' evenC oddR'];
        else if (adcNum >= 10) && (adcNum < 20)
            anum=adcNum-10;
            iend = 98-1+640*(anum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a8(98+2+640*anum:2:iend,1,:);
            sTitle11 = ['ADC#',num2str(adcNum), ' V=',num2str(x11,'%5.1f'),'mV', ' evenC evenR'];
            oddColumn = 1;
            end
        end
        
        figure(122); clf
        [aa, out3] = plotFn(b1,sTitle11);
        h1=setfield(h1,{iadcList,oddColumn},'fpn_avg',out3.ar_avg);  % column average of FPN Signed
        h2=setfield(h1,{iadcList,oddColumn},'h',aa);  % histogram 
        d(1,iadcList,oddColumn) = x11;
        d(2,iadcList,oddColumn) = out3.avg;
        d(3,iadcList,oddColumn) = out3.tn;
        
        saveas(figure(122),[dirSave, sTitle11, '.jpg']);
    end
  pause (1.5);
  out.h1 = h1; % column average of FPN Signed
  out.h2 = h2; % histogram
  out.d = d;
  out.adcList = adcList;
end

function [hist, out3] = plotFn(c1,sTitle11)
            a1=squeeze(c1);

            subplot(2,2,1)
            colormap('gray'); 
            hist = ihist(a1);
            out3.ar_avg = mean(a1,2)'; % array of temporal averages
            out3.ar_tn = std(a1,0,2)'; % array of temporal noise
            out3.avg = mean(out3.ar_avg);
            out3.tn = sqrt(mean((out3.ar_tn).^2));
            subplot(2,2,2)
            imshow(a1',[0 16384],'InitialMagnification',100);
            title(sTitle11);  
            subplot(2,2,3)
            imshow(out3.ar_tn,[0 50],'InitialMagnification',100);
            title('Temp Noise'); 
            subplot(2,2,4)
            plot(out3.ar_avg); grid on
%            imshow(out3.ar_fpn,[0 256],'InitialMagnification',100); colorbar
            title('Fixed Pattern Noise'); 
end


