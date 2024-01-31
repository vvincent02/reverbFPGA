library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY lateReverb IS 
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	clk50M : IN std_logic;
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize downto 0);
	decayValue : IN unsigned(dataSize  downto 0)
);
END lateReverb;

ARCHITECTURE archi OF lateReverb IS

type S_vectArray8 is array(1 to 8) of signed(dataIN'RANGE);
type S_vectArray4 is array(1 to 4) of signed(dataIN'RANGE);
type int_Array8 is array(1 to 8) of integer range 1 to 65535; 
type int_Array4 is array(1 to 4) of integer range 1 to 65535;

-- retards des blocs LFCF en parallèle
constant N_LFCF : int_Array8 := (547, 601, 683, 727, 859, 919, 983, 997);

-- retards des blocs APF en série
constant N_APF : int_Array4 := (227, 557, 443, 349);

signal inputAdder : S_vectArray8;
signal outputAdder : signed(dataIN'HIGH+3 downto 0);

signal dataOUT_APF : S_vectArray4;


-- génération des blocs LFCF en parallèle
BEGIN

LFCF_blocks : FOR i IN 1 TO 8
GENERATE
	
LFCF_block : entity work.LFCF(archi)
	generic map(dataSize, N_LFCF(i))
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => dataIN, dataOUT => inputAdder(i), dampingValue => dampingValue, decayValue => decayValue);

END GENERATE LFCF_blocks;


-- sommateur 8 entrées
outputAdder <= resize(inputAdder(1), outputAdder'LENGTH)  + 
					resize(inputAdder(2), outputAdder'LENGTH) +
					resize(inputAdder(3), outputAdder'LENGTH) +
					resize(inputAdder(4), outputAdder'LENGTH) +
					resize(inputAdder(5), outputAdder'LENGTH) +
					resize(inputAdder(6), outputAdder'LENGTH) + 
					resize(inputAdder(7), outputAdder'LENGTH) +
					resize(inputAdder(8), outputAdder'LENGTH);


-- génération des blocs APF en série
APF_blocks : FOR i IN 1 TO 4
GENERATE

beginCond : IF(i = 1)
GENERATE
APF_block : entity work.APF(archi)
	generic map(dataSize, N_APF(i))
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => outputAdder(outputAdder'HIGH downto 3), dataOUT => dataOUT_APF(1));
END GENERATE beginCond;

nextCond : IF(i > 1)
GENERATE
APF_block : entity work.APF(archi)
	generic map(dataSize, N_APF(i))
	port map(clk50M => clk50M, data_sampled_valid => data_sampled_valid, dataIN => dataOUT_APF(i-1), dataOUT => dataOUT_APF(i));
END GENERATE nextCond;

END GENERATE APF_blocks;


-- sortie de l'entité
dataOUT <= dataOUT_APF(4);

END archi;
