function hout = ihist(img)
% nF - figure number
    zz=size(img); 
    ff=reshape(img, zz(1)*zz(2),1);
    meanVal = mean(double(ff));
    stdVal = std(double(ff));
    [hh,xx]=hist(ff,2:4:16384);
    bar(xx,hh); grid on;
    xlim([0,16384])
%    hout = [hh,xx, meanVal, stdVal];
    hout.h = hh;
    hout.xx = xx;
    hout.meanVal = meanVal;
    hout.stdVal = stdVal;
end