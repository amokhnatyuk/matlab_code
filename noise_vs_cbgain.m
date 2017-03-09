% noise_vs_cbgain procedure
dirSave = 'C:\data\lot1_\cb_test\g2\';
if ~exist(dirSave, 'dir') mkdir(dirSave); end
copyfile('noise_vs_cbgain.m',dirSave);  % copy this file to dst folder

% set CB gain
t1 = gain_table( );
%gain_ind=[1,2,4,5,9,14,19,24,31,36,43,48,52,56,60,64];
gain_ind=[24,31,36,43,48,52,56,60,64];
gain_sz=length(gain_ind);
gain=[]; %gain(1:gain_sz)=0;
tn_adc=[]; %tn_adc(1:gain_sz,:)=0;
tn_av=[]; %tn_av(1:gain_sz,:)=0;
code_slope=[]; %code_slope(1:gain_sz,:)=0;

for kk=1:length(gain_ind)
    % sweep register x003c; x003d
    jj=gain_ind(kk);
    gain(kk)= t1{jj,1};
    prefix = ['gain=',num2str(gain(kk),'%5.2f')];
    load ([dirSave, prefix, '.mat']);  % loading out1 struct
    [tn_av(kk,:), code_slope(kk,:)] = averTNcalc1(out1);
    tn_adc(kk,:)=out1(1,1).adcList;
end
    figNum = 190;
    asz = size(tn_adc);
for jj=1:asz(2)
    hfig=figure(figNum); clf
    sAdc = num2str(tn_adc(1,jj));
    subplot(2,1,1);
  %  plot (tn_av(:,jj),gain);
    tn= tn_av; g=gain;   
    tn(4,:)=[]; g(4)=[];% 4th row is bad row
    tn(8,:)=[]; g(8)=[];% 4th row is bad row
    plot (g,tn(:,jj)./g','-g*');
    grid on
    xlim([0 13]); ylim([0 10])
    set(gca,'XTick',[0:2.5:13]);
    set(gca,'YTick',[0:2:10]);
    xlabel('CB gain as designed'); ylabel('Temporal Noise, lsb'); 
    title (['ADC#',sAdc,' Temporal Noise (CB input referred) vs gain'],'fontweight','bold','fontsize',11);
    subplot(2,1,2);
    plot (gain,code_slope(:,jj)/code_slope(1,jj)*gain(1),'-bx');
    grid on
    xlim([0 13]); ylim([0 13])
    set(gca,'XTick',[0:2.5:13]);
    set(gca,'YTick',[0:2.5:13]);
    xlabel('CB gain as designed'); 
    ylabel('CB gain measured'); 
    title ('Gain measured vs designed','fontweight','bold','fontsize',11);
    prefix=['ADC#',num2str(tn_adc(1,jj)),'_noise_vs_gain'];
    saveas (hfig,[dirSave, prefix, '.png']);
end
