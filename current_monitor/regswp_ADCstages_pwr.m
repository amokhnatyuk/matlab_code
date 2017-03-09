function regswp_ADCstages_pwr(sreg, s2,stitle3) 
% sreg = '0029' - string 4 alpha numerical values
% seq = [rstart:rstep:rend]; rstart=0; rend=10; rstep=1;  % decimal
plist = [1,2,6,7,8,9,13,14];
figN = 99;
C = {'k','b','r','g','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
LS ={':','--','-.','-','--'};
M ={'o','s','d','*','.','+'};
indexColors = 1; indexLines = 1; indexMarkers = 1;
% stitle3 = ['PGA PD Current measurement, reg. 0x',sreg];

rvarr(1,:) = {'0000','4000','8000','C000'};
rvarr(2,:) = {'0000','1000','2000','3000'};
rvarr(3,:) = {'0000','0400','0800','0C00'};
rvarr(4,:) = {'0000','0100','0200','0300'};
rvarr(5,:) = {'0000','0040','0080','00C0'};
rvarr(6,:) = {'0000','0010','0020','0030'};
rvarr(7,:) = {'0000','0004','0008','000C'};
rvarr(8,:) = {'0000','0001','0002','0003'};
dd = hex2dec(rvarr);
rv_sz = size(rvarr);
drv=reshape(dd,rv_sz(1),rv_sz(2));

for ii=1:rv_sz(1)
stitle4 = [ ' ADC\_stg=', num2str(ii), ' ', stitle3 ];
seq = [drv(ii,1),drv(ii,1),drv(ii,2),drv(ii,2),drv(ii,3),drv(ii,3),drv(ii,4),drv(ii,4)];
c_mA=0;
for jj=1:length(seq)
    rval = seq(jj);  % decimal
    hs = [ sreg, dec2hex(rval,4)];
    writeSensorReg( hs, s2);
    pause(1.0);
% current measurement units
    iFN = figN+ii;
    figure(iFN); clf
    for ndev=1:length(plist)
        [c_mA(jj,ndev), sName{ndev}, hval] = readI_revA(plist(ndev), s2);
        hh = plot(1:jj,c_mA(1:jj,ndev), 'DisplayName',sName{ndev}); 
        ylabel('currrent, mA')
        xlabel('register setting')
        ls = LS{indexLines};
        c = C{indexColors};
        m = M{indexMarkers};
        set(hh,'Color',c)
        set(hh,'Marker',m)
        set(hh,'LineStyle',ls)        %        if (ndev==1) 
        hold on; 
        if indexColors < length(C)  indexColors = indexColors + 1;
        else   indexColors = 1;
        end
        if indexMarkers < length(LS) indexMarkers = indexMarkers + 1;
        else      indexMarkers = 1;
        end
        if indexLines < length(LS)  indexLines = indexLines + 1;
        else        indexLines = 1;
        end
    end
%    drawnow
    grid on;   
end
for jj=1:length(seq)
    vdda12_ind= find(plist==8);
    if (jj==4 || jj==6 || jj==8)
        dI = c_mA(jj,vdda12_ind) - c_mA(jj-2,vdda12_ind);
        text(jj,c_mA(jj,vdda12_ind)*0.95,['\Uparrow \delta I=',num2str(dI),'mA'])
%            annotation('textarrow',[0.3 0.5],[c_mA(jj,ndev) c_mA(jj,ndev)],'String',['\delta I=',num2str(dI),'mA']);
    end
end    
    hleg1 = legend ('show'); 
    set(hleg1,'Location','West')
    title(stitle4); 
    ftitle = ['ADC_bias_0_1_2_3_vdda_12=1.3V_100MHz_ADCstg=', num2str(ii) ];
    xlim([1,length(seq)+1])
    saveas(iFN, [ftitle,'.fig']);saveas(iFN, [ftitle,'.jpg']);saveas(iFN, [ftitle,'.png']);
end

end