  
function sweepPlot3(swp3, iadc,iadcbias, figN, dirSave)
%bias=5
%dirSave = 'c:/data/lot1_/';
%sz=size(swp3.dadc);
   for iref=1:4
        figure(figN); clf
        x1=swp3.dadc(:,1,iref);
                
        sTitle1 = ['ADC#',num2str(iadc),' adcbias=',num2str(iadcbias),' adcref=',num2str(iref-1), ' even-cols odd-rows'];
        plot(x1,swp3.dadc(:,2,iref),'b','DisplayName', 'code mean corrected'); hold on; grid on; 
        plot(x1,swp3.dadc(:,3,iref),'g','DisplayName', 'code std corrected');
        plot(x1,swp3.dadc(:,4,iref),'m','DisplayName', 'code mean');
        plot(x1,swp3.dadc(:,5,iref),'y','DisplayName', 'code std');

        legend('show');
        title(sTitle1);
        xlabel('PGA input voltage, mV')
        ylabel('ADC code')
        saveas(gcf,[dirSave, sTitle1, '.jpg'])       
    end
end

