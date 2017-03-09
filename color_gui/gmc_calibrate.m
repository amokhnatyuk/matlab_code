function calib = gmc_calibrate( C, selected)
% C image of macbeth chart with subtraction of dark image (lsb, double)
% selected is structure which include:
% colorSet - structure of color parameters; 
% gamma - correction value; & gamma = 0.42;
% graySet - table of gray Values
% labCIE - table of labCIE Values
% weights - table of color and gray weights 

hFig = figure(); imshow(C,[])
maxY = 255;  % max value of R,G,B components
rgbValues = selected.colorSet;
labCIE = selected.labCIE;
gray_Values = selected.graySet;
gamma = selected.gamma;
wgray = selected.weights(19:24); % [0.8,1.2,1,0.8,0.6,0.2]; % Macbeth chart gray colors weights [white, ... dark]
wcolor = selected.weights(1:18); % [1,1,1,1,1,1, 1,1,1,1,1,1, 1,1,1,1,1,1];
chipNames = selected.chipNames;
pedestal = selected.pedestal;

out = findEdges( C );
rect = out.rect;
margin = out.margin;

figure(hFig); 
mSquares = []; raw_rgb = [];
for ii = 1:24
    rectangle('Position',rect(ii,3:6), 'EdgeColor','y' )
    sqrC = C(rect(ii,4):rect(ii,4)+rect(ii,6)-1, rect(ii,3):rect(ii,3)+rect(ii,5)-1);
    sing_sqr = [ mean2(sqrC(1:2:end, 1:2:end)), ... 
                    mean2(sqrC(2:2:end, 1:2:end)), ...
                    mean2(sqrC(1:2:end, 2:2:end)), ...
                    mean2(sqrC(2:2:end, 2:2:end)) ];
    mSquares = [mSquares; sing_sqr ];
    raw_rgb = [ raw_rgb; sing_sqr(1), mean(sing_sqr(2:3)), sing_sqr(4)];
end

gmc_gray = (double(gray_Values) /maxY ).^(1/gamma) * maxY; %gray no gamma correction
gmc_rgb  = (double(rgbValues) /maxY ).^(1/gamma) * maxY;

% perform 3-coef weighted fit with zero start point
wF = wgray(:).*gmc_gray(:);
ii0=18; gmcc(1:18,1:3)=0;
for ii=1:3
    gmcc(:,ii) = wcolor(:).*gmc_rgb(1:18,ii); % to be used to apply ccm 
    d(:,ii) = raw_rgb(ii0+1:ii0+6,ii); % selecting only gray squares
    wD(:,ii) = (wgray(:).*d(:,ii))';
    wb(ii) = wD(:,ii)\wF;
end
% Perform normalization on green color
gg = wb(2);
nwb = [wb(1)/gg, 1, wb(3)/gg];
cgain = gg*min(nwb); % to keep all rgb values within range [0,255]

% perform weighted fit with zero start point
%wa1=wgray.*x1;
%wb1=wgray.*gmc_gray;
%rr3=wa1'\wb1';

figure(hFig); 
for jj = 1:6
    ii=ii0+jj;
    % gamma correction and gain for gray squares in grab image
    f_col(jj,:) = (double(raw_rgb(ii,:)) .*nwb * cgain /maxY) .^ (gamma); 
    rectangle('Position',[rect(ii,3:4),200,200], 'EdgeColor','r', ...
            'FaceColor',[f_col(jj,1), f_col(jj,2), f_col(jj,3)] );
end
hC = size(C,1); wC = size(C,2); 
if mod(hC,2)>0 hC = hC-1; end % make yHeight even number
if mod(wC,2)>0 wC = wC-1; end % make yHeight even number
dC = double(C);

% creaste RBG array from original grayscale data with simple demosaic
% And we apply WB correction to each demosaic component
C3 = zeros(hC,wC,3,'double');
C3(1:2:hC, 1:2:wC,1) = cgain*nwb(1)* dC(1:2:hC, 1:2:wC);
C3(1:2:hC, 1:2:wC,2) = cgain*nwb(2)* (dC(2:2:hC, 1:2:wC) + dC(1:2:hC, 2:2:wC))/2;
C3(1:2:hC, 1:2:wC,3) = cgain*nwb(3)* dC(2:2:hC, 2:2:wC);

