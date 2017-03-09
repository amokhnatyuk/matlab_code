function plotNoiHist( A, savedir, tn )
% A [1:rows,1:cols]
% tn = 3.456;   % temporal noise
if (nargin >2) stitle = ['Dark image Temporal noise histogram (TN=',num2str(tn),'lsb)'];
else stitle = 'Dark image Temporal noise histogram';
end

fig_num = 36;
TT=reshape(A,1,size(A,1)*size(A,2));
[n,x] = hist(TT,256);
figure(fig_num);bar(x,n); grid
set(gca,'YScale','log');
xlim([0 25]);
xlabel('Noise, DN')
ylabel('Occurrence, relative units')
title(stitle);
fnsave = ['TN histogram'];
saveas(fig_num,[savedir,fnsave],'jpg');
saveas(fig_num,[savedir,fnsave],'fig');
saveas(fig_num,[savedir,fnsave],'emf');


end

