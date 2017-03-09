function out = stdcor(A)
% A is 2D aray where supposed to be nFrm = sz(1); nFrm>1
tStart = tic;
sz = size(A); 
nFrm = sz(1); 
iA = uint16( A);
l1=rem(iA,4)==1;   
l2=rem(iA,4)==2;
l=l1 | l2;       % selection of good pixels

    ls=sum(l,1);
%    lsi(1:sz(1),1:sz(2))=0;
    B= A.*l;
    ld=sum(B,1)./ls;  % average calculation fo "true pixels"
    gp=(ls>1);
    
    ld(ls<=1)=0;      % zero val for "bad pixels"
    G=ld(ld>0);    % array of "good pixels"
    d_aver = mean(G);
    pct=length(G)/sz(2)*100;

    fpn = abs(ld-d_aver);
    fpns = ld-d_aver;
    fpn(ls<=1)=0;      % zero fpn assign for "bad pixels"
    fpns(ls<=1)=0;      % zero fpn assign for "bad pixels"
    ld2=repmat (ld,nFrm,1); % same size as A
    ddsqr=double((A-ld2).^2);

    C = ddsqr.*l;
    sddsqr = sum(C,1);   % only values where logical l==1
    astd = sqrt(double(sddsqr)./(ls-1));  % std calculation
    astd(ls<=1) = 0;

    astd_ = astd;
    astd_(ls<=1) = -1;
    astd__= astd_(astd_~=-1);
    total_std = sqrt(sum(astd__.*astd__)/length(astd__)); % average std variance calc
    
    astd_nz = astd(astd>0);   % astd with non-zero values
    total_std_nz = sqrt(sum(astd_nz.*astd_nz)/length(astd_nz)); % average std variance calc
    
    out.ar_tn = astd;  % array of temporal noise
    out.tn    = total_std; % temporal noise total
    out.tn_nz  = total_std_nz; % temporal noise total calculated accounting only non-zero noise values
    out.ar_fpn = fpn;   % array of signal deviation from ar_avg, absolute val
    out.ar_fpns = fpns;   % array of signal deviation from ar_avg, signed
    out.ar_avg = ld;    % array averages (temporal noise removal)
    out.avg = d_aver;   % good pixel array average
    out.pct = pct;      % percentage of good pixels
    out.gp  = gp;        % good pixels location
%{    
for ii=2:nFrm
    ls=sum(l,1);
    ld=mean(l,1);
    ld=repmat (ld,nFrm,1); % same size as A
    ddsqr=(A-ld).^2;
    sddsqr = sum(ddsqr.*l,1);
    astd = sqrt(sddsqr./(ls-1));  % std calculation
    gg=A(:,ls==ii);
    ll=l(:,ls==ii);
    gg1=gg(ll==true);
    gg2=reshape(gg1,ii,[]);
    sstd = std( gg2,1);
end
%}
end % function