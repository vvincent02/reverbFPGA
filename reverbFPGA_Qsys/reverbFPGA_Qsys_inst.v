	reverbFPGA_Qsys u0 (
		.audio_controller_avalon_left_channel_sink_data     (<connected-to-audio_controller_avalon_left_channel_sink_data>),     //    audio_controller_avalon_left_channel_sink.data
		.audio_controller_avalon_left_channel_sink_valid    (<connected-to-audio_controller_avalon_left_channel_sink_valid>),    //                                             .valid
		.audio_controller_avalon_left_channel_sink_ready    (<connected-to-audio_controller_avalon_left_channel_sink_ready>),    //                                             .ready
		.audio_controller_avalon_left_channel_source_ready  (<connected-to-audio_controller_avalon_left_channel_source_ready>),  //  audio_controller_avalon_left_channel_source.ready
		.audio_controller_avalon_left_channel_source_data   (<connected-to-audio_controller_avalon_left_channel_source_data>),   //                                             .data
		.audio_controller_avalon_left_channel_source_valid  (<connected-to-audio_controller_avalon_left_channel_source_valid>),  //                                             .valid
		.audio_controller_avalon_right_channel_sink_data    (<connected-to-audio_controller_avalon_right_channel_sink_data>),    //   audio_controller_avalon_right_channel_sink.data
		.audio_controller_avalon_right_channel_sink_valid   (<connected-to-audio_controller_avalon_right_channel_sink_valid>),   //                                             .valid
		.audio_controller_avalon_right_channel_sink_ready   (<connected-to-audio_controller_avalon_right_channel_sink_ready>),   //                                             .ready
		.audio_controller_avalon_right_channel_source_ready (<connected-to-audio_controller_avalon_right_channel_source_ready>), // audio_controller_avalon_right_channel_source.ready
		.audio_controller_avalon_right_channel_source_data  (<connected-to-audio_controller_avalon_right_channel_source_data>),  //                                             .data
		.audio_controller_avalon_right_channel_source_valid (<connected-to-audio_controller_avalon_right_channel_source_valid>), //                                             .valid
		.audio_controller_external_interface_ADCDAT         (<connected-to-audio_controller_external_interface_ADCDAT>),         //          audio_controller_external_interface.ADCDAT
		.audio_controller_external_interface_ADCLRCK        (<connected-to-audio_controller_external_interface_ADCLRCK>),        //                                             .ADCLRCK
		.audio_controller_external_interface_BCLK           (<connected-to-audio_controller_external_interface_BCLK>),           //                                             .BCLK
		.audio_controller_external_interface_DACDAT         (<connected-to-audio_controller_external_interface_DACDAT>),         //                                             .DACDAT
		.audio_controller_external_interface_DACLRCK        (<connected-to-audio_controller_external_interface_DACLRCK>),        //                                             .DACLRCK
		.audio_pll_0_audio_clk_clk                          (<connected-to-audio_pll_0_audio_clk_clk>),                          //                        audio_pll_0_audio_clk.clk
		.clk_clk                                            (<connected-to-clk_clk>),                                            //                                          clk.clk
		.dampingvalue_pio_external_connection_export        (<connected-to-dampingvalue_pio_external_connection_export>),        //         dampingvalue_pio_external_connection.export
		.decayvalue_pio_external_connection_export          (<connected-to-decayvalue_pio_external_connection_export>),          //           decayvalue_pio_external_connection.export
		.hex0_external_connection_export                    (<connected-to-hex0_external_connection_export>),                    //                     hex0_external_connection.export
		.hex1_external_connection_export                    (<connected-to-hex1_external_connection_export>),                    //                     hex1_external_connection.export
		.hex2_external_connection_export                    (<connected-to-hex2_external_connection_export>),                    //                     hex2_external_connection.export
		.hex3_external_connection_export                    (<connected-to-hex3_external_connection_export>),                    //                     hex3_external_connection.export
		.hex4_external_connection_export                    (<connected-to-hex4_external_connection_export>),                    //                     hex4_external_connection.export
		.hex5_external_connection_export                    (<connected-to-hex5_external_connection_export>),                    //                     hex5_external_connection.export
		.hps_io_hps_io_i2c1_inst_SDA                        (<connected-to-hps_io_hps_io_i2c1_inst_SDA>),                        //                                       hps_io.hps_io_i2c1_inst_SDA
		.hps_io_hps_io_i2c1_inst_SCL                        (<connected-to-hps_io_hps_io_i2c1_inst_SCL>),                        //                                             .hps_io_i2c1_inst_SCL
		.hps_io_hps_io_gpio_inst_GPIO48                     (<connected-to-hps_io_hps_io_gpio_inst_GPIO48>),                     //                                             .hps_io_gpio_inst_GPIO48
		.hps_io_hps_io_gpio_inst_GPIO53                     (<connected-to-hps_io_hps_io_gpio_inst_GPIO53>),                     //                                             .hps_io_gpio_inst_GPIO53
		.memory_mem_a                                       (<connected-to-memory_mem_a>),                                       //                                       memory.mem_a
		.memory_mem_ba                                      (<connected-to-memory_mem_ba>),                                      //                                             .mem_ba
		.memory_mem_ck                                      (<connected-to-memory_mem_ck>),                                      //                                             .mem_ck
		.memory_mem_ck_n                                    (<connected-to-memory_mem_ck_n>),                                    //                                             .mem_ck_n
		.memory_mem_cke                                     (<connected-to-memory_mem_cke>),                                     //                                             .mem_cke
		.memory_mem_cs_n                                    (<connected-to-memory_mem_cs_n>),                                    //                                             .mem_cs_n
		.memory_mem_ras_n                                   (<connected-to-memory_mem_ras_n>),                                   //                                             .mem_ras_n
		.memory_mem_cas_n                                   (<connected-to-memory_mem_cas_n>),                                   //                                             .mem_cas_n
		.memory_mem_we_n                                    (<connected-to-memory_mem_we_n>),                                    //                                             .mem_we_n
		.memory_mem_reset_n                                 (<connected-to-memory_mem_reset_n>),                                 //                                             .mem_reset_n
		.memory_mem_dq                                      (<connected-to-memory_mem_dq>),                                      //                                             .mem_dq
		.memory_mem_dqs                                     (<connected-to-memory_mem_dqs>),                                     //                                             .mem_dqs
		.memory_mem_dqs_n                                   (<connected-to-memory_mem_dqs_n>),                                   //                                             .mem_dqs_n
		.memory_mem_odt                                     (<connected-to-memory_mem_odt>),                                     //                                             .mem_odt
		.memory_mem_dm                                      (<connected-to-memory_mem_dm>),                                      //                                             .mem_dm
		.memory_oct_rzqin                                   (<connected-to-memory_oct_rzqin>),                                   //                                             .oct_rzqin
		.mixvalue_pio_external_connection_export            (<connected-to-mixvalue_pio_external_connection_export>),            //             mixvalue_pio_external_connection.export
		.paramtype_pio_external_connection_export           (<connected-to-paramtype_pio_external_connection_export>),           //            paramtype_pio_external_connection.export
		.paramvalueupdate_pio_external_connection_export    (<connected-to-paramvalueupdate_pio_external_connection_export>),    //     paramvalueupdate_pio_external_connection.export
		.reset_reset_n                                      (<connected-to-reset_reset_n>),                                      //                                        reset.reset_n
		.serial_flash_loader_0_noe_in_noe                   (<connected-to-serial_flash_loader_0_noe_in_noe>)                    //                 serial_flash_loader_0_noe_in.noe
	);

