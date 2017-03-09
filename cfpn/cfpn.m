function [ out ] = cfpn( arr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%sz = size(arr);
a2= arr(1000:2:3000,1000:2:4000);
a3 = mean(a2);
out.arr = a2;
out.mean = a3;
out.cfpn=std(a3);
out.mmean=mean(a3);
end

