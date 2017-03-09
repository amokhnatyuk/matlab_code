function [c, m, ls, iC, iM, iL] = setColors (iC, iM, iL)
    C = {'b','r','g','m','k',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
    LS ={'-','--',':','--','-.'};
    M ={'o','d','*','.','+'};

    c = C{iC};
    m = M{iM};
    ls = LS{iL};

    if iC < length(C)  iC = iC + 1;
    else   iC = 1;
    end
    
    if iM < length(LS) iM = iM + 1;
    else      iM = 1;
    end
    
    if iL < length(LS)  iL = iL + 1;
    else        iL = 1;
    end
end