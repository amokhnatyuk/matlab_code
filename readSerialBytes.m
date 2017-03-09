function [ hval ] = readSerialBytes( nExpectedBytes, s2 )
% nExpectedBytes = 10;
% port - serial port s1 (serial object must be opened)
    
    % repeating up to 10 times cycl waiting for the required byes
    cCount=1; maxCount=1000;
    while (s2.BytesAvailable < nExpectedBytes)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
%    bb = fscanf(s2,'%x',s2.BytesAvailable);
    bb = fread(s2,s2.BytesAvailable);
    aa = cell(1,4);
    
    if (length(bb) == nExpectedBytes)
        for ii=nExpectedBytes-3:nExpectedBytes   % looking for 4 last bytes
            jj=ii-nExpectedBytes+4;  % index with nExpectedBytes offset
            b2='';
            if (bb(ii)>=0 && bb(ii)<16)
                b2=['0',dec2hex(bb(ii))];
            elseif (bb(ii)>=16 && bb(ii)<255) 
                b2= dec2hex(bb(ii));
            end
            aa{jj}=b2;
        end
        hval=[aa{1},aa{2},aa{3},aa{4}];
    else
        hval= '';
    end  
%    hval = sprintf('%x', bb);
end

