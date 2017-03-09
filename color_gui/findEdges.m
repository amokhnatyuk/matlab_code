function [ out ] = findEdges( C, showplot)
% C (:, :) 2D image of Macbeth chart
% showplot=1 show figure
if nargin<2 showplot = 0; end
rect = [];

% horizontal edges
result = verifyEdges(C,'horiz',showplot);
if (~result.success)
    error('Tricolor can"t recognize the pattern. Horizontal edges do not match');
end
xEdges = result.Edges;
% calc mean width of Macbeth square selection
xarr = [xEdges(2)-xEdges(1), xEdges(4)-xEdges(3), xEdges(6)-xEdges(5), ... 
            xEdges(8)-xEdges(7), xEdges(10)-xEdges(9), xEdges(12)-xEdges(11) ];
xWidth = mean (xarr );
xMargin = floor(xWidth/12); % xMargin = 40; % horizontal margin for each Macbeth square
if mod(xMargin,2)>0 xMargin = xMargin-1; end % make xMargin even number
xWidth = floor(xWidth -2* xMargin);
if mod(xWidth,2)>0 xWidth = xWidth-1; end % make xWidth even number

% vertical edges
result = verifyEdges(C,'vert',showplot);
if (~result.success)
    error('Tricolor can"t recognize the pattern. Vertical edges do not match');
end
yEdges = result.Edges;
% calc mean height of Macbeth square selection
yarr = [yEdges(2)-yEdges(1), yEdges(4)-yEdges(3), ...
                    yEdges(6)-yEdges(5), yEdges(8)-yEdges(7) ];
yHeight = mean (yarr );
yMargin = floor(yHeight/12); % yMargin = 40; % vertical margin for each Macbeth square
if mod(yMargin,2)>0 yMargin = yMargin-1; end % make yMargin even number
yHeight = floor( yHeight -2* yMargin); 
if mod(yHeight,2)>0 yHeight = yHeight-1; end % make yHeight even number

j=1; k=1; 
    for i = 1:24
        xx = xEdges(2*j-1)+ xMargin;
        yy = yEdges(2*k-1)+ yMargin;
        if mod(xx,2)==0 xx = xx-1; end % make xx odd number
        if mod(yy,2)==0 yy = yy-1; end % make yy odd number
    
        rect = [ rect; k, j, xx, yy, xWidth, yHeight ];
        if (mod(i,6) >0) j=j+1; % indexing macbeth squares horizontally
        else j=1; k=k+1; end
    end
out.rect = rect;
out.margin = [xMargin, yMargin];
end

function result = verifyEdges(C, direction, showplot)
% direction = 'horiz'; % or 'vert'
% C is orig image 
if strcmp(direction,'horiz')
    nEdges_required = 12;
    inum = 1;
    stitle = 'Horizontal';
elseif strcmp(direction,'vert')
    inum = 2;
    nEdges_required = 8;
    stitle = 'Vertical';
end
    C1=mean(C,inum);
    Possible_Dither_Num_Of_pixels = 5;
    success = 0;
    
% vary position of edge crosssection line
    points = 20; % number of iteration to check edges alignment
    position1 = 0.2; % portion of max profile value
    position_swing = 0.5; % portion of max profile value
    for ii= 1:points
        Edges = [];
        portion = position1 + position_swing*ii/points; % total range from 0.2 to 0.7
        line_pos = double(max(C1))* portion;
        if (showplot)
            figure(21); 
            hsub=subplot(2,1,inum); cla(hsub);
%            subplot(2,1,inum);
            plot(C1); ylim([0, max(C1)]); grid on; hold on
            plot(1:length(C1),line_pos, '--r');
            title(stitle);
        end
        lC1 = C1 - line_pos; 
        xC0 = find(lC1 >0 );
        xC1 = xC0(:)';  % make sure it is line
        Edges(1) = xC1(1);
        xC2 = xC1(2:end) - xC1(1:end-1);
        iC3 = find(xC2 >Possible_Dither_Num_Of_pixels );
        Edges = sort([Edges, xC1(iC3),xC1(iC3+1), xC1(end)]);
        nEdges = length(Edges);
        if (nEdges == nEdges_required)
            for jj=1: (nEdges-1)/2
                space = Edges(2*jj+1) - Edges(2*jj);
                pitch = Edges(2*jj+1) - Edges(2*jj-1);
                out = complyRatio (space, pitch );
                if (~out) break; end
            end
            if (out) 
                success = 1;
                break; 
            end
%            error('Number of discovered horizontal edges not equal to 12.')
        else continue
        end
    end
    
    result.Edges = Edges;
    result.nEdges = nEdges;
    result.success = success;
end

function out = complyRatio (space, pitch )
    min_spaceSqr_over_pitch = 0.08; % min(space/pitch)
    max_spaceSqr_over_pitch = 0.17; % max(space/pitch)

    ratio = double(space)/double(pitch);
    if ratio< min_spaceSqr_over_pitch || ratio>max_spaceSqr_over_pitch
        out = false;
    else out = true;
    end
end
