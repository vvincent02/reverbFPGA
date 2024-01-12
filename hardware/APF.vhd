library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY APF IS
GENERIC(
	dataSize: integer range 1 to 32;
	N : integer range 1 to 65535
	--g : std_logic_vector(dataSize-1 downto 0) fonctionne pas 
);
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0)
);
END APF;

--ARCHITECTURE archi OF FCF IS