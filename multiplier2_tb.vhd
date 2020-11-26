library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.multiplier2_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity multiplier2_tb is
    generic (n:natural := N_BITS);
end multiplier2_tb;

architecture tb of multiplier2_tb is
    signal inicio, reset, clk, pronto : std_logic;
    signal a, b : std_logic_vector(n-1 downto 0);
	 signal saida : std_logic_vector((2*n)-1 downto 0);
	 
component multiplier2 is
    generic (n:natural := n_BITS);
    port(entA, entB   : in std_logic_vector(n-1 downto 0);
			iniciar, Reset, ck :in std_logic;
			pronto : out std_logic;
			mult : out std_logic_vector(n-1 downto 0)
			);
end component;

    constant clkp : time := 30 ns;
begin
    UUT : entity work.multiplier2 port map ( entA => a, 
															entB => b, 
															iniciar => inicio, 
															Reset => reset, 
															ck => clk, 
															pronto => pronto, 
															mult => saida);

    reset <= '1', '0' after 10 ns;
	 
    clk_simulation : process
    begin
        clk <= '0'; wait for clkp/2;
        clk <= '1'; wait for clkp/2;
    end process;

    -- stimulus : process
    -- begin
    --     a <= (0 => '1',2 => '1', others => '0'); b <= (0 => '1', 1 => '1', others => '0'); inicio <= '0';
    --     wait for clkp; inicio <= '1';
    --     wait for clkp; inicio <= '0';
    --     wait for 50*clkp;
    -- end process;

    file_io: process
        variable read_col_from_input_buf : line;
        file input_buf : text;
        variable write_col_to_output_buf : line;
        file output_buf : text;

        variable val_A, val_B : std_logic_vector(n-1 downto 0);
        variable val_SPACE : character;

        begin
            file_open(input_buf, "D:\Git_Desktop_Files\trabalho-multiplicador\multiplier2\inputs.txt", read_mode);
            file_open(output_buf, "D:\Git_Desktop_Files\trabalho-multiplicador\multiplier2\outputs_testbench.txt", write_mode);
				
				
            wait until reset = '0';				
				
            while not endfile(input_buf) loop
                readline(input_buf, read_col_from_input_buf);
                read(read_col_from_input_buf, val_A);
                read(read_col_from_input_buf, val_SPACE);
                read(read_col_from_input_buf, val_B);

                a <= val_A;
                b <= val_B;

                wait for clkp; inicio <= '1';
                wait for clkp; inicio <= '0';

                while (pronto = '0') loop
                    wait for clkp;
                end loop;
                write(write_col_to_output_buf, saida);
                writeline(output_buf, write_col_to_output_buf);

            end loop; 

            write (write_col_to_output_buf, string'("Simulation from testbench completed!"));
            writeline(output_buf, write_col_to_output_buf);

            file_close(input_buf);
            file_close(output_buf);

            wait;
        end process;
end tb;