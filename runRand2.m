function arrD = runRand2( s2)
    dirSave = 'C:\data\lot1_\randscan2\';
    fSave = [dirSave, 'randCheck4.txt'];
    nFrm = 0;
        
    a1 = igrab4(1); pause (1.5);
    sz=size(a1);
    str = randCheck2 (s2);
    vec_sz = length(str.arr);
    desc = str.desc;
    arrD = cell(1,vec_sz); % 
    nUpdate = 50; iUpd = 0;

    iadc = 8;
    iend = 98-1+640*(iadc);
    if (98-1+640*(iadc) > sz(1)) iend = sz(1); end

    while(1)
        str = randCheck2 (s2);
        for kk=1:4
            switch kk
                case 1
                    evksetDac( '5000', s2);
                case 2
                    evksetDac( '5800', s2);
                case 3
                    evksetDac( '7800', s2);
                case 4
                    evksetDac( '8000', s2);
            end
                igrab4(1);
                nFrm = nFrm +1;
                pause (1.5);
                a1 = igrab4(1);  % grab
                out = a1(98+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
                h1_cor = ihistCor(out,0);
                amean(kk)= h1_cor.meanVal;
                astd(kk) = h1_cor.stdVal;
                pctPix(kk) = h1_cor.pctPixCorr;  % percentage of corrected pixels
        end

        if ((pctPix(1)>=1) && (pctPix(2)>=1) && (pctPix(3)>=1) && (pctPix(4)>=1) && ... % see some "good pixels"
            (astd(1)>=1) && (astd(2)>=1) && (astd(3)>=1) && (astd(4)>=1) ) % see reasonable std
        
            % {'M*Lin/Std','M1','M2','Lin','Std','M1/Std'};
            B(1) = double(abs(amean(1)-amean(2)));
            B(2) = double(abs(amean(3)-amean(4)));
            C = double(min([B(1)/B(2), B(2)/B(1),]));   % linearity parameter
            D = double(max(astd));
            A = B(1)/D*C;
            E=B(1)/D;

            vec = str.arr;
            vec{1} = A; vec{2} = B(1); vec{3} = B(2); 
            vec{4} = C; vec{5} = D; vec{6} = E;
            dataFormat = str.dataFormat;
            colHeadFormat = str.colHeadFormat;
            arrD(end+1,:) = vec;

            if (mod(iUpd,nUpdate)==0 )
                if (iUpd<= nUpdate)
                    appendArrtoFile(fSave, arrD, dataFormat,desc, colHeadFormat);
                else
                    appendArrtoFile(fSave, arrD, dataFormat);
                end
                arrD = cell(1,vec_sz); 
            end
            iUpd = iUpd +1;
        end

        f2=out;
        f2((rem(out,4)==0 | rem(out,4)==3))=0;

        figure(22); clf; colormap('gray'); 
        sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];
        subplot(6,1,[1:4])
        imshow(f2,[0 16384],'InitialMagnification',200);
        title(sTitle11);
        subplot(6,1,5); h1_cor = ihistCor(out,1);
        sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
        title(sTitle12);

        subplot(6,1,6); h1 = ihist(out);
        title(['Histogram Image #',num2str(nFrm)]);
    end        
end