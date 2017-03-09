function writeEvkDac( str, port)
% str is input string;  str ='002d0001';
% port - serial port object; port = 'COM2' or port = s1 (serial object must be opened)

    portString = (isa(port,'char') && strcmp(port(1:3), 'COM'));
    if (portString)
        s2 = serial(port,'BaudRate',9600);
        fopen(s2);
    else
        s2 = port;
    end

    header = '0624053103';  % header for sensor single write command
    footer = 'ff';
    out = [header, str, footer];
    sendSerial( out, s2);
    bb1 = readSerialBuffer(s2);
   
    if (portString) fclose(s2); end
end