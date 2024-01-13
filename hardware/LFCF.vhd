library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LFCF IS
GENERIC(
	dataSize: integer range 1 to 32;
	N : integer range 1 to 65535
);
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize-1 downto 0);
	decayValue : IN unsigned(dataSize-1 downto 0)
); 
END LFCF;

ARCHITECTURE archi OF LFCF IS

signal delayedOutputAdder : signed(dataIN'range);
signal outFCFilter : signed(dataIN'range);

signal firstInputAdder : signed(dataIN'range);
signal secondInputAdder : signed(dataIN'range);

signal outputAdder : signed(dataIN'range);

type delayArray is array(1 to N) of signed(dataIN'range);
signal delayLine : delayArray;

BEGIN

-- gain (feedback correspondant au paramètre decay de la reverb)
gain : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => outFCFilter, dataOUT => secondInputAdder, coef => decayValue);

-- filtre FCF dans la boucle de retour	
FCFilter : entity work.FCF(archi)
	generic map(dataIN'length)
	port map(clk => clk, rst => rst, dataIN => delayedOutputAdder, dataOUT => outFCFilter, dampingValue => dampingValue);

-- opérateur retard
delayLineOperator : entity work.delayLine(archi)
	generic map(dataIN'length, N)
	port map(clk => clk, rst => rst, dataIN => outputAdder, dataOUT => delayedOutputAdder);
	
-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- sortie de l'entité
dataOUT <= delayedOutputAdder;

END archi;