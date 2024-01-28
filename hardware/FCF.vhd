library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FCF IS
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	clk50M : IN std_logic;
	data_sampled_valid : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize downto 0)
);
END FCF;

ARCHITECTURE archi OF FCF IS

constant U_fullScaleVector : unsigned(dataIN'HIGH+1 downto 0) := (others => '1');

signal prevOutputAdder : signed(dataIN'HIGH+1 downto 0);

signal firstInputAdder : signed(dataIN'HIGH+1 downto 0);
signal secondInputAdder : signed(dataIN'HIGH+1 downto 0);

signal outputAdder : signed(dataIN'HIGH+1 downto 0);

BEGIN

firstInputAdder <= resize(dataIN, dataIN'LENGTH+1);

-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- gain (1-d)
--gain1 : entity work.coefMult(archi)
--	generic map(dataIN'length)
--	port map(dataIN => dataIN, dataOUT => firstInputAdder, coef => U_fullScaleVector - dampingValue);

-- gain d (retour de la boucle)
--gain2 : entity work.coefMult(archi)
--	generic map(dataIN'length)
--	port map(dataIN => prevOutputAdder, dataOUT => secondInputAdder, coef => dampingValue);

secondInputAdder <= (others => '0');

-- registre à décalage d'un échantillon	
process(clk50M)
begin
	if(clk50M'EVENT and clk50M = '1') then
		if(data_sampled_valid = '1') then
			if(rst = '0') then
				prevOutputAdder <= (others => '0');
			else
				prevOutputAdder <= outputAdder;
			end if;
		end if;
	end if;
end process;

-- sortie de l'entité
dataOUT <= outputAdder(outputAdder'HIGH downto 1);


END archi;