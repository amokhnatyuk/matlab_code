function out = cfpn_mem_model_imgs (savedir, weight_current, pixval_shift_mem_bits)
% cfpn_mem_model_imgs (8,8)
% savedir = 'C:\data\cmodel\cfpn1\2\';
% im memory we store signed integer values of x_deviation in range [xmin,xmax]
% cfpn_row_bits = 5;
% weight_current = 14; % weight_current
% pixval_shift_mem_bits = 10;
% suffix _MO means matlab_only, because this is for evaluation and not for RTL

fn = 'seq_6dB_0_';
suffix = '.tif';
    jpg_dirSave = [savedir,'proc_jpg\'];
    fig_dirSave = [savedir,'proc_fig\'];
    emf_dirSave = [savedir,'proc_emf\'];
    if ~exist(savedir, 'dir') mkdir(savedir); end
    if ~exist(jpg_dirSave, 'dir') mkdir(jpg_dirSave); end
    if ~exist(fig_dirSave, 'dir') mkdir(fig_dirSave); end
    if ~exist(emf_dirSave, 'dir') mkdir(emf_dirSave); end
imdir = [savedir,'imgs\'];

cfpn_row_bits = 5;
mem_bits_used_to_sum_cfpn_rows= cfpn_row_bits+1; % because it is signed value

weight_total = 16;
weight_previous = weight_total - weight_current; % weight_previous
xlimit = 2^( cfpn_row_bits);

bits_to_correct_pixval_deviation = 10; % perform correction +/- pixval_maxdeviation
%pixval_maxdeviation is signed, therefore MSB bits_to_correct_pixval_deviation is sign
pixval_maxdeviation = 2^(bits_to_correct_pixval_deviation-1);

% we assume to use 
xmax = pixval_maxdeviation-1;
xmin = -pixval_maxdeviation+1;
total_mem_bits = pixval_shift_mem_bits + bits_to_correct_pixval_deviation;

maxFames = 40;
r_target = 120; % lsb;
cfpn_row_start = 553; % 7;  % 16;
cfpn_row_end =  890; %146;   % 77;  % the last visible CFPN row on the image is row 77
clear_vert_start = 1025;
clear_vert_margin = 64;
clear_hight = 1024;
clear_hor_start = 513;
clear_width = 2048;
up_thres = 160;
down_thres = 160;
vert_start = clear_vert_start+clear_vert_margin;
% cfpn_rows_num = 2^cfpn_row_bits;
cfpn_rows_num = length (cfpn_row_start:cfpn_row_end);

cfpn_mem =[];
y_lump(1:8, 1:floor((clear_hight+1)/2),1:floor((clear_width+1)/2))=0;
y_lump_cor(1:8, 1:floor((clear_hight+1)/2),1:floor((clear_width+1)/2))=0;
clear ctnVal ptnVal cfpnVal flutClearVal flutBlackColVal y_lump y_lump_cor;
ptn_y=0; ctn_y=0; ptn_y_cor=0; ctn_y_cor=0;
rtn_y = 0;  rtn_y_cor = 0; flutY=0;
fig_num=59; 
iFrames = 1;
while (iFrames<=maxFames)
    % array xlimit x 1000 of random integer [xmin,xmax] 
    % designed to achieve mean(x) = 0
    % y= round( pixval_std * randn(xlimit,1000)); % integer code
    
    y_arr = double(imread([imdir,fn,num2str(iFrames-1),suffix]));
      
    % CFPN array c_arr
    c_arr = double( y_arr(cfpn_row_start:2:cfpn_row_end,clear_hor_start:2:clear_hor_start+clear_width-1)); % CFPN corection array
    % TODO: remove 2max and 2 min from cfpn array
    sz_c = size(c_arr);
    
    rc_arr = double( y_arr(cfpn_row_start:2:cfpn_row_end,clear_hor_start-512:2:clear_hor_start-1)); % RTN corection array
    rc_cor = mean(rc_arr,2);
    rc_corr_arr = repmat(rc_cor,1,sz_c(2));
    
    % img clear_hight x clear_width
    y_all = double(y_arr(vert_start:vert_start+clear_hight-1,clear_hor_start:clear_hor_start+clear_width-1)); 
    y = double(y_all(1:2:end,1:2:end));  % take G1 pixels only
    sz_y=size(y);
    r_arr = y_arr(vert_start:vert_start+clear_hight-1,clear_hor_start-512:clear_hor_start-1); % RTN corection array
    r = r_arr(1:2:end,1:2:end);  % take G1 pixels only
    r_cor = mean(r,2) - r_target;
    rcorr_arr = repmat(r_cor,1,sz_y(2));
    
    cfpn_y1 = mean(y);
    tot_noise_y = std2(y); 
    cfpn_y = std (cfpn_y1);

    x= double(c_arr) - rc_corr_arr;   % x is deviation from row mean in col cor array, signed
    x(x>up_thres)=up_thres;
    x(x<-down_thres)=-down_thres;
    cfpn_x= mean(x);
    cfpn_calc= clipSigned (cfpn_x, bits_to_correct_pixval_deviation); % cfpn_x clipped
    if (iFrames==1)
        cfpn1 =  cfpn_calc;
    else
        cfpn_mem_shift_down = double(cfpn_mem) / 2^pixval_shift_mem_bits;
%{        
        corr_arr = repmat(cfpn_mem_shift_down,sz_c(1),1);
        xx= double(c_arr) - corr_arr - rc_corr_arr;
        z=xx; 
        z(z>up_thres)=up_thres;
        z(z<-down_thres)=-down_thres;
        cfpn_calc= mean(z + corr_arr);
%}        
    %    [vv,vi] = sort(c_arr); 
    %    c2 = vv(1:end-2,:);
        cfpn1 = (cfpn_mem_shift_down * weight_previous + ...
                       cfpn_calc * weight_current)/weight_total;
    end
    cfpn_yarr = repmat(cfpn1,sz_y(1),1);
    y_colcor = y -cfpn_yarr;
    y_corrected = y_colcor -rcorr_arr;
    ymean_MO = mean2(y);
    y_signed = y-ymean_MO; % y - c_mean; % subtract c_mean to get rid of flutter
    ycormean_MO = mean2(y_corrected);
%    y_lump_cor(iFrames,:,:) = y_corrected; % frames x rows x columns
    y_cor_signed = y_corrected - ycormean_MO; % y_corrected; % frames x rows x columns
    rtn_ycor = std(mean(y_corrected,2));

    if (iFrames ==1)
        y_lump_cor(iFrames,:,:) = double(y_cor_signed);
        y_lump(iFrames,:,:) = double(y_signed); 
    else
        if (iFrames<=8)
            y_lump_cor(iFrames,:,:) = y_cor_signed;
            yy= squeeze(std(y_lump_cor(1:iFrames,:,:)));
            c_aver = squeeze(mean(y_lump_cor,2));
            ctn_y_cor = sqrt(mean(std(c_aver(1:iFrames,:)).^2) );            
            r_aver = squeeze(mean(y_lump_cor,3));
            rtn_y_cor = sqrt(mean(std(r_aver(1:iFrames,:)).^2) );            
            
            y_lump(iFrames,:,:) = y_signed; 
            yy1= squeeze(std(y_lump(1:iFrames,:,:)));
            c_aver0 = squeeze(mean(y_lump,2));
            ctn_y = sqrt(mean(std(c_aver0(1:iFrames,:)).^2) );            
            r_aver0 = squeeze(mean(y_lump,3));
            rtn_y = sqrt(mean(std(r_aver0(1:iFrames,:)).^2) );            
        else % keeping only last 8 frames for CTN calculation
%            y_lump_cor(1:7,:,:) = y_lump_cor(2:8,:,:);
            y_lump_cor = circshift (y_lump_cor,1);
            y_lump_cor(8,:,:) = y_cor_signed; 
            yy= squeeze(std(y_lump_cor));
            c_aver = squeeze(mean(y_lump_cor,2));
            ctn_y_cor = sqrt(mean(std(c_aver).^2) );
            r_aver = squeeze(mean(y_lump_cor,3));
            rtn_y_cor = sqrt(mean(std(r_aver).^2) );
            
            y_lump(1:7,:,:) = y_lump(2:8,:,:);
            y_lump(8,:,:) = y_signed; 
            yy1= squeeze(std(y_lump));
            c_aver0 = squeeze(mean(y_lump,2));
            ctn_y = sqrt(mean(std(c_aver0).^2) );            
            r_aver0 = squeeze(mean(y_lump,3));
            rtn_y = sqrt(mean(std(r_aver0).^2) );            
        end
        tn_y = sqrt(mean2( yy1.^2 ));
        tn_y_cor = sqrt(mean2( yy.^2 ));
    end    
    
    cfpn_y_cor = mean(y_corrected);
    noise_y_cor = std2(y_corrected); 
    cfpn_y_cor = std (cfpn_y_cor);
    cfpnVal(iFrames) = cfpn_y_cor;
    ctnVal(iFrames) = ctn_y_cor;
    rtnVal(iFrames) = rtn_y_cor;
    meanClearVal(iFrames) = ycormean_MO;
    
    cfpnY(iFrames) = cfpn_y;
    ctnY(iFrames) = ctn_y;
    rtnY(iFrames) = rtn_y;
    meanClearY(iFrames) = ymean_MO;
    meanDarkRowsY(iFrames) = mean2(c_arr);
    if (iFrames >1)
        tnY(iFrames) = tn_y;
        flutY(iFrames) = std(meanClearY);
        ptnY(iFrames) = sqrt(tn_y^2 - ctn_y^2 -rtn_y^2 - flutY(iFrames)^2);
        tnVal(iFrames) = tn_y_cor;
        flutVal(iFrames) = std(meanClearVal);
        ptnVal(iFrames) = sqrt(tn_y_cor^2 - rtn_ycor^2 - ctn_y_cor^2 - flutVal(iFrames)^2);
        flutDarkRows(iFrames) = std(meanDarkRowsY);
    end

    figure(fig_num); clf
    subplot (4,3, 1:6)
    if iFrames>1
    stitle1 = {['Frame #',num2str(iFrames), ' Intial [lsb]: std = ',num2str(tot_noise_y),', ',...
            ' CFPN=',num2str(cfpn_y),', CTN=',num2str(ctn_y),', PTN=',num2str(ptnY(iFrames))], ...
            ['Corrected [lsb]: std = ',num2str(noise_y_cor),...
            ' CFPN=',num2str(cfpn_y_cor),', CTN=',num2str(ctn_y_cor),', PTN=',num2str(ptnVal(iFrames))]};
    imshow(y_corrected,[r_target+xmin/8 r_target+xmax/8]); colormap (gray); title(stitle1);
    end
    subplot (4,3,7)
    cfpn_mem_no_clip = cfpn1 * double(2^pixval_shift_mem_bits);
    cfpn_mem = round(cfpn_mem_no_clip);  % throw out residual   
    xhist_lo = ymean_MO-xmax/2; xhist_hi = ymean_MO+xmax/2;
    
    y_vec = reshape (y, 1, sz_y(1)*sz_y(2));
    [hh,xx]=hist(y_vec, xhist_lo:0.5: xhist_hi);
    bar(xx,hh); grid on;
    xlim([xhist_lo,xhist_hi]);
    stitle2 = ['Init. Hist., Noi=', num2str(std(tot_noise_y),4), 'lsb, CFPN=', num2str(cfpnY(iFrames),4), 'lsb'];
    title(stitle2);
    subplot (4,3,8)
    if iFrames>1
        plot(2:iFrames, flutY(2:iFrames), '-r', 'DisplayName','Flt Clear'); grid on; hold on;
        plot(2:iFrames, flutDarkRows(2:iFrames), '-m', 'DisplayName','Flt Dark'); 
        plot(2:iFrames,ctnY(2:end), '-g', 'DisplayName','CTN'); 
        plot(2:iFrames,rtnY(2:end), '-b', 'DisplayName','RTN'); 
        stitle3 = ['Orig img. Noise, w\_curr=',num2str(weight_current)];
        title(stitle3); legend ('show');
    end
    xlim([0,maxFames]);
    xlabel('frames'); ylabel('Noise, lsb');
    subplot (4,3,9)
    if iFrames>1
        plot(2:iFrames,tnY(2:end), '-r', 'DisplayName','TN'); grid on; hold on;
        plot(2:iFrames,ptnY(2:iFrames), '-b','DisplayName','PTN'); 
        stitle4 = ['PTN and Flutter vs frame#, PTN=',num2str(ptnY(iFrames),4),' lsb'];
        title(stitle4); legend ('show');
    end
    xlim([0,maxFames]);
    xlabel('frames'); ylabel('Noise, lsb');
    
    subplot (4,3,10)
    xhist_lo = ycormean_MO-xmax/8; xhist_hi = ycormean_MO+xmax/8;
    y_cor_vec = reshape (y_corrected, 1, sz_y(1)*sz_y(2));
    [hh,xx]=hist(y_cor_vec, xhist_lo:0.5: xhist_hi);
    bar(xx,hh); grid on;
    xlim([xhist_lo,xhist_hi]);
    stitle2 = ['Corrected Hist., Noi=', num2str(noise_y_cor,4), 'lsb'];
    title(stitle2);
    subplot (4,3,11)
    plot(cfpnVal, '-b', 'DisplayName','CFPN'); grid on; hold on;
    if iFrames>1
        plot(2:iFrames,ctnVal(2:iFrames), '--g', 'DisplayName','CTN'); grid on; hold on;
        plot(2:iFrames,rtnVal(2:iFrames), '-m', 'DisplayName','RTN'); 
        plot(2:iFrames, flutVal(2:iFrames), '-r', 'DisplayName','Flt Clear'); 
        legend ('show');
    end
    xlim([0,maxFames]);
    stitle3 = ['Corrected img: CN, RTN and Flutter'];
    title(stitle3); legend ('show');
    xlabel('frames'); ylabel('Noise, lsb');
    subplot (4,3,12)
    if iFrames>1
        plot(2:iFrames,tnVal(2:iFrames), '.r', 'DisplayName','TN'); grid on; hold on;
        plot(2:iFrames,ptnVal(2:iFrames), '-b','DisplayName','PTN'); 
        legend ('show');
        stitle4 = ['PTN and Flutter vs frame#'];
        title(stitle4);
    end
    xlim([0,maxFames]);
    xlabel('frames'); ylabel('Noise, lsb');    
    
    iFrames = iFrames +1;
end % while 1
fnsave= ['wc=',num2str(weight_current),'_memBits=',num2str(pixval_shift_mem_bits)];
saveas(fig_num,[jpg_dirSave,fnsave],'jpg');
saveas(fig_num,[fig_dirSave,fnsave],'fig');
saveas(fig_num,[emf_dirSave,fnsave],'emf');

out.cfpn_corrected_img = cfpnVal;
out.ctn_corrected_im = ctnVal;
out.rtn_corrected_im = rtnVal;
out.ptn_corrected_im = ptnVal;
out.tn_corrected_im = tnVal;
out.flut_corrected_im = flutVal;
    
out.cfpn_orig_img = cfpnY;
out.ctn_orig_img = ctnY;
out.rtn_orig_img = rtnY;
out.ptn_orig_img = ptnY;
out.tn_orig_img = tnY;
out.flut_orig_img = flutY;
out.flutDarkRows = flutDarkRows;

end
