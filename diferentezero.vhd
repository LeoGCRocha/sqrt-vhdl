LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY diferentezero IS
generic (n:natural);
PORT (	a : 		IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		diferente : OUT STD_LOGIC);
END diferentezero;

ARCHITECTURE estrutura OF diferentezero IS
BEGIN
	diferente <= '1' WHEN A /= 0 ELSE '0';
END estrutura;
