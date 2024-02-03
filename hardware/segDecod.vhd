LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY segDecod IS
PORT (
valueIN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
segOUT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END segDecod;

ARCHITECTURE archi OF segDecod IS
BEGIN

process (valueIN)
begin
	case valueIN is
		when "0000" => segOUT<="1000000";
		when "0001" => segOUT<="1111001";
		when "0010" => segOUT<="0100100";
		when "0011" => segOUT<="0110000";
		when "0100" => segOUT<="0011001";
		when "0101" => segOUT<="0010010";
		when "0110" => segOUT<="0000010";
		when "0111" => segOUT<="1111000";
		when "1000" => segOUT<="0000000";
		when "1001" => segOUT<="0010000";
		when "1010" => segOUT<="0111111"; -- signe moins 
		when others => segOUT<="1111111"; -- 7 seg éteint
	end case;
end process;

END archi;