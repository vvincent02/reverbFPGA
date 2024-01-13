library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY coefMult IS
GENERIC(
	dataSize: integer range 1 to 64
);
PORT(
	dataIN : IN signed(dataSize-1 downto 0);
	dataOUT : OUT signed(dataSize-1 downto 0);
	
	coef : IN unsigned(dataSize-1 downto 0)
);
END coefMult;

ARCHITECTURE archi OF coefMult IS

constant S_coefFullScale : signed(2*dataSize+1 downto 0) := (coef'range => '1', others => '0');
signal multTempValue : signed(2*dataSize+1 downto 0);

BEGIN

multTempValue <= resize(dataIN, dataSize+1) * signed(std_logic_vector('0' & coef));  
dataOUT <= resize(multTempValue(multTempValue'high downto dataSize+1), dataSize);

END archi;