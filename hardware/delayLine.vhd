library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- !! ATTENTION !! : il faut s'assurer que la valeur du décalage (N) ne soit pas trop grand de sorte à 
-- ce que les données aient le temps d'être écrites et lues dans la RAM (voir le rapport entre clk50 et samplingClk)

ENTITY delayLine IS
GENERIC(
	dataSize: integer range 1 to 64;
	N : integer range 1 to 65535
);
PORT(
	clk50M : IN std_logic;
	samplingClk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0)
);
END delayLine;

ARCHITECTURE archi OF delayLine IS

type shiftState_type is (idle, pull, shift, push);
signal shiftState : shiftState_type; 

signal wr_data : std_logic_vector(dataIN'range);
signal rd_data : std_logic_vector(dataIN'range);
signal wr_addr : integer range 0 to N-1;
signal rd_addr : integer range 0 to N-1;
signal we : std_logic;

signal launchShift : std_logic;
signal launchShift_metastable : std_logic;
signal launchShift_stable : std_logic;

signal dataOUT_pre : signed(dataIN'range);

BEGIN

RAM_module : entity work.RAM(rtl)
	generic map(data_width => dataSize, nbr_blocks => N)
	port map(clk => clk50M, rst => rst, wr_data => wr_data, rd_data => rd_data, wr_addr => wr_addr, rd_addr => rd_addr, we => we);

-- lancement décalage de N échantillons	
process(samplingClk, rst)
begin
	if(samplingClk'EVENT and samplingClk='1') then
		if(rst='0') then -- reset synchrone
			launchShift <= '0';
		else 
			dataOUT <= dataOUT_pre;
			launchShift <= '1';
		end if;
	end if;
end process;

-- décalage de N échantillons et mise à jour de la valeur de sortie 
process(clk50M, rst)

variable sampleIndex : integer range 0 to N-1;

begin
	if(clk50M'EVENT and clk50M='1') then
		if(rst='0') then
			shiftState <= idle;
			launchShift_metastable <= '0';
			launchShift_stable <= '0';
		else
			-- passage du drapeau issu de samplingClk à un état stable sur clk50
			launchShift_metastable <= launchShift;
			launchShift_stable <= launchShift_metastable;
			
			case shiftState is
				when idle =>
					rd_addr <= N-1;
					we <= '0';
					
					-- si on peut lancer le décalage
					if(launchShift_stable = '1') then
						shiftState <= pull;
						
						launchShift_stable <= '0';
					end if;
				-- on récupère la donnée en fin de file (i.e l'entrée décalée)
				when pull =>
					dataOUT_pre <= signed(rd_data);
				
					wr_addr <= N-1;
					rd_addr <= N-2;
					we <= '1';
				-- décalage de la file
				when shift =>
					wr_data <= rd_data;
					
					if(rd_addr = 0) then
						shiftState <= push;
						wr_addr <= 0;
					else 
						wr_addr <= wr_addr-1;
						rd_addr <= rd_addr-1;
					end if;
				-- ajout de la dernière valeur au début de la file
				when push =>
					wr_data <= std_logic_vector(dataIN);
				
					shiftState <= idle;
			end case;
		end if;
	end if;
end process;


END archi;