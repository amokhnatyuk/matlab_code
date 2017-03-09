  
function sweepProc1(swp1, adcNum, bias, figN, dirSave)
%adcNum = 5;
%biasSetting=5
%dirSave = 'c:/data/lot1_/';
strTile1 = ['ADC ', num2str(adcNum), ' Odd rows, biasSetting=', num2str(bias)];
figure(figN); clf
plot(swp1.d(:,1),swp1.d(:,2),'b'); hold on;
grid on; plot(swp1.d(:,1),swp1.d(:,3),'g');
plot(swp1.d(:,1),swp1.d(:,4),'m');
plot(swp1.d(:,1),swp1.d(:,5),'r');
legend ('Mean Corrected', 'Std Corrected', 'Mean', 'Std')';
title(strTile1);
xlabel('PGA input voltage, mV')
ylabel('ADC code')
saveas(gcf,[dirSave, strTile1, '.jpg'])

strTile2 = ['ADC ', num2str(adcNum), ' Even rows, biasSetting=', num2str(bias)];
figure(figN+1); clf
plot(swp1.d(:,1),swp1.d(:,6),'b'); hold on;
grid on; plot(swp1.d(:,1),swp1.d(:,7),'g');
plot(swp1.d(:,1),swp1.d(:,8),'m');
plot(swp1.d(:,1),swp1.d(:,9),'r');
legend ('Mean Corrected', 'Std Corrected', 'Mean', 'Std')';
title(strTile2);
xlabel('PGA input voltage, mV')
ylabel('ADC code')
saveas(gcf,[dirSave, strTile2, '.jpg'])
end