C3(2:2:hC, 1:2:wC,:) = C3(1:2:hC, 1:2:wC,:);
C3(1:2:hC, 2:2:wC,:) = C3(1:2:hC, 1:2:wC,:);
C3(2:2:hC, 2:2:wC,:) = C3(1:2:hC, 1:2:wC,:);

%{
% dermine black color in th picture
Y = 0.299 *C3(:,:,1) + 0.587 *C3(:,:,2) + 0.114 *C3(:,:,3);
h2 = fspecial('average', [10,10]);
mY2 = imfilter(Y, h2, 'same');
pedestal = min(min(mY2(85:end-10,219:end-10))); % additional black value
%}
uC = C3 - pedestal; uC(uC<0)=0; % nonnegative image data
% (C11 C12 C13) * (r1 g1 b1)' = (rr1 gg1 bb1)'; n=1:18
% Ci1+ Ci2+ Ci3 = 1;  i=1:3, CCM restriction because WB has been done
% (g1-r1)*C12 + (b1-r1) * C13 = rr1-r1; n=1:18
% (g-r, b-r) (C12, C13)' = rr-r;
% (C12, C13)' = (g-r, b-r)\(rr-r);
ri=cgain*nwb(1)*raw_rgb(1:18,1);
gi=cgain*nwb(2)*raw_rgb(1:18,2);
bi=cgain*nwb(3)*raw_rgb(1:18,3);

GRBR1 =  [wcolor(:).*(gi-ri), wcolor(:).*(bi-ri)];
CC(:,1) = GRBR1 \ (gmcc(:,1)-ri);
GRBR2 =  [wcolor(:).*(ri-gi), wcolor(:).*(bi-gi)];
CC(:,2) = GRBR2 \ (gmcc(:,2)-gi);
GRBR3 =  [wcolor(:).*(ri-bi), wcolor(:).*(gi-bi)];
CC(:,3) = GRBR3 \ (gmcc(:,3)-bi);
CC1 = 1-sum(CC);
ccm = [ CC1(1),  CC(1,1), CC(2,1); ...
        CC(1,2), CC1(2),  CC(2,2); ...
        CC(1,3), CC(2,3), CC1(3) ];
    
