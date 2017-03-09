function xstr = xnCode(xxn,xmin,xmax)
%    xxn = 8; % usedf in array of multiples of 4
%    x4val=floor(mval/xxn)*xxn;
%    x4ar = x4val-64:xxn:x4val+64;
    x4ar = xmin:xxn:xmax;
    xstr = ['x',num2str(xxn),' code: ',mat2str(x4ar)];
end
