%dirSave = 'C:\data\raijin_lot3\hist\';
%if ~exist(dirSave, 'dir') mkdir(dirSave); end
prog_path='./test_row/';
addpath(prog_path);
%copyfile([prog_path,'testrow.m'],dirSave);  % copy this file to dst folder

%test_adc1;
%test_ld1;
cb_settings;
writeSensorReg( '090800f0', s2);  % de-Select vref_colbuf for analogtest1

%writeSensorReg( '09060014', s2);  % Select vclamp_pixsf_sig
%writeSensorReg( '090c0080', s2);  % Select vclamp_pixsf_sig_in,
writeSensorReg( '09380077', s2);  % Set vclamp_pixsf_sig, 0x0 vclamp_pixsf_sig= 0V, to 0xff vclamp_pixsf_sig=1.5V, default x77 is 0.7V

% reg0x0906:[4]=0 Power down vclamp_pixsf_sig buffer; [2]=1 Select vclamp_pixsf_sig for analogtest1
% reg0x0906: vclamp_pixsf_rst, [5]=0 power-down buffer, and [3]=0 disconnect from analogtest0
%writeSensorReg( '09060004', s2);  [4]=0 Power down vclamp_pixsf_sig buffer; [2]=1 Select vclamp_pixsf_sig for analogtest1
% extinput of vclamp_pixsf_sig
writeSensorReg( '09060024', s2);

writeSensorReg( '08100000', s2);  % OBFPN_START_BLACK1
writeSensorReg( '0811001f', s2);  % OBFPN_STOP_BLACK1
writeSensorReg( '0812106c', s2);  % OBFPN_START_BLACK2
writeSensorReg( '0813108b', s2);  % OBFPN_STOP_BLACK2

% default settings
%{
writeSensorReg( '08100006', s2);  % OBFPN_START_BLACK1
writeSensorReg( '08110025', s2);  % OBFPN_STOP_BLACK1
writeSensorReg( '08121066', s2);  % OBFPN_START_BLACK2
writeSensorReg( '08131085', s2);  % OBFPN_STOP_BLACK2
%}

% from cb)settions
writeSensorReg( '021c0001', s2); % dflt: 021c000A  RO_RSM_cb_sample1_LE_00
writeSensorReg( '021d0142', s2); % dflt: 021d012C  RO_RSM_cb_sample1_TE_00
writeSensorReg( '021e0001', s2); % dflt: 021e000A  RO_RSM_cb_sample2_LE_00
writeSensorReg( '021f0142', s2); % dflt: 021f012C  RO_RSM_cb_sample2_TE_00

% testrow settings
%writeSensorReg( '02200001', s2);  % RO_RSM_ref_sample_en1_LE_00
%writeSensorReg( '02210001', s2);  % RO_RSM_ref_sample_en1_TE_00
%writeSensorReg( '02220001', s2);  % RO_RSM_ref_sample_en2_LE_00
%writeSensorReg( '02230001', s2);  % RO_RSM_ref_sample_en2_TE_00
%writeSensorReg( '02240001', s2);  % RO_RSM_sample_switch1_LE_00
%writeSensorReg( '02250001', s2);  % RO_RSM_sample_switch1_TE_00
%writeSensorReg( '02260001', s2);  % RO_RSM_sample_switch2_LE_00
%writeSensorReg( '02270001', s2);  % RO_RSM_sample_switch2_TE_00
%%
writeSensorReg( '02280001', s2); % dflt: 02280064  RO_RSM_slct_switch1_1_LE_00
writeSensorReg( '02290146', s2); % dflt: 02290FFF  RO_RSM_slct_switch1_1_TE_00
writeSensorReg( '022a0001', s2); % dflt: 022a0064  RO_RSM_slct_switch2_1_LE_00
writeSensorReg( '022b0146', s2); % dflt: 022b0FFF  RO_RSM_slct_switch2_1_TE_00
%%
writeSensorReg( '02280048', s2);
writeSensorReg( '02290FFF', s2);
writeSensorReg( '022a0048', s2);
writeSensorReg( '022b0fff', s2);

writeSensorReg( '02ee0000', s2);  % 0x2ee	RO_RSM_slct_switch1_2_LE_00
writeSensorReg( '02ef0040', s2); % 0x2ef	RO_RSM_slct_switch1_2_TE_00
writeSensorReg( '02f00000', s2); % 0x2f0	RO_RSM_slct_switch2_2_LE_00
writeSensorReg( '02f10040', s2); % 0x2f1	RO_RSM_slct_switch2_2_TE_00

writeSensorReg( '08369699',s2);  % read map
%writeSensorReg( '08366999',s2);  % read map
writeSensorReg( '08399000',s2);  % read map
%writeSensorReg( '08399F00',s2);  % read map see what is best
%writeSensorReg( '0833C936',s2);  % read map see what is best
%writeSensorReg( '083C36C9',s2);  % read map see what is best