uC2 = reshape(uC,size(uC,1)*size(uC,2),size(uC,3));    
uC3=ccm*uC2';    
uCC = reshape(uC3',size(uC,1),size(uC,2),size(uC,3)); 

uC_bcor = uCC;  
uC_bcor(uC_bcor<0)=0; 
gC_bcor = (uC_bcor /maxY) .^ (gamma) *maxY; % uCC is double here
figure(hFig);clf;
imshow(uint8(gC_bcor))
gmc_width = floor(rect(1,5)/2); % 2 time smaller then rect with
gmc_hight = floor(rect(1,6)/2);
rgbImage = uint8(gC_bcor);
for jj = 1:24
    row1 = rect(jj,4) -margin(1); row2= row1+gmc_hight-1;
    col1 = rect(jj,3) -margin(1); col2= col1+gmc_width-1;
    sqrC = rgbImage(rect(jj,4):rect(jj,4)+rect(jj,6)-1, rect(jj,3):rect(jj,3)+rect(jj,5)-1,:);
    rgbIm(jj,:) = uint8(mean(mean(sqrC)));
		rgbImage(row1:row2, col1:col2, 1) = rgbValues(jj, 1);
		rgbImage(row1:row2, col1:col2, 2) = rgbValues(jj, 2);
		rgbImage(row1:row2, col1:col2, 3) = rgbValues(jj, 3);
end
figure(hFig);clf; imshow(rgbImage)
for jj = 1:24
    rectangle('Position',[rect(jj,3:4)-margin(1),gmc_width,gmc_hight], 'EdgeColor','w');
end
displayLabels(rect(:,3:6),chipNames,rgbValues,rgbIm);

% Convert image from RGB colorspace to lab color space.
ulC = uint8(uC_bcor);
cform = makecform('srgb2lab');
lab_Image = applycform(im2double(ulC),cform);
% Extract 3 separate 2D arrays, one for each color component.
LChannel = lab_Image(:, :, 1); 
aChannel = lab_Image(:, :, 2); 
bChannel = lab_Image(:, :, 3); 

%{
% Display the lab images.
figure(15); fontSize = 12;
uC3 = uint8(C3);
subplot(2, 2, 1); imshow(uC3)
title('Raw Img + WB corr. (no CCM)', 'FontSize', fontSize);
subplot(2, 2, 2); imshow(LChannel, []);
title('L Channel', 'FontSize', fontSize);
subplot(2, 2, 3); imshow(aChannel, []);
title('a Channel', 'FontSize', fontSize);
subplot(2, 2, 4); imshow(bChannel, []);
title('b Channel', 'FontSize', fontSize);
%}
% Get the average lab color value.
labSqr = [];
for ii = 1:24
    sqrC = lab_Image(rect(ii,4):rect(ii,4)+rect(ii,6)-1, rect(ii,3):rect(ii,3)+rect(ii,5)-1,:);
    sing_sqr = [ mean2(sqrC(:, :, 1)), ... 
                    mean2(sqrC(:, :, 2)), ... 
                    mean2(sqrC(:, :, 3)) ];
    labSqr = [ labSqr; sing_sqr];
end

% Create the delta structure in Lab coordinates for all GMC squares
delta = labSqr - labCIE;
	
% Delta E represents the color difference between procesed image and GMC
% L*a*b* targets. 
deltaE = sqrt(delta(:,1).^2 + delta(:,2).^2 + delta(:,3).^2);
sdE = sqrt(mean(deltaE(:).^2 ));
calib.ccm = ccm;
calib.wb = nwb;
calib.delta = delta;
calib.deltaE = deltaE;
calib.sdE = sdE;
end

function displayLabels(edges,chipNames,rgbValues,rgbIm)
% Annotate.  Place chip names and RGB values on the chips, if they chose to do so.
fontSize = 10;
chipNumber = 1;
for row = 1 : 4
    row1 = edges(chipNumber,2) + floor(edges(chipNumber,4)/20);
    rowL2 = edges(chipNumber,2) + floor(edges(chipNumber,4) * 5/6);
    for col = 1 : 6
        col1 = edges(chipNumber,1);
        colL2 = edges(chipNumber,1)+ floor(edges(chipNumber,3) * 3/4);;
        % Place chip name
        chipName = chipNames{chipNumber};
        textTgt = sprintf('%s\nR=%3d\nG=%3d\nB=%3d', chipName, ...
            rgbValues(chipNumber, 1), rgbValues(chipNumber, 2), rgbValues(chipNumber, 3));
        textImg = sprintf('R=%3d\nG=%3d\nB=%3d', ...
            rgbIm(chipNumber, 1), rgbIm(chipNumber, 2), rgbIm(chipNumber, 3));
        if sum(rgbValues(chipNumber, :)) > 470
            txtcolor = 'k'; % Use black text over the yellow, white, and bright gray chips.
        else
            txtcolor = 'w'; % Use white text over all the other chips.
        end
            text(double(col1), double(row1), textTgt, 'Color', txtcolor, 'FontSize', fontSize);
            text(double(colL2), double(rowL2), textImg, 'Color', txtcolor, 'FontSize', fontSize);
        
        chipNumber = chipNumber + 1;
    end % of loop over columns.
end % of loop over rows.
	
end

function out_xyz = rgb2xyz(arr)
% arr (1:3,:)
d65_rgb2xyz = [0.4125, 0.3576, 0.1804; 0.2127, 0.7152, 0.0722; 0.0193, 0.1192, 0.9503];
out_xyz = d65_rgb2xyz * arr(:);
end