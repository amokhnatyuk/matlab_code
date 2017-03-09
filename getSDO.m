function out = getSDO (ss,s2)
    dd = hex2dec(ss);
    dd2 = dd*2+1;
    
    b2= dec2hex(dd2,2);
    s = ['003300', b2];
    out = writeSensorReg( s, s2);
end