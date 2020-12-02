library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sqrt_bc is
    port(clk, reset, iniciar,
        multiplicado, startMaiorEnd, midMaiorX, midIgualX : in                                  std_logic;
        ini, cStart, cEnd, cMid, cResultado, sub, multiplicar, mResultado, opera1, pronto : out std_logic);
end sqrt_bc;

architecture arch of sqrt_bc is

    type states is (waiting, boot, defineMid, squareMid, squaredMidWithX, squaredMidGreaterX, squaredMidEqualX, squaredMidLesserX, startWithEnd, startGreaterEnd, ready);
    signal state, nextState : states;

begin
    ChangeOfState : process (clk, reset)
    begin
        if reset = '1' then
            state <= waiting;
        elsif rising_edge(clk) then
            state <= nextState;

        end if;
    end process;

    LogicalOfStates : process (state, iniciar, multiplicado, midMaiorX, midIgualX, startMaiorEnd)
    begin
        case state is
            when waiting =>
                if iniciar = '0' then
                    nextState <= waiting;
                else
                    nextState <= boot;
                end if;
            when boot =>
                nextState <= defineMid;
            when defineMid =>
                nextState <= squareMid;
            when squareMid =>
                if multiplicado = '0' then
                    nextState <= squareMid;
                else
                    nextState <= squaredMidWithX;
                end if;
            when squaredMidWithX =>
                if midMaiorX = '1' then
                    nextState <= squaredMidGreaterX;
                elsif midIgualX = '1' then
                    nextState <= squaredMidEqualX;
                else
                    nextState <= squaredMidLesserX;
                end if;
            when squaredMidGreaterX =>
                nextState <= startWithEnd;
            when squaredMidEqualX =>
                nextState <= ready;
            when squaredMidLesserX =>
                nextState <= startWithEnd;
            when startWithEnd =>
                if startMaiorEnd = '1' then
                    nextState <= startGreaterEnd;
                else
                    nextState <= defineMid;
                end if;
            when startGreaterEnd =>
                nextState <= ready;
            when others =>
                nextState <= ready;
        end case;
    end process;
    OutputSignals : process (state)
    begin
        case state is
            when waiting =>
                ini         <= '0';
                cStart      <= '-';
                cEnd        <= '-';
                cMid        <= '-';
                cResultado  <= '-';
                sub         <= '-';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '-';
                pronto      <= '0';
            when boot =>
                ini         <= '1';
                cStart      <= '1';
                cEnd        <= '1';
                cMid        <= '-';
                cResultado  <= '-';
                sub         <= '-';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '-';
                pronto      <= '0';
            when defineMid =>
                ini         <= '0';
                cStart      <= '0';
                cEnd        <= '0';
                cMid        <= '1';
                cResultado  <= '-';
                sub         <= '0';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '-';
                pronto      <= '0';
            when squareMid =>
                ini         <= '0';
                cStart      <= '0';
                cEnd        <= '0';
                cMid        <= '0';
                cResultado  <= '-';
                sub         <= '-';
                multiplicar <= '1';
                mResultado  <= '-';
                opera1      <= '-';
                pronto      <= '0';
            when squaredMidWithX =>
                ini         <= '0';
                cStart      <= '0';
                cEnd        <= '0';
                cMid        <= '0';
                cResultado  <= '-';
                sub         <= '1';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '0';
                pronto      <= '0';
            when squaredMidGreaterX =>
                ini         <= '0';
                cStart      <= '0';
                cEnd        <= '1';
                cMid        <= '0';
                cResultado  <= '-';
                sub         <= '1';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '1';
                pronto      <= '0';
            when squaredMidEqualX =>
                ini         <= '-';
                cStart      <= '-';
                cEnd        <= '-';
                cMid        <= '-';
                cResultado  <= '1';
                sub         <= '-';
                multiplicar <= '-';
                mResultado  <= '1';
                opera1      <= '-';
                pronto      <= '0';
            when squaredMidLesserX =>
                ini         <= '0';
                cStart      <= '1';
                cEnd        <= '0';
                cMid        <= '0';
                cResultado  <= '-';
                sub         <= '0';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '1';
                pronto      <= '0';
            when startWithEnd =>
                ini         <= '0';
                cStart      <= '0';
                cEnd        <= '0';
                cMid        <= '0';
                cResultado  <= '-';
                sub         <= '1';
                multiplicar <= '0';
                mResultado  <= '-';
                opera1      <= '-';
                pronto      <= '0';
            when startGreaterEnd =>
                ini         <= '-';
                cStart      <= '-';
                cEnd        <= '-';
                cMid        <= '-';
                cResultado  <= '1';
                sub         <= '-';
                multiplicar <= '-';
                mResultado  <= '0';
                opera1      <= '-';
                pronto      <= '0';
            when others =>
                ini         <= '-';
                cStart      <= '-';
                cEnd        <= '-';
                cMid        <= '-';
                cResultado  <= '0';
                sub         <= '-';
                multiplicar <= '-';
                mResultado  <= '-';
                opera1      <= '-';
                pronto      <= '1';
        end case;
    end process;
end arch;
