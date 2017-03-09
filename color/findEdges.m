function [ rect ] = findEdges( C, showplot)
% C (:, :) 2D image of Macbeth chart
% showplot=1 show figure
if nargin<2 showplot = 0; end

C1=mean(C,1);
C2=mean(C,2);
if (showplot)
    figure; subplot(2,1,1); plot(C1); ylim([0, max(C1)]); grid on
    ylim([min(C1(210:end)), max(C1)]);
    subplot(2,1,2); plot(C2); ylim([0, max(C2)]); grid on
end
Possible_Dither_Num_Of_pixels = 5;
xMargin = 40; % horizontal margin for each Macbeth square
yMargin = 40; % vertical margin for each Macbeth square

% horizontal edges
lC1 = C1 - double(max(C1))/3; xC1 = find(lC1 >0 );
xEdges(1) = xC1(1);
xC2 = xC1(2:end) - xC1(1:end-1);
iC3 = find(xC2 >Possible_Dither_Num_Of_pixels );
xEdges = sort([xEdges, xC1(iC3),xC1(iC3+1), xC1(end)]);
if (length(xEdges) ~= 12)
    error('Number of discovered horizontal edges not equal to 12.')
end
% calc mean width of Macbeth square selection
xarr = [xEdges(2)-xEdges(1), xEdges(4)-xEdges(3), xEdges(6)-xEdges(5), ... 
            xEdges(8)-xEdges(7), xEdges(10)-xEdges(9), xEdges(12)-xEdges(11) ];
xWidth = mean (xarr );
xWidth = floor(xWidth -2* xMargin);
if mod(xWidth,2)>0 xWidth = xWidth-1; end % make xWidth even number

% vertical edges
minC2 = double(min(C2(300:end-200)));
lC2 = C2 - ((max(C2) - minC2)/3 + minC2); 
yC2 = find(lC2 >0 );
yEdges(1) = yC2(1);
yD = yC2(2:end) - yC2(1:end-1);
iE = find(yD >Possible_Dither_Num_Of_pixels );
yEdges = sort([yEdges; yC2(iE); yC2(iE+1); yC2(end)]);
if (length(yEdges) ~= 8)
    error('Number of discovered vertical edges not equal to 8.')
end
% calc mean height of Macbeth square selection
yarr = [yEdges(2)-yEdges(1), yEdges(4)-yEdges(3), ...
                    yEdges(6)-yEdges(5), yEdges(8)-yEdges(7) ];
yHeight = mean (yarr );
yHeight = floor( yHeight -2* yMargin); 
if mod(yHeight,2)>0 yHeight = yHeight-1; end % make yHeight even number

j=1; k=1; rect = [];
    for i = 1:24
        xx = xEdges(2*j-1)+ xMargin;
        yy = yEdges(2*k-1)+ yMargin;
        if mod(xx,2)==0 xx = xx-1; end % make xx odd number
        if mod(yy,2)==0 yy = yy-1; end % make yy odd number
    
        rect = [ rect; k, j, xx, yy, xWidth, yHeight ];
        if (mod(i,6) >0) j=j+1; % indexing macbeth squares horizontally
        else j=1; k=k+1; end
    end
end

