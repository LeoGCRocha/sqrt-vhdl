LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY flip_flop IS
PORT (clk: IN STD_LOGIC;
	  d : IN STD_LOGIC;
	  q : OUT STD_LOGIC);
END flip_flop;

ARCHITECTURE comportamento OF flip_flop IS
BEGIN
	PROCESS(clk)
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN
			q <= d;
		END IF;
	END PROCESS;
END comportamento;
