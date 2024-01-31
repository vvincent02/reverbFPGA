library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY interface_AVST_proc IS
GENERIC(
	dataSize : integer range 0 to 63
);
PORT(
	clk50M : IN std_logic;
	rst : IN std_logic;
	
	audio_IN_ready : OUT std_logic;
	audio_IN_valid : IN std_logic;
	audio_IN_data : IN std_logic_vector(dataSize-1 downto 0);
	audio_OUT_ready : IN std_logic;
	audio_OUT_valid : OUT std_logic;
	audio_OUT_data : OUT std_logic_vector(dataSize-1 downto 0);
	
	data_IN : OUT std_logic_vector(dataSize-1 downto 0);
	data_OUT : IN std_logic_vector(dataSize-1 downto 0);
	
	data_sampled_valid : OUT std_logic
);
END interface_AVST_proc;

ARCHITECTURE archi OF interface_AVST_proc IS

type interfaceState_type is (idle, transferData, endTransfer, assertDataSampledValid);
signal interfaceState : interfaceState_type := idle;

BEGIN

-- machine d'état permettant l'interfaçage entre les données du controleur audio (bus avalon streaming) et celles traitées en dur dans le FPGA
--interface : process(clk50M)
--begin
--	-- reset non utilisé ici pour reprendre à l'état courant lorsque l'IP Audio core n'est plus mise à zéro
--	if(clk50M'EVENT and clk50M='1') then
--		case interfaceState is 
--			when idle =>
--				data_sampled_valid <= '0';
--				
--				audio_IN_ready <= '0';
--				audio_OUT_valid <= '0';
--				if(audio_IN_valid = '1') then
--					interfaceState <= transferData;
--				end if;
--			when transferData =>
--				-- data IN are read from the audio controller source while asserting ready
--				audio_IN_ready <= '1';
--				data_IN <= audio_IN_data;
--				 
--				-- data OUT are loaded and ready to be read by the audio controller sink
--				audio_OUT_valid <= '1';
--				audio_OUT_data <= data_OUT;
--				
--				interfaceState <= endTransfer;
--			when endTransfer =>
--				-- wait while the audio controller sink has not assert ready
--				if(audio_OUT_ready = '1') then
--					interfaceState <= assertDataSampledValid;
--				end if;
--			when assertDataSampledValid =>
--				data_sampled_valid <= '1';
--				interfaceState <= idle;
--		end case;
--	end if;
--end process;

interface : process(clk50M)
begin
	-- reset non utilisé ici pour reprendre à l'état courant lorsque l'IP Audio core n'est plus mise à zéro
	if(clk50M'EVENT and clk50M='1') then
		if(rst='0') then
			data_sampled_valid <= '0';
			
			interfaceState <= idle;
		else
			case interfaceState is 
				when idle =>
					data_sampled_valid <= '0';
					
					audio_IN_ready <= '0';
					audio_OUT_valid <= '0';
					if(audio_IN_valid = '1') then
						-- data IN are read from the audio controller source while asserting ready
						data_IN <= audio_IN_data;
						audio_IN_ready <= '1';
						
						-- data OUT are loaded and ready to be read by the audio controller sink at the next cycle
						audio_OUT_valid <= '1';
						audio_OUT_data <= data_OUT;
						
						interfaceState <= transferData;
					end if;
				when transferData =>
					audio_IN_ready <= '0';
					
					-- les données de sortie sont lues par le controleur audio
			
					interfaceState <= endTransfer;
				when endTransfer =>
					-- wait while the audio controller sink has not assert ready
					if(audio_OUT_ready = '1') then
						interfaceState <= assertDataSampledValid;
					end if;
				when assertDataSampledValid =>
					data_sampled_valid <= '1';
					
					interfaceState <= idle;
			end case;
		end if;
	end if;
end process;

END archi;