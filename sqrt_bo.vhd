library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sqrt_bo is
    generic(n : natural := 8);
    port(clk : in                                                               std_logic;
        ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado : in  std_logic;
        entrada : in                                                            std_logic_vector(n-1 downto 0);
        multiplicado, less, igual : out                                          std_logic;
        saida : out                                                             std_logic_vector(n-1 downto 0));
end sqrt_bo;

architecture estrutura of sqrt_bo is

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

COMPONENT multiplier2 is
    generic (n:natural);
    port(entA, entB   : in std_logic_vector(n-1 downto 0);
			iniciar, Reset, ck :in std_logic;
			pronto : out std_logic;
			mult : out std_logic_vector((2*n)-1 downto 0)
			);
END COMPONENT;

signal saidaSTART, saidaMID, saidaEND, saidaX, saidaRESULTADO, saidaSOMASUB, saidaSOMA, saidaMuxSTART, saidaMuxEND, saidaMuxRESULTADO, zero :   std_logic_vector(n-1 downto 0);
signal saidaMULT, saidaSUB, saidaXDoble :                                                                                                       std_logic_vector(2*n-1 downto 0);
signal saidaSOMAcout :                                                                                                                          std_logic;

begin
    X : registrador
        generic map (n => n)
        port map(clk, ini, entrada, saidaX);

    Start : registrador
        generic map (n => n)
        port map(clk, cStart, saidaMuxSTART, saidaSTART);

    Mid : registrador
        generic map (n => n)
        port map(clk, cMid, saidaSOMA, saidaMID); -- É necessário dar o shift na saída da soma antes de inserir nesse registrador, mas deixei assim pra compilar

    End_r : registrador
        generic map (n => n)
        port map(clk, cEND, saidaMuxEND, saidaEND);

    Resultado : registrador
        generic map (n => n)
        port map(clk, cResultado, saidaMuxRESULTADO, saidaRESULTADO);

    muxStart : mux2para1
        generic map (n => n)
        port map(saidaSOMASUB, (others => '0'), ini, saidaMuxSTART);

    muxEND : mux2para1
        generic map (n => n)
        port map(saidaSOMASUB, entrada, ini, saidaMuxEND);

    muxRESULTADO : mux2para1
        generic map (n => n)
        port map(saidaEND, saidaMID, mResultado, saidaMuxRESULTADO);

    SOMA : somadorsubtrator
        generic map (n => n)
        port map(a=>saidaSTART, b=>saidaEND, op=>'0', s=>saidaSOMA); -- cout não é utilizado
    
    SOMASUB : somadorsubtrator
        generic map (n => n)
        port map(a=>saidaMID, b=>((0) => '1', others => '0'), op=>sub, s=>saidaSOMASUB); -- cout não é utilizado
    
    SUBTRATOR : somadorsubtrator
        generic map (n => 2*n)
        port map(saidaMULT, saidaXDoble, '1', less, saidaSUB);
    zero <= (others => '0');
    saidaXDoble <= zero & saidaX;

    QuadradoIgualAZero : igualazero
        generic map (n => 2*n)
        port map(saidaMULT, igual);

end estrutura;