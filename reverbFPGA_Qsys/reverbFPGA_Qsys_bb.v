
module reverbFPGA_Qsys (
	audio_controller_avalon_left_channel_sink_data,
	audio_controller_avalon_left_channel_sink_valid,
	audio_controller_avalon_left_channel_sink_ready,
	audio_controller_avalon_left_channel_source_ready,
	audio_controller_avalon_left_channel_source_data,
	audio_controller_avalon_left_channel_source_valid,
	audio_controller_avalon_right_channel_sink_data,
	audio_controller_avalon_right_channel_sink_valid,
	audio_controller_avalon_right_channel_sink_ready,
	audio_controller_avalon_right_channel_source_ready,
	audio_controller_avalon_right_channel_source_data,
	audio_controller_avalon_right_channel_source_valid,
	audio_controller_external_interface_ADCDAT,
	audio_controller_external_interface_ADCLRCK,
	audio_controller_external_interface_BCLK,
	audio_controller_external_interface_DACDAT,
	audio_controller_external_interface_DACLRCK,
	audio_pll_0_audio_clk_clk,
	clk_clk,
	dampingvalue_pio_external_connection_export,
	decayvalue_pio_external_connection_export,
	hex0_external_connection_export,
	hex1_external_connection_export,
	hex2_external_connection_export,
	hex3_external_connection_export,
	hex4_external_connection_export,
	hex5_external_connection_export,
	hps_io_hps_io_i2c1_inst_SDA,
	hps_io_hps_io_i2c1_inst_SCL,
	hps_io_hps_io_gpio_inst_GPIO48,
	hps_io_hps_io_gpio_inst_GPIO53,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	mixvalue_pio_external_connection_export,
	paramtype_pio_external_connection_export,
	paramvalueupdate_pio_external_connection_export,
	predelayvalue_pio_external_connection_export,
	reset_reset_n,
	serial_flash_loader_0_noe_in_noe);	

	input	[23:0]	audio_controller_avalon_left_channel_sink_data;
	input		audio_controller_avalon_left_channel_sink_valid;
	output		audio_controller_avalon_left_channel_sink_ready;
	input		audio_controller_avalon_left_channel_source_ready;
	output	[23:0]	audio_controller_avalon_left_channel_source_data;
	output		audio_controller_avalon_left_channel_source_valid;
	input	[23:0]	audio_controller_avalon_right_channel_sink_data;
	input		audio_controller_avalon_right_channel_sink_valid;
	output		audio_controller_avalon_right_channel_sink_ready;
	input		audio_controller_avalon_right_channel_source_ready;
	output	[23:0]	audio_controller_avalon_right_channel_source_data;
	output		audio_controller_avalon_right_channel_source_valid;
	input		audio_controller_external_interface_ADCDAT;
	input		audio_controller_external_interface_ADCLRCK;
	input		audio_controller_external_interface_BCLK;
	output		audio_controller_external_interface_DACDAT;
	input		audio_controller_external_interface_DACLRCK;
	output		audio_pll_0_audio_clk_clk;
	input		clk_clk;
	output	[24:0]	dampingvalue_pio_external_connection_export;
	output	[24:0]	decayvalue_pio_external_connection_export;
	output	[5:0]	hex0_external_connection_export;
	output	[5:0]	hex1_external_connection_export;
	output	[5:0]	hex2_external_connection_export;
	output	[5:0]	hex3_external_connection_export;
	output	[5:0]	hex4_external_connection_export;
	output	[5:0]	hex5_external_connection_export;
	inout		hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_io_hps_io_gpio_inst_GPIO48;
	inout		hps_io_hps_io_gpio_inst_GPIO53;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	output	[23:0]	mixvalue_pio_external_connection_export;
	input	[3:0]	paramtype_pio_external_connection_export;
	input	[1:0]	paramvalueupdate_pio_external_connection_export;
	output	[9:0]	predelayvalue_pio_external_connection_export;
	input		reset_reset_n;
	input		serial_flash_loader_0_noe_in_noe;
endmodule
