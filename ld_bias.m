writeSensorReg( '092500c0', s2);  % pbias def 40
writeSensorReg( '09260030', s2);  % pcasc def 30
writeSensorReg( '09270070', s2);  % nbias def 30
writeSensorReg( '09280030', s2);  % ncasc def 30
%{
0x925	I80	[7:0]		
		[7:2]	0x10	ibias_ld_p_sel<5:0>
		[1]	0x0	ibias_spare_n_sel<15>
		[0]	0x0	ibias_nc_sel<4>
0x926	I88	[7:0]		
		[7:6]	0x1	ibias_refbuf_p_sel<27:26>
		[5:0]	0x10	icasc_ld_p_sel<5:0>
0x927	I95	[7:0]		
		[7:6]	0x1	ibias_refbuf_p_sel<29:28>
		[5:0]	0x10	ibias_ld_n_sel<5:0>
0x928	I102	[7:0]		
		[7:6]	0x1	ibias_refbuf_p_sel<31:30>
		[5:0]	0x10	icasc_ld_n_sel<5:0>
%}