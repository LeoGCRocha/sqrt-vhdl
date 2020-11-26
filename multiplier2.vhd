library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.multiplier2_pkg.all;
 
entity multiplier2 is
    generic (n:natural := N_BITS);
    port(entA, entB   : in std_logic_vector(n-1 downto 0);
			iniciar, Reset, ck :in std_logic;
			pronto : out std_logic;
			mult : out std_logic_vector((2*n)-1 downto 0)
			);
END multiplier2;

ARCHITECTURE estrutura OF multiplier2 IS

COMPONENT bo is
	generic (n:natural);
	PORT (clk : IN STD_LOGIC;
				-- entrada dos sionais de controle
				mPH, srPH, cPH, srPL, cPL, cB, cmult, mFF, mcont, ccont, srAA, cAA : IN STD_LOGIC;
				-- entrada dos operandos
				entA, entB : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				--sinal que vai para o BC
				Az, Bz, contz, A0 : OUT STD_LOGIC;
				--resultado da multiplicaçao
				saida : OUT STD_LOGIC_VECTOR((2*n)-1 DOWNTO 0));
END COMPONENT;

COMPONENT bc IS
	PORT (Reset, clk, iniciar : IN STD_LOGIC;
			--sinal que vem do BC
			Az, Bz, contz, A0 : IN STD_LOGIC;
			--sinal saida p/ multiplier
			pronto : OUT STD_LOGIC;
			--sinal de controle do BO
			mPH, srPH, cPH, srPL, cPL, cB, cmult, mFF, mcont, ccont, srAA, cAA: OUT STD_LOGIC );
END COMPONENT;

SIGNAL mPH, srPH, cPH, srPL, cPL, cB, cmult, mFF, mcont, ccont, srAA, cAA, Az, Bz, contz, A0: STD_LOGIC;

BEGIN

	bloco_operativo : bo 
		generic map (n => n)
		port map(clk=>ck, mPH=>mPH, srPH=>srPH, cPH=>cPH, srPL=>srPL, cPL=>cPL, cB=>cB, cmult=>cmult, mFF=>mFF, 
					mcont=>mcont, ccont=>ccont, srAA=>srAA, cAA=>cAA, entA=>entA, entB=>entB, Az=>Az, Bz=>Bz, 
					contz=>contz, A0=>A0, saida=>mult);
	
	bloco_controle : bc
		port map(Reset=>Reset, clk=>ck, iniciar=>iniciar, Az=>Az, Bz=>Bz, contz=>contz, A0=>A0, pronto=>pronto, 
					mPH=>mPH, srPH=>srPH, cPH=>cPH, srPL=>srPL, cPL=>cPL, cB=>cB, cmult=>cmult, mFF=>mFF, 
					mcont=>mcont, ccont=>ccont, srAA=>srAA, cAA=>cAA);

END estrutura;
