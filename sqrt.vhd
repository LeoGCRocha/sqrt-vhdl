library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sqrt_pkg.all;
 
entity sqrt is
    generic (n:natural := N_BITS);
    port(clk, iniciar, reset :in std_logic;
		entrada   : in std_logic_vector(n-1 downto 0);
		pronto : out std_logic;
		resultado : out std_logic_vector((n)-1 downto 0)
		);
END sqrt;

ARCHITECTURE estrutura OF sqrt IS

COMPONENT sqrt_bo is
	generic (n:natural);
	PORT ();
END COMPONENT;

COMPONENT sqrt_bc IS
	PORT ();
END COMPONENT;

SIGNAL ;

BEGIN

	bloco_operativo : sqrt_bo 
		generic map (n => n)
		port map();
	
	bloco_controle : sqrt_bc
		port map();

END estrutura;
