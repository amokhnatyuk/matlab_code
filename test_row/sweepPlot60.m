function sweepPlot60(ar1, figN, dirSave, prefix)
% sval = 'pga'; % sval = 'adc'; would plot appropriate sweep
%bias=5
%dirSave = 'c:/data/lot1_/';
sTitle1 = '';
dirSavePlots =  [dirSave, prefix, '\'];
if ~exist(dirSavePlots, 'dir') mkdir(dirSavePlots); end
iadcMax = length(ar1(1).d(1,:,1));
ar1sz = length(ar1);
x1(1:ar1sz)=0;
y2(1:ar1sz)=0; y3(1:ar1sz)=0; y4(1:ar1sz)=0; y6(1:ar1sz)=0;
iOddCol=2;
    for iadc = 1:iadcMax
            for ii=1:length(ar1)
                nadc = ar1(ii).adcList(iadc);
                x1(ii) = ar1(ii).v_dac;
                y2(ii) = ar1(ii).d(2,iadc,iOddCol);
                y3(ii) = ar1(ii).d(3,iadc,iOddCol);
                y4(ii) = ar1(ii).d(4,iadc,iOddCol);
%                y5(ii) = ar1(ii).v_measur;
                col_sz = length(ar1(1,ii).h1(iadc,iOddCol).fpn_avg);
                y6(ii,1:col_sz) = ar1(1,ii).h1(iadc,iOddCol).fpn_avg;
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
            subplot(2,2,1)
                plot(x1,y2,'b','DisplayName', 'mean, lsb'); hold on; grid on; 
                y_ = calcAssimptote(x1,y2);
                plot(x1,y_,'-r','DisplayName', 'assymptote');
                ylim([0, 16384]);
                legend('show','Location','East');
                title(sprintf([sTitle1, ' TestRow input sweep']));
                xlabel('DAC Voltage, mV')
                ylabel('ADC code, lsb')
            subplot(2,2,2)
                plot(x1,y2-y_,'r','DisplayName', 'deviation from linear, lsb'); hold on; grid on; 
                ylim([-64, 100]);
                legend('show','Location','SouthEast');
                title('CB+LD+PGA+ADC nonlinearity, lsb')
                xlabel('DAC Voltage, mV')
                ylabel('ADC code, lsb')
            subplot(2,2,3)
                plot(x1,y3,'g','DisplayName', 'TN,lsb'); hold on; grid on; 
                ylim([0, 25]);
                legend('show');
                title('Temporal Noise')
                xlabel('DAC Voltage, mV')
                ylabel('ADC code, lsb')
                
            subplot(2,2,4)
                plot(1:length(y6(ii,:)),y6(ii,:),'g','DisplayName', 'Col.Aver.deviation, lsb'); hold on; grid on; 
%                ylim([0, 50]);
                legend('show');
                title('Column Average Deviation')
                xlabel('Column number')
                ylabel('ColAvg deviation, lsb')
                
            saveas(figN,[dirSavePlots, sTitle1, '.jpg'])
    end
end
%%
function y1 = calcAssimptote(x,y)
% x,y must be vectors same dimension
% assimptote relies on decreasing portion of cuve approximation
sz = length(y);
sz2=floor(sz/2);
[ymin, imin] = min(y(1:sz2));
[ymax, imax] = max(y(sz2:end));
imin = imin +sz2-1; % corecion for counting from middle of array
%imin = imax+16;ymin=y(imin);
range = [];
if ((imax<imin) && (imin-imax>2)) range = imax+1:imin-3;
else range = imin+5:imax-1;
end
p=polyfit(x(range),y(range),1);
y1=p(1)*x+p(2);
end