function saveArrtoFile(fn, C, formatSpec, colHeader, colHeaderFormat)
% C - input array
fileID = fopen(fn,'w');
%formatSpec = '%s %d %2.1f %s\n';
%formatSpec = '%s\t %s\t %s\t %s\n';
%colHeader = {'Criter','ADCDly','HoriDly','PgaDly'};
fprintf(fileID,colHeaderFormat, colHeader{:});

[nrows,ncols] = size(C);
for row = 1:nrows
    fprintf(fileID,formatSpec,C{row,:});
end

fclose(fileID);
end