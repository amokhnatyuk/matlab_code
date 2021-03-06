function out = readreg( istart, iend, s2 )
%{
arr= {
    '0240';'0241';'0242';'0243';'0244';'0245';'0246';'0247';
    '0248';'0249';'024A';'024B';'024C';'024D';'024E';'024F';
    '0250';'0251';'0252';'0253';'0254';'0255';'0256';'0257';
    '0258';'0259';'025A';'025B';'025C';'025D';'025E';'025F';
    '0260';'0261';'0262';'0263';'0264';'0265';'0266';'0267';
    '0268';'0269';'026A';'026B';'026C';'026D';'026E';'026F';
    '0270';'0271';'0272';'0273';'0274';'0275';'0276';'0277';
    '0278';'0279';'027A';'027B';'027C';'027D';'027E';'027F';'0280';}   
%}


dstart=hex2dec(istart);
dend=hex2dec(iend);
ii=1;
for addr=dstart:dend
    haddr = dec2hex(addr,4);
    aa{ii,1}= haddr;
    aa{ii,2}=  readSensorReg( haddr, s2);
    ii=ii+1;
end
out=aa;
end