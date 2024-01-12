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

gain : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => outFCFilter, dataOUT => secondInputAdder, coef => decayValue);
	
FCFilter : entity work.FCF(archi)
	generic map(dataIN'length)
	port map(clk => clk, rst => rst, dataIN => delayedOutputAdder, dataOUT => outFCFilter, dampingValue => dampingValue);

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
			delayLine(1) <= outputAdder;
		end if;
	end if;
end process;

delayedOutputAdder <= delayLine(N);
	
-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- sortie de l'entité
dataOUT <= delayedOutputAdder;

END archi;