  
function sweepPlot2(swp1, bias, figN, dirSave)
%bias=5
%dirSave = 'c:/data/lot1_/';
sz=size(swp1.d);
sTitle1 = '';
for iadc = 1:sz(3)
    for iOddCol=1:2
        figure(figN); clf
        x1=swp1.d(:,1,iadc,iOddCol);
            if (iadc < 10) 
                
                if (iOddCol == 1)
                    sTitle1 = ['ADC#',num2str(iadc), ' odd-cols odd-rows, adc-bias=', num2str(bias)];
                else
                    sTitle1 = ['ADC#',num2str(iadc), ' even-cols even-rows, adc-bias=', num2str(bias)];
                end
                plot(x1,swp1.d(:,2,iadc,iOddCol),'b'); hold on; grid on; 
                plot(x1,swp1.d(:,3,iadc,iOddCol),'g');
                plot(x1,swp1.d(:,4,iadc,iOddCol),'m');
                plot(x1,swp1.d(:,5,iadc,iOddCol),'y');

                legend ('Mean Corrected', 'Std Corrected', 'Mean', 'Std')';
                title(sTitle1);
                xlabel('PGA input voltage, mV')
                ylabel('ADC code')
                saveas(gcf,[dirSave, sTitle1, '.jpg'])            
                               
            elseif ((iadc >= 10) && (iadc < 20))
                if (iOddCol == 1)
                    sTitle1 = ['ADC#',num2str(iadc), ' odd-cols even-rows, adc-bias=', num2str(bias)];
                else
                    sTitle1 = ['ADC#',num2str(iadc), ' even-cols odd-rows, adc-bias=', num2str(bias)];
                end
                plot(x1,swp1.d(:,6,iadc,iOddCol),'b'); hold on; grid on; 
                plot(x1,swp1.d(:,7,iadc,iOddCol),'g');
                plot(x1,swp1.d(:,8,iadc,iOddCol),'m');
                plot(x1,swp1.d(:,9,iadc,iOddCol),'y');
                legend ('Mean Corrected', 'Std Corrected', 'Mean', 'Std')';
                title(sTitle1);
                xlabel('PGA input voltage, mV')
                ylabel('ADC code')
                saveas(gcf,[dirSave, sTitle1, '.jpg'])                            
            end
    end
end
end