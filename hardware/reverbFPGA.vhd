library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY reverbFPGA IS
PORT(
	CLOCK_50 : IN std_logic;
	rst : IN std_logic;
	
	-- choix du paramètre de reverb et changement de la valeur du paramètre
	paramType : IN std_logic_vector(3 downto 0);
	paramValueUpdate : IN std_logic_vector(1 downto 0);
	
	-- signaux d'interfaçage du FPGA avec le CODEC audio
	AUD_ADCDAT : IN std_logic;
	AUD_ADCLRCK : IN std_logic;
	AUD_BCLK : IN std_logic;
	AUD_XCK : OUT std_logic;
	AUD_DACDAT : OUT std_logic;
	AUD_DACLRCK : IN  std_logic;
	
	-- signaux d'interface avec la mémoire DDR3 du HPS
	HPS_DDR3_ADDR : OUT std_logic_vector(14 downto 0); 
	HPS_DDR3_BA : OUT std_logic_vector(2 downto 0);
	HPS_DDR3_CK_P : OUT std_logic;
	HPS_DDR3_CK_N : OUT std_logic;
	HPS_DDR3_CKE : OUT std_logic;
	HPS_DDR3_CS_N : OUT std_logic;
	HPS_DDR3_RAS_N : OUT std_logic;
	HPS_DDR3_CAS_N : OUT std_logic;
	HPS_DDR3_WE_N : OUT std_logic;
	HPS_DDR3_RESET_N : OUT std_logic;
	HPS_DDR3_DQ : INOUT std_logic_vector(31 downto 0);
	HPS_DDR3_DQS_P : INOUT std_logic_vector(3 downto 0);
	HPS_DDR3_DQS_N : INOUT std_logic_vector(3 downto 0);
	HPS_DDR3_ODT : OUT std_logic;
	HPS_DDR3_DM : OUT std_logic_vector(3 downto 0);
	HPS_DDR3_RZQ : IN std_logic;
	
	HPS_eventI : IN std_logic;
	HPS_eventO : OUT std_logic;
	HPS_standbywfe : OUT std_logic_vector(1 downto 0);
	HPS_standbywfi : OUT std_logic_vector(1 downto 0);
	
	HPS_I2C1_SDAT : INOUT std_logic;
	HPS_I2C1_SCLK : INOUT std_logic;
	HPS_I2C_CONTROL : INOUT std_logic;
	HPS_UART_RX : IN std_logic;
	HPS_UART_TX : OUT std_logic;
	HPS_LED : INOUT std_logic;
	
	LEDR_1 : OUT std_logic;
	stereo_n_mono : IN std_logic
);
END reverbFPGA;

ARCHITECTURE archi OF reverbFPGA IS

-- horloge de cadencement des opérations numériques
signal samplingClk : std_logic;

---- paramètres de la reverb
--signal preDelayValue : std_logic_vector(23 downto 0);
--signal decayValue : std_logic_vector(23 downto 0);
--signal dampingValue : std_logic_vector(23 downto 0);
--signal mixValue : std_logic_vector(23 downto 0);

-- signaux audio d'entrée et de sortie gauche/droite (signaux du bus avalon streaming)
signal audioL_IN_ready : std_logic;
signal audioL_IN_valid : std_logic;
signal audioL_IN_data : std_logic_vector(23 downto 0);
signal audioL_OUT_ready : std_logic;
signal audioL_OUT_valid : std_logic;
signal audioL_OUT_data : std_logic_vector(23 downto 0);
signal audioR_IN_ready : std_logic;
signal audioR_IN_valid : std_logic;
signal audioR_IN_data : std_logic_vector(23 downto 0);
signal audioR_OUT_ready : std_logic;
signal audioR_OUT_valid : std_logic;
signal audioR_OUT_data : std_logic_vector(23 downto 0);


