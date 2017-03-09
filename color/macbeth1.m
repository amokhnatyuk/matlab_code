B=imread('C:\data\apsc\macbeth\3.tif');
B_dark=imread('C:\data\apsc\macbeth\dark2.tif');
C=double(B) - double(B_dark);
figure(12); imshow(C,[])
maxY = 255;  % max value of R,G,B components
gmc = getGMC_color();
chipNames   = gmc.chipNames;
sRGB_Values = gmc.sRGB_Values;
gray_Values = gmc.gray_Values /256; % sRGB gray with gamma correction
labCIE = gmc.Lab_CIE_D50;

gamma = 0.42;
w = [0.8,1.2,1,0.8,0.6,0.2]; % Macbeth chart gray colors weights [white, ... dark]
wcolor = [1,1,1,1,1,1, 1,1,1,1,1,1, 1,1,1,1,1,1];
rect = findEdges( C );

figure(12); 
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

%{
ii0=18;
for jj = 1:6
    ii=ii0+jj;
    d(jj,1)=raw_rgb(ii,1); d(jj,2)=raw_rgb(ii,2); d(jj,3)=raw_rgb(ii,3);
%    dd= d(jj,1) +d(jj,2) +d(jj,3);
%    wbb(jj,:)=[1/d(jj,1), 1/d(jj,2), 1/d(jj,3)]*dd/3;
%    wbm=[wbb(jj,1),0,0; 0,wbb(jj,2),0; 0,0,wbb(jj,3)];
%    wb_rgb(jj,:) = raw_rgb(ii,:) * wbm /max(max(raw_rgb));
%    rectangle('Position',[rect(ii,3:4),200,200], 'EdgeColor','r', ...
%            'FaceColor',[wb_rgb(jj,1), wb_rgb(jj,2), wb_rgb(jj,3)] );
end
%}
gmc_gray = (double(gray_Values) /maxY ).^(1/gamma) * maxY; %gray no gamma correction
gmc_rgb  = (double(sRGB_Values) /maxY ).^(1/gamma) * maxY;

% perform 3-coef weighted fit with zero start point
wF = w(:).*gmc_gray(:);
ii0=18; gmcc(1:18,1:3)=0;
for ii=1:3
    gmcc(:,ii) = wcolor(:).*gmc_rgb(1:18,ii); % to be used to apply ccm 
    d(:,ii) = raw_rgb(ii0+1:ii0+6,ii); % selecting only gray squares
    wD(:,ii) = (w(:).*d(:,ii))';
    wb(ii) = wD(:,ii)\wF;
end
% Perform normalization on green color
gg = wb(2);
nwb = [wb(1)/gg, 1, wb(3)/gg];

% perform weighted fit with zero start point
%wa1=w.*x1;
%wb1=w.*gmc_gray;
%rr3=wa1'\wb1';

figure(12); 
for jj = 1:6
    ii=ii0+jj;
    % gamma correction and gain for gray squares in grab image
    f_col(jj,:) = (double(raw_rgb(ii,:)) .*nwb * gg /maxY) .^ (gamma); 
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
C3(1:2:hC, 1:2:wC,1) = gg*nwb(1)* dC(1:2:hC, 1:2:wC);
C3(1:2:hC, 1:2:wC,2) = gg*nwb(2)* (dC(2:2:hC, 1:2:wC) + dC(1:2:hC, 2:2:wC))/2;
C3(1:2:hC, 1:2:wC,3) = gg*nwb(3)* dC(2:2:hC, 2:2:wC);

C3(2:2:hC, 1:2:wC,:) = C3(1:2:hC, 1:2:wC,:);
C3(1:2:hC, 2:2:wC,:) = C3(1:2:hC, 1:2:wC,:);
C3(2:2:hC, 2:2:wC,:) = C3(1:2:hC, 1:2:wC,:);

pedestal = 2.0;
uC = C3 - pedestal; uC(C3<0)=0; % nonnegative image data
% (C11 C12 C13) * (r1 g1 b1)' = (rr1 gg1 bb1)'; n=1:18
% Ci1+ Ci2+ Ci3 = 1;  i=1:3, CCM restriction because WB has been done
% (g1-r1)*C12 + (b1-r1) * C13 = rr1-r1; n=1:18
% (g-r, b-r) (C12, C13)' = rr-r;
% (C12, C13)' = (g-r, b-r)\(rr-r);
ri=gg*nwb(1)*raw_rgb(1:18,1);
gi=gg*nwb(2)*raw_rgb(1:18,2);
bi=gg*nwb(3)*raw_rgb(1:18,3);

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
gg=ccm*uC2';    
uCC = reshape(gg',size(uC,1),size(uC,2),size(uC,3)); 
gC = (uCC /maxY) .^ (gamma) *maxY; % uCC is double here
% figure();imshow(uint8(gC),[])

%{
% dermine black color in th picture
Y = 0.299 *uCC(:,:,1) + 0.587 *uCC(:,:,2) + 0.114 *uCC(:,:,3);
h2 = fspecial('average', [10,10]);
mY2 = imfilter(Y, h2, 'same');
pedestal = min(min(mY2(85:end-10,219:end-10))); % additional black value
%}
uC_bcor = uCC;  % uC_bcor = uCC - pedestal;  
uC_bcor(uC_bcor<0)=0; 
gC_bcor = (uC_bcor /maxY) .^ (gamma) *maxY; % uCC is double here
figure();imshow(uint8(gC_bcor),[])


uC3 = uint8(C3);
% Convert image from RGB colorspace to lab color space.
cform = makecform('srgb2lab');
lab_Image = applycform(im2double(uC3),cform);
% Extract 3 separate 2D arrays, one for each color component.
LChannel = lab_Image(:, :, 1); 
aChannel = lab_Image(:, :, 2); 
bChannel = lab_Image(:, :, 3); 

%{
% Display the lab images.
figure(15); fontSize = 12;
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
deltaE = sqrt(delta(:,1)^2 + delta(:,2)^2 + delta(:,3)^2);
sdE = sqrt(mean(deltaE(:).^2 ));
