library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY interface_AVST_proc IS
GENERIC(
	dataSize : integer range 0 to 63
);
PORT(
	clk50M : IN std_logic;
	samplingClk : IN std_logic;
	rst : IN std_logic;
	
	signal audio_IN_ready : OUT std_logic;
	signal audio_IN_valid : IN std_logic;
	signal audio_IN_data : IN std_logic_vector(dataSize-1 downto 0);
	signal audio_OUT_ready : IN std_logic;
	signal audio_OUT_valid : OUT std_logic;
	signal audio_OUT_data : OUT std_logic_vector(dataSize-1 downto 0);
	
	-- données sous le cadencement de l'horloge d'échantillonnage
	signal data_IN_sampleRate : OUT std_logic_vector(dataSize-1 downto 0); -- sortie de l'interfaçe (cadencé sous l'horloge d'échantillonnage)
	signal data_OUT_sampleRate : IN std_logic_vector(dataSize-1 downto 0) -- entrée de l'interfaçe (cadencé sous l'horloge d'échantillonnage)
);
END interface_AVST_proc;

ARCHITECTURE archi OF interface_AVST_proc IS

type interfaceState_type is (idle, transferData, endTransfer);
signal interfaceState : interfaceState_type;

-- signaux pour le changement de domaine d'horloge (50MHz <-> horloge d'échantillonnage)
signal data_IN_50MRate : std_logic_vector(dataSize-1 downto 0); -- données d'entrée ADC (cadencés à 50MHz) issues du bus avalon
signal data_IN_toSampleRate : std_logic_vector(dataSize-1 downto 0); -- sortie bascule D (cadencé sur sampleClk) avec pour entrée data_IN_50MRate
signal data_OUT_to50MRate : std_logic_vector(dataSize-1 downto 0); -- sortie bascule D (cadencé à 50MHz) avec pour entrée data_OUT_sampleRate           
signal data_OUT_50MRate : std_logic_vector(dataSize-1 downto 0); -- données de sortie DAC (cadencés à 50MHz) envoyées sur le bus avalon

BEGIN

-- machine d'état permettant l'interfaçage entre les données du controleur audio (bus avalon streaming) et celles traitées en dur dans le FPGA
interface : process(clk50M, rst)
begin
	if(clk50M'EVENT and clk50M='1') then
		if(rst = '0') then -- reset synchrone
			interfaceState <= idle;
		else
			case interfaceState is 
				when idle =>
					audio_IN_ready <= '0';
					audio_OUT_valid <= '0';
					if(audio_IN_valid = '1') then
						interfaceState <= transferData;
					end if;
				when transferData =>
					-- data IN are read from the audio controller source while asserting ready
					audio_IN_ready <= '1';
					data_IN_50MRate <= audio_IN_data;
					 
					-- data OUT are loaded and ready to be read by the audio controller sink
					audio_OUT_valid <= '1';
					audio_OUT_data <= data_OUT_50MRate;
					
					interfaceState <= endTransfer;
				when endTransfer =>
					-- wait while the audio controller sink has not assert ready
					if(audio_OUT_ready = '1') then
						interfaceState <= idle;
					end if;
			end case;
		end if;
	end if;
end process;

-- disponibilité des données d'entrées sous le cadencement de l'horloge d'échantillonnage -> data_IN_sampleRate
data_IN_crossingClk : process(samplingClk, rst)
begin
	if(samplingClk'EVENT and samplingClk = '1') then
		if(rst = '0') then
			data_IN_toSampleRate <= (others => '0');
			data_IN_sampleRate <= (others => '0');
		else 
			data_IN_toSampleRate <= data_IN_50MRate;
			data_IN_sampleRate <= data_IN_toSampleRate;
		end if;
	end if;
end process;

-- disponibilité des données de sortie sous le cadencement de l'horloge à 50 MHz pour l'envoi sur le bus avalon
dataL_OUT_crossingClk : process(clk50M, rst)
begin
	if(clk50M'EVENT and clk50M = '1') then
		if(rst = '0') then
			data_OUT_to50MRate <= (others => '0');
			data_OUT_50MRate <= (others => '0');
		else 
			data_OUT_to50MRate <= data_OUT_sampleRate;
			data_OUT_50MRate <= data_OUT_to50MRate;
		end if;
	end if;
end process;

END archi;