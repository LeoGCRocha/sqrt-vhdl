library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sqrt_pkg.all;
 
entity sqrt is
    generic (n:natural := N_BITS);
    port(clk, iniciar, reset :in 	std_logic;
		entrada   : in 				std_logic_vector(n-1 downto 0);
		pronto : out 				std_logic;
		resultado : out 			std_logic_vector(n-1 downto 0)
		);
END sqrt;

ARCHITECTURE estrutura OF sqrt IS

COMPONENT sqrt_bo is
	generic (n:natural);
  	port(clk, reset, 
     	ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1 : in  std_logic;
     	entrada : in                                                                    std_logic_vector(n-1 downto 0);
     	multiplicado, startMaiorEnd, midMaiorX, midIgualX : out                         std_logic;
     	saida : out                                                                     std_logic_vector(n-1 downto 0));
END COMPONENT;

COMPONENT sqrt_bc IS
    port(clk, reset, iniciar,
        multiplicado, startMaiorEnd, midMaiorX, midIgualX : in                              	std_logic;
        ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1, pronto : out	std_logic);
END COMPONENT;

SIGNAL 	ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1,
		multiplicado, startMaiorEnd, midMaiorX, midIgualX : 						std_logic;

BEGIN

	bloco_operativo : sqrt_bo 
		generic map (n => n)
		port map(clk, reset,
        		ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1,
        		entrada,
        		multiplicado, startMaiorEnd, midMaiorX, midIgualX,
        		resultado);
	
	bloco_controle : sqrt_bc
		port map(clk, reset,
				iniciar, multiplicado, startMaiorEnd, midMaiorX, midIgualX, 
				ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1, pronto);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

END estrutura;