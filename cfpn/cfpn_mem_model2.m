function out = cfpn_mem_model2 (savedir, weight_current, pixval_shift_mem_bits)
% cfpn_mem_model2 (savedir, 8,8)
% savedir = 'C:\data\cmodel\cfpn1\5\';
% im memory we store signed integer values of x_deviation in range [xmin,xmax]
% weight_current = 14; % weight_current
% pixval_shift_mem_bits = 10;
% suffix _MO means matlab_only, because this is for evaluation and not for RTL
%
%Area1   | Area 2 (Dcols)
%--------|-----------
%Area3   | Area 4 (Clear)
%(Drows) |
     
%fn_prefix = 'seq_6dB_0_';
fn_prefix = 'seq_6dB_0_';
suffix = '.tif';
    jpg_dirSave = [savedir,'proc_jpg\'];
    fig_dirSave = [savedir,'proc_fig\'];
    emf_dirSave = [savedir,'proc_emf\'];
    summary_dirSave = [savedir,'summary\'];
    if ~exist(savedir, 'dir') mkdir(savedir); end
    if ~exist(jpg_dirSave, 'dir') mkdir(jpg_dirSave); end
    if ~exist(fig_dirSave, 'dir') mkdir(fig_dirSave); end
    if ~exist(emf_dirSave, 'dir') mkdir(emf_dirSave); end
    if ~exist(summary_dirSave, 'dir') mkdir(summary_dirSave); end
imdir = [savedir,'imgs\'];

% cfpn_row_bits = 5;
% mem_bits_used_to_sum_cfpn_rows = cfpn_row_bits+1; % because it is signed value
% cfpn_rows_num = 2^cfpn_row_bits;

weight_total = double(16);
weight_previous = weight_total - double(weight_current); % weight_previous

bits_to_correct_pixval_deviation = 10; % perform correction +/- pixval_maxdeviation
%pixval_maxdeviation is signed, therefore MSB bits_to_correct_pixval_deviation is sign
pixval_maxdeviation = 2^(bits_to_correct_pixval_deviation-1);

% we assume to use 
xmax = pixval_maxdeviation-1;
xmin = -pixval_maxdeviation+1;
total_mem_bits = pixval_shift_mem_bits + bits_to_correct_pixval_deviation;

maxFames = 40;
r_target = 120; % lsb;
r_cold = 1; r_hot=3;
cfpn_row_start = 7; % 553; % 7;  % 16;
cfpn_row_end =  134;% 890; %146;   % 77;  % the last visible CFPN row on the image is row 77
dark_cols_start = 5;
dark_cols_lnoise = 192;
clear_vert_start = 1025;
clear_vert_margin = 64;
clear_hight = 1024;
clear_hor_start = 513;
clear_width = 2048;
up_thres = 92;
down_thres = 92;
vert_start = clear_vert_start+clear_vert_margin;
cfpn_rows_num = length (cfpn_row_start:cfpn_row_end);

clear ctnVal ptnVal cfpnVal flutClearVal flutBlackColVal y_lump y_lump_cor c_lump;
cfpn_mem =[];
max_statsFrms = 8; % number shows how many frames we store im matlab 3D array to calculate frames statistics
%y_lump(1:max_statsFrms, 1:floor((clear_hight+1)/2),1:floor((clear_width+1)/2))=0;
%y_lump_cor(1:max_statsFrms, 1:floor((clear_hight+1)/2),1:floor((clear_width+1)/2))=0;
%c_lump(1:max_statsFrms,  1:(cfpn_row_end-cfpn_row_start+1)/2, 1:floor((clear_width+1)/2) )=0;

fig_num=73; 
iFrames = 1;
while (iFrames<=maxFames)
    
    y_arr = double(imread([imdir,fn_prefix,num2str(iFrames-1),suffix]));
      
    % CFPN array c_arr (Area2)
    c_arr = y_arr(cfpn_row_start:2:cfpn_row_end,clear_hor_start:2:clear_hor_start+clear_width-1); % CFPN corection array
    % TODO: remove 2max and 2 min from cfpn array
    sz_c = size(c_arr);
    
    % area 1 array
    rc1 = y_arr(cfpn_row_start:cfpn_row_end,dark_cols_start:dark_cols_start +dark_cols_lnoise-1); % RTN corection array 192 rows
    rc_arr = rc1(1:2:end,1:2:end);
    rc_arr_meanr = mean(rc_arr,2);  % area1 row averages
    rc_arr_meanr_rep = repmat(rc_arr_meanr,1,sz_c(2)); % row averages replicatd to appy to area2
    rc_arr_meanc = mean(rc_arr,1);  % area1 row averages
    rc_arr_mean2= mean2(rc_arr);
    
    % img clear_hight x clear_width
    y_all = double(y_arr(vert_start:vert_start+clear_hight-1,clear_hor_start:clear_hor_start+clear_width-1)); 
    y = double(y_all(1:2:end,1:2:end));  % take G1 pixels only
    sz_y=size(y);
    % area 3 dark cols used for row corrections for clear pixels
    r_arr = y_arr(vert_start:vert_start+clear_hight-1,dark_cols_start:dark_cols_start +dark_cols_lnoise-1); % RTN corection array
    r = r_arr(1:2:end,1:2:end);  % take G1 pixels only

    % row hot clip calculation
    rc_arr_meanc_rep = repmat(rc_arr_meanc,sz_y(1),1); % col averages replicatd to appy to area3
    r_arr_corc = r - rc_arr_meanc_rep + rc_arr_mean2;
%    r_arr_corc = r - rc_arr_meanc_rep;
    [r_sort, r_ix] = sort(r_arr_corc,2);
%    for mm=[1:size(r_ix,1)]
%        hc(mm,:) = r(mm,r_ix(mm,:));
%    end
%    r_hclip = hc(:,r_cold+1:end-r_hot);
    r_hclip = r_sort(:,r_cold+1:end-r_hot);
    
    r_cor = mean(r_hclip,2) - r_target; 
    rcorr_arr = repmat(r_cor,1,sz_y(2));  % correction user for clear pixels
    y_rowcor = y -rcorr_arr;
    
    x= double(c_arr) - rc_arr_meanr_rep;   % x is deviation from row mean in col cor array, signed
%{    
    if (iFrames==1)
        x_thres_substitute = 0;
        x(x>up_thres)   =x_thres_substitute;
        x(x<-down_thres)=x_thres_substitute;
    else
        cfpn_mem_shift_down = double(cfpn_mem) / 2^pixval_shift_mem_bits;
        x_thres_substitute = repmat(cfpn_mem_shift_down,sz_c(1),1);
        x(x>up_thres)   = x_thres_substitute(x>up_thres);
        x(x<-down_thres)= x_thres_substitute(x<-down_thres);
    end
%}    
%        x(x>up_thres)   =up_thres;
%        x(x<-down_thres)=-down_thres;
    cfpn_x= mean(x);
    cfpn_calc= clipSigned (cfpn_x, bits_to_correct_pixval_deviation); % cfpn_x clipped
    if (iFrames==1)
        cfpn1 =  cfpn_calc;
    else
        cfpn_mem_shift_down = double(cfpn_mem) / 2^pixval_shift_mem_bits;
%{        
        corr_arr = repmat(cfpn_mem_shift_down,sz_c(1),1);
        xx= double(c_arr) - corr_arr - rc_arr_meanr_rep;
        z=xx; 
        z(z>up_thres)=up_thres;
        z(z<-down_thres)=-down_thres;
        cfpn_calc= mean(z + corr_arr);
%}        
    %    [vv,vi] = sort(c_arr); 
    %    c2 = vv(1:end-2,:);
        cfpn_mem_rep = repmat (cfpn_mem_shift_down,size(x,1),1);
        x_mem = x-cfpn_mem_rep;
        x(x_mem >up_thres)   = up_thres;
        x(x_mem <-down_thres)= 0;
        cfpn_x= mean(x);
        cfpn_calc= clipSigned (cfpn_x, bits_to_correct_pixval_deviation); % cfpn_x clipped
    
    
        cfpn1 = (cfpn_mem_shift_down * weight_previous + ...
                       cfpn_calc * double(weight_current))/weight_total;
    end
    cfpn_yarr = repmat(cfpn1,sz_y(1),1);
%{    
    g_conv =[0.1; 0.2; 0.3; 0.4];
    y_rowcor2 = conv2(y_rowcor,g_conv);
    y_rowcor3 = y_rowcor2(4:end,:);
    y_rowcor3(end-2,:) = y_rowcor(end-2,:);
    y_rowcor3(end-1,:) = y_rowcor(end-1,:); y_rowcor3(end,:) = y_rowcor(end,:);
    y_corrected = y_rowcor3 -cfpn_yarr;
%}    
    y_corrected = y_rowcor -cfpn_yarr;

    if (iFrames<=max_statsFrms)
        y_lump_cor(iFrames,:,:) = double(y_corrected);
        y_lump(iFrames,:,:) = double(y); 
        c_lump(iFrames,:,:) = double(c_arr);
        istatFrm = iFrames;
    else % keeping only last max_statsFrms frames for CTN calculation
%            y_lump_cor(1:max_statsFrms-1,:,:) = y_lump_cor(2:max_statsFrms,:,:);
        y_lump_cor = circshift (y_lump_cor,1);
        y_lump_cor(max_statsFrms,:,:) = double(y_corrected); 

        y_lump(1:max_statsFrms-1,:,:) = y_lump(2:max_statsFrms,:,:);
        y_lump(max_statsFrms,:,:) = double(y); 

        c_lump(1:max_statsFrms-1,:,:) = c_lump(2:max_statsFrms,:,:);
        c_lump(max_statsFrms,:,:) = double(c_arr);
        istatFrm = max_statsFrms; % because in stats we hold only max_statsFrms frames
    end
    ycor_stats = img_stats(y_lump_cor);
    y_stats = img_stats(y_lump);
    c_stats = img_stats(c_lump);
    
    cfpnVal(iFrames) = ycor_stats.cfpn;
    ctnVal(iFrames) = ycor_stats.ctn;
    rtnVal(iFrames) = ycor_stats.rtn;
    meanClearVal(iFrames) = ycor_stats.frm_aver2(end);
    
    cfpnY(iFrames) = y_stats.cfpn;
    ctnY(iFrames) = y_stats.ctn;
    rtnY(iFrames) = y_stats.rtn;
    meanClearY(iFrames) = y_stats.frm_aver2(end);

    meanDarkRowsY(iFrames) = c_stats.frm_aver2(istatFrm);
    flutDarkRows(iFrames) = c_stats.flut;
    if (iFrames >1)
        tnY(iFrames) = y_stats.tn;
        flutY(iFrames) = y_stats.flut;
        ptnY(iFrames) = y_stats.ptn;
        tnVal(iFrames) = ycor_stats.tn;
        flutVal(iFrames) = ycor_stats.flut;
        ptnVal(iFrames) = ycor_stats.ptn;
    end

    figure(fig_num); clf
    subplot (4,3, 1:6)
    if iFrames>1
    stitle1 = {['Frame #',num2str(iFrames), ' Original [lsb]: PFPN=',num2str(y_stats.pfpn), ...
       ', CFPN=',num2str(y_stats.cfpn,4), ', RFPN=',num2str(y_stats.rfpn,4), ... 
       ', PTN=',num2str(y_stats.ptn,4), ', CTN=',num2str(y_stats.ctn,4), ', RTN=',num2str(y_stats.rtn,4)], ...
       ['Corrected [lsb]: PFPN = ',num2str(ycor_stats.pfpn),...
       ' CFPN=',num2str(ycor_stats.cfpn,4), ', RFPN=',num2str(ycor_stats.rfpn,4), ...
       ', PTN=',num2str(ycor_stats.ptn,4), ', CTN=',num2str(ycor_stats.ctn,4),', RTN=',num2str(ycor_stats.rtn,4)]};
    imshow(y_corrected,[r_target+xmin/8 r_target+xmax/8]); colormap (gray); title(stitle1);
    end
    subplot (4,3,7)
    cfpn_mem_no_clip = cfpn1 * double(2^pixval_shift_mem_bits);
    cfpn_mem = round(cfpn_mem_no_clip);  % throw out residual   
    xhist_lo = meanClearY(iFrames)-xmax/2; xhist_hi = meanClearY(iFrames)+xmax/2;
    
    y_vec = reshape (y, 1, sz_y(1)*sz_y(2));
    [hh,xx]=hist(y_vec, xhist_lo:0.5: xhist_hi);
    bar(xx,hh); grid on;
    xlim([xhist_lo,xhist_hi]);
    stitle2 = ['Orig. Hist., Noi=', num2str(y_stats.totn,4), 'lsb, CFPN=', num2str(y_stats.cfpn,4), 'lsb'];
    title(stitle2);
    subplot (4,3,8)
    if iFrames>1
        plot(2:iFrames, flutY(2:iFrames), '.r', 'DisplayName','Flt Clear'); grid on; hold on;
        plot(2:iFrames, flutDarkRows(2:iFrames), '-m', 'DisplayName','Flt Dark'); 
        plot(2:iFrames,ctnY(2:end), '-g', 'DisplayName','CTN'); 
        plot(2:iFrames,rtnY(2:end), '-b', 'DisplayName','RTN'); 
        stitle3 = ['Orig img. Noise, w\_curr=',num2str(weight_current)];
        title(stitle3); 
        hleg8 = legend ('show'); set(hleg8,'Location','South')        
    end
    xlim([0,maxFames]);
    xlabel('frames'); ylabel('Noise, lsb');
    subplot (4,3,9)
    if iFrames>1
        plot(2:iFrames,tnY(2:end), '-r', 'DisplayName','TN'); grid on; hold on;
        plot(2:iFrames,ptnY(2:iFrames), '-b','DisplayName','PTN'); 
        stitle4 = ['Orig. TN and PTN, PTN=',num2str(ptnY(iFrames),4),' lsb'];
        title(stitle4); 
        hleg9 = legend ('show'); set(hleg9,'Location','South')        
    end
    xlim([0,maxFames]);
    xlabel('frames'); ylabel('Noise, lsb');
    
    subplot (4,3,10)
    xhist_lo = meanClearVal(iFrames)-xmax/8; xhist_hi = meanClearVal(iFrames)+xmax/8;
    y_cor_vec = reshape (y_corrected, 1, sz_y(1)*sz_y(2));
    [hh,xx]=hist(y_cor_vec, xhist_lo:0.5: xhist_hi);
    bar(xx,hh); grid on;
    xlim([xhist_lo,xhist_hi]);
    stitle2 = ['Corrected Hist., Noi=', num2str(ycor_stats.totn,4), 'lsb'];
    title(stitle2);
    subplot (4,3,11)
    plot(cfpnVal, '-b', 'DisplayName','CFPN'); grid on; hold on;
    if iFrames>1
        plot(2:iFrames,ctnVal(2:iFrames), '--g', 'DisplayName','CTN'); grid on; hold on;
        plot(2:iFrames,rtnVal(2:iFrames), '-m', 'DisplayName','RTN'); 
        plot(2:iFrames, flutVal(2:iFrames), '-r', 'DisplayName','Flt Clear'); 
        hleg11 = legend ('show'); % set(hleg11,'Location','East')        
    end
    xlim([0,maxFames]);
    stitle3 = ['Corrected CN, RTN and Flutter'];
    title(stitle3); 
    xlabel('frames'); ylabel('Noise, lsb');
    subplot (4,3,12)
    if iFrames>1
        plot(2:iFrames,tnVal(2:iFrames), '.r', 'DisplayName','TN'); grid on; hold on;
        plot(2:iFrames,ptnVal(2:iFrames), '-b','DisplayName','PTN'); 
        hleg12 = legend ('show'); set(hleg12,'Location','South')        
        stitle4 = ['Corrected TN and PTN'];
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

out.corr_img_stats = ycor_stats;
out.orig_img_stats = y_stats;
out.darkRows_stats = c_stats;

out.corrected.cfpn  = cfpnVal;
out.corrected.ctn   = ctnVal;
out.corrected.rtn   = rtnVal;
out.corrected.ptn   = ptnVal;
out.corrected.tn    = tnVal;
out.corrected.flut  = flutVal;
    
out.orig.cfpn = cfpnY;
out.orig.ctn = ctnY;
out.orig.rtn = rtnY;
out.orig.ptn = ptnY;
out.orig.tn = tnY;
out.orig.flut = flutY;
out.orig.flutDarkRows = flutDarkRows;
save ([summary_dirSave,fn_prefix],'out','-v7.3')
end
