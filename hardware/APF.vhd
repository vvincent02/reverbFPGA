library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY APF IS
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
END APF;

ARCHITECTURE archi OF APF IS

signal firstInputAdder1 : signed(dataIN'RANGE); -- valeur d'entrée multipliée par (1+g) = 1.5
signal secondInputAdder1 : signed(dataIN'RANGE);
signal outputAdder1 : signed(dataIN'RANGE);

signal firstInputAdder2 : signed(dataIN'RANGE);
signal secondInputAdder2 : signed(dataIN'RANGE);
signal outputAdder2 : signed(dataIN'RANGE);

BEGIN

-- gain (1+g) = 1.5
firstInputAdder1 <= dataIN + dataIN / 2;

-- gain g (retour de la boucle)
secondInputAdder1 <= outputAdder2 / 2;

-- sommateurs
outputAdder1 <= firstInputAdder1 + secondInputAdder1;
outputAdder2 <= firstInputAdder2 - dataIN;

-- opérateur retard
delayLineOperator : entity work.delayLine(archi)
	generic map(outputAdder1'LENGTH, N)
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => outputAdder1, dataOUT => firstInputAdder2);

dataOUT <= outputAdder2;

END archi;