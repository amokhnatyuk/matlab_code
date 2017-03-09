function v = measCont(g1,figN)
% g1 - gpib object
% figN=51;

tStep = 0.5;  % time step in seconds
if nargin <2
    figN=51;
end

jj=1;
while 1
    figure(figN);

    if (jj<256)   
        v(jj) = measVolt(g1);
        x=[0:tStep:double(length(v)-1)*tStep];
    else
        x=[0:tStep:double(length(v)-1)*tStep];
        v(1:end-1) = v(2:end);
        v(end)= measVolt(g1);
    end
    plot (x,v);  
    grid on; set(gca,'XGrid','off');
    ymin = min(v); ymin = min ([0,ymin]);
    ylim([ymin,max(v)*1.1]);
    ylabel('Voltage, V')
    xlabel ('Time, sec')
    title('Voltage monitor')
    pause(tStep);
    jj=jj+1;
end
end