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
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0)
);
END delayLine;

ARCHITECTURE archi OF delayLine IS

type shiftState_type is (idle, pull, shift, push);
signal shiftState : shiftState_type := idle; 

signal wr_data : std_logic_vector(dataIN'range);
signal rd_data : std_logic_vector(dataIN'range);
signal wr_addr : integer range 0 to N-1;
signal rd_addr : integer range 0 to N-1;
signal we : std_logic;

signal dataOUT_prev : signed(dataIN'range);

BEGIN

RAM_module : entity work.RAM(rtl)
	generic map(data_width => dataSize, nbr_blocks => N)
	port map(clk => clk50M, wr_data => wr_data, rd_data => rd_data, wr_addr => wr_addr, rd_addr => rd_addr, we => we);

-- décalage de N échantillons et mise à jour de la valeur de sortie 
process(clk50M)
begin
	if(clk50M'EVENT and clk50M='1') then
--		if(rst = '0') then
--			if(data_sampled_valid = '1') then
--				dataOUT_prev <= (others => '0');
--				dataOUT <= (others => '0');
--			end if;	
--			shiftState <= idle;
--		else
			case shiftState is
				when idle =>
					rd_addr <= N-1;
					we <= '0';
					
					-- si on peut lancer le décalage
					if(data_sampled_valid = '1') then
						dataOUT <= dataOUT_prev;
						shiftState <= pull;
					end if;
				-- on récupère la donnée en fin de file (i.e l'entrée décalée)
				when pull =>
					dataOUT_prev <= signed(rd_data);
				
					rd_addr <= N-2;
					wr_addr <= N-1;
					
					shiftState <= shift;
				-- décalage de la file
				when shift =>
					wr_data <= rd_data;
					we <= '1';
					
					if(rd_addr = 0) then
						shiftState <= push;
					else 
						wr_addr <= wr_addr-1;
						rd_addr <= rd_addr-1;
					end if;
				-- ajout de la dernière valeur au début de la file
				when push =>
					wr_addr <= 0;
					wr_data <= std_logic_vector(dataIN);
				
					shiftState <= idle;
			end case;
		--end if;
	end if;
end process;


END archi;