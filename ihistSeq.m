function hout = ihistSeq(img)
% nF - figure number
    zz=size(img); 
    ff=reshape(img, zz(1)*zz(2),1);
    [hh,xx]=hist(ff,2:8:16384);
    bar(xx,hh); grid on;
    xlim([0,16384]);
%    hout = [hh,xx, meanVal, stdVal];
    hout.h = hh;
    hout.xx = xx;
end