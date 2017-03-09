function out = igrab4( nfunc )

out=[];

    if nfunc == 0  % initialize grabber
        grab56_4links(nfunc);
    elseif (nfunc == -1) % release framgrabber
        grab56_4links(nfunc);    
    elseif (nfunc == -2) % imageinfo
        out = grab56_4links(nfunc);    
    elseif (nfunc == -3) % grab single image and show
        nFrm = 0;
        %a1 = grab56_4links;
        figure(22); colormap('gray'); 
        %imshow(a1',[0 16384],'InitialMagnification',100);
        while(1)
            a1 = grab56_4links;
            figure(22); 
            out = a1(96+1+640*5:2:96+640*6,1:2:500)';
%            imshow(a1',[0 4384],'InitialMagnification',25);
            imshow(out,[0 16384],'InitialMagnification',200);
%            ihist(out,23);
            ihist(out);
            title(['Image #',num2str(nFrm)]);
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -33) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            out = a1(98+1+640*5:2:98-1+640*6,1:2:500)';
            figure(22); colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);
            
            subplot(6,1,[1:4])
            imshow(out,[0 16384],'InitialMagnification',200);
            title(['Odd rows Image #',num2str(nFrm)]);
            subplot(6,1,5); ihistCor(out);
            title(['Corrected histogram Image #',num2str(nFrm)]);
            subplot(6,1,6); ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);

            figure(24); colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);

            b1 = a1(96+1+640*5:2:96+640*6,2:2:500)';
            subplot(6,1,[1:4])
            imshow(b1,[0 16384],'InitialMagnification',200);
            title(['Even Rows Image #',num2str(nFrm)]);
            subplot(6,1,5); ihistCor(b1);
            title(['Corrected histogram Image #',num2str(nFrm)]);
            subplot(6,1,6); ihist(b1);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -34) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
%            out = a1(98+1+640*6:2:98-1+640*7,1:2:500)';
            out = a1';
            figure(22); colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);
            
            subplot(5,1,[1:4])
            imshow(out,[0 16384],'InitialMagnification',200);
            title(['Odd rows Image #',num2str(nFrm)]);
            subplot(5,1,5); ihist(out);
