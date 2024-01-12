
module reverbFPGA_Qsys (
	audio_controller_avalon_left_channel_sink_data,
	audio_controller_avalon_left_channel_sink_valid,
	audio_controller_avalon_left_channel_sink_ready,
	audio_controller_avalon_left_channel_source_ready,
	audio_controller_avalon_left_channel_source_data,
	audio_controller_avalon_left_channel_source_valid,
	audio_controller_external_interface_ADCDAT,
	audio_controller_external_interface_ADCLRCK,
	audio_controller_external_interface_BCLK,
	audio_controller_external_interface_DACDAT,
	audio_controller_external_interface_DACLRCK,
	clk_clk,
	dampingvalue_pio_external_connection_export,
	decayvalue_pio_external_connection_export,
	hps_0_h2f_mpu_events_eventi,
	hps_0_h2f_mpu_events_evento,
	hps_0_h2f_mpu_events_standbywfe,
	hps_0_h2f_mpu_events_standbywfi,
	hps_io_hps_io_gpio_inst_GPIO48,
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
	memory_oct_rzqin,
	mixvalue_pio_external_connection_export,
	paramtype_pio_external_connection_export,
	paramvalueupdate_pio_external_connection_export,
	predelayvalue_pio_external_connection_export,
	reset_reset_n,
	serial_flash_loader_0_noe_in_noe,
	audio_config_external_interface_SDAT,
	audio_config_external_interface_SCLK);	

	input	[23:0]	audio_controller_avalon_left_channel_sink_data;
	input		audio_controller_avalon_left_channel_sink_valid;
	output		audio_controller_avalon_left_channel_sink_ready;
	input		audio_controller_avalon_left_channel_source_ready;
	output	[23:0]	audio_controller_avalon_left_channel_source_data;
	output		audio_controller_avalon_left_channel_source_valid;
	input		audio_controller_external_interface_ADCDAT;
	input		audio_controller_external_interface_ADCLRCK;
	input		audio_controller_external_interface_BCLK;
	output		audio_controller_external_interface_DACDAT;
	input		audio_controller_external_interface_DACLRCK;
	input		clk_clk;
	output	[23:0]	dampingvalue_pio_external_connection_export;
	output	[23:0]	decayvalue_pio_external_connection_export;
	input		hps_0_h2f_mpu_events_eventi;
	output		hps_0_h2f_mpu_events_evento;
	output	[1:0]	hps_0_h2f_mpu_events_standbywfe;
	output	[1:0]	hps_0_h2f_mpu_events_standbywfi;
	inout		hps_io_hps_io_gpio_inst_GPIO48;
	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	input		memory_oct_rzqin;
	output	[23:0]	mixvalue_pio_external_connection_export;
	input	[3:0]	paramtype_pio_external_connection_export;
	input	[1:0]	paramvalueupdate_pio_external_connection_export;
	output	[23:0]	predelayvalue_pio_external_connection_export;
	input		reset_reset_n;
	input		serial_flash_loader_0_noe_in_noe;
	inout		audio_config_external_interface_SDAT;
	output		audio_config_external_interface_SCLK;
endmodule
