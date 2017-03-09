function out = measVref2(g1,s2,refreg,refName,dirSave, figN)
% refreg = '0930';  % string with 4-hexdigit register number
% g1 - gpib object
% figN=51;
%refName = 'vref\_az';
%dirSave = 'C:\data\raijin_lot3\vclamp_pixsf_ref\';

if ~exist(dirSave, 'dir') mkdir(dirSave); end
refName_mod = strrep(refName, '\', '');  % this removes "\" from refName
oldval = readSensorReg( refreg, s2);  % hold value to restore it later

tStep = 0.01;  % time step in seconds
if nargin <6
    figN=52;
end
f=figure(figN); clf
xmin = 0; xmax = 255; xstep = 1;
x=[];
xSeq=xmin:xstep:xmax;
for jj=1: length(xSeq)
    regval = ['00', dec2hex(xSeq(jj),2)];
    writeSensorReg( [refreg, regval], s2);
    if (jj==1) pause(0.1); end
    figure(figN);
    v(jj) = measVolt(g1);

    x = [x,xSeq(jj)];
    plot (x,v);  
    grid on; 
    ymin = min(v); ymin = min ([0,ymin]);
    ylim([ymin,max(v)*1.1]);
    xlim([xmin,xmax*1.05]);
    ylabel('Voltage, V')
    xlabel (['vref setting, reg.x',refreg,'[7:0]'])
    title([refName, ' sweep', ])
    pause(tStep);
end

out.v = v;
out.x = x;
out.ref = refName_mod;
save ([dirSave, refName_mod, '.mat'], 'out');
saveas (f,[dirSave, refName_mod, '.png']);
saveas (f,[dirSave, refName_mod, '.fig']);
writeSensorReg( [refreg, oldval], s2);

end