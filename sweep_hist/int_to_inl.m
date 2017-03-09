load_dir = 'C:\data\raijin_lot3\dnl_swp\';
load_mat = 'ADC#7 StDev of pixVal within [10000, 12000].mat';
save_dir = [load_dir, 'inl\'];
load([load_dir, load_mat]);
B=[];
hf1 = figure(21);
for ii=1:16
    ax=A.arr(1,ii).x; 
    an=A.arr(1,ii).n;
    adcBias = ii-1;
    as=cumsum(an);
    % normalization
    as1=as/as(end)*(ax(end)-ax(1)+1);
    p = polyfit(ax,as1,3);
    ay= p(1)*ax.^3 + p(2)*ax.^2 + p(3)*ax.^1 + p(4);
    figure(hf1); clf
    subplot (2,1,1)
    plot(ax,as1,'-g.'); grid on
    hold on; plot(ax,ay,'-b')
    xlabel('code, lsb');
    ylabel('Accum signal, lsb');
    stitle1 =['INL interpolated with input RAMP at ADC bias=', num2str(adcBias)];
    title(stitle1);
    subplot (2,1,2)
    ar=ay-as1;
    plot(ax,ar,'-g.'); grid on
    xlabel('code, lsb');
    ylabel('INL, lsb');
    iinl(ii) = max(ar) - min(ar);
    B(ii,:)=ar;
    saveas(hf1,[save_dir, stitle1, '.png']) 
    saveas(hf1,[save_dir, stitle1, '.emf']) 
    saveas(hf1,[save_dir, stitle1, '.fig']) 
end
hf2 = figure(22);
plot (0:15, iinl); grid on
xlabel('ADC bias, reg.x091c[7:4], lsb');
ylabel('INL (peak to peak), lsb');
stitle2 = 'ADC INL interpolated vs ADC bias';
title(stitle2)
saveas(hf2,[save_dir, stitle2, '.png']) 
saveas(hf2,[save_dir, stitle2, '.emf']) 
saveas(hf2,[save_dir, stitle2, '.fig']) 
save ([dirSave, stitle2, '.mat'], 'iinl','B');

