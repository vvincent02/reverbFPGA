library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Single clock dual-port RAM with Old Data Read-during-Write

ENTITY RAM IS
GENERIC(
	data_width : integer range 1 to 64;
	nbr_blocks : integer range 1 to 65535
);
PORT(
	clk : IN std_logic;
	
	-- bus de données entrant/sortant (mémoire dual-port)
	wr_data : IN std_logic_vector(data_width-1 downto 0);
	rd_data : OUT std_logic_vector(data_width-1 downto 0);
	
	-- bus d'adresse de lecture/écriture
	wr_addr : IN integer range 0 to nbr_blocks-1;
	rd_addr : IN integer range 0 to nbr_blocks-1;
	
	-- write enable signal
	we : IN std_logic
);
END RAM;

ARCHITECTURE rtl OF RAM IS

type mem is array(0 to nbr_blocks-1) of std_logic_vector(data_width-1 downto 0);
signal ram_block : mem;

BEGIN

process(clk)
begin
	if(clk'EVENT and clk='1') then
		-- écriture donnée synchrone
		if(we = '1') then
			ram_block(wr_addr) <= wr_data;
		end if;
		
		-- lecture donnée synchrone
		rd_data <= ram_block(rd_addr);
	end if;
end process;

END rtl;