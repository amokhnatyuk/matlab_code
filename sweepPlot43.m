  
function sweepPlot43(ar1, figN, dirSave, prefix,sval)
% sval = 'pga'; % sval = 'adc'; would plot appropriate sweep
%bias=5
%dirSave = 'c:/data/lot1_/';
sTitle1 = '';
dirSavePlots =  [dirSave, prefix, ' '];
iadcNumMax = length(ar1(1).d(1,:,1));
ar1sz = length(ar1);
for ii=1:ar1sz adcdly_seq(ii) = ar1(ii).([sval, 'dly']); end
x1=adcdly_seq;
y2(1:ar1sz)=0; y3(1:ar1sz)=0; y4(1:ar1sz)=0;

    for iadc = 1:iadcNumMax
        for iOddCol=1:2
            nadc = iadc-1;
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
            figure(figN); clf
            for ii=1:length(ar1)
                y2(ii) = ar1(ii).d(2,iadc,iOddCol);
                y3(ii) = ar1(ii).d(3,iadc,iOddCol);
                y4(ii) = ar1(ii).d(4,iadc,iOddCol);
            end
            subplot(2,1,1)
                plot(x1,y2,'b','DisplayName', 'mean, lsb'); hold on; grid on; 
%                ylim([0, 16384]);
                legend('show');
                title(sprintf([sTitle1, 'n\', prefix]));
                xlabel('ADC delay setting')
                ylabel('ADC code, lsb')
            subplot(2,1,2)
                plot(x1,y3,'g','DisplayName', 'TN corrected,lsb'); hold on; grid on; 
                plot(x1,y4,'m','DisplayName', 'good pixels, %');
                ylim([0, 100]);
                legend('show');
                xlabel('ADC delay setting')
                ylabel('code, lsb; good pixels, %')
                saveas(figN,[dirSavePlots, [sTitle1, ' ', prefix], '.jpg'])                        
        end
    end
end