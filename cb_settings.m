writeSensorReg( '00900000', s2);   % coltest disable
writeSensorReg( '00600180', s2);   % CB PD disable
writeSensorReg( '01970008', s2);   % Keeps OBCLAMPDAC output at initial value
writeSensorReg( '01910200', s2);   % OBCLAMPDAC_INIT value
writeSensorReg( '003d4040', s2);   % COLBUF_GAIN_ODD
writeSensorReg( '003c4040', s2);   % COLBUF_GAIN_EVEN
writeSensorReg( '08369999', s2);   % READBUS map
writeSensorReg( '0909000c', s2);   % ld PD disable
writeSensorReg( '090800d2', s2);  % [1] Select vref_colbuf for analogtest1, default is xf0
writeSensorReg( '093000b0', s2);  %  vref_cb_colbuf_sel<7:0>
writeSensorReg( '093400f0', s2);  % Set vref_colbuf hi and lo voltage selection

writeSensorReg( '021c0001', s2); % dflt: 021c000A  RO_RSM_cb_sample1_LE_00
writeSensorReg( '021d0142', s2); % dflt: 021d012C  RO_RSM_cb_sample1_TE_00
writeSensorReg( '021e0001', s2); % dflt: 021e000A  RO_RSM_cb_sample2_LE_00
writeSensorReg( '021f0142', s2); % dflt: 021f012C  RO_RSM_cb_sample2_TE_00
writeSensorReg( '02280001', s2); % dflt: 02280064  RO_RSM_slct_switch1_1_LE_00
writeSensorReg( '02290146', s2); % dflt: 02290FFF  RO_RSM_slct_switch1_1_TE_00
writeSensorReg( '022a0001', s2); % dflt: 022a0064  RO_RSM_slct_switch2_1_LE_00
writeSensorReg( '022b0146', s2); % dflt: 022b0FFF  RO_RSM_slct_switch2_1_TE_00

%{
readSensorReg( '0214', s2) %0x214	RO_RSM_cb_azcap_LE_00
readSensorReg( '0215', s2) % 0x215	RO_RSM_cb_azcap_TE_00
readSensorReg( '0216', s2) % 0x216	RO_RSM_cb_azref_LE_00
readSensorReg( '0217', s2) % 0x217	RO_RSM_cb_azref_TE_00

readSensorReg( '0218', s2) % 0x218	RO_RSM_cb_fbcap_LE_00
readSensorReg( '0219', s2) % 0x219	RO_RSM_cb_fbcap_TE_00
readSensorReg( '021a', s2) % 0x21a	RO_RSM_cb_fben_LE_00
readSensorReg( '021b', s2) % 0x21b	RO_RSM_cb_fben_TE_00

%}
writeSensorReg( '093100f0', s2);  % vref_ld_sel<7:0>

writeSensorReg( '02190000', s2);  % RO_RSM_cb_fbcap_TE_00
writeSensorReg( '02150000', s2);  % RO_RSM_cb_azcap_TE_00
writeSensorReg( '021b0060', s2);  % RO_RSM_cb_fben_TE_00

writeSensorReg( '003d4040', s2);  % COLBUF_GAIN_ODD
writeSensorReg( '003c4040', s2);  % COLBUF_GAIN_EVEN
%writeSensorReg( '003d0000', s2);  % COLBUF_GAIN_ODD
%writeSensorReg( '003c0000', s2);  % COLBUF_GAIN_EVEN
