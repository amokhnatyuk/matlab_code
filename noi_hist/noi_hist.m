function out = noi_hist (savedir )
% savedir = 'C:\data\TQV_S2\1\'
start0;
fn = 'i_0_';
suffix = '.tif';
if ~exist(savedir, 'dir') mkdir(savedir); end
imdir = [savedir];
maxFames = 64;
row_start = 100;
hight_c = 1024;
col_start = 100;
width_c = 1024;

    % array input
for iFrames = 1:maxFames
    B = double(imread([imdir,fn,num2str(iFrames-1),suffix]));
    C = B(row_start:2:row_start+hight_c-1, col_start:2:col_start+width_c-1); 
    D(iFrames,:,:) = C;
end
    sz_d = size(D);
    out = img_stats (D);
    fig_num = 6;
T = squeeze(std(D,0,1));
TT=reshape(T,1,size(T,1)*size(T,2));
[n,x] = hist(TT,256);
figure(fig_num);bar(x,n); grid
set(gca,'YScale','log');
xlim([0 25]);
xlabel('Noise, DN')
ylabel('Occurrence, relative units')
title(['Dark image Temporal noise histogram (',num2str(iFrames),' frames statistics TN=',num2str(out.tn),'lsb)'])    
fnsave = ['tn_hist_frames=',num2str(iFrames)];
saveas(fig_num,[savedir,fnsave],'jpg');
saveas(fig_num,[savedir,fnsave],'fig');
saveas(fig_num,[savedir,fnsave],'emf');

end