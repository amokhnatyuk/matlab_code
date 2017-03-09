function [  ] = imagevw( arr, npause )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    s=size(arr);
    nFrm = s(1);
    for i=1:nFrm
        figure(22); title(['Image #',num2str(nFrm)])
        imshow(arr,[0 6200],'InitialMagnification','fit');
        pause (npause);
    end

end