function  imageview( arr, npause )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    s=size(arr);
    nFrm = s(3);
    for i=1:nFrm
        figure(22); 
        bb = squeeze(arr(:,:,i));
%        imshow(bb',[0 6200],'InitialMagnification','fit');
        imshow(bb',[0 8192],'InitialMagnification',20);
        title(['Image #',num2str(i)])
        pause (npause);
    end

end