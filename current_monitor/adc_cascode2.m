function out = adc_cascode2( s2) 
% function performs random variation of Biasing DACs (reg.x92)

save_dir = 'C:\data\raijin_lot3\current_monitor\adc_cascode2\1\';
if ~exist(save_dir, 'dir') mkdir(save_dir); end
%copyfile(['adc_cascode2.m'],save_dir);  % copy this file to dst folder

fSave = [save_dir, 'randCheck5.txt'];
    dataFormat = '%s\t %7.2f\t %7.2f\n ';
    colHeadFormat = '%s\t %s\t %s\n ';
    desc = {'r.x92','VDDA_12', 'quality'};

plist = [1,2,6,7,8,9,13,14];
vdda12_ind= find(plist==8);
figN = 77;
figure(figN); clf
figNum = 29; fig = figure(figNum);
iadc = 5; sTitle9 = ['ADC#',num2str(iadc)];
i2=[5:8:320, 6:8:320, 7:8:320,8:8:320];
i3=sort(i2);

vec_sz = 3; arrD = cell(1,vec_sz); % 
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
    
    a8 = igrab4(8);  % grab
    sz=size(a8);  %% 6400x4232x8

    iend = 98-3+640*(iadc);
    if (98-3+640*(iadc) > sz(1)) iend = sz(1); end
    out = a8(98-1+640*(iadc-1):2:iend,501:2:4200,:);  % even columns, odd rows

    f1=out;
    f2=f1(i3,:,:);
    f2_sz=size(f2);
    f3=double(reshape(f2,1,f2_sz(1)*f2_sz(2)*f2_sz(3)));
    mval=11000;   
    m_area = 1000; % area around mval where we expect histogram to show
    f3(f3<mval-m_area | f3>mval+m_area)=[];

    figure(fig); clf; colormap('gray'); 
    xrng = [10000 12000];
    [nout,xout] = hist(f3,xrng(1):xrng(2));
    xlim(xrng);

    ax=gca; % 
    xmin = mval - m_area; xmax = mval + m_area; 
    ymax = max(nout); 
    bar(xout,nout); grid on;
    axis tight; axis([xmin xmax 0 ymax]); 
    xlim([xmin,xmax]); 
    ylim([0,ymax]);
    stamp = curStamp( s2 );

    hnorm = nout/sum(nout);
    stdev(jj) = std(hnorm);
    sTitle10 = [sTitle9, ' #',num2str(jj-1)];
    sTitle11 = sprintf([sTitle10,', std=%6.5f rel.units'],stdev(jj));
    title(sTitle11,'FontWeight','bold');
    xlabel('Code, lsb'); ylabel('Occurrence');
    saveas(figNum,[save_dir, sTitle11, '.png']) 
    saveas(figNum,[save_dir, sTitle11, '.fig']) 
    pause (1.4);

    vec{1} = hval; 
    vec{2} = stamp.c_mA(vdda12_ind); 
    vec{3} = 1/stdev(jj); 
    arrD(end+1,:) = vec;
    c_mA(jj,:) = stamp.c_mA;
    
        if (rem(jj,nUpdate)==0 )
            if (jj<= nUpdate)
                appendArrtoFile(fSave, arrD, dataFormat,desc, colHeadFormat);
            else
                appendArrtoFile(fSave, arrD, dataFormat);
            end
            arrD = cell(1,vec_sz); 
        end

    figure(figNum+1); clf; 
    try delete(hh);
    catch ME
    end
    if jj<=display_last
        hh = plot((1:jj),1./stdev(1:jj)); grid on;
    else
        hh = plot((jj-display_last:jj),1./stdev(jj-display_last:jj)); grid on;
    end
    
    xlabel('selection progress'); ylabel('Code quality parameter, rel.units');
    jj=jj+1;
    stitle4 = ['ADC code quality vs cascode DAC settings reg.x92'];
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

