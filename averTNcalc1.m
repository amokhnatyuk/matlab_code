  
function [tn_av, slope] = averTNcalc1(ar1 )
% sval = 'pga'; % sval = 'adc'; would plot appropriate sweep
%bias=5
% p - assymptote coefficients
iadcMax = length(ar1(1).d(1,:,1));
ar1sz = length(ar1);
x1(1:ar1sz)=0;
y2(1:ar1sz)=0; y3(1:ar1sz)=0; 
iOddCol=2;
tn_av(1:iadcMax) = 0;
    for iadc = 1:iadcMax
            for ii=1:length(ar1)
                nadc = ar1(ii).adcList(iadc);
                x1(ii) = ar1(ii).v_dac;
                y2(ii) = ar1(ii).d(2,iadc,iOddCol);
                y3(ii) = ar1(ii).d(3,iadc,iOddCol);
%                y4(ii) = ar1(ii).d(4,iadc,iOddCol);
%                y5(ii) = ar1(ii).v_measur;
                if (nadc < 10) 
                    if (iOddCol == 1)
                        sTitle1 = ['ADC#',num2str(nadc), ' oddC evenR'];
                    else
                        sTitle1 = ['ADC#',num2str(nadc), ' evenC oddR'];
                    end
                elseif ((nadc >= 10) && (nadc < 20))
                    if (iOddCol == 1)
                        sTitle1 = ['ADC#',num2str(nadc), ' oddC oddR'];
                    else
                        sTitle1 = ['ADC#',num2str(nadc), ' evenC evenR'];
                    end
                end
            end
            [y_, lo_hi, p] = calcAssimptote(x1,y2);
            
            % average tn calculation as sqrt(average variation)
            tn_tmp = 0;
            tn_sz=length(lo_hi(1):lo_hi(2));
            for jj= lo_hi(1):lo_hi(2)
                tn_tmp = tn_tmp + y3(jj)^2;
            end
            tn_av(iadc) =sqrt(tn_tmp/tn_sz);
            slope(iadc) = p(1);
    end
end

function [y1, lo_hi, p] = calcAssimptote(x,y)
% x,y must be vectors same dimension
% assimptote relies on decreasing portion of cuve approximation
% lo_hi - low and high x-coordinate values which correspond to linear region, no clipping
sz = length(y);
sz2=floor(sz/2);
[ymax, imax] = max(y(1:sz2));
[ymin, imin] = min(y(sz2:end));
imin = imin +sz2-1; % corecion for counting from middle of array
range = [];
if ((imax<imin) && (imin-imax>2)) range = imax+1:imin-1;
else
    y1=y; 
    return;
end
lo_hi = [imax+1,imin-1];
p=polyfit(x(range),y(range),1);
y1=p(1)*x+p(2);
end