function setDly (dv, s2)
% dv - decimal integer or hex number
% dv must be <= 255-60 = 195; ('C3')
% '3C' ->60;
if ~isa(dv,'numeric')
    dv1=hex2dec(dv);
else dv1=dv;
end

d2 = dv1+60;
b='';
    if (dv1>=0 && dv1<16)
        b=['0',dec2hex(dv1)];
    elseif (dv1>=16 && dv1<=255) 
        b= dec2hex(dv1);
    end
b2='';
    if (d2>=0 && d2<16)
        b2=['0',dec2hex(d2)];
    elseif (d2>=16 && d2<=255) 
        b2= dec2hex(d2);
    end
    
setAdcDly(b, s2);
setPgaDly(b2, s2);
end