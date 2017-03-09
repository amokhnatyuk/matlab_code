function out = window_swp_power(win_width, seq, s2) 
% seq = [rstart:rstep:rend]; rstart=0; rend=10; rstep=1;  % decimal
% win_width = 120;
% example: 
% 1) out1=window_swp_power([14:4:777],s2);
% 2) win_wid = 100; out2=window_swp_power(win_wid,[14:8:787-win_wid],s2);
save_dir = 'C:\project\RaijinMat\matlab\current_monitor\win_adc_curr2\';
plist = [1,2,6,7,8,9,13,14];
vdda_12_ind= find(plist==8);
vdd_dig_ind= find(plist==14);
figN = 76;
C = {'k','b','r','g','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
LS ={':','--','-.','-','--'};
M ={'o','d','*','.','+'};
indexColors = 1; indexLines = 1; indexMarkers = 1;
hori_start_clear = '0800';
hori_stop_clear = '0801';
for jj=1:length(seq)
    rval = seq(jj);  % decimal
    hstart = [ hori_start_clear, dec2hex(rval,4)];
    hstop  = [ hori_stop_clear, dec2hex(rval+win_width,4)];
    writeSensorReg( hstart, s2);  pause(0.2);
    writeSensorReg( hstop, s2);  pause(0.2);
% current measurement units
    figure(figN); 
    indexColors = 1; indexMarkers = 1; indexLines = 1;
    for ndev=1:length(plist)
        [c_mA(jj,ndev), sName{ndev}, hval] = readI_revA(plist(ndev), s2);
        try delete(hh(ndev));
        catch ME
        end
        hh(ndev) = plot(seq(1:jj),c_mA(1:jj,ndev), 'DisplayName',sName{ndev}); 
% win_wid = 8; if ((rem((double(jj)-17),20 ) ==0)   && ... % {17,37,57, ...}     
% win_wid = 100;
    if ((rem((double(jj)-17),20 ) ==0)   && ... % {17,37,57, ...} 
            (ndev==vdda_12_ind || ndev==vdd_dig_ind))
        dI = c_mA(jj,ndev) - c_mA(jj-4,ndev);
        text(seq(jj),c_mA(jj,ndev)*1.05,['\Downarrow \delta I=',num2str(dI,3),'mA'])
%            annotation('textarrow',[0.3 0.5],[c_mA(jj,ndev) c_mA(jj,ndev)],'String',['\delta I=',num2str(dI),'mA']);
    end
        ylabel('currrent, mA')
        xlabel('clear window Hori_start position')
        ls = LS{indexLines};
        c = C{indexColors};
        m = M{indexMarkers};
        set(hh(ndev),'Color',c)
        set(hh(ndev),'Marker',m)
        set(hh(ndev),'LineStyle',ls)        
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
%    hold off;
    drawnow
    hleg1 = legend ('show'); 
    set(hleg1,'Location','SouthWest')
    grid on;  
end
stitle4 = ['ADC current vs ',num2str(win_width*8),'-cols window position'];
title(stitle4); 
out.c_mA = c_mA;
out.sName = sName;
out.seq = seq;
save(stitle4,'out','-v7.3');
saveas(figN, [save_dir, stitle4 ,'.jpg']);
saveas(figN, [save_dir, stitle4 ,'.fig']);
saveas(figN, [save_dir, stitle4 ,'.png']);
saveas(figN, [save_dir, stitle4 ,'.emf']);
end