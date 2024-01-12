library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LFCF IS
GENERIC(
	dataSize: integer range 1 to 32,
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

signal delayedOutputAdder : signed(dataSize downto 0);
signal outFCFilter : signed(dataSize downto 0);

signal firstInputAdder : signed(dataSize downto 0);
signal secondInputAdder : signed(dataSize downto 0);

signal outputAdder : signed(dataSize downto 0);

BEGIN

FCFilter : entity work.FCF(archi)
	generic map(dataSize+1)
	port map(clk => clk, rst => rst, dataIN => delayedOutputAdder, dataOUT => outFCFilter, dampingValue => resize(dampingValue, dataSize+1));

gain : entity work.coefMult(archi)
	generic map(dataSize+1)
	port map(dataIN => outFCFilter, dataOUT => secondInputAdder, coef => resize(decayValue, dataSize+1));

-- opérateur décalage de N échantillons	
process(clk, rst)

variable cnt : integer range 0 to N; 

begin

	if(clk'EVENT and clk='1') then
		if(rst='0') then -- reset synchrone
			cnt := 0;
			delayedOutputAdder <= (others => '0');
		else 
			cnt := cnt + 1;
			if(cnt = N) then
				delayedOutputAdder <= outputAdder;
				cnt := 0;
		end if;
	end if;

end process;
	
-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

END archi;