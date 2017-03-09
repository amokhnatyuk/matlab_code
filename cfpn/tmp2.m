fldnames = fieldnames(z);
sz_out=size(out1);
fign = 88;
dirSummary = [ddir,'summary\'];
if ~exist(dirSummary, 'dir') mkdir(dirSummary); end

for jj=1:length(fldnames)
    figure(fign); clf
    fldname = fldnames{jj};
    
    % re-arranging fields for easy acceass
    for ii=1:sz_out(1)
    for kk=1:sz_out(2)
        out2(ii,kk) = out1(ii,kk).z.(fldname)(end);
    end
    end

    surf (out2);
    xlim([0,max(shift_mbits)]);
    xstr = 'shift\_mem\_bits'; xlabel(xstr);
    ylim([1,16]);
    ystr = 'weight\_current'; ylabel(ystr)
    zlabel('noise, lsb');
    title(fldname);
    
    fname = [dirSummary,fldname];
    saveas(fign,fname,'jpg');
    saveas(fign,fname,'fig');
    saveas(fign,fname,'emf');
    
end