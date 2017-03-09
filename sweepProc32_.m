
dirSave = 'C:\data\lot1_\all_adc\';
biasTable=[1,2,3,4,5,6,7,8,9,10,12,14];
%iadc=8;
%ibias = 6;
adc=[6,10;7,4;8,6;7,10;8,10]; % adc#, adc_bias
adcsz = size(adc);

iOddCol = 2;
C = {':y',':r',':g',':b','-m','-k','-r','-g','-m','-b','-c','--r','--c','--m','--b','--y'}; % Cell array of colros    

% sweep adc#
figNum = 98;
for ii= 1: adcsz(1) 
    figNum = figNum + ii;
    figure(figNum); clf
    iadc=adc(ii,1);
    adcbias = adc(ii,2);
    sbias = num2str(adcbias);
    sname = ['ADCbias=',sbias,' alladc_bias',sbias,'.mat'];
    sTitleSave = ['ADC#',num2str(iadc), ' adc bias=',num2str(adcbias)];
    sTitle1 = ['ADC#',num2str(iadc), ' corrected code mean'];
    sTitle2 = ['ADC#',num2str(iadc), ' corrected code std'];
    
    load([dirSave,sname]);
    figure(figNum); subplot(2,1,1)
    x1=swp1.d(:,1,iadc,iOddCol);
    plot(x1,swp1.d(:,2,iadc,iOddCol),C{adcbias+1},'DisplayName',['adc\_bias',num2str(adcbias)]); hold on; grid on; 
    bb1 = polyfit(x1(33:93),swp1.d(33:93,2,iadc,iOddCol),1);
    yfit =  bb1(1) * x1 + bb1(2);
    plot(x1,yfit,C{2},'DisplayName',['polyfit slope=',num2str(1/double(bb1(1)),3),'mV/lsb']);
    subplot(2,1,2)
    plot(x1,swp1.d(:,3,iadc,iOddCol),C{adcbias+1},'DisplayName',['adc\_bias',num2str(adcbias)]); hold on; grid on;    

    figure(figNum); subplot(2,1,1)
    title(sTitle1);
    legend('show');
    xlabel('PGA input voltage, mV')
    ylabel('Corrected ADC code mean, lsb')
    subplot(2,1,2)
    ylim([0,50]);
    legend('show');
    title(sTitle2);
    xlabel('PGA input voltage, mV')
    ylabel('ADC code std, lsb')

dirSavePlots =  [dirSave, 'plots\'];
saveas(gcf,[dirSavePlots, sTitleSave, '.jpg'])
end

