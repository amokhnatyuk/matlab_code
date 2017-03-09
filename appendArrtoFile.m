function appendArrtoFile(fn, C, formatSpec, colHeader, colHeaderFormat)
% C - input array
fileID = fopen(fn,'a');
%formatSpec = '%s %d %2.1f %s\n';
%formatSpec = '%s\t %s\t %s\t %s\n';
%colHeader = {'Criter','ADCDly','HoriDly','PgaDly'};
% colHeadFormat = [colHeadFormat, '%s\t ']; % colHeadFormat output format

if nargin>3  
    fprintf(fileID,colHeaderFormat, colHeader{:});
end
[nrows,ncols] = size(C);
for row = 1:nrows
    fprintf(fileID,formatSpec,C{row,:});
end

fclose(fileID);
end