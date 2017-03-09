  
function sweepPlot48(ar1, figN, dirSave, prefix)
%dirSave = 'c:/data/lot1_/';
sTitle1 = '';
dirSavePlots =  [dirSave, prefix, ' '];
iadcMax = length(ar1(1).d(1,:,1));
ar1sz = length(ar1);
x1(1:ar1sz)=0;
y2(1:ar1sz)=0; y3(1:ar1sz)=0; y4(1:ar1sz)=0;
iOddCol=2;

    for iadc = 1:iadcMax
            for ii=1:length(ar1)
                nadc = ar1(ii).adcList(iadc);
                x1(ii) = ar1(ii).v_dac;
                y2(ii) = ar1(ii).d(2,iadc,iOddCol);
                y3(ii) = ar1(ii).d(3,iadc,iOddCol);
                y4(ii) = ar1(ii).d(4,iadc,iOddCol);
                y5(ii) = ar1(ii).v_measur;
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
%                ylim([0, 16384]);
                legend('show');
                title([sTitle1, ' ', prefix]);
                xlabel('DAC Volage, mV')
                ylabel('ADC code, lsb')
            subplot(3,1,2)
                plot(x1,y3,'g','DisplayName', 'TN corrected,lsb'); hold on; grid on; 
                plot(x1,y4,'m','DisplayName', 'good pixels, %');
                ylim([0, 100]);
                legend('show');
                xlabel('DAC Volage, mV')
                ylabel('code, lsb; good pixels, %')
            subplot(3,1,3)
                plot(x1,x1-y5*1000,'g','DisplayName', 'Deviation of Applied and Measured Voltage'); hold on; grid on; 
                legend('show');
                xlabel('DAC Volage, mV')
                ylabel('Deviation, mV')

            saveas(figN,[dirSavePlots, sTitle1, '.jpg'])          
    end
end