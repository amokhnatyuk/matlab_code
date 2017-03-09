function selT(le,te,s2)
%selT('1000','0100');
writeSensorReg( ['0270',le], s2); % RO_RSM_bot_select_ptr_tx_even_LE_00
writeSensorReg( ['0271',te], s2); % RO_RSM_bot_select_ptr_tx_even_TE_00
writeSensorReg( ['0274',le], s2); % RO_RSM_bot_select_ptr_rst_even_LE_00
writeSensorReg( ['0275',te], s2); % RO_RSM_bot_select_ptr_rst_even_TE_00
writeSensorReg( ['02a8',le], s2); % RO_RSM_bot_select_ptr_tx_odd_LE_00
writeSensorReg( ['02a9',te], s2); % RO_RSM_bot_select_ptr_tx_odd_TE_00
writeSensorReg( ['02ac',le], s2); % RO_RSM_bot_select_ptr_rst_odd_LE_00
writeSensorReg( ['02ad',te], s2); % RO_RSM_bot_select_ptr_rst_odd_TE_00
end