function [listPass, listFail] = readWriteRegsFromFile( fn, port)
% fn='C:\project\matlab\tmp\Book3.csv';
% port - serial port object; port = 'COM2' or port = s1 (serial object must be opened)
    portString = (isa(port,'char') && strcmp(port(1:3), 'COM'));
    if (portString)
        s2 = serial(port,'BaudRate',9600);
        fopen(s2);
    else
        s2 = port;
    end

    fid = fopen(fn,'r+');
    tmp = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    val1 = 'ffff';
    val2 = '0000';

    aa=tmp{1,1};
    sz=length(aa);
    nFail = 0; nPass = 0;
    listPass = cell(1,1); 
    listFail = cell(1,1);
    hBar = waitbar(0,'Checking registers ...');
    for ii=1:sz
        ss=aa{ii};
%        ss= s(2:end-1);  % ss- string without quotes ''
        if ( length(ss)>=6 && strcmp (ss(1:2), '0x') )
            regH = ss(3:6);  % 0xa123,  regH=a123
            
            % check if register 1st symbol is missing and delimiter at the end
            if (regH(4)==',' || regH(4)==' ' || regH(4)==';')
                regH = ['0',regH(1:3)];
            end
            if (regH(4)==':')  continue;     end
            val0 = readSensorReg( regH, s2);
            if (length(val0) ~= 4)
                nFail = nFail+1;
                listFail{nFail,1}=regH;
            else
                wv0 = [regH,val0];
                wv1 = [regH,val1];
                wv2 = [regH,val2];
                if (~strcmpi (writeSensorReg( wv1, s2), wv1 )  || ...
                    ~strcmpi (writeSensorReg( wv2, s2), wv2 ))
                    nFail = nFail+1;
                    listFail{nFail,1}=regH;
                else
                    nPass = nPass+1;
                    listPass{nPass,1}=regH;
                end
                writeSensorReg( wv0, s2);
            end
        end
        waitbar (ii/sz,hBar);
    end
    close(hBar)
    if (portString) fclose(s2); end
end