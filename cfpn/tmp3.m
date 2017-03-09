for jj=1:length(fldnames)
    fldname = fldnames{jj};
    
    % re-arranging fields for easy acceass
    for ii=1:sz_out(1)
    for kk=1:sz_out(2)
        out2(ii,kk) = out1(ii,kk).z.(fldname)(end);
        ctn(ii,kk) = out2(ii,kk).ctn;
        rtn(ii,kk) = out2(ii,kk).rtn;
        cfpn(ii,kk) = out2(ii,kk).cfpn;
    end
    end

    figure(fign); clf
    surf (ctn);
    xlim([0,max(shift_mbits)]);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ylim([1,16]);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('CTN noise, lsb');
    stit_ctn = [fldname, ' CTN noise'];
    title(stit_ctn);
    
    fname = [dirSummary,stit_ctn];
    saveas(fign,fname,'jpg');
    saveas(fign,fname,'fig');
    saveas(fign,fname,'emf');

    figure(fign+1); clf
    surf (rtn);
    xlim([0,max(shift_mbits)]);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ylim([1,16]);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('noise, lsb');
    stit_rtn = [fldname, ' RTN noise'];
    title(stit_rtn);
    
    fname = [dirSummary,fldname];
    saveas(fign,fname,'jpg');
    saveas(fign,fname,'fig');
    saveas(fign,fname,'emf');
    
    figure(fign+2); clf
    surf (cfpn);
    xlim([0,max(shift_mbits)]);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ylim([1,16]);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('noise, lsb');
    stit_cfpn = [fldname, ' CFPN noise'];
    title(stit_cfpn);
    
    fname = [dirSummary,fldname];
    saveas(fign,fname,'jpg');
    saveas(fign,fname,'fig');
    saveas(fign,fname,'emf');
    
end

