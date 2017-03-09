function [ out_arr ] = seqfrm( nFrm, npause )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    a=grab5';
    s=size(a);
    out_arr(nFrm,s(1),s(2))=0;
    for i=1:nFrm
        if (i>1) 
            a=grab5'; 
        end
        out_arr(i,:,:)=a;
        figure(22);imshow(a,[0 6200],'InitialMagnification','fit');
        title(['Image #',num2str(i)]);
        pause (npause);
    end

end

