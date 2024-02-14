library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- !! ATTENTION !! : 
-- il faut s'assurer que la valeur du décalage (Ns_max et currentN) ne soit pas trop grand de sorte à 
-- ce que les données aient le temps d'être écrites et lues daNs_max la RAM (voir le rapport entre clk50 et samplingClk)

-- !! ATTENTION !! : 
-- Ns_max et currentN doivent être supérieures ou égales à 5 pour pouvoir établir le pipeline

ENTITY delayLine IS
GENERIC(
	dataSize: integer range 1 to 64;
	Ns_max : integer range 5 to 1000
);
PORT(
	clk50M : IN std_logic;
	rst : IN std_logic;
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	currentN : IN integer range 5 to 1000 -- délai variable
);
END delayLine;

ARCHITECTURE archi OF delayLine IS

constant N : integer range 4 to 1000 := Ns_max - 1; -- la structure de la ligne à retard induit déjà un décalage d'un échantillon au minimum

type shiftState_type is (idle, pull, shift, endPipeline, push);
signal shiftState : shiftState_type; 

signal wr_data : std_logic_vector(dataIN'range);
signal rd_data : std_logic_vector(dataIN'range);
signal wr_addr : integer range 0 to N-1;
signal rd_addr : integer range 0 to N-1;
signal we : std_logic;

signal currentN_valid : integer range 4 to 1000;

BEGIN

RAM_module : entity work.RAM(rtl)
	generic map(data_width => dataSize, nbr_blocks => N)
	port map(clk => clk50M, wr_data => wr_data, rd_data => rd_data, wr_addr => wr_addr, rd_addr => rd_addr, we => we);

-- décalage de N échantillons et mise à jour de la valeur de sortie 
process(clk50M)

variable cnt : integer range 0 to 2;
variable read_addr_pipeline : integer range 0 to N-4; -- adresse de la donnée (daNs_max le pipeline) qui sera copiée à l'adresse supérieure 3 cycles plus tard)  

begin
	if(clk50M'EVENT and clk50M='1') then
		if(rst = '0') then
			we <= '0';
			
			shiftState <= idle;
		else 
			case shiftState is
			
				-- état de repos : attente du prochain tick pour l'échantillonnage suivant
				when idle =>
					we <= '0';
					cnt := 0;
					
					-- si on peut lancer le décalage
					if(data_sampled_valid = '1') then
						currentN_valid <= currentN - 1; -- on récupère le nombre de retards de la ligne
						read_addr_pipeline := (currentN - 1) - 4;
						
						rd_addr <= (currentN-1)-1;
						shiftState <= pull;
					end if;
					
				-- on récupère la donnée en fin de la file (i.e l'entrée décalée) + mise en place du pipeline (début de l'empilement des données)
				when pull =>
					if(cnt = 0) then
						rd_addr <= currentN_valid-2;
						
						cnt := cnt + 1;
					elsif(cnt = 1) then 
						rd_addr <= currentN_valid-3;
						dataOUT <= signed(rd_data);
						
						cnt := 0;
						shiftState <= shift;
					end if;
					
				-- le pipeline est lancé -> décalage des données
				when shift =>
					rd_addr <= read_addr_pipeline;
					we <= '1';
					wr_addr <= read_addr_pipeline+3;
					wr_data <= rd_data; 
					
					if(read_addr_pipeline > 0) then
						read_addr_pipeline := read_addr_pipeline - 1;
					else
						shiftState <= endPipeline;
					end if;
				
				-- fin du pipeline
				when endPipeline =>
					if(cnt = 0) then
						wr_addr <= 2;
						wr_data <= rd_data;
						
						cnt := cnt + 1;
					elsif(cnt = 1) then
						wr_addr <= 1;
						wr_data <= rd_data; 
						
						cnt := 0;
						shiftState <= push;
					end if;
					
				-- ajout de la dernière valeur au début de la file
				when push =>
					wr_addr <= 0;
					wr_data <= std_logic_vector(dataIN);
				
					shiftState <= idle;
			end case;
		end if;
	end if;
end process;


END archi;