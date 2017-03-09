function out = igrab( nfunc )

out=[];

    if nfunc == 0  % initialize grabber
        grab56(nfunc);
    elseif (nfunc == -1) % release framgrabber
        grab56(nfunc);    
    elseif (nfunc == -2) % release framgrabber
        out = grab56(nfunc);    
    elseif (nfunc == 1) % release framgrabber
        out = grab56;    
    elseif (nfunc >1) % grab nfunc frames nfunc<30
        bb = grab56(nfunc);
        s = grab56(-2);  % acquire image info
        width = s.dblData(2);
        height = s.dblData(3);
        sz= size(bb);
        nframes= sz(2);
        out = zeros(width,height,nframes);
        for i=1:nframes
            out(:,:,i) = reshape(bb(:,i), width,height );
       %     aa = squeeze(out(:,:,i));
       %     imtool(aa')
        end
    end

end