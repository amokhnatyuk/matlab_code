function rval = evkCurrRead(sNode, s2)
% s2 - serial object must be opened
% sNode = 'VDD_DIG_MPHY';

header = '0622064280';
footer = 'ff';

switch sNode
    case 'VDD_DIG_MPHY'
        s_dev = '9000';  % I2C addr + reg_addr_hi
        msb_req = '0c01'; % MSB request
        lsb_req = '0d01'; % LSB request
    case 'VDDIO_DIG'
        s_dev = '9000';  % I2C addr + reg_addr_hi
        msb_req = '1001'; % MSB request
        lsb_req = '1101'; % LSB request
    case 'VDDA_36_PIX'
        s_dev = '9200';  % I2C addr + reg_addr_hi
        msb_req = '0c01'; % MSB request
        lsb_req = '0d01'; % LSB request
    case 'VDDA_36_VERT'
        s_dev = '9200';  % I2C addr + reg_addr_hi
        msb_req = '1001'; % MSB request
        lsb_req = '1101'; % LSB request
    case 'VDDA_33'
        s_dev = '9200';  % I2C addr + reg_addr_hi
        msb_req = '1401'; % MSB request
        lsb_req = '1501'; % LSB request
    case 'VDDA_12'
        s_dev = '9200';  % I2C addr + reg_addr_hi
        msb_req = '1801'; % MSB request
        lsb_req = '1901'; % LSB request
    case 'VDDA_PLL'
        s_dev = '9400';  % I2C addr + reg_addr_hi
        msb_req = '0c01'; % MSB request
        lsb_req = '0d01'; % LSB request
    case 'VDDA_MPHY'
        s_dev = '9400';  % I2C addr + reg_addr_hi
        msb_req = '1001'; % MSB request
        lsb_req = '1101'; % LSB request
    case 'VRST_HIGH'
        s_dev = '9600';  % I2C addr + reg_addr_hi
        msb_req = '0c01'; % MSB request
        lsb_req = '0d01'; % LSB request
    case 'VTX_HIGH'
        s_dev = '9600';  % I2C addr + reg_addr_hi
        msb_req = '1001'; % MSB request
        lsb_req = '1101'; % LSB request
    case 'VTX_LOW'
        s_dev = '9600';  % I2C addr + reg_addr_hi
        msb_req = '1201'; % MSB request
        lsb_req = '1301'; % LSB request
end
cmd1= [header, s_dev, msb_req,  footer];
cmd2= [header, s_dev, lsb_req,  footer];
    
    expectedBytes = 10;
    msB = readLastByte(cmd1, s2, expectedBytes);
    lsB = readLastByte(cmd2, s2, expectedBytes);
    w=[msB, lsB];
    w14 = rem(hex2dec(w),2^14); % mask out MS 2B
    
% current (in amps) = (([readback_value]/15727)* 0.3)/0.005
    rval = w14/15727* 0.3/0.005 * 1000;  % in mA
end

function hval = readLastByte(cmd1, s2, expectedBytes)
    sendSerial( cmd1, s2);
    cCount=1; maxCount=1000;
    while (s2.BytesAvailable < expectedBytes)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
    bb = fread(s2,s2.BytesAvailable);
    hval= '';
    if (length(bb) == expectedBytes)
        b2='';
        cc = bb(expectedBytes);
        if (cc>=0 && cc<16)
            b2=['0',dec2hex(cc)];
        elseif (cc>=16 && cc<=255) 
            b2= dec2hex(cc);
        end
        hval= [hval, b2];
    end
end