function out = igrab41( nfunc )

out=[];

    if nfunc == 0  % initialize grabber
        grab56_4links(nfunc);
    elseif (nfunc == -1) % release framgrabber
        grab56_4links(nfunc);    
    elseif (nfunc == -2) % imageinfo
        out = grab56_4links(nfunc);    
    elseif (nfunc == -3) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(22); 
            imshow(a1',[0 16384],'InitialMagnification',25);
            title(['Image #',num2str(nFrm)]);
            nFrm = nFrm +1;
            pause (1.5);
        end
    elseif (nfunc == -4) % grab single image, subtract black, and show 
        nFrm = 0;
        black = grab56_4links;
            figure(22); 
            imshow(black',[980 1050],'InitialMagnification',25);
        while(1)
            pause (1.5);
            i1 = grab56_4links;
            a1 = i1-black + 1000;
            d1 = a1(1:320,1000:1200);
            figure(23); 
            imshow(d1',[980 1050]);
            title(['Image #',num2str(nFrm)]);
            nFrm = nFrm +1;
        end
    elseif (nfunc == 1) % grab 1 frame
        out = grab56_4links;    
    elseif (nfunc >1) % grab nfunc frames nfunc<30
        bb = grab56_4links(nfunc);
        s = grab56_4links(-2);  % acquire image info
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