%{
            figure(24); colormap('gray'); 
            gp=get(gcf,'position'); set(gcf,'position',[gp(1),gp(2),800,700]);

            b1 = a1(96+1+640*5:2:96+640*6,2:2:500)';
            subplot(5,1,[1:4])
            imshow(b1,[0 16384],'InitialMagnification',200);
            title(['Even Rows Image #',num2str(nFrm)]);
            subplot(5,1,5); ihist(b1);
%}                   
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -35) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 8;
            iend = 98-1+640*(iadc);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(98+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(6,1,[1:4])
            imshow(out,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(6,1,5); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);

            subplot(6,1,6); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            
            nFrm = nFrm +1;
            pause (1.5);
        end        

    elseif (nfunc == -350) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 6;
            iend = 98-1+640*(iadc);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(98+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
            
            f2=out;
%            f2((rem(out,4)==0 | rem(out,4)==3))=0;
            
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(5,1,[1:4])
            imshow(f2,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(5,1,5); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -650) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 7;
            iend = 98-1+640*(iadc);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(98+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
            
            f2=out;
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(5,1,[1:4])
            imshow(f2,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(5,1,5); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
    elseif (nfunc == -653) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 8;
            iend = 98-1+640*(iadc);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(98+1+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
            
            f2=out;
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(5,1,[1:4])
            imshow(f2,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(5,1,5); h1 = ihist(out); 
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
    elseif (nfunc == -6531) % grab single image and show
        nFrm = 0;
        i2=[5:8:320, 6:8:320, 7:8:320,8:8:320];
        i3=sort(i2);
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 5;
            iend = 98-3+640*(iadc);
            if (98-3+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(98-1+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
            
            f2=out;
            f3=f2(:,i3);
            
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            xrng = [0000 16384];
            subplot(4,1,[1,2]);
            imshow(f3,xrng,'InitialMagnification',200);
            title(sTitle11);
            subplot(4,1,3); h1 = ihist(f3); 
            xlim([10000 12000]);
            title(['Histogram Image #',num2str(nFrm)]);
            subplot(4,1,4); h1 = ihist(f3); 
            xlim(xrng);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
                
    elseif (nfunc == -351) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 6;
            ishift = 202;
            iend = ishift+7+640*(iadc-1);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(ishift+640*(iadc-1):2:iend,1001:2:3500)';  % even columns, odd rows
            
            f2=out;
            f2((rem(out,4)==0 | rem(out,4)==3))=0;
            
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(6,1,[1:4])
            imshow(f2,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(6,1,5); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);

            subplot(6,1,6); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -652) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            out = a1(1:2:end,1:2:end)';  % even columns, odd rows
%            out = a1';  % even columns, odd rows
            
            f2=out;
            
            figure(22); clf; colormap('gray'); 
            subplot(5,1,[1:4])
            imshow(f2,[0 16400],'InitialMagnification',200);
            title('Pre-datapath image');

            subplot(5,1,5); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -654) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

%            out = a1(end-300:end,end-150:end)';  % even columns, odd rows
            out1 = a1';  % even columns, odd rows
            
            out=out1(1:150,100:300);
            f2=out;
            
            figure(23); clf; colormap('gray'); 
            subplot(5,1,[1:4])
            imshow(f2,[0 16384],'InitialMagnification',100);
            title('Image Top');

            subplot(5,1,5); h1 = ihist(f2);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        

    elseif (nfunc == -6541) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

%            out = a1(end-300:end,end-150:end)';  % even columns, odd rows
            out1 = a1';  % even columns, odd rows
            
            out=out1(1:1,1:2:300);
            f2=out;
            
            figure(22); clf; colormap('gray'); 
            subplot(3,1,1)
            imshow(f2,[0 16384],'InitialMagnification',100);
            title('TestRow image');

            subplot(3,1,[2:3]); h1 = ihist(f2);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -6542) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            out = a1';  % even columns, odd rows
            f2=out;
            
            figure(22); clf; colormap('gray'); 
            subplot(3,1,1:2)
            imshow(f2,[0 16384],'InitialMagnification',100);
            title(['image#', num2str(nFrm)]);

            subplot(3,1,3); h1 = ihist(f2);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
        elseif (nfunc == -6543) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);
            adcNum = 4;
        if (adcNum < 10)
            iend = 98-1+640*(adcNum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a1(98+2+640*adcNum:2:iend,1,:);
        else if (adcNum >= 10) && (adcNum < 20)
            anum=adcNum-10;
            iend = 98-1+640*(anum+1);
            if (iend > sz(1)) iend = sz(1); end
            b1 = a1(98+2+640*anum:2:iend,1,:);
            end
        end            
%            out = a1(end-300:end,end-150:end)';  % even columns, odd rows
            out = b1';  % even columns, odd rows
            
%            out=out1(1:1,1:2:300);
            f2=out;
            
            figure(22); clf; colormap('gray'); 
            subplot(3,1,1)
            imshow(f2,[0 16384],'InitialMagnification',100);
            title('TestRow image');

            subplot(3,1,[2:3]); h1 = ihist(f2);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
    elseif (nfunc == -3510) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 6;
            ishift = 202;
            iend = ishift+7+640*(iadc-1);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(ishift+640*(iadc-1):2:iend,1001:2:3500)';  % even columns, odd rows
            f2=out;
            
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];
            figure(22); clf; colormap('gray'); 
            subplot(5,1,[1:4])
            imshow(f2,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(5,1,5); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            nFrm = nFrm +1;
            pause (1.5);
        end
        
        
    elseif (nfunc == -3514) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 6;
            ishift = 202;
            iend = ishift+7+640*(iadc-1);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out1 = a1(ishift+640*(iadc-1):2:iend,1001:2:3500)';  % even columns, odd rows
            
            f2=out1;
            f2_sz1=size(f2);
            f4=reshape(f2,1,f2_sz1(1)*f2_sz1(2));
            f2_sz=size(f2);
            f3=reshape(f2,1,f2_sz(1)*f2_sz(2));
            f3((rem(f3,4)==0 | rem(f3,4)==3))=[];
            mval=floor(double(mean(f3))/10)*10;   
%            m_area = 500; % area around mval where we expect histogram to show
%            f4(f4<mval-m_area | f4>mval+m_area)=[];

            figure(44); clf; colormap('gray'); 
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];
%            mval = 14200;
%            hist(double(f3-1),0:16384);
            [nout,xout] = hist(double(f4),0:16384);
            
%            bar(xout,nout); grid on;
            ax=gca; % 
            xmin = 12300; xmax = 12500; 
            ymax = 600; 
            bar(xout,nout); grid on;
            axis tight; axis([xmin xmax 0 ymax]); 
            xlim([xmin,xmax]); 
            ylim([0,ymax]);
            set(ax,'xtick',[mval-500:10:mval+500]);
            
            sTitle12 = sprintf([sTitle11,' std=%5.2f lsb'],std(double(f4)));
            title(sTitle12,'FontWeight','bold');
%            drawnow;
            pause (1.5);        
        end
        
        elseif (nfunc == -352) % grab ADC narrow vertical stripe and show
        nFrm = 1;
%        code='00';
%        code_step=4;
        fig = figure(22);
        
        % Set up the movie.
        aviobj = avifile('example4.avi','compression','None','quality',100,'fps',2);

        while(nFrm<20)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 6;
            ishift = 202;
            iend = ishift+7+640*(iadc-1);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out1 = a1(ishift+640*(iadc-1):2:iend,1001:2:3500)';  % even columns, odd rows
            
            f2=out1;
            f2_sz1=size(f2);
            f4=reshape(f2,1,f2_sz1(1)*f2_sz1(2));
            f2((rem(out1,4)==0 | rem(out1,4)==3))=0;
            f2_sz=size(f2);
            f3=reshape(f2,1,f2_sz(1)*f2_sz(2));
            f3((rem(f3,4)==0 | rem(f3,4)==3))=[];
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(fig); clf; colormap('gray'); 
            mval=floor(double(mean(f3))/10)*10;   
%            mval = 14200;
%            hist(double(f3-1),0:16384);
            [nout,xout] = hist(double(f3-1),0:16384);
            
%            bar(xout,nout); grid on;
            ax=gca; set(ax,'xtick',[mval-500:10:mval+500]);
%            ax.XAxis.TickLabelFormat = '%,.0f';
            xmin = 14100; xmax = 14400; 
            ymax = 600; 
            axis tight; axis([xmin xmax 0 ymax]); 
            bar(xout,nout); grid on;
            xlim([xmin,xmax]); 
            ylim([0,ymax]);
            title([sTitle11,' std=',num2str(std(double(f3)))]);
            xstr = xnCode(8,xmin,xmax-30); text(xmin+5,ymax-22,xstr); % x8
            xstr = xnCode(16,xmin,xmax); text(xmin+5,ymax-44,xstr); % x16
            xstr = xnCode(32,xmin,xmax); text(xmin+5,ymax-66,xstr); % x32
            xstr = xnCode(64,xmin,xmax); text(xmin+5,ymax-88,xstr); % x64
            xstr = xnCode(128,xmin,xmax); text(xmin+5,ymax-110,xstr); % x128
            drawnow;
%            out.F(nFrm) = getframe(fig);
%            frame = getframe;
            aviobj = addframe(aviobj,fig);
%            writeVideo(aviobj,out.F(nFrm));
            pause (1.5);
%            dcode=hex2dec(code);
%            dcode = dcode + code_step;
%            code = dec2hex(dcode,2);
%            v = evksetDac (['3b',code], s2);
            nFrm = nFrm +1;
        end      
   ffobj =  close(aviobj);
   
    elseif (nfunc == -355) % FULL SPEED grab single ADC and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            l_off = 634; 
            iadc = 6;
            iend = l_off-1+640*(iadc);
            if (l_off-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(l_off+2+640*(iadc-1):2:iend,1001:2:1500)';  % even columns, odd rows
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(6,1,[1:4])
            imshow(out,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(6,1,5); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);

            subplot(6,1,6); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
    elseif (nfunc == -359) % grab single Soutn hemisphere and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            sz=size(a1);

            iadc = 8;
            iend = 98-1+640*(iadc);
            if (98-1+640*(iadc) > sz(1)) iend = sz(1); end
            out = a1(98+2+640*(iadc-1):2:iend,1002:2:1500)';  % even columns, even rows
            sTitle11 = ['ADC#',num2str(iadc), ' evenC oddD'];

            figure(22); clf; colormap('gray'); 
            subplot(6,1,[1:4])
            imshow(out,[0 16384],'InitialMagnification',200);
            title(sTitle11);
            subplot(6,1,5); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram Img#',num2str(nFrm), ', "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);

            subplot(6,1,6); h1 = ihist(out);
            title(['Histogram Image #',num2str(nFrm)]);
            
            
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
    elseif (nfunc == -36) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(25); clf; colormap('gray'); 
            
%            imshow(a1',[0 16384],'InitialMagnification',20);
%            imcontrast;
            
            subplot(6,1,[1:5])
            imshow(a1',[0 16384],'InitialMagnification',200);
            title(['Image #',num2str(nFrm)] );
            subplot(6,1,6); h1_cor = ihistCor(a1);
            sTitle12 = ['Corrected histogram, "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        

    elseif (nfunc == -37) % grab image continuosly and show only one hemisphere
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(25); clf; colormap('gray'); 
            
%            imshow(a1',[0 16384],'InitialMagnification',20);
%            imcontrast;
            out = a1(2:2:end,1:2:end)';  % even columns, odd rows
            
            subplot(6,1,[1:5])
            imshow(out,[0 16384],'InitialMagnification',20);
            title(['Image #',num2str(nFrm), ' evenC oddD'] );
            subplot(6,1,6); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram, "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
    elseif (nfunc == -371) % grab image continuosly and show only one hemisphere
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(25); clf; colormap('gray'); 
            
%            imshow(a1',[0 16384],'InitialMagnification',20);
%            imcontrast;
            out = a1(2:2:end,1:2:end)';  % even columns, odd rows
            
            subplot(6,1,[1:5])
            imshow(out,[0 1384],'InitialMagnification',100);
            title(['Image #',num2str(nFrm), ' evenC oddD'] );
            subplot(6,1,6); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram, "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        

        
    elseif (nfunc == -38) % same as 37 but mask (with 0) displayed image bad pixels
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(25); clf; colormap('gray'); 
            
%            imshow(a1',[0 16384],'InitialMagnification',20);
%            imcontrast;
            out = a1(2:2:end,1:2:end)';  % even columns, odd rows
            f2=out;
            f2((rem(out,4)==0 | rem(out,4)==3))=0;
            
            subplot(6,1,[1:5])
            imshow(f2,[0 16384],'InitialMagnification',200);
            title(['Image #',num2str(nFrm), ' evenC oddD'] );
            subplot(6,1,6); h1_cor = ihistCor(out);
            sTitle12 = ['Corrected histogram, "good pixels"=', num2str(h1_cor.pctPixCorr,'%5.1f'),'%' ];
            title(sTitle12);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
    elseif (nfunc == -40) % grab image continuosly and show only one hemisphere
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(25); clf; colormap('gray'); 
            
%            imshow(a1',[0 16384],'InitialMagnification',20);
%            imcontrast;
%            out = a1(2:2:end,1:2:end)';  % even columns, odd rows
            out1 = a1';  % even columns, odd rows
            out = out1(1:400,1:600);
            
            subplot(6,1,[1:5])
            imshow(out,[0 1384],'InitialMagnification',20);
            title(['Image #',num2str(nFrm), ' evenC oddD'] );
            subplot(6,1,6); h1_cor = ihist(out);
            sTitle12 = ['Histogram, all pixels' ];
            title(sTitle12);
            
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
    elseif (nfunc == -23) % grab single image and show
        nFrm = 0;
        a1 = grab56_4links;
        while(1)
            a1 = grab56_4links;
            b1 = a1(628:2:659, 11:490);
%            b1 = a1(377:408, 11:490);
            out= b1';
            figure(22); colormap('gray'); imshow(out,[0 16384],'InitialMagnification',200);
%            imagesc(out);  
            figure(23); gp=get(gcf,'position');
            set(gcf,'position',[gp(1),gp(2),600,230]);
            ihist(out);
%            imcontrast;
            title(['Image #',num2str(nFrm)]);
            m1=mean2(out(:,1:8));m2=mean2(out(:,9:16));
%            sprintf('Avrages %.1f, %.1f', m1,m2)
            nFrm = nFrm +1;
            pause (1.5);
        end        
        
     elseif (nfunc == -13) % grab single image and show
        nFrm = 0;
        while(1)
            a1 = grab56_4links;
            figure(22); colormap('gray'); 
%            imshow(a1',[0 4384],'InitialMagnification',25);
            imshow(a1',[0 16384],'InitialMagnification',25);
            figure(23); gp=get(gcf,'position');
            set(gcf,'position',[gp(1),gp(2),600,230]);
            ihist(a1');
            
%            imcontrast
            title(['Image #',num2str(nFrm)]);
            nFrm = nFrm +1;
            pause (1.5);
        end
       
    elseif (nfunc == -4) % grab single image, subtract black, and show
        nFrm = 0;
        black = grab56_4links;
            figure(22); 
            imshow(black',[8000 16384],'InitialMagnification',25);
        while(1)
            pause (1.5);
            i1 = grab56_4links;
            a1 = i1-black + 1000;
            figure(22); 
            imshow(a1',[900 1100],'InitialMagnification',25);
            title(['Image #',num2str(nFrm)]);
            nFrm = nFrm +1;
        end
    elseif (nfunc == -5) % grab single ADC image, subtract black, and show 
        nFrm = 0;
        black = grab56_4links;
        b0 = black(1:2:540,1000:1200);
        figure(23); 
            imshow(b0',[980 1050],'InitialMagnification',200);
        while(1)
            pause (1.5);
            i0 = grab56_4links;
            i1 = i0(1:2:540,1000:1200);
            d1 = i1-b0 + 1000;
            figure(23); 
            imshow(d1',[980 1050],'InitialMagnification',200);
            title(['Image #',num2str(nFrm)]);
            imcontrast;
            nFrm = nFrm +1;
        end        
        
    elseif (nfunc == -6) % grab single ADC image, subtract black, and show 
        nFrm = 0;
        while(1)
            pause (1.5);
            d0 = grab56_4links;
            d1 = d0(1:2:540,1000:1200);
            figure(23); 
            imshow(d1',[0 16384],'InitialMagnification',200);
            title(['Image #',num2str(nFrm)]);
            imcontrast;
            nFrm = nFrm +1;
        end        
        
    elseif (nfunc == -7) % grab single ADC image, subtract black, and show 
        nFrm = 0;
        while(1)
            pause (1.5);
            d0 = grab56_4links;
            d1 = d0(1:2:1280,1000:1200);
            figure(23); 
            imshow(d1',[0 16384],'InitialMagnification',200);
            title(['Image #',num2str(nFrm)]);
   %         imcontrast;
            nFrm = nFrm +1;
        end  
    elseif (nfunc == -101) % grab 2 ADCs image, and show 
            pause (1.5);
            d0 = grab56_4links;
            d1 = d0(1:1280,1000:1400);
            figure(23); 
            imshow(d1',[0 16384],'InitialMagnification',200);
            imcontrast;
            
    elseif (nfunc == -102) % grab image, and show 
            pause (1.5);
            d1 = grab56_4links;
            figure(23); 
            imshow(d1',[0 16384],'InitialMagnification',50);
%            imcontrast;
    elseif (nfunc == -201) % grab 2 ADCs image, and show 
        nFrm = 0;
        while(1)
            pause (1.5);
            d0 = grab56_4links;
            d1 = d0(800:2:1480,1000:1400);
            figure(22); colormap('gray');
            out = d1';
            imshow(out,[0 16384],'InitialMagnification',200);
            ihist(out,23);
            title(['Image #',num2str(nFrm)]);
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
