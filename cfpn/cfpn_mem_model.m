function cfpn_mem_model (cfpn_row_bits, weight_current, pixval_shift_mem_bits)
% cfpn_mem_model (5,8,8)
% im memory we store signed integer values of x_deviation in range [xmin,xmax]
%cfpn_row_bits = 5;
weight_bits = 2;
clear stdVal
cfpn_rows = 2^cfpn_row_bits;
mem_bits_used_to_sum_cfpn_rows= cfpn_row_bits+1; % because it is signed value

%weight_current = 14; % weight_current
weight_total = 16;
weight_previous = weight_total - weight_current; % weight_previous
xlimit = 2^( cfpn_row_bits);
bits_to_correct_pixval_deviation = 10;
ditr = 'gaussian'; % 'random';

%pixval_maxdeviation is signed, therefore MSB bits_to_correct_pixval_deviation is sign
pixval_maxdeviation = 2^(bits_to_correct_pixval_deviation-1);
pixval_std = 2; % pixval_maxdeviation/2;  % used for (ditr == 'gaussian')

% we assume to use 
xmax = pixval_maxdeviation-1;
xmin= -pixval_maxdeviation+1;
% pixval_shift_mem_bits = mem_bits_used_to_sum_cfpn_rows + weight_bits;
total_mem_bits = pixval_shift_mem_bits + bits_to_correct_pixval_deviation;

nFames = 0;
maxFames = 30;
fnum=51; 
%figure(fnum); clf
cfpn_mem =[];
while (nFames<maxFames)
    % array xlimit x 1000 of random integer [xmin,xmax] 
    % designed to achieve mean(x) = 0
    if (strcmp(ditr, 'random'))
        y=randi(2^bits_to_correct_pixval_deviation-1,xlimit,1000)+ xmin-1; 
    elseif (ditr == 'gaussian')
        y= round( pixval_std * randn(xlimit,1000)); % integer code
    end
    x= clipSigned (y, bits_to_correct_pixval_deviation);
    cfpn_arr= mean(double(x));
    tot_noise = std2(double(x));  
    if (strcmp(ditr, 'random'))
        stitle1 = ['Random integer numbers [',num2str(xmin),':', ... 
            num2str(xmax),'] lsb', ', noise = ',num2str(tot_noise,3),' lsb, ', ...
            'cfpn\_rows=',num2str(cfpn_rows,3)];
    elseif (ditr == 'gaussian')
        stitle1 = ['Norm.distrib. int. numbers ', ', std = ',num2str(tot_noise,3),' lsb, ',...
            'cfpn\_rows=',num2str(cfpn_rows,3)];
    end
    if (nFames==0)
        cfpn1 =  cfpn_arr;
    else
        cfpn1 = (double(cfpn_mem) / 2^pixval_shift_mem_bits * weight_previous + ...
                       cfpn_arr * weight_current)/weight_total;
    end
    figure(fnum); clf
    subplot (3,1,1)
    imshow(x,[xmin xmax]); colormap (gray); title(stitle1);
    subplot (3,1,2)
    stdVal(nFames+1) = std(double(cfpn1));
    cfpn_mem_no_clip = cfpn1 * double(2^pixval_shift_mem_bits);
    cfpn_mem = round(cfpn1 * double(2^pixval_shift_mem_bits));  % throw out residual   
    xhist_lo = -xmax/4; xhist_hi = xmax/4;
    [hh,xx]=hist(cfpn_arr,xhist_lo:0.2:xhist_hi);
    bar(xx,hh); grid on;
    xlim([xhist_lo,xhist_hi]);
    stitle2 = ['CFPN Historgam, std =',num2str(stdVal(nFames+1),3),' lsb'];
    title(stitle2);
    subplot (3,1,3)
    plot(stdVal); grid on
    xlim([0,maxFames]);
    stitle3 = ['Column Noise vs number of frames, std =',num2str(stdVal(nFames+1),3), ...
        ' lsb, w\_curr=',num2str(weight_current)];
    title(stitle3);
    xlabel('frames'); ylabel('column noise, lsb');
    nFames = nFames +1;
end % while 1
