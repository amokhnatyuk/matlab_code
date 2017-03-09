function B = gain_table( )
%finction gain_table returns CB gain table in format:
% reg x3c settiongs, gain
%  setting  gain   setting  gain
%{
tbl = { ...
  '0000', 2;       '4040', 1; ...
  '0303', 2.83;    '4343', 1.415; ... 
  '0505', 3.24;    '4545', 1.62; ...
  '0909', 3.71;    '4949', 1.85; ...
  '0707', 4.08;    '4747', 2.04; ...
  '0d0d', 4.95;    '4d4d', 2.47; ...
  '0f0f', 5.79;    '4f4f', 2.89; ...
  '1111', 4.49;    '5151', 2.25; ...
  '1313', 5.32;    '5353', 2.66; ...
  '1515', 5.74;    '5555', 2.87; ...
  '1717', 6.57;    '5757', 3.28; ...
};
%}
sArr = cell(2^6+1,1);
sArr{1}='0000'; sArr{2}='4040';
for jj = 1 : 2^6-1   % vary bits 1 - 6
    h1 = dec2hex(jj*2+1,2); % b[0]=1 always,
    sArr{jj+2}= [h1,h1];
end
tbl1 = tablecalc(sArr);
[B,index] = sortrows(tbl1,1);
B(2,:)=[];  % delete 2nd element, because gain is 1 same as 1st element
end

function tbl1 = tablecalc(slist)
tbl1 = cell(length(slist),2);
for jj=1:length(slist)
    tbl1{jj,1} = cbgain(slist{jj});
    tbl1{jj,2} = slist{jj};
end
end
