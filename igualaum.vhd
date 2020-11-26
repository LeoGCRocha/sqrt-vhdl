LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY igualaum IS
PORT (a : IN STD_LOGIC;
igual : OUT STD_LOGIC);
END igualaum;

ARCHITECTURE estrutura OF igualaum IS
BEGIN
	igual <= '1' WHEN A = '1' ELSE '0';
END estrutura;