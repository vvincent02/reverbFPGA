library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY earlyReverb IS
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	clk50M : IN std_logic;
	rst : IN std_logic;
	data_sampled_valid : IN std_logic;
	
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT_toLateReverb : OUT signed(dataSize-1 downto 0); -- sortie alimentation late reverb
	dataOUT_earlyReverb : OUT signed(dataSize-1 downto 0); -- sortie reverb proche pure
	
	delayInitEcho : IN integer range 0 to 1000 -- retard du premier echo (délai total du premier echo = nbrDelays * nombre d'instances de ligne à retard)
);
END earlyReverb;

ARCHITECTURE archi OF earlyReverb IS

constant nbrCells : integer range 0 to 15 := 8; -- min = 1 (pour l'écho principal)
constant nbrDelayLines_initEcho : integer range 0 to 15 := 7; -- nombre de ligne à retard pouvant chacune décaler au maximum de 1000 échantillons 
constant delayValue_earlyEchoes : integer range 0 to 500 := 50; -- délai des réflexions proches par rapport à la réflexion initiale

type S_vectArray_nbrCells is array(1 to nbrCells) of signed(dataIN'RANGE);
type S_vectArray_nbrDelayLines_initEcho is array(0 to nbrDelayLines_initEcho) of signed(dataIN'RANGE);
type U_vectArray_nbrCells is array(1 to nbrCells) of unsigned(dataIN'RANGE);

-- coefficients de pondération des différents retards succédants au premier retard
constant coefs : U_vectArray_nbrCells := ("111111111111111111111111",
														"111111111111111111000000",
														"111111111111000000000000",
														"111111100000001111111111",
														"111110000111111111111111",
														"000011111111111111111111",
														"000000000111111111111111",
														"000000000000001111111111");
														

-- signaux intermédiaires décalés au sein du premier bloc retard (réflexion initiale)
signal interDelayedInputs : S_vectArray_nbrDelayLines_initEcho;

-- signaux décalés par les différents blocs retard
signal delayedInputs : S_vectArray_nbrCells;
signal inputAdder : S_vectArray_nbrCells;

signal outputAdder : signed(dataIN'HIGH+3 downto 0); -- 3 bits supplémentaires pour éviter les débordements en sortie de l'additionneur

BEGIN

----------------------- Cellules de la ligne à retard multi-tap (early reverb) ------------------------------------
interDelayedInputs(0) <= dataIN;
delayedInputs(1) <= interDelayedInputs(nbrDelayLines_initEcho);

cells : FOR i IN 1 TO nbrCells
GENERATE

-- réflexion initiale du son (correspond au paramètre pre-delay directement) 
mainEchoCondition : IF(i = 1)
GENERATE

delayLines : FOR j IN 1 TO nbrDelayLines_initEcho
GENERATE
delayLineOperator : entity work.delayLine(archi)
	generic map(dataSize, 1000)
	port map(clk50M => clk50M, rst => rst, data_sampled_valid => data_sampled_valid, dataIN => interDelayedInputs(j-1), dataOUT => interDelayedInputs(j));
END GENERATE delayLines;

END GENERATE mainEchoCondition;

-- réflexions très proches de l'écho principal (légèrement retardées)
nearEchoes : IF(i > 1)
GENERATE
delayLineOperator : entity work.delayLine(archi)
	generic map(dataSize, delayValue_earlyEchoes)
	port map(clk50M => clk50M, rst => rst, data_sampled_valid => data_sampled_valid, dataIN => delayedInputs(i-1), dataOUT => delayedInputs(i));
END GENERATE nearEchoes;


-- pondération des échos
weight : entity work.coefMult(archi)
	generic map(dataSize)
	port map(dataIN => delayedInputs(i), dataOUT => inputAdder(i), coef => coefs(i));

END GENERATE cells;
----------------------------------------------------------------------------------------------------------

-- sommateur 8 entrées
outputAdder <= resize(inputAdder(1), outputAdder'LENGTH) +
					resize(inputAdder(2), outputAdder'LENGTH) +
					resize(inputAdder(3), outputAdder'LENGTH) +
					resize(inputAdder(4), outputAdder'LENGTH) +
					resize(inputAdder(5), outputAdder'LENGTH) +
					resize(inputAdder(6), outputAdder'LENGTH) + 
					resize(inputAdder(7), outputAdder'LENGTH) +
					resize(inputAdder(8), outputAdder'LENGTH);

dataOUT_toLateReverb <= delayedInputs(nbrCells); 
dataOUT_earlyReverb <= outputAdder(outputAdder'HIGH downto 3); -- division par 8

END archi;