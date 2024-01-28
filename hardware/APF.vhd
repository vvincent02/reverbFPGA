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

signal dataIN_resized : signed(dataIN'HIGH downto 0); -- données d'entrée sur 2 bits supplémentaires
signal firstInputAdder1 : signed(dataIN'HIGH downto 0); -- valeur d'entrée multipliée par (1+g) = 1.5
signal secondInputAdder1 : signed(dataIN'HIGH downto 0);
signal outputAdder1 : signed(dataIN'HIGH downto 0);

signal firstInputAdder2 : signed(dataIN'HIGH downto 0);
signal secondInputAdder2 : signed(dataIN'HIGH downto 0);
signal outputAdder2 : signed(dataIN'HIGH downto 0);

BEGIN

dataIN_resized <= resize(dataIN, dataIN'LENGTH);

-- gain (1+g) = 1.5
firstInputAdder1 <= dataIN_resized + dataIN_resized / 2;

-- gain g (retour de la boucle)
secondInputAdder1 <= outputAdder2 / 2;

-- sommateurs
outputAdder1 <= firstInputAdder1 + secondInputAdder1;
outputAdder2 <= firstInputAdder2 - dataIN_resized;

-- opérateur retard
delayLineOperator : entity work.delayLine(archi)
	generic map(outputAdder1'LENGTH, N)
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => outputAdder1, dataOUT => firstInputAdder2);

dataOUT <= outputAdder2(outputAdder2'HIGH downto 0);

END archi;