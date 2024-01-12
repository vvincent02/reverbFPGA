library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY clkDivider IS
GENERIC(clkPrescaler : integer := 5208); -- 9600 Hz par défaut
PORT(
	clk : IN std_logic; -- horloge 50 MHz
	rst : IN std_logic;
	clkDiv : BUFFER std_logic -- horloge divisée
);
END clkDivider;

ARCHITECTURE archi OF clkDivider IS

BEGIN

process(clk, rst)

variable  cntDiv : integer range 0 to clkPrescaler; -- compteur 

begin
	if(rst = '0')	then
		cntDiv := 0;
	elsif(clk'EVENT and clk = '1') then
		cntDiv := cntDiv + 1;
		
		if(cntDiv = clkPrescaler/2) then
			clkDiv <= not(clkDiv);
			cntDiv := 0;
		end if;
	end if;
end process; 

END archi;