
dirSave = 'C:\data\lot1_\all_adc\';
biasTable=[1,2,3,4,5,6,7,8,9,10,12,14];
iadc=7;
iOddCol = 2;
C = {':y',':r',':g',':b','-m','-k','-r','-g','-m','-b','-c','--r','--c','--m','--b','--y'}; % Cell array of colros    

figNum = 102;
figure(figNum); clf

% sweep adc reference
for ibias=1:length(biasTable)-3 
    adcbias = biasTable(ibias);
    sbias = num2str(adcbias);
    sname = ['ADCbias=',sbias,' alladc_bias',sbias,'.mat'];
    load([dirSave,sname]);
    figure(figNum); 
    subplot(2,1,1)
    x1=swp1.d(:,1,iadc,iOddCol);
    plot(x1,swp1.d(:,2,iadc,iOddCol),C{adcbias+1},'DisplayName',['adc\_bias',num2str(adcbias)]); hold on; grid on; 
    subplot(2,1,2)
    plot(x1,swp1.d(:,3,iadc,iOddCol),C{adcbias+1},'DisplayName',['adc\_bias',num2str(adcbias)]); hold on; grid on;    
end

figure(figNum);
sTitleSave = ['ADC#',num2str(iadc), ' adc bias variation'];
sTitle1 = ['ADC#',num2str(iadc), ' corrected code mean'];
sTitle2 = ['ADC#',num2str(iadc), ' corrected code std'];

        subplot(2,1,1)
        title(sTitle1);
        legend('show');
        xlabel('PGA input voltage, mV')
        ylabel('Corrected ADC code mean, lsb')
        subplot(2,1,2)
        ylim([0,200]);
        legend('show');
        title(sTitle2);
        xlabel('PGA input voltage, mV')
        ylabel('ADC code std, lsb')


saveas(gcf,[dirSave, sTitleSave, '.jpg'])

