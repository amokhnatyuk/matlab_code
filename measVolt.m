function [v, footer] = measVolt(g1)
% g1=gpib('ni',0,22); fopen(g1)
%    fprintf(g1,'VOLTage:DC');
%    fprintf(g1,'read?');
    fprintf(g1,':FETCh?');
    r1 = fscanf(g1);
    C = find(r1==',');  % find commas in string
    vstr = r1(1:C(1)-1);
    footer = '';
    while  (isempty(str2num(vstr(end))))
        footer = [vstr(end),footer];
        vstr = vstr(1:end-1);
    end
    v=str2num(vstr);
end