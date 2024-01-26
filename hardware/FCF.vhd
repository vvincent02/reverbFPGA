library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FCF IS
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	samplingClk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize-1 downto 0)
);
END FCF;

ARCHITECTURE archi OF FCF IS

constant U_fullScaleVector : unsigned(dataIN'range) := (others => '1');

signal prevOutputAdder : signed(dataIN'range);

signal firstInputAdder : signed(dataIN'range);
signal secondInputAdder : signed(dataIN'range);

signal outputAdder : signed(dataIN'range);

BEGIN

-- gain (1-d)
gain1 : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => dataIN, dataOUT => firstInputAdder, coef => U_fullScaleVector - dampingValue);

-- gain d (retour de la boucle)
gain2 : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => prevOutputAdder, dataOUT => secondInputAdder, coef => dampingValue);

-- registre à décalage d'un échantillon	
process(samplingClk, rst)
begin
	if(samplingClk'EVENT and samplingClk='1') then
		if(rst='0') then
			prevOutputAdder <= (others => '0');
		else 
			prevOutputAdder <= outputAdder;
		end if;
	end if;
end process;

-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- sortie de l'entité
dataOUT <= outputAdder;

END archi;