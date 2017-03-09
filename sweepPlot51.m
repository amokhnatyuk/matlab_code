function rms_rgain = sweepPlot51(ar1, figN, dirSave, prefix)
% ar1 - struct produced in sweep_cbgain2 procedure
%dirSave = 'c:/data/lot1_/';
sTitle1 = '';
dirSavePlots =  [dirSave, prefix, ' '];
iadcMax = length(ar1(1).d(1,:,1));
ar1sz = length(ar1);
iOddCol=2;
rms_rgain = [];  
    for iadc = 1:iadcMax
        x1=[]; y2=[]; y3=[]; y4=[]; y6=[]; % clean arrays
        x1(1:ar1sz)=0; y2(1:ar1sz)=0; y3(1:ar1sz)=0; y4(1:ar1sz)=0; y6(1:ar1sz)=0;
        for ii=1:length(ar1)
            nadc = ar1(ii).adcList(iadc);
            x1(ii) = ar1(ii).v_dac;
            y2(ii) = ar1(ii).d(2,iadc,iOddCol); % frame adc average
            y3(ii) = ar1(ii).d(3,iadc,iOddCol); % frame adc temp.noise
            y4(ii) = ar1(ii).d(4,iadc,iOddCol); % frame adc good pixels
%                y5(ii) = ar1(ii).v_measur;
            col_sz = length(ar1(1,ii).h1(iadc,iOddCol).fpn_cavgs);
            y6(ii,1:col_sz) = ar1(1,ii).h1(iadc,iOddCol).fpn_cavgs;
            if (nadc < 10) 
                if (iOddCol == 1)
                    sTitle1 = ['ADC#',num2str(nadc), ' oddC evenR'];
                else
                    sTitle1 = ['ADC#',num2str(nadc), ' evenC oddR'];
                end
            elseif ((nadc >= 10) && (nadc < 20))
                if (iOddCol == 1)
                    sTitle1 = ['ADC#',num2str(nadc), ' oddC oddR'];
                else
                    sTitle1 = ['ADC#',num2str(nadc), ' evenC evenR'];
                end
            end
        end
        figure(figN); clf
        subplot(2,2,1)
            plot(x1,y2,'b','DisplayName', 'mean, lsb'); hold on; grid on; 
            [y_, p, rng] = calcAssimptote(x1,y2);
            plot(x1,y_,'-r','DisplayName', 'assymptote');
            ylim([0, 16384]);
            legend('show','Location','East');
            title(sprintf([sTitle1, ' ', prefix]));
            xlabel('DAC Voltage, mV')
            ylabel('ADC code, lsb')
        subplot(2,2,2)
            plot(x1,y2-y_,'r','DisplayName', 'deviation from linear, lsb'); hold on; grid on; 
            ylim([-64, 100]);
            legend('show','Location','SouthEast');
            title('CB+LD+PGA+ADC nonlinearity, lsb')
            xlabel('DAC Voltage, mV')
            ylabel('ADC code, lsb')
        subplot(2,2,3)
            plot(x1,y3,'g','DisplayName', 'TN corrected,lsb'); hold on; grid on; 
            ylim([0, 50]);
            legend('show');
            title('Temporal Noise')
            xlabel('DAC Voltage, mV')
            ylabel('ADC code, lsb')
        subplot(2,2,4)
            plot(x1,y4,'m','DisplayName', 'good pixels, %');  grid on; 
            ylim([0, 100]);
            legend('show');
            xlabel('DAC Voltage, mV')
            ylabel('good pixels, %')
        saveas(figN,[dirSavePlots, sTitle1, '.jpg'])                        
