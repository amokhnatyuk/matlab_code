function hval = evkCurrReset(sNode, s2)
% s2 - serial object must be opened
% sNode = 'VDD_DIG_MPHY';

header = '0622074180';
footer = 'ff';
str2 = '080110'; % set device to repeated measurement mode

if (strcmp(sNode, 'VDD_DIG_MPHY') || strcmp(sNode, 'VDDIO_DIG'))
    s_dev = '9000';  % I2C addr + reg_addr_hi
    str1 = '010130'; % write channel enable register on device U21, enable V1-V4 channels
elseif (strcmp(sNode, 'VDDA_36_PIX') || strcmp(sNode, 'VDDA_36_VERT') || ...
        strcmp(sNode, 'VDDA_33') || strcmp(sNode, 'VDDA_12'))
    s_dev = '9200';  % I2C addr + reg_addr_hi
    str1 = '0101f0'; % write channel enable register on device U20, enable all Vx channels
elseif (strcmp(sNode, 'VDDA_PLL') || strcmp(sNode, 'VDDA_MPHY') )
    s_dev = '9400';  % I2C addr + reg_addr_hi
    str1 = '010130'; % write channel enable register on device U22, enable V1-V4 channels
elseif (strcmp(sNode, 'VRST_HIGH') || strcmp(sNode, 'VTX_HIGH') || ...
        strcmp(sNode, 'VTX_LOW') )
    s_dev = '9600';  % I2C addr + reg_addr_hi
    str1 = '010170'; % write channel enable register on device U18, enable all Vx channels
end
cmd1= [header, s_dev, str1,  footer];
cmd2= [header, s_dev, str2,  footer];

%{
set U21 V1-V4 as differential, filters enabled
set U20 V1-V4 as differential, filters enabled
set U20 V5-V8 as differential, filters enabled
set U22 V1-V4 as differential, filters enabled
set U18 V1-V4 as differential, filters enabled
set U18 V5-V6 as single-ended, filters enabled
%}
    sendSerial( cmd1, s2);
%    sendSerial( cmd2, s2);

    expectedBytes = 10;
    cCount=1; maxCount=1000;
    while (s2.BytesAvailable < expectedBytes)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
    bb = fread(s2,s2.BytesAvailable);
    hval= '';
    if (length(bb) == expectedBytes)
        for ii= 1:expectedBytes
            b2='';
            if (bb(ii)>=0 && bb(ii)<16)
                b2=['0',dec2hex(bb(ii))];
            elseif (bb(ii)>=16 && bb(ii)<=255) 
                b2= dec2hex(bb(ii));
            end
            hval= [hval, b2];
        end
    end

end
