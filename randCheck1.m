function out = randCheck1 (s2)
%s2 - serial port object
    f = arDescr();
    arr={};
    kk=4; % starting assign values from 4-th element because 1-3 assigned as (A,B,C) in runRand1 function
    dataFormat = '%8.3f\t %8.2f\t %8.2f\t ';
    colHeadFormat = '%s\t %s\t %s\t ';
    desc = {'Mean/Std','Mean','Std'};

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
            case 2 % RSM registers with random LE and random invert bit
                b1 = randHex (imax,length(f.list(jj).set),4);
                for ii=1:length(b1)
                    func = str2func(f.list(jj).set{ii,2}); 
                    hval = func(f.list(jj).set{ii,1}, b1{ii}, s2);
                    arr{kk} = hval;
                    desc{kk} = f.list(jj).set{ii,1};
                    dataFormat = [dataFormat, '%s\t ']; % data output format
                    colHeadFormat = [colHeadFormat, '%s\t ']; % colHeadFormat output format
                    kk=kk+1;
                end
            case 3  % RSM registers with random TE
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
    dataFormat = [dataFormat(1:end-3), '\n']; % replacing '\t' by '\n'
    out.dataFormat = dataFormat;
    out.colHeadFormat = colHeadFormat;
    out.desc = desc;
    out.arr = arr;
end

function f = arDescr()
    f.criter = ...  % Header    function  
    {'Mean/Std',  'fCriteria';    ...
    'Mean',  'fCriteria';    ...
    'Std',  'fCriteria';    ...
    };

    % registers with random selection from [0 max] 
    f.list(1).max = 255;
    f.list(1).set = ...  % Header    function 
    {'ADCDly',   'setAdcDly';    ...
    'HoriDly',  'setHoriDly2';  ...
    'PgaDly',   'setPgaDly2';   ...
    };
    
    % RSM registers with random LE and random invert bit
    f.list(2).max = 360;
    f.list(2).set = ...     % Header    function  
    {'0210',   'setRSMrandInvert';    ...
    '020c',    'setRSMrandInvert';  ...
    };

    % RSM registers with random TE
    f.list(3).max = 360;
    f.list(3).set = ...    % Header    function  
    {'0211',   'setRSMRegs';    ...
    '020d',    'setRSMRegs';  ...
    };

    f.clist = ...    % Header  function 
    {'x90',   'writeSensorReg';    ...
    };
    f.regs.x90.a = {'00','01','02','04','08','09','0a','0c', ...
                              '03','05',          '0b','0d'};
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
