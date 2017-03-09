function sendSerial( str, port)
        for kk=1:length(str)/2  
%            F(kk,:) = str(2*kk-1:2*kk); 
            gg = str(2*kk-1:2*kk);
%            fwrite(port, uint8(hex2dec(gg)), 'uint8');
            fwrite(port, uint8(hex2dec(gg)));
        end
end
