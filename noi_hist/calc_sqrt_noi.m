function out = calc_sqrt_noi (ptn2,savedir)
% script calc_sqrt_noi to calculate sqrt(ptn2), where ptn2 are squares of noise
% if squares of noise are negative, plot sqrt negative, and calc it as abs value
g2 = zeros(size(ptn2,1),size(ptn2,2));
g2(ptn2>=0)=1;
g3 = zeros(size(ptn2,1),size(ptn2,2));
g3(ptn2<0)=1;
h=sqrt(ptn2).*g2;
h1=sqrt(-ptn2).*g3;
h2=h -h1;
ttn = sqrt(mean2(ptn2)); 
plotNoiHist( h2, savedir, ttn );
xlim([-3 25]);
htitle = get(gca,'Title');
stitle = get(htitle,'String');

e1 = length(h2(h2>=0));
e2 = length(h2(h2<0));
h2_sz = size(h2,1)*size(h2,2);
pix_er = double(e2)/h2_sz;
out.h2=h2;
out.pix_er=pix_er;
title([stitle, ', negative\_noise\_pixels=',num2str(pix_er*100,3),'%']);
fnsave = [stitle, ', negative_noise_pixels=',num2str(pix_er*100,3),'%'];
saveas(gcf,[savedir,fnsave,'.jpg'],'jpg');
saveas(gcf,[savedir,fnsave,'.fig'],'fig');
saveas(gcf,[savedir,fnsave,'.emf'],'emf');

end