library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LFCF IS
GENERIC(
	dataSize: integer range 1 to 64;
	N : integer range 1 to 65535
);
PORT(
	clk50M : IN std_logic;
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize downto 0);
	decayValue : IN unsigned(dataSize downto 0)
); 
END LFCF;

ARCHITECTURE archi OF LFCF IS

constant nbrExtraBits : integer range 0 to 6 := 1;

signal firstDelayedOutputAdder : signed(dataIN'HIGH + nbrExtraBits downto 0);
signal secondDelayedOutputAdder : signed(dataIN'HIGH + nbrExtraBits downto 0);
signal outFCFilter : signed(dataIN'HIGH + nbrExtraBits downto 0);

signal firstInputAdder : signed(dataIN'HIGH + nbrExtraBits downto 0);
signal secondInputAdder : signed(dataIN'HIGH + nbrExtraBits downto 0);

signal outputAdder : signed(dataIN'HIGH + nbrExtraBits downto 0);

BEGIN

firstInputAdder <= resize(dataIN, firstInputAdder'LENGTH);

-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- gain (feedback correspondant au paramètre decay de la reverb)
gain : entity work.coefMult(archi)
	generic map(outFCFilter'LENGTH)
	port map(dataIN => outFCFilter, dataOUT => secondInputAdder, coef => decayValue);

-- filtre FCF dans la boucle de retour	
FCFilter : entity work.FCF(archi)
	generic map(secondDelayedOutputAdder'LENGTH)
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => secondDelayedOutputAdder, dataOUT => outFCFilter, dampingValue => dampingValue);

------------- lignes à retard (2 instances pour pouvoir dépasser le retard de 1000 sans problème) --------------------
-- opérateur retard 1
delayLineOperator1 : entity work.delayLine(archi)
	generic map(outputAdder'LENGTH, N/2)
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => outputAdder, dataOUT => firstDelayedOutputAdder);

-- opérateur retard 2
delayLineOperator2 : entity work.delayLine(archi)
	generic map(outputAdder'LENGTH, N/2)
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => firstDelayedOutputAdder, dataOUT => secondDelayedOutputAdder);
----------------------------------------------------------------------------------------------------------------------

-- sortie de l'entité
dataOUT <= resize(secondDelayedOutputAdder, dataOUT'LENGTH);

END archi;