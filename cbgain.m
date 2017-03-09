function gain = cbgain(rval)
% rval = readSensorReg( '003c', s2);  % rval = '1717';
sw(1:6)=0; fb_sw = 0;
for i=1:length(sw)+1
    if (i<=length(sw)) 
            sw(i) = bitget(hex2dec(rval),8+i,'uint16');
    else
        fb_sw = bitget(hex2dec(rval),8+i,'uint16');
    end
end
fb_swB = ~fb_sw;

c1 = sw(1)*(418*sw(2) + 626*sw(3) + 860*sw(4) + 1253*sw(5) + 2013*sw(6)) + 503*fb_swB;
c2 = 503 * (1 + fb_sw);
gain = 1 + c1/c2;
end