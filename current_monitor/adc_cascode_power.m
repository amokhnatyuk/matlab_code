function out = adc_cascode_power( s2) 
% function performs random variation of Biasing DACs (reg.x92)

save_dir = 'C:\data\raijin_lot3\current_monitor\adc_cascode_curr\';
fSave = [save_dir, 'randCheck4.txt'];
    dataFormat = '%s\t %7.2f\n ';
    colHeadFormat = '%s\t %s\n ';
    desc = {'r.x92','VDDA_12'};

plist = [1,2,6,7,8,9,13,14];
vdda12_ind= find(plist==8);
figN = 77;
figure(figN); clf
vec_sz = 2; arrD = cell(1,vec_sz); % 
display_last = 100;
nUpdate = 50;
reg='0092';
regdflt='8888'; hval=regdflt;
jj=1;
while 1
    rval = randi(7,1,4)-4; % Random values [-3 3]
    for ii=1:4
        hval(ii) = dec2hex( hex2dec(regdflt(ii)) + rval(ii),1);
    end
    writeSensorReg( [reg, hval], s2);  pause(0.2);
% current measurement units
    figure(figN); 
    indexColors = 1; indexMarkers = 1; indexLines = 1;
    for ndev=1:length(plist)
        [c_mA(jj,ndev), sName{ndev}, htmp] = readI_revA(plist(ndev), s2);
        try delete(hh(ndev));
        catch ME
        end
        if jj<=display_last
            hh(ndev) = plot((1:jj),c_mA(1:jj,ndev), 'DisplayName',sName{ndev}); 
        else
            hh(ndev) = plot((jj-display_last:jj),c_mA(jj-display_last:jj,ndev), 'DisplayName',sName{ndev}); 
        end
        ylabel('currrent, mA')
        xlabel('clear window Hori_start position')
        
        [c, m, ls, indexColors, indexMarkers, indexLines] = ...
                    setColors (indexColors, indexMarkers, indexLines);
        set(hh(ndev),'Color',c,'Marker',m,'LineStyle',ls);
        hold on;
    end
%    hold off;
    drawnow
    hleg1 = legend ('show'); 
    set(hleg1,'Location','SouthWest')
    grid on;  
    
    vec{1} = hval; 
    vec{2} = c_mA(jj,vdda12_ind); 
    arrD(end+1,:) = vec;
    
            if (rem(jj,nUpdate)==0 )
                if (jj<= nUpdate)
                    appendArrtoFile(fSave, arrD, dataFormat,desc, colHeadFormat);
                else
                    appendArrtoFile(fSave, arrD, dataFormat);
                end
                arrD = cell(1,vec_sz); 
            end
    
    jj=jj+1;
    stitle4 = ['ADC current vs cascode DAC settings reg.x92'];
    title(stitle4); 
end
out.c_mA = c_mA;
out.sName = sName;
save(stitle4,'out','-v7.3');
saveas(figN, [save_dir, stitle4 ,'.jpg']);
saveas(figN, [save_dir, stitle4 ,'.fig']);
saveas(figN, [save_dir, stitle4 ,'.png']);
saveas(figN, [save_dir, stitle4 ,'.emf']);
end


function [c, m, ls, iC, iM, iL] = setColors (iC, iM, iL)
    C = {'k','b','r','g','m',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
    LS ={':','--','-.','-','--'};
    M ={'o','d','*','.','+'};

    c = C{iC};
    m = M{iM};
    ls = LS{iL};

    if iC < length(C)  iC = iC + 1;
    else   iC = 1;
    end
    
    if iM < length(LS) iM = iM + 1;
    else      iM = 1;
    end
    
    if iL < length(LS)  iL = iL + 1;
    else        iL = 1;
    end
end