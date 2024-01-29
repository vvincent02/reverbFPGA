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
	
	dampingValue : IN unsigned(dataSize+1 downto 0);
	decayValue : IN unsigned(dataSize downto 0)
); 
END LFCF;

ARCHITECTURE archi OF LFCF IS

signal delayedOutputAdder : signed(dataIN'HIGH+1 downto 0);
signal outFCFilter : signed(dataIN'HIGH+1 downto 0);

signal firstInputAdder : signed(dataIN'HIGH+1 downto 0);
signal secondInputAdder : signed(dataIN'HIGH+1 downto 0);

signal outputAdder : signed(dataIN'HIGH+1 downto 0);

BEGIN

firstInputAdder <= resize(dataIN, dataIN'LENGTH+1);

-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- gain (feedback correspondant au paramètre decay de la reverb)
--gain : entity work.coefMult(archi)
--	generic map(outFCFilter'LENGTH)
--	port map(dataIN => outFCFilter, dataOUT => secondInputAdder, coef => decayValue);

secondInputAdder <= outFCFilter/2;

-- filtre FCF dans la boucle de retour	
--FCFilter : entity work.FCF(archi)
--	generic map(delayedOutputAdder'LENGTH)
--	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => delayedOutputAdder, dataOUT => outFCFilter, dampingValue => dampingValue);
outFCFilter <= delayedOutputAdder;

-- opérateur retard
delayLineOperator : entity work.delayLine(archi)
	generic map(outputAdder'LENGTH, N)
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => outputAdder, dataOUT => delayedOutputAdder);

-- sortie de l'entité
dataOUT <= delayedOutputAdder(delayedOutputAdder'HIGH downto 1);

--process(clk50M)
--begin
--	if(clk50M'EVENT and clk50M='1') then
--		if(data_sampled_valid='1') then
--			dataOUT <= dataIN;
--		end if;
--	end if;
--end process;

END archi;