-- signaux interfaçe controleur audio / traitement reverb
type interfaceState_type is (idle, transferData, endTransfer);
signal interfaceStateL : interfaceState_type;
signal interfaceStateR : interfaceState_type;
signal dataL_IN : std_logic_vector(23 downto 0); -- sortie de l'interfaçe
signal dataL_IN_toSampleRate : std_logic_vector(23 downto 0); -- sortie bascule D (cadencé sur sampleClk) avec pour entrée dataL_IN 
signal dataL_IN_stable : std_logic_vector(23 downto 0); -- sortie seconde bascule D (cadencé sur sampleClk) pour éviter la métastabilité / entrée traitement reverb
signal dataL_OUT : std_logic_vector(23 downto 0); -- sortie traitement reverb
signal dataL_OUT_to50MRate : std_logic_vector(23 downto 0); -- sortie bascule D (cadencé sur clk50MHz)
signal dataL_OUT_stable : std_logic_vector(23 downto 0); -- sortie seconde bascule D / entrée interfaçe
signal dataR_IN : std_logic_vector(23 downto 0); -- sortie de l'interfaçe
signal dataR_IN_toSampleRate : std_logic_vector(23 downto 0); -- sortie bascule D (cadencé sur sampleClk) avec pour entrée dataL_IN 
signal dataR_IN_stable : std_logic_vector(23 downto 0); -- sortie seconde bascule D (cadencé sur sampleClk) pour éviter la métastabilité / entrée traitement reverb
signal dataR_OUT : std_logic_vector(23 downto 0); -- sortie traitement reverb
signal dataR_OUT_to50MRate : std_logic_vector(23 downto 0); -- sortie bascule D (cadencé sur clk50MHz)
signal dataR_OUT_stable : std_logic_vector(23 downto 0); -- sortie seconde bascule D / entrée interfaçe


-- signal de sortie avant remise à l'échelle sur 24 bits signés
signal dataL_OUT_extended : signed(40 downto 0);


