%start0;

fn1='C:\ProCEEd_Working_Directory\3DIC_LC1\RegisterFiles\Raijin_26MHz_PLL100_dig50_fps28.2_mphyhalf_master_0914.regfile';
%fn2='C:\ProCEEd_Working_Directory\3DIC_LC1\RegisterFiles\Raijin_26MHz_PLL100_dig50_fullpix_mphyhalf_master_analog_0323.regfile';
fn3='C:\ProCEEd_Working_Directory\3DIC_LC1\RegisterFiles\Raijin_t103_reg_wrt2.regfile';
%fn3='C:\ProCEEd_Working_Directory\3DIC_LC1\RegisterFiles\Raijin_t103_reg_wrt2_0826.regfile';
fn5='C:\ProCEEd_Working_Directory\3DIC_LC1\RegisterFiles\Raijin_26MHz_PLL200_dig100_fullpix_mphy_master_analog_0325.regfile';
fn6='C:\ProCEEd_Working_Directory\3DIC_LC1\RegisterFiles\Raijin_26MHz_PLL200_dig100_fullpix_mphy_master_analog_0325_ampmax.regfile';

readRegsFromFile( fn1, s2);
readRegsFromFile( fn3, s2);
set_TP_corrections_off;
% writeSensorReg( '00350006', s2);
test_adc1;
setPgaDly('3C', s2);
setAdcDly('00', s2);
% setLdDly('04', s2);  % interferes with setPgaDly('3C', s2);
% test_ld1;
%start3; % set ld timing
writeEvkDacReset(s2);
v = evksetDac ('6800', s2)
%vdac = 'ad00'; writeEvkDac( ['08' vdac], s2); writeEvkDac( ['01' vdac], s2);
%writeEvkDac( '010534', s2)
%writeSensorReg( '00350005', s2)

% SDO
% writeSensorReg( '00340001', s2)
%getSDO ('1e',s2);