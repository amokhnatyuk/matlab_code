function hval = readSensorReg( str, port)
% str is input string (register number in hex);  str ='002d';
% port - serial port object; port = 'COM2' or port = s1 (serial object must be opened)
    portString = (isa(port,'char') && strcmp(port(1:3), 'COM'));
    if (portString)
        s2 = serial(port,'BaudRate',9600);
        fopen(s2);
    else
        s2 = port;
    end

    header = '06160302';  % header for sensor single write command
    footer = 'ff';
    
    try
        d2 = hex2dec(str);
    catch ME
        hval = '';
        return
    end
    d3 = hex2dec('8000'); % added to sensor reg according to protocol
    d4=d2+d3;
    str2='';
    if ( d4 < hex2dec('ffff'))
        str2 = dec2hex(d4);
    end

    rstr = [header, str2, footer];
    sendSerial( rstr, s2);
%    pause(0.1)
    % the number of bytes expected to be filled in serial buffer in
    % response to sendSerial command, each of byte represent data nibble
    expectedNibbles = 10; 
    
    % repeating up to maxCount times cycl waiting for the required bytes
    cCount=1; maxCount=1000;
    while (s2.BytesAvailable < expectedNibbles)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
%    bb = fscanf(s2,'%x',s2.BytesAvailable);
    bb = fread(s2,s2.BytesAvailable);
    aa = cell(1,4);
    
    if (length(bb) == expectedNibbles)
        for ii=expectedNibbles-3:expectedNibbles   % looking for 4 last Nibbles
            jj=ii-expectedNibbles+4;  % index with expectedNibbles offset
            b2='';
            if (bb(ii)>=0 && bb(ii)<16)
                b2=['0',dec2hex(bb(ii))];
            elseif (bb(ii)>=16 && bb(ii)<=255) 
                b2= dec2hex(bb(ii));
            end
            aa{jj}=b2;
        end
        if strcmpi([aa{4},aa{3}],str2)  % if responded string register coincide with initial register
            hval=[aa{2},aa{1}];
        end
    else
        hval= '';
    end
    
    if (portString) fclose(s2); delete(s2); end
end