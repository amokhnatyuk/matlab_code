function hval = writeSensorReg( str, port)
% str is input string;  str ='002d0001';
% port - serial port object; port = 'COM2' or port = s1 (serial object must be opened)
% example: writeSensorReg( '00350005', s2);
    portString = (isa(port,'char') && strcmp(port(1:3), 'COM'));
    if (portString)
        s2 = serial(port,'BaudRate',9600);
        fopen(s2);
    else
        s2 = port;
    end
    hval= '';

    header = '06160501';  % header for sensor single write command
    footer = 'ff';

    out = [header, str, footer];
    sendSerial( out, s2);

    % the number of bytes expected to be filled in serial buffer in
    % response to sendSerial command, each of byte represent data nibble
    expectedNibbles = 8;

    % repeating up to maxCount times cycl waiting for the required bytes
    cCount=1; maxCount=100;
    while (s2.BytesAvailable < expectedNibbles)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
    bb = fread(s2,s2.BytesAvailable);
    aa(1:4)={''};
    if (length(bb) == expectedNibbles)
        for ii=expectedNibbles-3:expectedNibbles   % looking for 4 last Nibbles
            jj=ii-expectedNibbles+4;  % index with expectedNibbles offset
            b2='';
            if ( bb(ii)<=255) 
                b2= dec2hex(bb(ii),2);
            end
            aa{jj}=b2;
        end
        s = [aa{1},aa{2},aa{3},aa{4}];
%        if strcmpi(s, str)  % if responded string register coincide with initial register
            hval=s;
%        end
    else
        hval= '';
    end
    
    if (portString) fclose(s2); delete(s2); end
end
