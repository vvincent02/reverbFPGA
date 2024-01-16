library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY lateReverb IS 
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	dampingValue : IN unsigned(dataSize-1 downto 0);
	decayValue : IN unsigned(dataSize-1 downto 0);
	
	g : IN unsigned(dataSize-1 downto 0)
);
END lateReverb;

ARCHITECTURE archi OF lateReverb IS

type S_vectArray8 is array(1 to 8) of signed(dataIN'range);
type S_vectArray4 is array(1 to 4) of signed(dataIN'range);
type int_Array8 is array(1 to 8) of integer range 1 to 65535; 
type int_Array4 is array(1 to 4) of integer range 1 to 65535;

-- retards des blocs LFCF en parallèle
constant N_LFCF : int_Array8 := (150, 150, 150, 150, 150, 150, 150, 150);

-- retards des blocs APF en série
constant N_APF : int_Array4 := (150, 150, 150, 150);

signal inputAdder : S_vectArray8;
signal outputAdder : signed(dataIN'range);

signal dataOUT_APF : S_vectArray4;



BEGIN

LFCF_blocks : FOR i IN 1 TO 8
GENERATE
	
LFCF_block : entity work.LFCF(archi)
	generic map(dataSize, N_LFCF(i))
	port map(clk => clk, rst => rst, dataIN => dataIN, dataOUT => inputAdder(i), dampingValue => dampingValue, decayValue => decayValue);

END GENERATE LFCF_blocks;


APF_blocks : FOR i IN 1 TO 4
GENERATE

beginCond : IF(i = 1)
GENERATE
APF_block : entity work.APF(archi)
	generic map(dataSize, N_APF(i))
	port map(clk => clk , rst => rst, dataIN => outputAdder, dataOUT => dataOUT_APF(1), g => g);
END GENERATE beginCond;

nextCond : IF(i > 1)
GENERATE
APF_block : entity work.APF(archi)
	generic map(dataSize, N_APF(i))
	port map(clk => clk , rst => rst, dataIN => dataOUT_APF(i-1), dataOUT => dataOUT_APF(i), g => g);
END GENERATE nextCond;

END GENERATE APF_blocks;

outputAdder <= inputAdder(1) + inputAdder(2) + inputAdder(3) + inputAdder(4) + inputAdder(5) + inputAdder(6) + inputAdder(7) + inputAdder(8);

dataOUT <= dataOUT_APF(4);

END archi;