-- Qsys component
component reverbFPGA_Qsys is
port (
	clk_clk                                           : in    std_logic                     := 'X';             -- clk
--	dampingvalue_pio_external_connection_export       : out   std_logic_vector(23 downto 0);                    -- export
--	decayvalue_pio_external_connection_export         : out   std_logic_vector(23 downto 0);                    -- export
	memory_mem_a                                      : out   std_logic_vector(14 downto 0);                    -- mem_a
	memory_mem_ba                                     : out   std_logic_vector(2 downto 0);                     -- mem_ba
	memory_mem_ck                                     : out   std_logic;                                        -- mem_ck
	memory_mem_ck_n                                   : out   std_logic;                                        -- mem_ck_n
	memory_mem_cke                                    : out   std_logic;                                        -- mem_cke
	memory_mem_cs_n                                   : out   std_logic;                                        -- mem_cs_n
	memory_mem_ras_n                                  : out   std_logic;                                        -- mem_ras_n
	memory_mem_cas_n                                  : out   std_logic;                                        -- mem_cas_n
	memory_mem_we_n                                   : out   std_logic;                                        -- mem_we_n
	memory_mem_reset_n                                : out   std_logic;                                        -- mem_reset_n
	memory_mem_dq                                     : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
	memory_mem_dqs                                    : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
	memory_mem_dqs_n                                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
	memory_mem_odt                                    : out   std_logic;                                        -- mem_odt
	memory_mem_dm                                     : out   std_logic_vector(3 downto 0);                     -- mem_dm
	memory_oct_rzqin                                  : in    std_logic                     := 'X';             -- oct_rzqin
--	mixvalue_pio_external_connection_export           : out   std_logic_vector(23 downto 0);                    -- export
--	paramtype_pio_external_connection_export          : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
--	paramvalueupdate_pio_external_connection_export   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
--	predelayvalue_pio_external_connection_export      : out   std_logic_vector(23 downto 0);                    -- export
	reset_reset_n                                     : in    std_logic                     := 'X';             -- reset_n
	audio_controller_external_interface_ADCDAT        : in    std_logic                     := 'X';             -- ADCDAT
	audio_controller_external_interface_ADCLRCK       : in    std_logic                     := 'X';             -- ADCLRCK
	audio_controller_external_interface_BCLK          : in    std_logic                     := 'X';             -- BCLK
	audio_controller_external_interface_DACDAT        : out   std_logic;                                        -- DACDAT
	audio_controller_external_interface_DACLRCK       : in    std_logic                     := 'X';             -- DACLRCK
	audio_controller_avalon_left_channel_sink_data    : in    std_logic_vector(23 downto 0) := (others => 'X'); -- data
	audio_controller_avalon_left_channel_sink_valid   : in    std_logic                     := 'X';             -- valid
	audio_controller_avalon_left_channel_sink_ready   : out   std_logic;                                        -- ready
	audio_controller_avalon_left_channel_source_ready : in    std_logic                     := 'X';             -- ready
	audio_controller_avalon_left_channel_source_data  : out   std_logic_vector(23 downto 0);                    -- data
	audio_controller_avalon_left_channel_source_valid : out   std_logic;	-- valid
	audio_controller_avalon_right_channel_source_ready : in    std_logic                     := 'X';             -- ready
	audio_controller_avalon_right_channel_source_data  : out   std_logic_vector(23 downto 0);                    -- data
	audio_controller_avalon_right_channel_source_valid : out   std_logic;                                        -- valid
	audio_controller_avalon_right_channel_sink_data    : in    std_logic_vector(23 downto 0) := (others => 'X'); -- data
	audio_controller_avalon_right_channel_sink_valid   : in    std_logic                     := 'X';             -- valid
	audio_controller_avalon_right_channel_sink_ready   : out   std_logic;                                         -- ready

	hps_0_h2f_mpu_events_eventi                       : in    std_logic                     := 'X';             -- eventi
   hps_0_h2f_mpu_events_evento                       : out   std_logic;                                        -- evento
   hps_0_h2f_mpu_events_standbywfe                   : out   std_logic_vector(1 downto 0);                     -- standbywfe
	hps_0_h2f_mpu_events_standbywfi                   : out   std_logic_vector(1 downto 0);                     -- standbywfi
	
	serial_flash_loader_0_noe_in_noe                  : in    std_logic                     := 'X';              -- noe
	
	hps_io_hps_io_uart0_inst_RX                       : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
	hps_io_hps_io_uart0_inst_TX                       : out   std_logic;                                        -- hps_io_uart0_inst_TX
	hps_io_hps_io_i2c1_inst_SDA                       : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
	hps_io_hps_io_i2c1_inst_SCL                       : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
	hps_io_hps_io_gpio_inst_GPIO53                    : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO00
   hps_io_hps_io_gpio_inst_GPIO48                    : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48

	clksampling_clk                                   : out   std_logic;                                         -- clk
	audio_pll_0_audio_clk_clk                         : out   std_logic                                         -- clk
);
end component reverbFPGA_Qsys;

BEGIN

