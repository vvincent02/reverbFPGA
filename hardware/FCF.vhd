library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FCF IS
GENERIC(
	dataSize: integer range 1 to 32
);
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize-1 downto 0)
);
END FCF;

ARCHITECTURE archi OF FCF IS

constant U_fullScaleVector : unsigned(dataSize downto 0) := (others => '1');

signal prevOutputAdder : signed(dataSize downto 0);

signal firstInputAdder : signed(dataSize downto 0);
signal secondInputAdder : signed(dataSize downto 0);

signal outputAdder : signed(dataSize downto 0);

BEGIN

gain1 : entity work.coefMult(archi)
	generic map(dataSize+1)
	port map(dataIN => resize(dataIN, dataSize+1), dataOUT => firstInputAdder, coef => U_fullScaleVector - resize(dampingValue, dataSize+1));

gain2 : entity work.coefMult(archi)
	generic map(dataSize+1)
	port map(dataIN => prevOutputAdder, dataOUT => secondInputAdder, coef => resize(dampingValue, dataSize+1));

-- registre à décalage d'un échantillon	
process(clk, rst)
begin
	if(clk'EVENT and clk='1') then
		if(rst='0') then -- reset synchrone
			prevOutputAdder <= (others => '0');
		else 
			prevOutputAdder <= outputAdder;
		end if;
	end if;
end process;

-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- sortie de l'entité
dataOUT <= outputAdder(dataSize downto 1);

END archi;