function writeSensor( str, port)
% str is input string;  str ='002d0001';
% port - serial port object; port = 'COM2'

    header = '06160501';  % header for sensor single write commend
    footer = 'ff';



    out = [h_sz, bb, f_sz];
    s2 = serial(port,'BaudRate',9600);
    fopen(s2);
    
    for ii=1:sz
        gg=out(ii,:);
%        fprintf(s2,'%x', gg);
        for kk=1:length(gg)/2  
%            F(kk,:) = gg(2*kk-1:2*kk); 
            ff = gg(2*kk-1:2*kk);
            fwrite(s2, uint8(hex2dec(ff)), 'uint8');
        end
        pause(0.01);
    end
    fclose(s2);
end