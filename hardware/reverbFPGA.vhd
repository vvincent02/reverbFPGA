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
	AUD_DACDAT : OUT std_logic;
	AUD_DACLRCK : IN  std_logic;
	
	-- signaux d'interface avec la mémoire DDR3 du HPS
	HPS_DDR3_A : OUT std_logic_vector(12 downto 0); 
	HPS_DDR3_BA : OUT std_logic_vector(2 downto 0);
	HPS_DDR3_CK_p : OUT std_logic;
	HPS_DDR3_CK_n : OUT std_logic;
	HPS_DDR3_CKE : OUT std_logic;
	HPS_DDR3_CS_n : OUT std_logic;
	HPS_DDR3_RAS_n : OUT std_logic;
	HPS_DDR3_CAS_n : OUT std_logic;
	HPS_DDR3_WE_n : OUT std_logic;
	HPS_DDR3_RESET_n : OUT std_logic;
	HPS_DDR3_DQ : INOUT std_logic_vector(7 downto 0);
	HPS_DDR3_DQS_p : INOUT std_logic;
	HPS_DDR3_DQS_n : INOUT std_logic;
	HPS_DDR3_ODT : OUT std_logic;
	HPS_DDR3_RZQ : IN std_logic;
	
	HPS_eventI : IN std_logic;
	HPS_eventO : OUT std_logic;
	HPS_standbywfe : OUT std_logic_vector(1 downto 0);
	HPS_standbywfi : OUT std_logic_vector(1 downto 0);
	
	HPS_I2C1_SDAT : INOUT std_logic;
	HPS_I2C1_SCLK : OUT std_logic;
	HPS_I2C_CONTROL : INOUT std_logic
);
END reverbFPGA;

ARCHITECTURE archi OF reverbFPGA IS

-- horloge de cadencement des opérations numériques
signal clkSampling : std_logic;

-- paramètres de la reverb
signal preDelayValue : std_logic_vector(23 downto 0);
signal decayValue : std_logic_vector(23 downto 0);
signal dampingValue : std_logic_vector(23 downto 0);
signal mixValue : std_logic_vector(23 downto 0);

-- signaux audio d'entrée et de sortie (signaux du bus avalon streaming)
signal audioIN_ready : std_logic;
signal audioIN_valid : std_logic;
signal audioIN_data : std_logic_vector(23 downto 0);
signal audioOUT_ready : std_logic;
signal audioOUT_valid : std_logic;
signal audioOUT_data : std_logic_vector(23 downto 0);

-- signal de sortie avant remise à l'échelle sur 24 bits signés
signal dataOUT : signed(40 downto 0);

-- Qsys component
component reverbFPGA_Qsys is
port (
	clk_clk                                           : in    std_logic                     := 'X';             -- clk
	dampingvalue_pio_external_connection_export       : out   std_logic_vector(23 downto 0);                    -- export
	decayvalue_pio_external_connection_export         : out   std_logic_vector(23 downto 0);                    -- export
	memory_mem_a                                      : out   std_logic_vector(12 downto 0);                    -- mem_a
	memory_mem_ba                                     : out   std_logic_vector(2 downto 0);                     -- mem_ba
	memory_mem_ck                                     : out   std_logic;                                        -- mem_ck
	memory_mem_ck_n                                   : out   std_logic;                                        -- mem_ck_n
	memory_mem_cke                                    : out   std_logic;                                        -- mem_cke
	memory_mem_cs_n                                   : out   std_logic;                                        -- mem_cs_n
	memory_mem_ras_n                                  : out   std_logic;                                        -- mem_ras_n
	memory_mem_cas_n                                  : out   std_logic;                                        -- mem_cas_n
	memory_mem_we_n                                   : out   std_logic;                                        -- mem_we_n
	memory_mem_reset_n                                : out   std_logic;                                        -- mem_reset_n
	memory_mem_dq                                     : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dq
	memory_mem_dqs                                    : inout std_logic                     := 'X';             -- mem_dqs
	memory_mem_dqs_n                                  : inout std_logic                     := 'X';             -- mem_dqs_n
	memory_mem_odt                                    : out   std_logic;                                        -- mem_odt
	memory_oct_rzqin                                  : in    std_logic                     := 'X';             -- oct_rzqin
	mixvalue_pio_external_connection_export           : out   std_logic_vector(23 downto 0);                    -- export
	paramtype_pio_external_connection_export          : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
	paramvalueupdate_pio_external_connection_export   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
	predelayvalue_pio_external_connection_export      : out   std_logic_vector(23 downto 0);                    -- export
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
	
	hps_0_h2f_mpu_events_eventi                       : in    std_logic                     := 'X';             -- eventi
   hps_0_h2f_mpu_events_evento                       : out   std_logic;                                        -- evento
   hps_0_h2f_mpu_events_standbywfe                   : out   std_logic_vector(1 downto 0);                     -- standbywfe
	hps_0_h2f_mpu_events_standbywfi                   : out   std_logic_vector(1 downto 0);                     -- standbywfi

	hps_io_hps_io_gpio_inst_GPIO48                    : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
	
	serial_flash_loader_0_noe_in_noe                  : in    std_logic                     := 'X';              -- noe
	
	audio_config_external_interface_SDAT              : inout std_logic                     := 'X';             -- SDAT
   audio_config_external_interface_SCLK              : out   std_logic                                         -- SCLK
);
end component reverbFPGA_Qsys;

