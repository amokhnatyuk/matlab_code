function writeEvkDacReset( port)
% port - serial port object; port = 'COM2' or port = s1 (serial object must be opened)
    portString = (isa(port,'char') && strcmp(port(1:3), 'COM'));
    if (portString)
        s2 = serial(port,'BaudRate',9600);
        fopen(s2);
    else
        s2 = port;
    end

    header = '06180521005400';  % header for sensor single write command
    footer = 'ff';
    rst = '00';
%    gain1 = '01';   gain off
    gain1 = '11';   % gain on

    str1 = [header, rst, footer];
    str2 = [header, gain1, footer];

    sendSerial( str1, s2);
    bb1 = readSerialBuffer(s2);
    sendSerial( str2, s2);
    bb2 = readSerialBuffer(s2);
    
    if (portString) fclose(s2); end
end
