function [current_mA, sName, hval] = readI_revA(ndev, s2)
% ndev 1:15
% [current_mA, hval] = readI(1,s2)

d{1,1} = '90000C'; d{1,2} = '90000D';
d{1,3} = 'VDD-MPHY 1.2V'; % read U21 V1/2 VDD_MPHY 1.2V (schematics VDD_DIG_MPHY)
d{2,1} = '900010'; d{2,2} = '900011';
d{2,3} = 'VDDIO-DIG 1.8V'; % read U21 V3/4 VDDIO_DIG 1.8V
d{3,1} = '900014'; d{3,2} = '900015';
d{3,3} = '';
d{4,1} = '900018'; d{4,2} = '900019';
d{4,3} = '';

d{5,1} = '92000C'; d{5,2} = '92000D'; 
d{5,3} = ''; % - (no connect) read device U20 V1/2 VDDA_36_PIX 3.6V
d{6,1} = '920010'; d{6,2} = '920011'; 
d{6,3} = 'VDDA-MPHY 1.2V';  % read VDDA_MPHY 1.2V U20 V3/4 ( schematics VDDA_36_VERT 3.6V )
d{7,1} = '920014'; d{7,2} = '920015'; 
d{7,3} = 'VDDA-33 3.3V'; % read 1.2V U20 V5/6  VDDA_33 3.3V
d{8,1} = '920018'; d{8,2} = '920019'; 
d{8,3} = 'VDDA-12 1.25V'; % read device U20 V7/8 VDDA_12 1.25V

d{9,1} = '94000C'; d{9,2} = '94000D'; 
d{9,3} = 'VDDA-PLL 3.3V'; % read U22 V1/2 VDDA_PLL 3.3V
d{10,1} = '940010'; d{10,2} = '940011'; 
d{10,3} = ''; % - (no connect) read device U22 V3/4 VDDA_MPHY 1.2V
d{11,1} = '940014'; d{11,2} = '940015'; 
d{11,3} = '';
d{12,1} = '940018'; d{12,2} = '940019'; 
d{12,3} = '';

d{13,1} = '96000C'; d{13,2} = '96000D'; 
d{13,3} = 'VDDA-PLL-MPHY + VDD-PLL-MPHY 1.2V'; % read VDDA_PLL_MPHY + VDD_PLL_MPHY U18 V1/2 ( schematics VRSTHIGH )
d{14,1}= '960010'; d{14,2}= '960011'; 
d{14,3} = 'VDD-DIG 1.2V'; % read VDD_DIG 1.2V device U18 V3/4 (schematics VTXHIGH )
d{15,1}= '960012'; d{15,2}= '960013'; 
d{15,3} = ''; %  - (no connect) read device U18 V5 VTXLOW

hdr='0622064280';   % header
ftr='02ff';         % footer
expectedBytes = 11;
current_mA = 0;

    ii=1;
    s=[hdr,d{ndev,ii},ftr];
    sendSerial( s, s2);

    % repeating up to maxCount times waiting for the required number of bytes
    cCount=1; maxCount=1000;
    while (s2.BytesAvailable < expectedBytes)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
    data = fread(s2,s2.BytesAvailable);

    if (length(data) == expectedBytes)
        r=''; for jj=1:length(data) t=dec2hex(data(jj),2); r=[r,t]; end

        if strcmpi(r(1:end-4),s(1:end-2))  % if responded string r(1:end-2) coincide with initial 
            hval=r(end-3:end);
        end
    end
        
    dval=hex2dec(hval);
    bit15 = bitget(dval,15,'uint16');  % bit 15 sign
    
    % readValue[13:0] * 19.075 uV / 5m ohm
    readValue = bitand(dval,hex2dec('3FFF'),'uint16');
    sign=1;
    if bit15  % if negative
        sign=-1;
        dval2 = readValue + hex2dec('8000');   % now it is int16 negative
        dval3 = bitcmp(dval2,16)+1; % complement +1; dval3 is positive
    else
        dval3 = readValue; % dval3 is positive
    end
    dval4 = bitand(dval3,hex2dec('3FFF'),'uint16');
    current_mA = sign * dval4 * 3.815;  % 19.075 uV / 5mOhm = 3.815 mA
    sName = d{ndev,3};
end