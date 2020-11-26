LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY somadorsubtrator IS
generic (n:natural);
PORT (a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
      op: IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
      s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END somadorsubtrator;

ARCHITECTURE estrutura OF somadorsubtrator IS
SIGNAL TEMP  : STD_LOGIC_VECTOR(n DOWNTO 0);

BEGIN
	WITH op SELECT
         TEMP <= ('0' & a) + ('0' & b) WHEN '0',
              ('0' & a) - ('0' & b) WHEN OTHERS;
			Cout <= TEMP(n); 
			s <= TEMP(n-1 DOWNTO 0);
END estrutura;
