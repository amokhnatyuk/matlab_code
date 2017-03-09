function out = img_stats (B)
A=double(B);
szA = size(A); % A(1:Frames, 1:Rows, 1:Cols); % Required: Rows>1; Cols>1
Frames = szA(1); Rows = szA(2); Cols = szA(3);
tn = 0; rtn = 0;  ctn = 0;  ptn = 0;
frm_aver2 = squeeze(mean(mean(A,2),3));
flutter = std(frm_aver2);
r_aver(:,:) = squeeze(mean(A,2));
c_aver(:,:) = squeeze(mean(A,3));
if Frames>1 
    tn  = sqrt(mean2((std(A,0,1)).^2));
    rtn = sqrt(mean((std(c_aver,0,1)).^2));
    ctn = sqrt(mean((std(r_aver,0,1)).^2));
    ptn = sqrt(tn^2-rtn^2-ctn^2+flutter^2);
end
frm_aver = squeeze(mean(A,1)); % (1:Rows, 1:Cols);
fpn = std2(frm_aver);
totn = sqrt(fpn^2+tn^2);  % total noise
rfpn = std(mean(frm_aver,2));
cfpn = std(mean(frm_aver,1));
pfpn = sqrt(fpn^2-rfpn^2-cfpn^2);

out.flut = flutter;
out.totn = totn;
out.tn = tn;
out.rtn = rtn;
out.ctn = ctn;
out.ptn = ptn;
out.fpn = fpn;
out.rfpn = rfpn;
out.cfpn = cfpn;
out.pfpn = pfpn;
out.frm_aver2 = frm_aver2(:); % (1:Frames)
end