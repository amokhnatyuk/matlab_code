function listPass = sensorState( fn, port, fnOut)
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

    aa=tmp{1,1};
    sz=length(aa);
    listPass = 0; 
    hBar = waitbar(0,'Checking registers ...');
    
    fid2 = fopen(fnOut,'wt');
    try
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
                wv0 = [regH,val0];
                fprintf(fid2, [wv0, '\n']);
            end
            waitbar (ii/sz,hBar);
        end
    catch ME
        listPass = -1; 
    end
    fclose(fid2);    
    
    close(hBar)
    if (portString) fclose(s2); end
end