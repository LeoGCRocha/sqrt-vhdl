library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sqrt_bo is
    generic(n : natural := 8);
    port(clk, reset : in                                                                std_logic;
        ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1 : in  std_logic;
        entrada : in                                                                    std_logic_vector(n-1 downto 0);
        multiplicado, startMaiorEnd, midMaiorX, midIgualX : out                         std_logic;
        saida : out                                                                     std_logic_vector(n-1 downto 0));
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
	PORT (  a :     IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			igual : OUT STD_LOGIC);
END COMPONENT;

COMPONENT diferentezero IS
generic (n:natural);
PORT (  a : 		IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        diferente : OUT STD_LOGIC);
END COMPONENT;

COMPONENT multiplier2 is
    generic (n:natural);
    port(entA, entB   : in std_logic_vector(n-1 downto 0);
			iniciar, Reset, ck :in std_logic;
			pronto : out std_logic;
			mult : out std_logic_vector((2*n)-1 downto 0)
			);
END COMPONENT;

signal saidaSTART, saidaMID, saidaEND, saidaX, saidaSOMASUB_StartEnd, saidaSOMASUB_MidX, saidaSOMASUB_StartEndShifted
saidaMuxSTART, saidaMuxEND, saidaMuxRESULTADO, saidaMuxMidX, saidaMuxMidOne, 
zero :                                                                                      std_logic_vector(n-1 downto 0);
signal saidaMULT :                                                                          std_logic_vector(2*n-1 downto 0);
signal coutStartEnd, coutMidX, midMaiorXPorBits :                                           std_logic;

begin
    X : registrador
        generic map (n => n)
        port map(clk, ini, entrada, saidaX);

    Start : registrador
        generic map (n => n)
        port map(clk, cStart, saidaMuxSTART, saidaSTART);

    Mid : registrador
        generic map (n => n)
        port map(clk, cMid, saidaSOMASUB_StartEndShifted, saidaMID); -- É necessário dar o shift na saída da soma antes de inserir nesse registrador, mas deixei assim pra compilar

    End_r : registrador
        generic map (n => n)
        port map(clk, cEND, saidaMuxEND, saidaEND);

    Resultado : registrador
        generic map (n => n)
        port map(clk, cResultado, saidaMuxRESULTADO, saida);

    muxStart : mux2para1
        generic map (n => n)
        port map(saidaSOMASUB_MidX, (others => '0'), ini, saidaMuxSTART);

    muxEnd : mux2para1
        generic map (n => n)
        port map(saidaSOMASUB_MidX, entrada, ini, saidaMuxEND);

    muxMidX : mux2para1
        generic map (n => n)
        port map(saidaX, saidaMID, opera1, saidaMuxMidX);
    
    muxMidOne : mux2para1
        generic map (n => n)
        port map(saidaMULT(n-1 downto 0), ((0) => '1', others => '0'), opera1, saidaMuxMidOne);

    muxResultado : mux2para1
        generic map (n => n)
        port map(saidaEND, saidaMID, mResultado, saidaMuxRESULTADO);

    SomaSub_StartEnd : somadorsubtrator
        generic map (n => n)
        port map(saidaEND, saidaSTART, sub, coutStartEnd, saidaSOMASUB_StartEnd);
    saidaSOMASUB_StartEndShifted <= coutStartEnd & saidaSOMASUB_StartEnd(n-1 downto 1);
    startMaiorEnd <= coutStartEnd;

    SomaSub_MidX : somadorsubtrator
        generic map (n => n)
        port map(saidaMuxMidX, saidaMuxMidOne, sub, coutMidX, saidaSOMASUB_MidX);
    
    StartIgualX : igualazero
        generic map (n => n)
        port map(saidaSOMASUB_MidX, midIgualX);
    
    Multiplier : multiplier2
        generic map (n => n)
        port map(saidaMID, saidaMID, multiplicar, reset, clk, multiplicado, saidaMULT);
    
    MidGreaterThanNBits : diferentezero
        generic map (n => n)
        port map(saidaMULT(2*n-1 downto n), midMaiorXPorBits);
    
    midMaiorX <= coutMidX or midMaiorXPorBits;

end estrutura;