function arrD = runRand1( s2, dirSave)
    nFrm = 0;
        
    a1 = igrab4(1); pause (1.5);
    sz=size(a1);
    str = randCheck3 (s2);
    vec_sz = length(str.arr);
    desc = str.desc;
    nRepeat = 500; % n Top variations to save
%    arrD = cell(nRepeat+2,vec_sz); % 
    arrD = cell(1,vec_sz); % 
    nUpdate = 50; iUpd = 0;
    fSave = [dirSave, 'randCheck2.txt'];

    iadc = 8;
    iend = 98-1+640*(iadc);
    if (98-1+640*(iadc) > sz(1)) iend = sz(1); end

    while(1)
        str = randCheck3 (s2);
        for kk=1:2
            if (kk==1)
                evksetDac( '5000', s2);
                igrab4(1);
            else
                evksetDac( '7000', s2);
                igrab4(1);
            end
            
                nFrm = nFrm +1;
                pause (1.5);
                a1 = igrab4(1);  % grab
                out = a1(98+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
                h1_cor = ihistCor(out,0);
                amean(kk)= h1_cor.meanVal;
                astd(kk) = h1_cor.stdVal;
                pctPix(kk) = h1_cor.pctPixCorr;  % percentage of corrected pixels
        end

        if ((pctPix(1)>=1) && (pctPix(2)>=1) && ... % see some "good pixels"
            (astd(1)>=1) && (astd(2)>=1)) % see reasonable std
            B = abs(amean(1)-amean(2));
            C = max(astd);
            A = double(B)/double(C);

            vec = str.arr;
            vec{1} = A; vec{2} = B; vec{3} = C;
            dataFormat = str.dataFormat;
            colHeadFormat = str.colHeadFormat;
            arrD(end+1,:) = vec;
%            arrD = sortrows(arrD,1,'descend');
            
            % every nUpdate periodically save to file 
            if (mod(iUpd,nUpdate)==0 )
                fSave2 = fSave; fSave2(end-5)='1'; % replace 'randCheck0.txt' by 'randCheck3.txt'
                if (iUpd<= nUpdate)
                    appendArrtoFile(fSave, arrD, dataFormat,desc, colHeadFormat);
                else
%                    movefile(fSave, fSave2);
                    appendArrtoFile(fSave, arrD, dataFormat);
                end
                arrD = cell(1,vec_sz); 
            end
            iUpd = iUpd +1;
        end

        f2=out;
        f2((rem(out,4)==0 | rem(out,4)==3))=0;

        sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

        figure(22); clf; colormap('gray'); 
        subplot(6,1,[1:4])
        imshow(f2,[0 16384],'InitialMagnification',200);
        title(sTitle11);
        subplot(6,1,5); 
        sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
        title(sTitle12);

        subplot(6,1,6); h1 = ihist(out);
        title(['Histogram Image #',num2str(nFrm)]);
    end        
end