	component reverbFPGA_Qsys is
		port (
			audio_controller_avalon_left_channel_sink_data     : in    std_logic_vector(23 downto 0) := (others => 'X'); -- data
			audio_controller_avalon_left_channel_sink_valid    : in    std_logic                     := 'X';             -- valid
			audio_controller_avalon_left_channel_sink_ready    : out   std_logic;                                        -- ready
			audio_controller_avalon_left_channel_source_ready  : in    std_logic                     := 'X';             -- ready
			audio_controller_avalon_left_channel_source_data   : out   std_logic_vector(23 downto 0);                    -- data
			audio_controller_avalon_left_channel_source_valid  : out   std_logic;                                        -- valid
			audio_controller_avalon_right_channel_sink_data    : in    std_logic_vector(23 downto 0) := (others => 'X'); -- data
			audio_controller_avalon_right_channel_sink_valid   : in    std_logic                     := 'X';             -- valid
			audio_controller_avalon_right_channel_sink_ready   : out   std_logic;                                        -- ready
			audio_controller_avalon_right_channel_source_ready : in    std_logic                     := 'X';             -- ready
			audio_controller_avalon_right_channel_source_data  : out   std_logic_vector(23 downto 0);                    -- data
			audio_controller_avalon_right_channel_source_valid : out   std_logic;                                        -- valid
			audio_controller_external_interface_ADCDAT         : in    std_logic                     := 'X';             -- ADCDAT
			audio_controller_external_interface_ADCLRCK        : in    std_logic                     := 'X';             -- ADCLRCK
			audio_controller_external_interface_BCLK           : in    std_logic                     := 'X';             -- BCLK
			audio_controller_external_interface_DACDAT         : out   std_logic;                                        -- DACDAT
			audio_controller_external_interface_DACLRCK        : in    std_logic                     := 'X';             -- DACLRCK
			audio_pll_0_audio_clk_clk                          : out   std_logic;                                        -- clk
			clk_clk                                            : in    std_logic                     := 'X';             -- clk
			dampingvalue_pio_external_connection_export        : out   std_logic_vector(24 downto 0);                    -- export
			decayvalue_pio_external_connection_export          : out   std_logic_vector(24 downto 0);                    -- export
			hps_0_h2f_mpu_events_eventi                        : in    std_logic                     := 'X';             -- eventi
			hps_0_h2f_mpu_events_evento                        : out   std_logic;                                        -- evento
			hps_0_h2f_mpu_events_standbywfe                    : out   std_logic_vector(1 downto 0);                     -- standbywfe
			hps_0_h2f_mpu_events_standbywfi                    : out   std_logic_vector(1 downto 0);                     -- standbywfi
			hps_io_hps_io_uart0_inst_RX                        : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX                        : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c1_inst_SDA                        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL                        : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO48                     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53                     : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			memory_mem_a                                       : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                                      : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                                      : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                                    : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                                     : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                                    : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                                   : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                                   : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                                    : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                                 : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                                      : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                                     : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                                   : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                                     : out   std_logic;                                        -- mem_odt
			memory_mem_dm                                      : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                                   : in    std_logic                     := 'X';             -- oct_rzqin
			mixvalue_pio_external_connection_export            : out   std_logic_vector(23 downto 0);                    -- export
			paramtype_pio_external_connection_export           : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			paramvalueupdate_pio_external_connection_export    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			reset_reset_n                                      : in    std_logic                     := 'X';             -- reset_n
			serial_flash_loader_0_noe_in_noe                   : in    std_logic                     := 'X'              -- noe
		);
	end component reverbFPGA_Qsys;

	u0 : component reverbFPGA_Qsys
		port map (
			audio_controller_avalon_left_channel_sink_data     => CONNECTED_TO_audio_controller_avalon_left_channel_sink_data,     --    audio_controller_avalon_left_channel_sink.data
			audio_controller_avalon_left_channel_sink_valid    => CONNECTED_TO_audio_controller_avalon_left_channel_sink_valid,    --                                             .valid
			audio_controller_avalon_left_channel_sink_ready    => CONNECTED_TO_audio_controller_avalon_left_channel_sink_ready,    --                                             .ready
			audio_controller_avalon_left_channel_source_ready  => CONNECTED_TO_audio_controller_avalon_left_channel_source_ready,  --  audio_controller_avalon_left_channel_source.ready
			audio_controller_avalon_left_channel_source_data   => CONNECTED_TO_audio_controller_avalon_left_channel_source_data,   --                                             .data
			audio_controller_avalon_left_channel_source_valid  => CONNECTED_TO_audio_controller_avalon_left_channel_source_valid,  --                                             .valid
			audio_controller_avalon_right_channel_sink_data    => CONNECTED_TO_audio_controller_avalon_right_channel_sink_data,    --   audio_controller_avalon_right_channel_sink.data
			audio_controller_avalon_right_channel_sink_valid   => CONNECTED_TO_audio_controller_avalon_right_channel_sink_valid,   --                                             .valid
			audio_controller_avalon_right_channel_sink_ready   => CONNECTED_TO_audio_controller_avalon_right_channel_sink_ready,   --                                             .ready
			audio_controller_avalon_right_channel_source_ready => CONNECTED_TO_audio_controller_avalon_right_channel_source_ready, -- audio_controller_avalon_right_channel_source.ready
			audio_controller_avalon_right_channel_source_data  => CONNECTED_TO_audio_controller_avalon_right_channel_source_data,  --                                             .data
			audio_controller_avalon_right_channel_source_valid => CONNECTED_TO_audio_controller_avalon_right_channel_source_valid, --                                             .valid
			audio_controller_external_interface_ADCDAT         => CONNECTED_TO_audio_controller_external_interface_ADCDAT,         --          audio_controller_external_interface.ADCDAT
			audio_controller_external_interface_ADCLRCK        => CONNECTED_TO_audio_controller_external_interface_ADCLRCK,        --                                             .ADCLRCK
			audio_controller_external_interface_BCLK           => CONNECTED_TO_audio_controller_external_interface_BCLK,           --                                             .BCLK
			audio_controller_external_interface_DACDAT         => CONNECTED_TO_audio_controller_external_interface_DACDAT,         --                                             .DACDAT
			audio_controller_external_interface_DACLRCK        => CONNECTED_TO_audio_controller_external_interface_DACLRCK,        --                                             .DACLRCK
			audio_pll_0_audio_clk_clk                          => CONNECTED_TO_audio_pll_0_audio_clk_clk,                          --                        audio_pll_0_audio_clk.clk
			clk_clk                                            => CONNECTED_TO_clk_clk,                                            --                                          clk.clk
			dampingvalue_pio_external_connection_export        => CONNECTED_TO_dampingvalue_pio_external_connection_export,        --         dampingvalue_pio_external_connection.export
			decayvalue_pio_external_connection_export          => CONNECTED_TO_decayvalue_pio_external_connection_export,          --           decayvalue_pio_external_connection.export
			hps_0_h2f_mpu_events_eventi                        => CONNECTED_TO_hps_0_h2f_mpu_events_eventi,                        --                         hps_0_h2f_mpu_events.eventi
			hps_0_h2f_mpu_events_evento                        => CONNECTED_TO_hps_0_h2f_mpu_events_evento,                        --                                             .evento
			hps_0_h2f_mpu_events_standbywfe                    => CONNECTED_TO_hps_0_h2f_mpu_events_standbywfe,                    --                                             .standbywfe
			hps_0_h2f_mpu_events_standbywfi                    => CONNECTED_TO_hps_0_h2f_mpu_events_standbywfi,                    --                                             .standbywfi
			hps_io_hps_io_uart0_inst_RX                        => CONNECTED_TO_hps_io_hps_io_uart0_inst_RX,                        --                                       hps_io.hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX                        => CONNECTED_TO_hps_io_hps_io_uart0_inst_TX,                        --                                             .hps_io_uart0_inst_TX
			hps_io_hps_io_i2c1_inst_SDA                        => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SDA,                        --                                             .hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL                        => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SCL,                        --                                             .hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO48                     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO48,                     --                                             .hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53                     => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO53,                     --                                             .hps_io_gpio_inst_GPIO53
			memory_mem_a                                       => CONNECTED_TO_memory_mem_a,                                       --                                       memory.mem_a
			memory_mem_ba                                      => CONNECTED_TO_memory_mem_ba,                                      --                                             .mem_ba
			memory_mem_ck                                      => CONNECTED_TO_memory_mem_ck,                                      --                                             .mem_ck
			memory_mem_ck_n                                    => CONNECTED_TO_memory_mem_ck_n,                                    --                                             .mem_ck_n
			memory_mem_cke                                     => CONNECTED_TO_memory_mem_cke,                                     --                                             .mem_cke
			memory_mem_cs_n                                    => CONNECTED_TO_memory_mem_cs_n,                                    --                                             .mem_cs_n
			memory_mem_ras_n                                   => CONNECTED_TO_memory_mem_ras_n,                                   --                                             .mem_ras_n
			memory_mem_cas_n                                   => CONNECTED_TO_memory_mem_cas_n,                                   --                                             .mem_cas_n
			memory_mem_we_n                                    => CONNECTED_TO_memory_mem_we_n,                                    --                                             .mem_we_n
			memory_mem_reset_n                                 => CONNECTED_TO_memory_mem_reset_n,                                 --                                             .mem_reset_n
			memory_mem_dq                                      => CONNECTED_TO_memory_mem_dq,                                      --                                             .mem_dq
			memory_mem_dqs                                     => CONNECTED_TO_memory_mem_dqs,                                     --                                             .mem_dqs
			memory_mem_dqs_n                                   => CONNECTED_TO_memory_mem_dqs_n,                                   --                                             .mem_dqs_n
			memory_mem_odt                                     => CONNECTED_TO_memory_mem_odt,                                     --                                             .mem_odt
			memory_mem_dm                                      => CONNECTED_TO_memory_mem_dm,                                      --                                             .mem_dm
			memory_oct_rzqin                                   => CONNECTED_TO_memory_oct_rzqin,                                   --                                             .oct_rzqin
			mixvalue_pio_external_connection_export            => CONNECTED_TO_mixvalue_pio_external_connection_export,            --             mixvalue_pio_external_connection.export
			paramtype_pio_external_connection_export           => CONNECTED_TO_paramtype_pio_external_connection_export,           --            paramtype_pio_external_connection.export
			paramvalueupdate_pio_external_connection_export    => CONNECTED_TO_paramvalueupdate_pio_external_connection_export,    --     paramvalueupdate_pio_external_connection.export
			reset_reset_n                                      => CONNECTED_TO_reset_reset_n,                                      --                                        reset.reset_n
			serial_flash_loader_0_noe_in_noe                   => CONNECTED_TO_serial_flash_loader_0_noe_in_noe                    --                 serial_flash_loader_0_noe_in.noe
		);

