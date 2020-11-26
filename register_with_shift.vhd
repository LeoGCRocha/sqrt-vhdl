LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY register_with_shift IS
	generic (n:natural);
	PORT (clk, cRegister, srRegister, srIN : IN STD_LOGIC;
		  d : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END register_with_shift;

ARCHITECTURE estrutura OF register_with_shift is
signal var: STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN
	PROCESS(clk, cRegister, srRegister)
	BEGIN
		IF (clk'EVENT AND clk = '1' AND cRegister = '1') THEN
			var <= d;			
		ELSIF (clk'EVENT AND clk = '1' AND srRegister = '1') THEN
			var <= srIN & var(n-1 downto 1);
		END IF;
	END PROCESS;
	q <= var;
END estrutura;