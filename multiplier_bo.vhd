LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use work.multiplier2_pkg.all;

ENTITY bo is
	generic (n:natural);
	PORT (clk : IN STD_LOGIC;
			-- entrada dos sionais de controle
			mPH, srPH, cPH, srPL, cPL, cB, cmult, mFF, mcont, ccont, srAA, cAA : IN STD_LOGIC;
			-- entrada dos operandos
			entA, entB : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			--sinal que vai para o BC
			Az, Bz, contz, A0 : OUT STD_LOGIC;
			--resultado da multiplicaÃ§ao
			saida : OUT STD_LOGIC_VECTOR((2*n)-1 DOWNTO 0));
END bo;

ARCHITECTURE estrutura OF bo IS
	
COMPONENT registrador IS
		generic (n : natural);
		PORT (clk, carga : IN STD_LOGIC;
				d : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END COMPONENT;
	
COMPONENT mux2para1 IS
	generic (n : natural);
	PORT (a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			sel: IN STD_LOGIC;
			y : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END COMPONENT;
	
COMPONENT somadorsubtrator IS
	generic (n : natural);
	PORT (a, b : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  op: IN STD_LOGIC;
		  Cout : OUT STD_LOGIC;
		  s : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END COMPONENT;
	
COMPONENT igualazero IS
	generic (n : natural);
	PORT (a : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			igual : OUT STD_LOGIC);
END COMPONENT;

COMPONENT register_with_shift IS
	generic (n:natural);
	PORT (clk, cRegister, srRegister, srIN : IN STD_LOGIC;
		  d : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT flip_flop IS
PORT (clk: IN STD_LOGIC;
	  d : IN STD_LOGIC;
	  q : OUT STD_LOGIC);
END COMPONENT;

SIGNAL saidaSOMA, saimux1, saidaPH, saidaB, saidaPL, saidaA : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
SIGNAL entadaregMult : STD_LOGIC_VECTOR ((2*n)-1 DOWNTO 0);
SIGNAL saidamuxcont, saidaMENOS, saidacont, menos_um : STD_LOGIC_VECTOR (Bit_lenght(n)-1 DOWNTO 0); --ta meio errado pq não tá igual no slide mas funciona
SIGNAL saimuxFF, saiFF_vector, carry_vector	: STD_LOGIC_VECTOR (0 downto 0);
SIGNAL dPH, carry, saiFF : STD_LOGIC;

BEGIN
	--componentes para somar entB
	mux1: mux2para1 
		GENERIC MAP (n => n)
		PORT MAP (a=>saidaSOMA, b=>(others=>'0'), sel=>mPH, y=>saimux1);

	PH1: register_with_shift 
		GENERIC MAP (n => n)
		PORT MAP (clk, cPH, srPH, saiFF_vector(0), saimux1, saidaPH);
	 
	PL1: register_with_shift
		GENERIC MAP (n => n)
		PORT MAP (clk, cPL, srPL, saidaPH(0), (others=>'0'), saidaPL);
		
	regB: registrador
		GENERIC MAP (n => n)
		PORT MAP (clk=>clk, carga=>cB, d=>entB, q=>saidaB);
		
	compB: igualazero
		GENERIC MAP (n => n)
		PORT MAP (a=>saidaB, igual=>Bz);
	
	soma:somadorsubtrator -- op=0 == soma
		GENERIC MAP (n => n)
		PORT MAP (a=>saidaPH, b=>saidaB, op=>'0', s=>saidaSOMA, Cout=>carry);
		
	muxFF: mux2para1
		GENERIC MAP (n => 1)
		PORT MAP (carry_vector, "0", mFF, saimuxFF);
	carry_vector(0) <= carry;
	
	FF: flip_flop
		PORT MAP (clk, saimuxFF(0), saiFF);
	saiFF_vector(0) <= saiFF;

	regMult: registrador
		GENERIC MAP (n => 2*n)
		PORT MAP (clk=>clk, carga=>cmult, d=>entadaregMult, q=>saida);
		
	entadaregMult <= (saidaPH & saidaPL);
	
	--componetes para somar n --na (vdd tem um role do tamanho dos fios serem tipo 1+log2, logo esses negeric map dessa parte ta errado)
	muxcont: mux2para1
		GENERIC MAP (n => Bit_lenght(n)) 
		PORT MAP (a=>saidaMENOS, b=>(Bit_lenght(n)-1 => '1', others => '0'), sel=>mcont, y=>saidamuxcont);
		
	regCont : registrador
		GENERIC MAP (n => Bit_lenght(n))
		PORT MAP (clk=>clk, carga=>ccont, d=>saidamuxcont, q=>saidacont);
		
	compcont: igualazero
		GENERIC MAP (n => Bit_lenght(n))
		PORT MAP (a=>saidacont, igual=>contz);
		
	Subtracao: somadorsubtrator
		GENERIC MAP (n => Bit_lenght(n))
		PORT MAP (a=>saidacont, b=>menos_um, op=>'1', s=>saidaMENOS);
	
	menos_um <= (0 => '1', others => '0');
	
	--componentes da parte da entA
	regA: register_with_shift
		GENERIC MAP (n => n)
		PORT MAP (clk, cAA, srAA, '0', entA, saidaA);
		
	compA: igualazero
		GENERIC MAP (n => n)
		PORT MAP (a=>saidaA, igual=>Az);
		
	A0<= saidaA(0);
		
END estrutura;
