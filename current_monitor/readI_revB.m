function [current_mA, hval] = readI_revA(ndev, s2)
% ndev 1:15
% [current_mA, hval] = readI(1,s2)

d{1,1} = '90000C'; % read 1.2V U21 V1/2 (VDD_DIG_MPHY)
d{1,2} = '90000D';
d{2,1} = '900010'; % read 1.8V U21 V3/4 (VDDIO_DIG)
d{2,2} = '900011';
d{3,1} = '900014'; % read device U21 V5/6 (VRST_HIGH)
d{3,2} = '900015';
d{4,1} = '900018'; % read device U21 V7/8 (VTX_HIGH)
d{4,2} = '900019';

d{5,1} = '92000C'; % read device U20 V1/2 (VDDA_36_PIX)
d{5,2} = '92000D'; 
d{6,1} = '920010'; % read device U20 V3/4 (VDDA_36_PIX2)
d{6,2} = '920011'; 
d{7,1} = '920014'; % read 1.2V U20 V5/6 (VDDA_MPHY)
d{7,2} = '920015'; 
d{8,1} = '920018'; % read device U20 V7/8 (VDDA_MPHY2)
d{8,2} = '920019'; 

d{9,1} = '94000C'; % read device U22 V1/2 (VDDA_33)
d{9,2} = '94000D'; 
d{10,1} = '940010'; % read device U22 V3/4 (VDDA_12)
d{10,2} = '940011'; 
d{11,1} = '940014'; % read 1.2V U22 V5/6 (VDDA_PLL) 
d{11,2} = '940015'; 
d{12,1} = '940018'; % read device U22 V7/8 (VDDA_36_VERT) 
d{12,2} = '940019'; 

d{13,1} = '96000C'; % read 1.2V U18 V1/2 (PLL_MPHY)
d{13,2} = '96000D'; 
d{14,1}= '960010'; % read 1.2V U18 V3/4 (VDD_DIG)
d{14,2}= '960011'; 
d{15,1}= '960012'; % read device U18 V5/6 (VTX_LOW)
d{15,2}= '960013'; 

hdr='0622064280';   % header
ftr='01ff';         % footer
expectedBytes = 10;
hval= '';
current_mA = 0;

    for ii=1:2
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

            if strcmpi(r(1:end-2),s(1:end-2))  % if responded string r(1:end-2) coincide with initial 
                h1=r(end-1:end);
                hval = [hval,h1];
            end
        end
    end
    dval=hex2dec(hval);
    bit15 = bitget(dval,15,'uint16');  % bit 15 sign
    
    % readValue[13:0] * 19.075 uV / 5m ohm
    readValue = bitand(dval,hex2dec('3FFF'),'uint16');
    if bit15  % if negative
        dval2 = readValue + hex2dec('8000');   % now it is int16 negative
        dval3 = bitcmp(dval2,16)+1; % complement +1; dval3 is positive
    else
        dval3 = readValue; % dval3 is positive
    end
    dval4 = bitand(dval3,hex2dec('3FFF'),'uint16');
    current_mA = dval4 * 3.815;  % 19.075 uV / 5mOhm = 3.815 mA
end