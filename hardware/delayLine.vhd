library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY delayLine IS
GENERIC(
	dataSize: integer range 1 to 64;
	N : integer range 1 to 65535
);
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0)
);
END delayLine;

ARCHITECTURE archi OF delayLine IS

type delayArray is array(1 to N) of signed(dataIN'range);
signal delayLine : delayArray;

BEGIN

-- opérateur décalage de N échantillons	
process(clk, rst)
begin
	if(clk'EVENT and clk='1') then
		if(rst='0') then -- reset synchrone
			delayLine <= (others => (others => '0'));
		else 
			-- décalage de la ligne à retard
			for i in N downto 2 loop
            delayLine(i) <= delayLine(i-1);
         end loop;
			
			-- ajout de la dernière valeur
			delayLine(1) <= dataIN;
		end if;
	end if;
end process;

dataOUT <= delayLine(N);

END archi;