function out = stdcor2(A)
% A is 3D aray where supposed to be nFrm = sz(3); nFrm>1
    sz = size(A); % sz(3)
    nFrm = sz(3); 
    D=reshape(A,[],nFrm);
    out1 = stdcor(D'); 
    
    out.ar_tn  = reshape(out1.ar_tn,sz(1),sz(2));   % array of temporal noise
    out.ar_fpn = reshape(out1.ar_fpn,sz(1),sz(2));  % array of signAL deviation from ar_avg
    out.ar_fpns = reshape(out1.ar_fpns,sz(1),sz(2));  % array of signal deviation from ar_avg, signed
    out.ar_avg = reshape(out1.ar_avg,sz(1),sz(2));  % array of temporal noise averages
    out.gp = reshape(out1.gp,sz(1),sz(2));          % good pixels location
    out.fpn_cavg = sqrt(sum((out.ar_fpn.*out.gp).^2,2)./sum(out.gp,2));   % column average of FPN
    out.fpn_cavgs = sum((out.ar_fpns.*out.gp),2)./sum(out.gp,2);   % column average of FPN Signed
    out.tn  = out1.tn;        % temporal noise total
    out.tn_nz  = out1.tn_nz;  % temporal noise total calculated accounting only non-zero noise values
    out.avg = out1.avg;       % temporal noise total
    out.pctGood = out1.pct;      % percentage of good pixels
end % function