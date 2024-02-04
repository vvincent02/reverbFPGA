library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- !! ATTENTION !! : 
-- il faut s'assurer que la valeur du décalage (Ns) ne soit pas trop grand de sorte à 
-- ce que les données aient le temps d'être écrites et lues dans la RAM (voir le rapport entre clk50 et samplingClk)

-- !! ATTENTION !! : 
-- Ns doit être supérieure ou égale à 5 pour pouvoir établir le pipeline

ENTITY delayLine IS
GENERIC(
	dataSize: integer range 1 to 64;
	Ns : integer range 1 to 65535
);
PORT(
	clk50M : IN std_logic;
	rst : IN std_logic;
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0)
);
END delayLine;

ARCHITECTURE archi OF delayLine IS

constant N : integer range 0 to 65535 := Ns - 1; -- la structure de la ligne à retard induit déjà un décalage d'un échantillon au minimum

type shiftState_type is (idle, pull, startPipeline, shift, endPipeline, push);
signal shiftState : shiftState_type; 

signal wr_data : std_logic_vector(dataIN'range);
signal rd_data : std_logic_vector(dataIN'range);
signal wr_addr : integer range 0 to N-1;
signal rd_addr : integer range 0 to N-1;
signal we : std_logic;

signal dataOUT_prev : signed(dataIN'range);
signal dataIN_valid : signed(dataIN'range);

BEGIN

RAM_module : entity work.RAM(rtl)
	generic map(data_width => dataSize, nbr_blocks => N)
	port map(clk => clk50M, wr_data => wr_data, rd_data => rd_data, wr_addr => wr_addr, rd_addr => rd_addr, we => we);

-- décalage de N échantillons et mise à jour de la valeur de sortie 
process(clk50M)

variable cnt : integer range 0 to 2;
variable read_addr_pipeline : integer range 0 to N-4; -- adresse de la donnée (dans le pipeline) qui sera copiée à l'adresse supérieure 3 cycles plus tard)  

begin
	if(clk50M'EVENT and clk50M='1') then
		if(rst = '0') then
			dataOUT_prev <= (others => '0');
			we <= '0';
			
			shiftState <= idle;
		else 
			case shiftState is
			
				-- état de repos : attente du prochain tick pour l'échantillonnage suivant
				when idle =>
					we <= '0';
					cnt := 0;
					read_addr_pipeline := N-4;
					
					-- si on peut lancer le décalage
					if(data_sampled_valid = '1') then
						dataOUT <= dataOUT_prev; -- mise à jour de la sortie avec la dernière valeur de la précédente file
						dataIN_valid <= dataIN; -- on récupère l'entrée actuelle pour la mettre au début de la prochaine file
						shiftState <= pull;
					end if;
					
				-- on récupère la donnée en fin de la file (i.e l'entrée décalée)
				when pull =>
					case cnt is
						when 0 =>
							rd_addr <= N-1;
						when 1 => 
							-- accès à la donnée en RAM à l'adresse N-1
						when 2 => 
							dataOUT_prev <= signed(rd_data);
							
							shiftState <= startPipeline;
					end case;
					
					if(cnt < 2) then
						cnt := cnt + 1;
					else 
						cnt := 0;
					end if;
					
				-- mise en place du pipeline (début de l'empilement des données)
				when startPipeline =>
					case cnt is
						when 0 =>
							rd_addr <= N-2;
						when 1 => 
							rd_addr <= N-3;
							
							shiftState <= shift;
						when others =>
					end case;
					
					if(cnt < 1) then
						cnt := cnt + 1;
					else 
						cnt := 0;
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
					case cnt is
						when 0 =>
							wr_addr <= 2;
							wr_data <= rd_data;
						when 1 => 
							wr_addr <= 1;
							wr_data <= rd_data; 
							
							shiftState <= push;
						when others =>
					end case;
					
					if(cnt < 1) then
						cnt := cnt + 1;
					else 
						cnt := 0;
					end if;
					
				-- ajout de la dernière valeur au début de la file
				when push =>
					wr_addr <= 0;
					wr_data <= std_logic_vector(dataIN_valid);
				
					shiftState <= idle;
			end case;
		end if;
	end if;
end process;


END archi;