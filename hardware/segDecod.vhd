LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY segDecod IS
PORT (
valueIN : IN std_logic_vector(5 DOWNTO 0); -- chiffres + alphabet à partir de 10
segOUT : OUT std_logic_vector(6 DOWNTO 0)
);
END segDecod;

ARCHITECTURE archi OF segDecod IS
BEGIN

process (valueIN)
begin
	case valueIN is
		when "000000" => segOUT<="1000000"; -- 0
		when "000001" => segOUT<="1111001"; -- 1
		when "000010" => segOUT<="0100100"; -- 2
		when "000011" => segOUT<="0110000"; -- 3
		when "000100" => segOUT<="0011001"; -- 4
		when "000101" => segOUT<="0010010"; -- 5
		when "000110" => segOUT<="0000010"; -- 6
		when "000111" => segOUT<="1111000"; -- 7
		when "001000" => segOUT<="0000000"; -- 8
		when "001001" => segOUT<="0010000"; -- 9
		
		-- lettres (afficheur éteint si impossible de faire la lettre)
		when "001010" => segOUT <= "0001000";  -- A
		when "001011" => segOUT <= "0000011";  -- B
		when "001100" => segOUT <= "0100111";  -- C
		when "001101" => segOUT <= "0100001";  -- D
		when "001110" => segOUT <= "0000110";  -- E
		when "001111" => segOUT <= "0001110";  -- F
		when "010000" => segOUT <= "1111111";  -- G
		when "010001" => segOUT <= "0001011";  -- H
		when "010010" => segOUT <= "1111001";  -- I
		when "010011" => segOUT <= "1110001";  -- J
		when "010100" => segOUT <= "1111111";  -- K
		when "010101" => segOUT <= "1111111";  -- L
		when "010110" => segOUT <= "1001000";  -- M
		when "010111" => segOUT <= "0101011";  -- N
		when "011000" => segOUT <= "0100011";  -- O
		when "011001" => segOUT <= "0001100";  -- P
		when "011010" => segOUT <= "0011000";  -- Q
		when "011011" => segOUT <= "0101111";  -- R
		when "011100" => segOUT <= "0010010";  -- S
		when "011101" => segOUT <= "1111111";  -- T
		when "011110" => segOUT <= "1000001";  -- U
		when "011111" => segOUT <= "1111111";  -- V
		when "100000" => segOUT <= "1111111";  -- W
		when "100001" => segOUT <= "0001001";  -- X
		when "100010" => segOUT <= "1111111";  -- Y
		when "100011" => segOUT <= "1111111";  -- Z
		when "111111" => segOUT <= "0111111"; -- signe moins (ou tiret)
		
		when others => segOUT<="1111111"; -- 7 seg éteint
	end case;
end process;

END archi;