%{                
        figure(figN+1); clf
            plot(1:length(y6(ii,:)),y6(ii,:),'g','DisplayName', 'Col.Aver.deviation, lsb'); hold on; grid on; 
%                ylim([0, 50]);
            legend('show');
            title('Column Average Deviation')
            xlabel('Column number')
            ylabel('ColAvg deviation, lsb')
            sTitle2= [sTitle1,'_col.avg'];
        saveas(figN+1,[dirSavePlots, sTitle2, '.jpg'])                        
%}
        % here we calculate gain Deviation for each column
        % pp(1,:) array holds column averages gain Deviation coefficients
        [yy, pp, rms_var(iadc)] = calcAssimptote2(x1,y6,rng);
        rms_rgain(iadc)=rms_var(iadc)/abs(p(1))*100; % gain Deviation RMS in %
        figure(figN+3); clf
        sTitle3= [sTitle1,' Column Gain Deviation', ' @', prefix];
 %       annotation('textbox', [0 0.9 1 0.1], 'String', sTitle3,'EdgeColor', 'none','HorizontalAlignment', 'center')
        subplot(2,1,1)
        gg=pp(1,:)/p(1)*100; % gain Deviation in %
        plot(1:col_sz,gg,'g','DisplayName', 'Col.gain'); hold on; grid on; 
        legend('show','location', 'NorthWest');
        title(sprintf(sTitle3));
        xlabel('Column number')
        ylabel('Column gain deviation, %')
        subplot(2,1,2)
        gmin = min(gg); gmax = max(gg);
        xg=linspace(gmin,gmax,col_sz);  % vector length is col_sz
        plot(xg,hist(gg,col_sz),'g','DisplayName', ['RMS deviation=',num2str(rms_rgain(iadc),2)]); grid on;
        legend('show','location', 'NorthWest');
        xlim([gmin, gmax]);
        title('Gain Deviation Histogram')
        xlabel('Gain Deviation, %')
        ylabel('Occurrence');
%{
        subplot(2,2,3)
        yrep = repmat(y_',length(y_),col_sz);
        plot(1:length(pp(2,:))/p(2),'g','DisplayName', 'Col.offset'); hold on; grid on; 
        legend('show');
        title('Column Offset Deviation')
        xlabel('Column number')
        ylabel('Column Offset, lsb')
%}
        saveas(figN+3,[dirSavePlots, sTitle1, ' Col.gain deviation.jpg'])                        
    end
end
%%
function [y1,p, range] = calcAssimptote(x,y)
% x,y must be vectors same dimension
% assimptote relies on decreasing portion of cuve approximation
sz = length(y);
sz2=floor(sz/2);
[ymax, imax] = max(y(1:sz2));
[ymin, imin] = min(y(sz2:end));
imin = imin +sz2-1; % corecion for counting from middle of array
range = [];
if ((imax<imin) && (imin-imax>2)) range = imax+1:imin-1;
else
    y1=y; 
    return;
end
    xx= x(range);
    yy = y(range); 
    xx(isnan(yy)) =[]; % excluding NaN from xx-array
    yy(isnan(yy)) =[]; % excluding NaN from yy-array
    if length(yy)>=2
        p=polyfit(xx,yy,1);
        y1=p(1)*x+p(2);
    else
        p=NaN; y1=NaN;
    end
end

function [y1,p,rms_var] = calcAssimptote2(x,y,rng)
% x,y(:,1) must be vectors same dimension;
% y - is matrix of gain Deviation, where 2nd dimension is number of columns 1:ncol
% assimptote relies on decreasing portion of cuve approximation
% rng - is range of x-values used to calculate polyfit in calcAssimptote function
sz = size(y);
sz2=floor(sz(1)/2);
%{
[ymax, imax] = max(y(1:sz2,:),[],1);
[ymin, imin] = min(y(sz2:end,:),[],1);
imin = imin +sz2-1; % corecion for counting from middle of array
xrng(1,:)=imax+1;  %
xrng(2,:)=imin-1;
%}
    xrng=rng;  %
    gmargin = 5; % provide margin for gain Deviation if number of linear point greater or equal gmargin
    if (length(xrng) >= gmargin)  xrng=xrng(2:end-1);  end

    p(1:2,1:sz(2))=0;
    y1(1:sz(1),1:sz(2))=0; 
    x_= x(xrng);
    g_variance=0; isum=0;
    if length(x_)>=2
        for ii=1:sz(2)
            xx= x_;
            yy = y(xrng,ii)'; 
            xx(isnan(yy)) =[]; % excluding NaN from xx-array
            yy(isnan(yy)) =[]; % excluding NaN from yy-array
            if length(xx)>=2
                p(:,ii)=polyfit(xx,yy,1);
                y1(:,ii)=p(1,ii)*x'+p(2,ii);
                g_variance= g_variance + p(1,ii)^2; 
                isum=isum+1;
            else
                p(:,ii)=NaN; y1(:,ii)=NaN;
            end
        end
    else
        p(:,ii)=NaN; y1(:,ii)=NaN;
    end
    rms_var = sqrt(g_variance/isum);
end