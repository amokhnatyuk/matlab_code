function loadSett3(aa,s2)
% s2 - serial port object
% aa is expcted to be the following array format:
% aa={'0C'	 '71'	 'CA'};
setAdcDly(aa{1},s2);
setHoriDly2(aa{2},s2);
setPgaDly2(aa{3},s2);

end