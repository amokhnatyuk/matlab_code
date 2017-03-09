function out = randCheck2 (s2)
%s2 - serial port object
    f = arDescr();
    arr={};
    kk=7; % starting assign values from 7-th element because 1-6 assigned as (A,B,C ... ) in runRand1 function
    dataFormat = '%8.3f\t %8.2f\t %8.2f\t %8.3f\t %8.2f\t %8.2f\t ';
    colHeadFormat = '%s\t %s\t %s\t %s\t %s\t %s\t ';
    desc = {'M*Lin/Std','M1','M2','Lin','Std','M1/Std'};

    for jj=1:length(f.list)
        imax=f.list(jj).max;
        switch jj
            case 1  % registers with random selection from [0 max] 
                b1 = randHex (imax,length(f.list(jj).set),2);
                for ii=1:length(b1)
                    func = str2func(f.list(jj).set{ii,2}); 
                    func(b1{ii}, s2);
                    arr{kk} = b1{ii};
                    desc{kk} = f.list(jj).set{ii,1};
                    dataFormat = [dataFormat, '%s\t ']; % data output format
                    colHeadFormat = [colHeadFormat, '%s\t ']; % colHeadFormat output format
                    kk=kk+1;
                end
            case {2,3}   % registers with random selection from [min max]
                imin = f.list(jj).min;
                imax = f.list(jj).max;
                bshift = f.list(jj).bitshift;

                    func = str2func(f.list(jj).set{1,2}); 
                    hval1 = func(imin,imax,bshift,f.list(jj).set{1,1}, f.list(jj).zeroHVal, s2);
                    arr{kk} = hval1;
                    desc{kk} = f.list(jj).set{1,1};
                    dataFormat = [dataFormat, '%s\t ']; % data output format
                    colHeadFormat = [colHeadFormat, '%s\t ']; % colHeadFormat output format
                    kk=kk+1;
            case 4  % RSM registers with random TE
                b1 = randHex (imax,length(f.list(jj).set),4);
                for ii=1:length(b1)
                    func = str2func(f.list(jj).set{ii,2}); 
                    func(f.list(jj).set{ii,1}, b1{ii}, s2);
                    arr{kk} = b1{ii};
                    desc{kk} = f.list(jj).set{ii,1};
                    dataFormat = [dataFormat, '%s\t ']; % data output format
                    colHeadFormat = [colHeadFormat, '%s\t ']; % colHeadFormat output format
                    kk=kk+1;
                end
        end
    end
%{
    clist = f.clist;
    szList=size(clist);
    b1 = cellHex (clist,szList(1));
    for jj=1:szList(1)
        sreg = clist{1,jj};
        prefix = f.regs.(sreg).prefix;
    sz_selection =length(f.regs.(sreg).a);
    selection=randi([1,sz_selection],1,szList(1)); % uniform distrib integers inside [0, imax]
        v1 = f.regs.(sreg).a(selection(jj));
        rval = cell2mat(strcat(prefix, v1));
        writeSensorReg( rval, s2);
        arr{kk} = v1{1};
        desc{kk} = sreg;
        dataFormat = [dataFormat, '%s\t ']; % data output format
        colHeadFormat = [colHeadFormat, '%s\t ']; % colHeadFormat output format
        kk=kk+1;
    end
%}    
    dataFormat = [dataFormat(1:end-3), '\n']; % replacing '\t' by '\n'
    out.dataFormat = dataFormat;
    out.colHeadFormat = colHeadFormat;
    out.desc = desc;
    out.arr = arr;
end

function f = arDescr()
    f.criter = ...  % Header    function  
    {
    'M*Lin/Std',  'fCriteria';    ...
    'M1',  'fCriteria';    ...
    'M2',  'fCriteria';    ...
    'Lin',  'fCriteria';    ...
    'Std',  'fCriteria';    ...
    'M1/Std',  'fCriteria'    ...
    };

    % registers with random selection from [0 max] 
    f.list(1).min = 0;
    f.list(1).max = 255;
    f.list(1).set = ...  % Header    function 
    {'ADCDly',   'setAdcDly';    ...
    'HoriDly',  'setHoriDly2';  ...
    'PgaDly',   'setPgaDly2';   ...
    };
