function clipval = clipSigned (val, nbit)
v = 2^(nbit-1);
vmax=v-1;
vmin=-v;
if (val<vmin)
    clipval=vmin;
elseif (val>vmax)
    clipval=vmax;
else
    clipval=val;
end
end