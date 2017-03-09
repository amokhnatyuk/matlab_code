function v = evksetDacB (hexdac, s2)
%hexdac = 'ad00';
%s2 - serial port object

% writeEvkDacReset( s2);
% cCoef = 2510.11/65800;  % mV/lsb gain off
cCoef = 2510.11*2/65800;  % mV/lsb gain on
vdec = hex2dec(hexdac);
%writeEvkDac( ['08' hexdac], s2); writeEvkDac( ['01' hexdac], s2);
writeEvkDac( ['08' hexdac], s2);  % set both dacs
v = cCoef * vdec;  % voltage in mV
end