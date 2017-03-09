  
function sweepPlot45(ar1, figN, dirSave, prefix)
% sval = 'pga'; % sval = 'adc'; would plot appropriate sweep
%bias=5
%dirSave = 'c:/data/lot1_/';
sTitle1 = '';
dirSavePlots =  [dirSave, prefix, ' '];
iadcMax = length(ar1(1).d(1,:,1));
ar1sz = length(ar1);
x1(1:ar1sz)=0;
y2(1:ar1sz)=0; y3(1:ar1sz)=0; y4(1:ar1sz)=0;

    for iadc = 1:iadcMax
        for iOddCol=1:2
            for ii=1:length(ar1)
                nadc = ar1(ii).adcList(iadc);
                x1(ii) = ar1(ii).vpga;
                y2(ii) = ar1(ii).d(2,iadc,iOddCol);
                y3(ii) = ar1(ii).d(3,iadc,iOddCol);
                y4(ii) = ar1(ii).d(4,iadc,iOddCol);
                if (nadc < 10) 
                    if (iOddCol == 1)
                        sTitle1 = ['ADC#',num2str(nadc), ' oddC evenR'];
                    else
                        sTitle1 = ['ADC#',num2str(nadc), ' evenC oddR'];
                    end
                elseif ((nadc >= 10) && (nadc < 20))
                    if (iOddCol == 1)
                        sTitle1 = ['ADC#',num2str(nadc), ' oddC oddR'];
                    else
                        sTitle1 = ['ADC#',num2str(nadc), ' evenC evenR'];
                    end
                end
            end
            figure(figN); clf
            subplot(3,1,1)
                plot(x1,y2,'b','DisplayName', 'mean, lsb'); hold on; grid on; 
                y_ = calcAssimptote(x1,y2);
                plot(x1,y_,'-r','DisplayName', 'mean assymptote');
                xlim([600, 2800]); ylim([0, 16384]);
                legend('show');
                title(sprintf([sTitle1, ' ', prefix]));
                xlabel('PGA input Voltage, mV')
                ylabel('ADC code, lsb')
            subplot(3,1,2)
                plot(x1,y2-y_,'r','DisplayName', 'deviation from linear, lsb'); hold on; grid on; 
                xlim([600, 2800]); ylim([-64, 64]);
                legend('show');
                title('ADC nonlinearity, lsb')
                xlabel('PGA input Voltage, mV')
                ylabel('ADC code, lsb')
            subplot(3,1,3)
                plot(x1,y3,'g','DisplayName', 'TN corrected,lsb'); hold on; grid on; 
                plot(x1,y4,'m','DisplayName', 'good pixels, %');
                xlim([600, 2800]); ylim([0, 100]);
                legend('show');
                xlabel('PGA input Voltage, mV')
                ylabel('code, lsb; good pixels, %')
                saveas(figN,[dirSavePlots, [sTitle1, ' ', prefix], '.jpg'])                        
        end
    end
end

function y1 = calcAssimptote(x,y)
% x,y must be vectors same dimension
% assimptote relies on decreasing portion of cuve approximation
sz = length(y);
sz2=floor(sz/2);
[ymax, imax] = max(y(1:sz2));
[ymin, imin] = min(y(sz2:end));
imin = imin +sz2-1; % corecion for counting from middle of array
range = [];
if ((imax<imin) && (imin-imax>2)) range = imax+1:imin-1;
else
    y1=y; 
    return;
end
p=polyfit(x(range),y(range),1);
y1=p(1)*x+p(2);
end