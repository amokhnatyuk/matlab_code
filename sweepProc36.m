
dirSave = 'C:\data\lot1_\all_adc\ref_swp\';
C = {':y',':r',':g',':b','-m','-k','-r','-g','-m','-b','-c','--r','--c','--m','--b','--y'}; % Cell array of colros    

%sname='adc#6 adcbias=10.mat';
%adc=[6,10]; % adc#, adc_bias
sname='adc#8 adcbias=6.mat';
adc=[8,6]; % adc#, adc_bias
figNum = 103;
figure(figNum); clf

% sweep adc reference
for iRef=1:4
%    sbias = num2str(iRef-1);
%    sname = ['ADCref=',sbias,' alladc_bias',sbias,'.mat'];
    load([dirSave,sname]);
    iadc=adc(1,1);
    adcbias = adc(1,2);
    figure(figNum); 
    subplot(2,1,1)
    x1=swp3.dadc(:,1,iRef);
    plot(x1,swp3.dadc(:,2,iRef),C{iRef+4},'DisplayName',['adc\_ref',num2str(iRef)]); hold on; grid on; 
    subplot(2,1,2)
    plot(x1,swp3.dadc(:,3,iRef),C{iRef+4},'DisplayName',['adc\_ref',num2str(iRef)]); hold on; grid on;    
end

figure(figNum);
sTitleSave = ['ADC#',num2str(iadc),' bias=',num2str(adcbias), ' reference variation'];
sTitle1 = ['ADC#',num2str(iadc), ' corr.code mean'];
sTitle2 = ['ADC#',num2str(iadc), ' corr.code std'];

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

