figN = 71;
save_dir = 'C:\data\raijin_lot3\current_monitor\old_new_bias\';
fig_dir = [save_dir,'figs\'];
if ~exist(save_dir, 'dir') mkdir(save_dir); end
if ~exist(fig_dir, 'dir') mkdir(fig_dir); end
maxBiasSetting = 15;
plist = [1,2,6,7,8,9,13,14];
vdda12_ind= find(plist==8);
ii_noPD = 2; ii_PD = 4;

for jj=1:2  % ADC (1); PGA (2)
    switch jj 
        case 1  % ADC PD
            dval(jj) = 32; sdev{jj} = 'ADC PD Current ';
        case 2   % PGA PD
            dval(jj) = 64; sdev{jj} = 'PGA PD Current ';
    end
    indexColors = 1; indexMarkers = 1; indexLines = 1;
    for kk=1:2  % old bias (1); new bias (2)
        switch kk 
            case 1 
                writeSensorReg( '090a0000', s2);
                s_new_old ='Old'; 
            case 2
                writeSensorReg( '090a0001', s2);
                s_new_old ='New'; 
        end
        for ii=1:maxBiasSetting+1 
            sbias{kk}=[s_new_old,' bias=',num2str(ii)];
            
            hval = dec2hex([5+16*(ii-1)],4);
            writeSensorReg( ['091c', hval], s2);

            stitle4{jj,kk} = [sdev{jj},sbias{kk},];
            out(ii,jj,kk) = regswp_plot('0060',[0,0,dval(jj),dval(jj),0,0], s2, ... 
                [stitle4{jj,kk},', reg.0x60 mod.'], figN);
            cur_pd(ii,jj,kk) =out(ii,jj,kk).c_mA(ii_noPD,vdda12_ind) - ...
                 out(ii,jj,kk).c_mA(ii_PD,vdda12_ind);
            save([fig_dir,stitle4{jj,kk}],'out','-v7.3'); 

            saveas(figN, [fig_dir, stitle4{jj,kk} ,'.jpg']);
            saveas(figN, [fig_dir, stitle4{jj,kk} ,'.fig']);
            saveas(figN, [fig_dir, stitle4{jj,kk} ,'.png']);
            saveas(figN, [fig_dir, stitle4{jj,kk} ,'.emf']);
        end
    
        figR=35;
        figure(figR); 
        cur_pd(:,jj,kk) = cur_pd(:,jj,kk);
        hh = plot(0:maxBiasSetting,cur_pd(:,jj,kk), 'DisplayName',[s_new_old,' bias']); 
        grid on; hold on;
        [c, m, ls, indexColors, indexMarkers, indexLines] = ...
                    setColors (indexColors, indexMarkers, indexLines);
        set(hh,'Color',c,'Marker',m,'LineStyle',ls);
        
        xlabel('Register x91C[7:4]'); ylabel('Current, mA');
        stitle5 = [sdev{jj}, 'Old vs New bias'];
        title(stitle5);

    end
    hleg12 = legend ('show'); set(hleg12,'Location','South')    
    saveas(figR, [save_dir, stitle5 ,'.jpg']);
    saveas(figR, [save_dir, stitle5 ,'.fig']);
    saveas(figR, [save_dir, stitle5 ,'.png']);
    saveas(figR, [save_dir, stitle5 ,'.emf']);
    figure(figR); clf

end
save([save_dir,'Old vs New bias'],'cur_pd','out','-v7.3'); 

