%load('C:\data\raijin_lot3\hist\ld_swp_dnl9.mat')
savedir = 'C:\data\raijin_lot3\hist\';
aa=A.hsumm;
fig_num = 1;
figure(fig_num); clf
subplot(3,1,1)
plot(aa);
xlim([1 16383]);
xlabel('ADC code, lsb');
ylabel('occurrence');
title('LD Voltage sweep code histogram')

bb=cumsum(aa);
xx2=1800:15000;
bb2=bb(xx2);
p = polyfit(xx2,bb2,1);
yy2= p(1)*xx2 + p(2);
subplot(3,1,2)
plot(xx2,bb2,'-g.');
grid on; hold on
plot(xx2,yy2,'-r');
xlim([1800 15000]);
xlabel('ADC code, lsb')
ylabel('accumulated histogram, rel.counts')
title('ADC linearity calc from dnl measurements')

dd=yy2-bb2;
dcoef2=(max(yy2)/ xrange);
dd2=dd/dcoef2;
subplot(3,1,3)
xlim([1800 15000]);
plot(xx2,dd2,'-r'); grid on
xlabel('ADC code, lsb')
ylabel('INL')

fnsave = [savedir,'INL from DNL_full range swp'];
saveas(fig_num, fnsave,'jpg');
saveas(fig_num, fnsave,'fig');
saveas(fig_num, fnsave,'emf');
