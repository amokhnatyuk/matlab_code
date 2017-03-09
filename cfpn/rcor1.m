pp=mean(y_arr(10:60,:));
sz_a=size(y_arr);
cc=repmat(pp,sz_a(1),1);
bb=double(y_arr)-cc;
dd=mean(bb(:,10:60),2);
dd1=repmat(dd,1,sz_a(2));
bb1=double(bb)-dd1+100;
imtool (bb1);
