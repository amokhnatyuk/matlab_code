  
function sweepPlot41(swp1, bias, adcdly,pgadly, figN, dirSave)
%bias=5
%dirSave = 'c:/data/lot1_/';
sz=size(swp1.d);
sTitle1 = '';
dirSavePlots =  [dirSave];
sdly = [' adc-dly=', num2str(adcdly),' pga-dly=', num2str(pgadly)];
for iadc = 1:sz(3)
    for iOddCol=1:2
        x1=swp1.d(:,1,iadc,iOddCol);
            if (iadc < 10) 
                if (iOddCol == 1)
                    sTitle1 = ['ADC#',num2str(iadc), ' bias=', num2str(bias), ' oddC evenR', sdly];
                else
                    sTitle1 = ['ADC#',num2str(iadc), ' bias=', num2str(bias), ' evenC oddR', sdly];
                end
            elseif ((iadc >= 10) && (iadc < 20))
                if (iOddCol == 1)
                    sTitle1 = ['ADC#',num2str(iadc), ' bias=', num2str(bias), ' oddC oddR', sdly];
                else
                    sTitle1 = ['ADC#',num2str(iadc), ' bias=', num2str(bias), ' evenC evenR', sdly];
                end
            end
        figure(figN); clf
        subplot(2,1,1)
            plot(x1,swp1.d(:,2,iadc,iOddCol),'b','DisplayName', 'mean corrected, lsb'); hold on; grid on; 
            ylim([0, 16384]);
            legend('show');
            title(sTitle1);
            xlabel('PGA input voltage, mV')
            ylabel('ADC code, lsb')
        subplot(2,1,2)
            plot(x1,swp1.d(:,3,iadc,iOddCol),'g','DisplayName', 'TN corrected,lsb'); hold on; grid on; 
            plot(x1,swp1.d(:,4,iadc,iOddCol),'m','DisplayName', 'good pixels, %');
            ylim([0, 100]);
            legend('show');
            xlabel('PGA input voltage, mV')
            ylabel('code, lsb; good pixels, %')
            saveas(figN,[dirSavePlots, sTitle1, '.jpg'])            
    end
end
end