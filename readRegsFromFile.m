function out = readRegsFromFile( fn, port)
% fn='C:\ProCEEd_Working_Directory\RegisterFiles\Raijin_26MHz_PLL100_dig50_fullpix_mphyhalf_master_hramp.regfile';
% port - serial port object; port = 'COM2' or port = s1 (serial object must be opened)
    portString = (isa(port,'char') && strcmp(port(1:3), 'COM'));
    if (portString)
        s2 = serial(port,'BaudRate',9600);
        fopen(s2);
    else
        s2 = port;
    end

    header = '06160501';  % header for sensor single write commend
    footer = 'ff';
    nExpectedBytes = 8;   % number of bytes expected to return on single write commend

    fid = fopen(fn,'r+');
    tmp = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);

    aa=tmp{1,1};
    bb=cell2mat(aa);
    sbb=size(bb);
    sz=sbb(1);

    h_sz=repmat(header,sz,1);
    f_sz=repmat(footer,sz,1);

    out = [h_sz, bb, f_sz];
    for ii=1:sz
        gg=out(ii,:);
        sendSerial( gg, s2);
        readSerialBytes( nExpectedBytes, s2 );
        pause(0.01);
    end
    if (portString) fclose(s2); end
end