LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bc IS
	PORT (Reset, clk, iniciar : IN STD_LOGIC;
			--sinal que vem do BC
			Az, Bz, contz, A0 : IN STD_LOGIC;
			--sinal saida p/ multiplier
			pronto : OUT STD_LOGIC;
			--sinal de controle do BO
			mPH, srPH, cPH, srPL, cPL, cB, cmult, mFF, mcont, ccont, srAA, cAA: OUT STD_LOGIC );
END bc;

-- Sinais de comando
-- ini = RstP = mA = CB  => ini=1 somente em S1
-- CA=1 em S1 e em S4
-- dec = op = m1 = m2  => dec=1 somente em S4 (estado no qual ocorre A <= A - 1 )
-- CP=1 somente em S3 (estado no qual ocorre P <= P + B )


ARCHITECTURE estrutura OF bc IS
	TYPE state_type IS (S0, S1, S2, S3, S4, S5, S6 );
	SIGNAL state: state_type;
BEGIN
	-- Logica de proximo estado (e registrador de estado)
	PROCESS (clk, Reset)
	BEGIN
		if(Reset = '1') THEN
			state <= S0 ;
		ELSIF (clk'EVENT AND clk = '1') THEN
			CASE state IS
				WHEN S0 =>
                    if (iniciar = '0') then
                        state <= S0;
                    else
                        state <= S1;
                    end if;						  
				WHEN S1 =>
                    state <= S2;						  
				WHEN S2 =>
                    if (Az = '1' or Bz = '1') then
                        state <= S6;
                    else
                        state <= S3;
                    end if;						  
				WHEN S3 =>
                    if (contz = '1') then -- se cont = 0
						state <= S6;
					elsif (A0 = '0') then -- se o bit menos significativo de A for igual a 0
                        state <= S5;
                    else
                        state <= S4;
                    end if;						  
				WHEN S4 =>
                    state <= S5;
				WHEN S5 =>
                    state <= S3;
				WHEN S6 =>
                    state <= S0;
			END CASE;
		END IF;
	END PROCESS;
	
	
	-- Logica de saida
	PROCESS (state)
	BEGIN
		CASE state IS
			WHEN S0 =>
						pronto <= '1';
						cmult <= '0';

						mPH <= '0'; 
						srPH <= '0'; 
						cPH <= '0'; 
						srPL <= '0'; 
						cPL <= '0'; 
						cB <= '0'; 
						mFF <= '0'; 
						mcont <= '0'; 
						ccont <= '0'; 
						srAA <= '0'; 
						cAA <= '0';
			WHEN S1 =>					
						pronto <= '0';
						cAA <= '1';
						cB <= '1';
						cPH <= '1';
						cPL <= '1';
						mPH <= '1';
						srPH <= '0';
						srPL <= '0';
						ccont <= '1';
						mcont <= '1';
						srAA <= '0';

						cmult <= '0'; 
						mFF <= '0'; 
			WHEN S2 =>
						cAA <= '0';
						cB <= '0';
						cPH <= '0';
						cPL <= '0';
						ccont <= '0';

						pronto <= '0';
						mPH <= '0'; 
						srPH <= '0'; 
						srPL <= '0'; 
						cmult <= '0'; 
						mFF <= '0'; 
						mcont <= '0'; 
						srAA <= '0'; 
			WHEN S3 =>
						ccont <= '0';
						mFF <= '1';
						srPH <= '0';
						srPL <= '0';
						srAA <= '0';

						pronto <= '0';
						mPH <= '0'; 
						cPH <= '0'; 
						cPL <= '0'; 
						cB <= '0'; 
						cmult <= '0'; 
						mcont <= '0'; 
						cAA <= '0';
			WHEN S4 =>
						cPH <= '1';
						mFF <= '0';
						mPH <= '0';

						pronto <= '0';
						srPH <= '0'; 
						srPL <= '0'; 
						cPL <= '0'; 
						cB <= '0'; 
						cmult <= '0'; 
						mcont <= '0'; 
						ccont <= '0'; 
						srAA <= '0'; 
						cAA <= '0';
			WHEN S5 =>
						cPH <= '0';
						ccont <= '1';
						srPH <= '1';
						srPL <= '1';
						srAA <= '1';
						mcont <= '0';


						pronto <= '0';
						mPH <= '0'; 
						cPL <= '0'; 
						cB <= '0'; 
						cmult <= '0'; 
						mFF <= '0'; 
						cAA <= '0';
			WHEN S6 =>
						cmult <= '1';

						
						pronto <= '0';
						mPH <= '0'; 
						srPH <= '0'; 
						cPH <= '0'; 
						srPL <= '0'; 
						cPL <= '0'; 
						cB <= '0'; 
						mFF <= '0'; 
						mcont <= '0'; 
						ccont <= '0'; 
						srAA <= '0'; 
						cAA <= '0';
		END CASE;
	END PROCESS;
END estrutura;
