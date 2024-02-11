library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LPF IS
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	clk50M : IN std_logic;
	rst : IN std_logic;
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize-1 downto 0)
);
END LPF;

ARCHITECTURE archi OF LPF IS

signal prevOutputAdder : signed(dataIN'RANGE);

signal firstInputAdder : signed(dataIN'RANGE);
signal secondInputAdder : signed(dataIN'RANGE);

signal outputAdder : signed(dataIN'RANGE);

BEGIN

-- sommateur
outputAdder <= firstInputAdder + secondInputAdder;

-- gain (1-d)
gain1 : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => dataIN, dataOUT => firstInputAdder, coef => not(dampingValue));

-- gain d (retour de la boucle)
gain2 : entity work.coefMult(archi)
	generic map(dataIN'length)
	port map(dataIN => prevOutputAdder, dataOUT => secondInputAdder, coef => dampingValue);

-- registre à décalage d'un échantillon	
process(clk50M)
begin
	if(clk50M'EVENT and clk50M = '1') then
		if(rst = '0') then
			prevOutputAdder <= (others => '0');
		else
			if(data_sampled_valid = '1') then
				prevOutputAdder <= outputAdder;
			end if;
		end if;
	end if;
end process;

-- sortie de l'entité
dataOUT <= outputAdder;

END archi;