% testing vclamp_pixsf_rst and vclamp_pixsf_sig dacs and buffers
% writeSensorReg( '09060028', s2); % vclamp_pixsf_rst, [5]=1 power-up buffer, and [3]=1connect to analogtest0
% writeSensorReg( '09350077', s2); % Set vclamp_pixsf_rst voltage, when set to 0x0, vclamp_pixsf_rst is 3.5V, when set to 0xff, vclamp_pixsf_rst is 1.5V, default setup is 1.9V
% writeSensorReg( '090d0002', s2); % 0x90d[1]=1	St vclamp_pixsf_rst_in for analogtest0 to enable testing connection

% writeSensorReg( '09060014', s2); % vclamp_pixsf_sig, [4]=1 power-up buffer, and [2]=1 connect to analogtest1
% writeSensorReg( '09380077', s2); % Set vclamp_pixsf_sig voltage, when set to 0x0, vclamp_pixsf_sig is 0V, when set to 0xff, vclamp_pixsf_sig is 1.5V, default setup is 0.7V
% writeSensorReg( '090c0080', s2); % 0x90c[7]=1	Set vclamp_pixsf_sig_in for analogtest1 to enable connection

% clamp circuits config: disable clamp signal and reset
%writeSensorReg( '02c0000A', s2); % dflt=000A; RO_RSM_en1_clamprst_LE_00
writeSensorReg( '02c10000', s2); % dflt=012C; RO_RSM_en1_clamprst_TE_00
%writeSensorReg( '02c20064', s2); % dflt=0064; RO_RSM_en1_clampsig_LE_00
writeSensorReg( '02c30000', s2); % dflt=012C; RO_RSM_en1_clampsig_TE_00

%writeSensorReg( '02c4000A', s2); % dflt=000A; RO_RSM_en2_clamprst_LE_00
writeSensorReg( '02c50000', s2); % dflt=012C; RO_RSM_en2_clamprst_TE_00
%writeSensorReg( '02c60064', s2); % dflt=0064; RO_RSM_en2_clampsig_LE_00
writeSensorReg( '02c70000', s2); % dflt=012C; RO_RSM_en2_clampsig_TE_00

% clamp circuits config: enable clamp gnd to switch off sig and rst clamps
writeSensorReg( '02c81001', s2); % dflt=0000; RO_RSM_en1_clampgnda_LE_00
writeSensorReg( '02c90000', s2); % dflt=0184; RO_RSM_en1_clampgnda_TE_00
writeSensorReg( '02ca1001', s2); % dflt=0000; RO_RSM_en2_clampgnda_LE_00
writeSensorReg( '02cb0000', s2); % dflt=0184; RO_RSM_en2_clampgnda_TE_00

writeSensorReg( '08090000', s2);  % 0x0809	BLANK_STOP_BLACK1	[12:0]	0x4
writeSensorReg( '080b0000', s2);  % 0x080b	BLANK_STOP_BLACK2	[12:0]	0x0
writeSensorReg( '080d0000', s2);
% writeSensorReg( '080d0005', s2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
writeSensorReg( '01910380', s2);   % OBCLAMPDAC_INIT value
writeSensorReg( '02d303ff', s2);   % RO_RSM_en_sfbias0_TE_00

% pix timing
writeSensorReg( '02701000', s2); % RO_RSM_bot_select_ptr_tx_even_LE_00
writeSensorReg( '02710000', s2); % RO_RSM_bot_select_ptr_tx_even_TE_00
writeSensorReg( '02741000', s2); % RO_RSM_bot_select_ptr_rst_even_LE_00
writeSensorReg( '02750000', s2); % RO_RSM_bot_select_ptr_rst_even_TE_00
writeSensorReg( '02a81000', s2); % RO_RSM_bot_select_ptr_tx_odd_LE_00
writeSensorReg( '02a90000', s2); % RO_RSM_bot_select_ptr_tx_odd_TE_00
writeSensorReg( '02ac1000', s2); % RO_RSM_bot_select_ptr_rst_odd_LE_00
writeSensorReg( '02ad0000', s2); % RO_RSM_bot_select_ptr_rst_odd_TE_00

writeSensorReg( '02701000', s2); % RO_RSM_bot_select_ptr_tx_even_LE_00
writeSensorReg( '027100f0', s2); % RO_RSM_bot_select_ptr_tx_even_TE_00
writeSensorReg( '02741000', s2); % RO_RSM_bot_select_ptr_rst_even_LE_00
writeSensorReg( '02750120', s2); % RO_RSM_bot_select_ptr_rst_even_TE_00
%writeSensorReg( '02a80001', s2); % RO_RSM_bot_select_ptr_tx_odd_LE_00
%writeSensorReg( '02a90000', s2); % RO_RSM_bot_select_ptr_tx_odd_TE_00
%writeSensorReg( '02ac0001', s2); % RO_RSM_bot_select_ptr_rst_odd_LE_00
%writeSensorReg( '02ad0000', s2); % RO_RSM_bot_select_ptr_rst_odd_TE_00