BEGIN

Qsys : component reverbFPGA_Qsys
port map (
	clk_clk                                           => CLOCK_50,                                           --                                         clk.clk
	dampingvalue_pio_external_connection_export       => dampingValue,       --        dampingvalue_pio_external_connection.export
	decayvalue_pio_external_connection_export         => decayValue,         --          decayvalue_pio_external_connection.export
	mixvalue_pio_external_connection_export           => mixValue,           --            mixvalue_pio_external_connection.export
	paramtype_pio_external_connection_export      => paramType,      --       paramtype_pio_external_connection.export
	predelayvalue_pio_external_connection_export      => preDelayValue,      --       predelayvalue_pio_external_connection.export
	reset_reset_n                                     => rst,                                     --                                       reset.reset_n
	audio_controller_avalon_left_channel_source_ready => audioIN_ready, -- audio_controller_avalon_left_channel_source.ready
	audio_controller_avalon_left_channel_source_data  => audioIN_data,  --                                            .data
	audio_controller_avalon_left_channel_source_valid => audioIN_valid, --                                            .valid
	audio_controller_avalon_left_channel_sink_data    => audioOUT_data,    --   audio_controller_avalon_left_channel_sink.data
	audio_controller_avalon_left_channel_sink_valid   => audioOUT_valid,   --                                            .valid
	audio_controller_avalon_left_channel_sink_ready   => audioOUT_ready,   --                                            .ready
	paramvalueupdate_pio_external_connection_export   => paramValueUpdate,   --    paramvalueupdate_pio_external_connection.export
	audio_controller_external_interface_ADCDAT        => AUD_ADCDAT,        --         audio_controller_external_interface.ADCDAT
	audio_controller_external_interface_ADCLRCK       => AUD_ADCLRCK,       --                                            .ADCLRCK
	audio_controller_external_interface_BCLK          => AUD_BCLK,          --                                            .BCLK
	audio_controller_external_interface_DACDAT        => AUD_DACDAT,        --                                            .DACDAT
	audio_controller_external_interface_DACLRCK       => AUD_DACLRCK,	--                                            .DACLRCK
	
	memory_mem_a                                      => HPS_DDR3_A,                                      --                                      memory.mem_a
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
	memory_oct_rzqin                                  => HPS_DDR3_RZQ,

	hps_0_h2f_mpu_events_eventi                       => open,                       --                        hps_0_h2f_mpu_events.eventi
	hps_0_h2f_mpu_events_evento                       => open,                       --                                            .evento
	hps_0_h2f_mpu_events_standbywfe                   => open,                   --                                            .standbywfe
	hps_0_h2f_mpu_events_standbywfi                   => open,                   --                                            .standbywfi

	hps_io_hps_io_gpio_inst_GPIO48                    => HPS_I2C_CONTROL,                    --                                      hps_io.hps_io_gpio_inst_GPIO48
	
	serial_flash_loader_0_noe_in_noe => '0',
	
	audio_config_external_interface_SDAT              => HPS_I2C1_SDAT,              --             audio_config_external_interface.SDAT
   audio_config_external_interface_SCLK              => HPS_I2C1_SCLK               --                                            .SCLK
);

clkSamlingDivider : entity work.clkDivider(archi)
	generic map(1042)
	port map(clk => CLOCK_50, rst => rst, clkDiv => clkSampling);

lateReverbComponent : entity work.lateReverb(archi)
	generic map(41)
	port map(clk => clkSampling, rst => rst, dataIN => resize(signed(audioIN_data), 41), dataOUT => dataOUT, dampingValue => "10000000000000000000000000000000000000000", decayValue => "10000000000000000000000000000000000000000", g => "10000000000000000000000000000000000000000");  

audioOUT_ready <= audioIN_ready;
audioOUT_valid <= audioIN_valid;
audioOUT_data <= std_logic_vector(dataOUT(dataOUT'high downto 41-audioIN_data'length));

END archi;