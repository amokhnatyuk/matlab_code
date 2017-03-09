function loadSett4(aa,s2)
% s2 - serial port object
% aa is expcted to be the following array format:
% aa={'24' '9686' '6EE5'};
setDly(aa{1},s2);

writeSensorReg( ['0836',aa{2}], s2);  % regs.x0836
writeSensorReg( ['083b',aa{3}], s2);  % regs.x083b

end