Qsys : component reverbFPGA_Qsys
port map (
	clk_clk                                           => CLOCK_50,                                           --                                         clk.clk
--	dampingvalue_pio_external_connection_export       => dampingValue,       --        dampingvalue_pio_external_connection.export
--	decayvalue_pio_external_connection_export         => decayValue,         --          decayvalue_pio_external_connection.export
--	mixvalue_pio_external_connection_export           => mixValue,           --            mixvalue_pio_external_connection.export
--	paramtype_pio_external_connection_export      => paramType,      --       paramtype_pio_external_connection.export
--	paramvalueupdate_pio_external_connection_export   => paramValueUpdate,   --    paramvalueupdate_pio_external_connection.export
--	predelayvalue_pio_external_connection_export      => preDelayValue,      --       predelayvalue_pio_external_connection.export
	reset_reset_n                                     => rst,                                     --                                       reset.reset_n
	audio_controller_avalon_left_channel_source_ready => audioL_IN_ready, -- audio_controller_avalon_left_channel_source.ready
	audio_controller_avalon_left_channel_source_data  => audioL_IN_data,  --                                            .data
	audio_controller_avalon_left_channel_source_valid => audioL_IN_valid, --                                            .valid
	audio_controller_avalon_left_channel_sink_data    => audioL_OUT_data,    --   audio_controller_avalon_left_channel_sink.data
	audio_controller_avalon_left_channel_sink_valid   => audioL_OUT_valid,   --                                            .valid
	audio_controller_avalon_left_channel_sink_ready   => audioL_OUT_ready,   --                                            .ready
	audio_controller_avalon_right_channel_source_ready => audioR_IN_ready, -- audio_controller_avalon_right_channel_source.ready
	audio_controller_avalon_right_channel_source_data  => audioR_IN_data,  --                                             .data
	audio_controller_avalon_right_channel_source_valid => audioR_IN_valid, --                                             .valid
	audio_controller_avalon_right_channel_sink_data    => audioR_OUT_data,    --   audio_controller_avalon_right_channel_sink.data
	audio_controller_avalon_right_channel_sink_valid   => audioR_OUT_valid,   --                                             .valid
	audio_controller_avalon_right_channel_sink_ready   => audioR_OUT_ready,    --                                             .ready

	audio_controller_external_interface_ADCDAT        => AUD_ADCDAT,        --         audio_controller_external_interface.ADCDAT
	audio_controller_external_interface_ADCLRCK       => AUD_ADCLRCK,       --                                            .ADCLRCK
	audio_controller_external_interface_BCLK          => AUD_BCLK,          --                                            .BCLK
	audio_controller_external_interface_DACDAT        => AUD_DACDAT,        --                                            .DACDAT
	audio_controller_external_interface_DACLRCK       => AUD_DACLRCK,	--                                            .DACLRCK
	
	memory_mem_a                                      => HPS_DDR3_ADDR,                                      --                                      memory.mem_a
	memory_mem_ba                                     => HPS_DDR3_BA,                                     --                                            .mem_ba
	memory_mem_ck                                     => HPS_DDR3_CK_p,                                     --                                            .mem_ck
	memory_mem_ck_n                                   => HPS_DDR3_CK_n,                                   --                                            .mem_ck_n
	memory_mem_cke                                    => HPS_DDR3_CKE,                                    --                                            .mem_cke
	memory_mem_cs_n                                   => HPS_DDR3_CS_n,                                   --                                            .mem_cs_n
	memory_mem_ras_n                                  => HPS_DDR3_RAS_n,                                  --                                            .mem_ras_n
	memory_mem_cas_n                                  => HPS_DDR3_CAS_n,                                  --                                            .mem_cas_n
	memory_mem_we_n                                   => HPS_DDR3_WE_n,                                   --                                            .mem_we_n
	memory_mem_reset_n                                => HPS_DDR3_RESET_n,                                --                                            .mem_reset_n
	memory_mem_dq                                     => HPS_DDR3_DQ,                                     --                                            .mem_dq
	memory_mem_dqs                                    => HPS_DDR3_DQS_p,                                    --                                            .mem_dqs
	memory_mem_dqs_n                                  => HPS_DDR3_DQS_n,                                  --                                            .mem_dqs_n
	memory_mem_odt                                    => HPS_DDR3_ODT,                                    --                                            .mem_odt
	memory_mem_dm                                     => HPS_DDR3_DM,                                     --                                            .mem_dm
	memory_oct_rzqin                                  => HPS_DDR3_RZQ,

	hps_0_h2f_mpu_events_eventi                       => open,                       --                        hps_0_h2f_mpu_events.eventi
	hps_0_h2f_mpu_events_evento                       => open,                       --                                            .evento
	hps_0_h2f_mpu_events_standbywfe                   => open,                   --                                            .standbywfe
	hps_0_h2f_mpu_events_standbywfi                   => open,                   --                                            .standbywfi
	
	serial_flash_loader_0_noe_in_noe => '0',
	
	hps_io_hps_io_uart0_inst_RX                       => HPS_UART_RX,                       --                                      hps_io.hps_io_uart0_inst_RX
	hps_io_hps_io_uart0_inst_TX                       => HPS_UART_TX,                       --                                            .hps_io_uart0_inst_TX
	hps_io_hps_io_i2c1_inst_SDA                       => HPS_I2C1_SDAT,                       --                                            .hps_io_i2c0_inst_SDA
	hps_io_hps_io_i2c1_inst_SCL                       => HPS_I2C1_SCLK,                       --                                            .hps_io_i2c0_inst_SCL
	hps_io_hps_io_gpio_inst_GPIO53                    => HPS_LED,                    --                                            .hps_io_gpio_inst_GPIO00
   hps_io_hps_io_gpio_inst_GPIO48                    => HPS_I2C_CONTROL,                    --                                            .hps_io_gpio_inst_GPIO48
	
	clksampling_clk                                   => samplingClk,                                    --                                 clksampling.clk

	audio_pll_0_audio_clk_clk                         => AUD_XCK                          --                       audio_pll_0_audio_clk.clk
);

