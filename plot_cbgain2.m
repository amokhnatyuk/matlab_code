% plot_cbgain2 procedure
dirSave = 'C:\data\lot1_\cb_test\gain_column2\';
copyfile('plot_cbgain2.m',dirSave);  % copy this file to dst folder

% set CB gain
t1 = gain_table( );
h2=waitbar(0,'CB Gain sweep...');
%gain_ind=[1,4,9,14,19,24,31,36,43,48,52,56,60,64];
gain_ind=[1,14,31,48,56,64];
figNum = 210;
figNum2 = 810;
x_g = [];
for kk=1:length(gain_ind)
    dir_gain = [dirSave,num2str(kk),'\'];
    jj=gain_ind(kk);
    g= t1{jj,1};
    prefix = ['gain=',num2str(g,'%5.2f')];
    clear out1;
    load ([dirSave, prefix, '.mat']);  % loading 'out1' struct
    
    rms_var(kk,:) = sweepPlot51(out1, figNum, dirSave, prefix);
    try waitbar(kk/length(gain_ind),h2); catch ME; end
%%
%    figure(figNum2);
    figure(figNum2); clf
    adcList = out1(1).adcList;
    sTitle1 = 'Col.Gain deviation vs gain';
    lspec = {'--r*','-go','-bx','-cs','-md','-kp','-bs','-r*'};
    for iadc=1:length(adcList)
        x_g(kk) = g;
        nadc = adcList(iadc);
        plot(x_g,rms_var(1:kk,iadc),lspec{iadc},'DisplayName', ['ADC#',num2str(nadc)]); 
        hold on; grid on; 
        xlabel('CB gain, units')
        ylabel('RMS Gain deviation, %')
    end
    legend('show','Location','NorthWest');
    title(sprintf(sTitle1 ));
    drawnow;
end
saveas(figNum2,[dirSave, sTitle1, '.jpg']) 
close(h2);
