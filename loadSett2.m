function loadSett2(aa,s2)
% s2 - serial port object
% aa is expcted to be the following array format:
% aa={'0C'	 '71'	 'CA'	 '02'};
setAdcDly(aa{1},s2);
setHoriDly2(aa{2},s2);
setPgaDly2(aa{3},s2);

writeSensorReg( ['009002',aa{4}], s2);  % regs.x90

end