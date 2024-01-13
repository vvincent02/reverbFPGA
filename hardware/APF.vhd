library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY APF IS
GENERIC(
	dataSize: integer range 1 to 64;
	N : integer range 1 to 65535
);
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	g : IN unsigned(dataSize-1 downto 0)
);
END APF;

ARCHITECTURE archi OF APF IS

signal firstInputAdder1 : signed(dataIN'range); -- valeur d'entrée multipliée par (1+g)
signal firstInputAdder1Inter : signed(dataIN'range); -- valeur d'entrée multipliée par g (valeur intermédiaire)
signal secondInputAdder1 : signed(dataIN'range);
signal outputAdder1 : signed(dataIN'range);

signal firstInputAdder2 : signed(dataIN'range);
signal secondInputAdder2 : signed(dataIN'range);
signal outputAdder2 : signed(dataIN'range);

BEGIN

-- gain (1+g)
gain1 : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => dataIN, dataOUT => firstInputAdder1Inter, coef => g);

firstInputAdder1 <= dataIN + firstInputAdder1Inter;

-- gain g (retour de la boucle)
gain2 : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => outputAdder2, dataOUT => secondInputAdder1, coef => g);

-- opérateur retard
delayLineOperator : entity work.delayLine(archi)
	generic map(dataIN'length, N)
	port map(clk => clk, rst => rst, dataIN => outputAdder1, dataOUT => firstInputAdder2);
	
-- sommateurs
outputAdder1 <= firstInputAdder1 + secondInputAdder1;
outputAdder2 <= firstInputAdder2 - dataIN;

dataOUT <= outputAdder2;
	
END archi;