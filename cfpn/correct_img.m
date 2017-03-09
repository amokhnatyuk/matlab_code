function [ out ] = correct_img( arr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sz = size(arr);
fpn1=mean(arr(1:2:64,:));
fpn2=mean(arr(561:2:561+63,:));
fpn=(fpn1+fpn2)/2;
fpn_cor=repmat(fpn,sz(1),1);
out=double(arr)-fpn_cor;

end