%{    
    % RSM registers with random LE and random invert bit
    f.list(3).min = 0;
    f.list(3).max = 360;
    f.list(3).set = ...     % Header    function  
    {'0210',   'setRSMrandInvert';    ...
    '020c',    'setRSMrandInvert';  ...
    };

    % RSM registers with random TE
    f.list(4).min = 0;
    f.list(4).max = 360;
    f.list(4).set = ...    % Header    function  
    {'0211',   'setRSMRegs';    ...
    '020d',    'setRSMRegs';  ...
    };
    
    % registers with random selection from [0 max] 
    f.list(2).min = 0;
    f.list(2).max = 255;
    f.list(2).bitshift = 0;
    f.list(2).zeroHVal = '9600';
    f.list(2).set = ...  % Header    function 
    { '0836',   'setModeRegs'    ...
    };
    % registers with random selection from [0 max] 
    f.list(3).min = 0;
    f.list(3).max = 63;
    f.list(3).bitshift = 6;
    f.list(3).zeroHVal = '6025';
    f.list(3).set = ...  % Header    function 
    { '083b',   'setModeRegs'    ...
    };
%}

    f.clist = ...    % Header  function 
    {'x90',   'writeSensorReg';    ...
    };
    f.regs.x90.a = {'00','02','04','08','0a','0c'};
    f.regs.x90.prefix = '009002';

end

function h1 = randHex (imax,n, nDigits)
% n - number of outputs 
if nargin<2  n=1;  end

    dv1=randi([0,imax],1,n); % uniform distrib integers inside [0, imax]
    h1(1:n)={''};
    for ii=1:n
        h1{ii}= dec2hex(dv1(ii),nDigits);
    end
end

function h1 = randHex2 (imin,imax,n, nDigits)
% n - number of outputs 

    dv1=randi([imin,imax],1,n); % uniform distrib integers inside [0, imax]
    h1(1:n)={''};
    for ii=1:n
        h1{ii}= dec2hex(dv1(ii),nDigits);
    end
end

function h1 = cellHex (cellArr1,n)
% cellArr of 2digit hex numbers, like {'a1','2b'}
% n - number of outputs
if nargin<2  n=1;  end   % 1 output by default
    imax = length(cellArr1);
    ival=randi([1,imax],1,n); % uniform distrib integers inside [1, imax]

    h1(1:n)={''};
    for ii=1:n
        h1{ii} = cellArr1{ival(ii)};
    end
end

function out = setRSMRegs (reg, hval,s2)
% reg = '020c'
% hval = '01a3'
    writeSensorReg( [reg,hval], s2);

    % writing same value to reg+2
    reg2 = dec2hex(hex2dec(reg)+2,4);
    out = writeSensorReg( [reg2,hval], s2);
end

function hval = setModeRegs (imin,imax,bitshift, reg, hZeroval,s2)
% imin,imax - decimal vaules for min and max random selection vaules
% bitshift - integer indicating how many bits rabdom vaue right shifted to be added hex2dec(hZeroval)
% reg = '020c'
% hZeroval = '01a3'

    dv1=randi([imin,imax],1,1); % uniform distrib integers inside [0, imax]
    dv2 = dv1*2^bitshift;
    hval = dec2hex(hex2dec(hZeroval) + dv2,4);  % 4-letter gex value
    out = writeSensorReg( [reg,hval], s2);
end

function hval2 = setRSMrandInvert (reg, hval,s2)
% used to set register with invert bit
% reg = '020c'
% hval = '01a3'
    invert_bit=randi([0,1],1); % uniform distrib integers inside [0, 1]
    hval2 = hval;
    if (invert_bit) 
        hval2=dec2hex( hex2dec(hval)+4096, 4);  % set bit 12 to 1 (invert)
    end
    writeSensorReg( [reg,hval2], s2);

    % writing same value to reg+2
    reg2 = dec2hex(hex2dec(reg)+2,4);
    out = writeSensorReg( [reg2,hval2], s2);
end
