%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
function hout = ihistFn(img)
% img is 3D image [Hight xWidth xFrames]
    zz=size(img); 
    ff=reshape(img, zz(1)*zz(2)*zz(3),1);
    meanVal = mean(double(ff));
    stdVal = std(double(ff));
    [hh,xx]=hist(ff,0:16383);
    hout.h = hh;
    hout.xx = xx;
    hout.meanVal = meanVal;
    hout.stdVal = stdVal;
end


