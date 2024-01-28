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
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	g : IN unsigned(dataSize-1 downto 0)
);
END APF;

ARCHITECTURE archi OF APF IS

signal dataIN_resized : signed(dataIN'HIGH+2 downto 0); -- données d'entrée sur 2 bits supplémentaires
signal firstInputAdder1 : signed(dataIN'HIGH+2 downto 0); -- valeur d'entrée multipliée par (1+g)
signal firstInputAdder1Inter : signed(dataIN'HIGH+2 downto 0); -- valeur d'entrée multipliée par g (valeur intermédiaire)
signal secondInputAdder1 : signed(dataIN'HIGH+2 downto 0);
signal outputAdder1 : signed(dataIN'HIGH+2 downto 0);

signal firstInputAdder2 : signed(dataIN'HIGH+2 downto 0);
signal secondInputAdder2 : signed(dataIN'HIGH+2 downto 0);
signal outputAdder2 : signed(dataIN'HIGH+2 downto 0);

BEGIN

dataIN_resized <= resize(dataIN, dataIN'LENGTH+2);

-- gain (1+g) = 1.5
firstInputAdder1 <= dataIN_resized + dataIN_resized / 2;

-- gain g (retour de la boucle)
secondInputAdder1 <= outputAdder2 / 2;

-- sommateurs
outputAdder1 <= firstInputAdder1 + secondInputAdder1;
outputAdder2 <= firstInputAdder2 - dataIN_resized;

-- gain (1+g)
--gain1 : entity work.coefMult(archi)
--	generic map(dataIN'LENGTH+3)
--	port map(dataIN => resize(dataIN, dataIN'LENGTH+2), dataOUT => firstInputAdder1Inter, coef => g);


---- gain g (retour de la boucle)
--gain2 : entity work.coefMult(archi)
--	generic map(dataIN'length)
--	port map(dataIN => outputAdder2, dataOUT => secondInputAdder1, coef => g);

-- opérateur retard
--delayLineOperator : entity work.delayLine(archi)
--	generic map(outputAdder1'LENGTH, N)
--	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, rst => rst, dataIN => outputAdder1, dataOUT => firstInputAdder2);
--
--dataOUT <= outputAdder2(outputAdder2'HIGH downto 2);
	
process(clk50M, rst)
begin
	if(clk50M'EVENT and clk50M = '1') then
		if(rst = '0') then
			dataOUT <= (others => '0');
		elsif(data_sampled_valid = '1') then  
			dataOUT <= dataIN;
		end if;
	end if;
end process;

END archi;