interfaceL : entity work.interface_AVST_proc(archi)
	generic map(24)
	port map(clk50M => CLOCK_50, samplingClk => samplingClk, rst => rst, 
				audio_IN_ready => audioL_IN_ready, 
				audio_IN_valid => audioL_IN_valid,
				audio_IN_data => audioL_IN_data,
				audio_OUT_ready => audioL_OUT_ready, 
				audio_OUT_valid => audioL_OUT_valid,
				audio_OUT_data => audioL_OUT_data,
				data_IN => dataL_IN,
				data_OUT_stable => dataL_OUT_stable);
				
interfaceR : entity work.interface_AVST_proc(archi)
	generic map(24)
	port map(clk50M => CLOCK_50, samplingClk => samplingClk, rst => rst, 
				audio_IN_ready => audioR_IN_ready, 
				audio_IN_valid => audioR_IN_valid,
				audio_IN_data => audioR_IN_data,
				audio_OUT_ready => audioR_OUT_ready, 
				audio_OUT_valid => audioR_OUT_valid,
				audio_OUT_data => audioR_OUT_data,
				data_IN => dataR_IN,
				data_OUT_stable => dataR_OUT_stable);

--dataR_OUT_stable <= dataR_OUT;

---- disponibilité des données d'entrées sous le cadencement de l'horloge d'échantillonnage
--dataL_IN_crossingClk : process(samplingClk, rst)
--begin
--	if(samplingClk'EVENT and samplingClk = '1') then
--		if(rst = '0') then
--			dataL_IN_toSampleRate <= (others => '0');
--			dataL_IN_stable <= (others => '0');
--		else 
--			dataL_IN_toSampleRate <= dataL_IN;
--			dataL_IN_stable <= dataL_IN_toSampleRate;
--		end if;
--	end if;
--end process; 
--
---- disponibilité des données de sortie sous le cadencement de l'horloge d'échantillonnage
--dataL_OUT_crossingClk : process(CLOCK_50, rst)
--begin
--	if(CLOCK_50'EVENT and CLOCK_50 = '1') then
--		if(rst = '0') then
--			dataL_OUT_to50MRate <= (others => '0');
--			dataL_OUT_stable <= (others => '0');
--		else 
--			dataL_OUT_to50MRate <= dataL_OUT;
--			dataL_OUT_stable <= dataL_OUT_to50MRate;
--		end if;
--	end if;
--end process;


--lateReverbComponent : entity work.lateReverb(archi)
--	generic map(41)
--	port map(clk50M => CLOCK_50, samplingClk => samplingClk, rst => rst, dataL_IN => resize(signed(dataL_IN_stable), 41), dataL_OUT => dataL_OUT_extended, dampingValue => "10000000000000000000000000000000000000000", decayValue => "10000000000000000000000000000000000000000", g => "10000000000000000000000000000000000000000");  
--
--dataL_OUT <= dataL_IN_stable when (samplingClk'EVENT and samplingClk='1');
--dataL_OUT <= std_logic_vector(dataL_OUT_extended(40 downto 17));
--
----dataL_OUT <= (others => '0');
--
END archi;