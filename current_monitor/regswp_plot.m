function out = regswp_plot(sreg, seq, s2,stitle3, figN) 
% sreg = '0029' - string 4 alpha numerical values
% seq = [rstart:rstep:rend]; rstart=0; rend=10; rstep=1;  % decimal
% example:
% regswp_power('0801',[hex2dec('313'),hex2dec('313'),hex2dec('13'),hex2dec('13'),hex2dec('313'),hex2dec('313')], s2,'windowing',77)
% figN = 77;
plist = [1,2,6,7,8,9,13,14];
C = {'k','b','r','g','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
LS ={':','--','-.','-','--'};
M ={'o','s','d','*','.','+'};
indexColors = 1; indexLines = 1; indexMarkers = 1;
% stitle3 = ['PGA PD Current measurement, reg. 0x',sreg];
for jj=1:length(seq)
    rval = seq(jj);  % decimal
    hs = [ sreg, dec2hex(rval,4)];
    writeSensorReg( hs, s2);
    pause(1.0);
% current measurement units
    figure(figN); clf
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
    drawnow
    grid on; legend ('show');    
end
    title(stitle3); 
    out.c_mA = c_mA;
    out.sName = sName;
end