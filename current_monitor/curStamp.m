function [ out ] = curStamp( s2 )
% function curStamp is used to draw current stamp on the chart NW corner

plist = [1,2,6,7,8,9,13,14];

    for ndev=1:length(plist)
        [c_mA(ndev), sName{ndev}, htmp] = readI_revA(plist(ndev), s2);
        xstr{ndev} = [sName{ndev}, ' I=',num2str(c_mA(ndev)),'mA']; 
        xx = double(xlim); yy = double(ylim);
        dx=xx(2)-xx(1); dy=yy(2)-yy(1);
        text(xx(1)+dx*0.02,yy(2)-dy*ndev*0.025,xstr{ndev}); 
    end

    out.xstr = xstr;
    out.c_mA = c_mA;
    out.sName = sName;
end

