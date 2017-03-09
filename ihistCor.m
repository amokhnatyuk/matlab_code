function hout = ihistCor(img, showBars)
% function calculates histogram of corrected values in vector to include only reliable values
% this is correction to account for the bug in digital chain
% nF - figure number

if (nargin<2)
    showBars = true;
end
    zz=size(img); 
    ff=reshape(img, zz(1)*zz(2),1);
    fcor=ff((rem(ff,4)==1 | rem(ff,4)==2));  
%    fcor=ff((rem(ff,4)==1 | rem(ff,2)==0));  
    meanVal = mean(double(fcor));
    stdVal = std(double(fcor));
    [hcor,xx]=hist(fcor,2:4:16384);
    if (showBars)
        bar(xx,hcor); grid on;
        xlim([0,16384])
    end
%    hout = [hcor,xx, meanVal, stdVal];
    hout.h = hcor;
    hout.xx = xx;
    hout.meanVal = meanVal;
    hout.stdVal = stdVal;
    hout.pctPixCorr = double(length(fcor))/(zz(1)*zz(2))*100; % percentage of corrected pixels
end