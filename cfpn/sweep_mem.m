w_swp=1:16;
shift_mbits=0:10;
clear out1;
out1(1:length(w_swp),1:length(shift_mbits))=struct;
ddir = 'C:\data\cmodel\cfpn1\3\';
for w=1:length(w_swp)
    for n=1:length(shift_mbits)
        z=cfpn_mem_model2(ddir, w,shift_mbits(n));
        out1(w,n).z = z;
    end
end

save ([ddir,'out_swp'],'out1','-v7.3');
fldnames = fieldnames(z);
sz_out=size(out1);
fign = 88;
dirSummary = [ddir,'summary\'];
if ~exist(dirSummary, 'dir') mkdir(dirSummary); end

for jj=1:length(fldnames)
    fldname = fldnames{jj};
    
    % re-arranging fields for easy acceass
    for ii=1:sz_out(1)
    for kk=1:sz_out(2)
        if strcmp(fldname, 'corrected')
%            out2(ii,kk) = out1(ii,kk).z.(fldname);
            ctn(ii,kk) = out1(ii,kk).z.(fldname).ctn(end);
            rtn(ii,kk) = out1(ii,kk).z.(fldname).rtn(end);
            cfpn(ii,kk) = out1(ii,kk).z.(fldname).cfpn(end);
          
        else
            out2(ii,kk) = out1(ii,kk).z.(fldname)(end);
            ctn(ii,kk) = out2(ii,kk).ctn;
            rtn(ii,kk) = out2(ii,kk).rtn;
            cfpn(ii,kk) = out2(ii,kk).cfpn;
        end
    end
    end

    ptY = [1,16]; yV = 1:16;
    ptX = [0,max(shift_mbits)]; xV = 0:max(shift_mbits);
    [X,Y] = meshgrid(xV,yV);
    
    figure(fign); clf
    surf (X,Y, ctn);
    xlim(ptX);    ylim(ptY);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('CTN noise, lsb');
    stit_ctn = [fldname, ' CTN noise'];
    title(stit_ctn);
    
    fname = [dirSummary,stit_ctn];
    saveas(fign,fname,'jpg');
    saveas(fign,fname,'fig');
    saveas(fign,fname,'emf');

    figure(fign+1); clf
    surf (X,Y, rtn);
    xlim(ptX);    ylim(ptY);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('noise, lsb');
    stit_rtn = [fldname, ' RTN noise'];
    title(stit_rtn);
    
    fname = [dirSummary,stit_rtn];
    saveas(fign+1,fname,'jpg');
    saveas(fign+1,fname,'fig');
    saveas(fign+1,fname,'emf');
    
    figure(fign+2); clf
    surf (X,Y, cfpn);
    xlim(ptX);    ylim(ptY);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('noise, lsb');
    stit_cfpn = [fldname, ' CFPN noise'];
    title(stit_cfpn);
    
    fname = [dirSummary,stit_cfpn];
    saveas(fign+2,fname,'jpg');
    saveas(fign+2,fname,'fig');
    saveas(fign+2,fname,'emf');
    
end

