function data = readSerialBuffer(s2)
    expectedBytes = 8;
    cCount=1; maxCount=1000;
    % repeating up to 10 times cycl waiting for the required byes
    while (s2.BytesAvailable < expectedBytes)  
        pause(0.00001); 
        cCount = cCount +1;
        if (cCount > maxCount) break; end
    end
    data = fread(s2,s2.BytesAvailable);
end
