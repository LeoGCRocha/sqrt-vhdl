library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sqrt_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity sqrt_tb is
    generic (n:natural := N_BITS);
end entity;

architecture tb of sqrt_tb is
    signal inicio, reset, clk, pronto : std_logic;
    signal a: std_logic_vector(n-1 downto 0);
    signal saida : std_logic_vector(n-1 downto 0);
    signal contador : natural;
	 
component sqrt  is
    generic (n:natural := n);
    port(clk, iniciar, reset :in std_logic;
		entrada   : in std_logic_vector(n-1 downto 0);
		pronto : out std_logic;
		resultado : out std_logic_vector(n-1 downto 0)
		);
end component;

    constant clkp : time := 30 ns;
begin
    UUT : entity work.sqrt port map (entrada => a, iniciar => inicio, reset => reset, clk => clk, pronto => pronto, resultado => saida);

    -- reset <= '1', '0' after 10 ns;
	 
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

        variable val_A: std_logic_vector(n-1 downto 0);

        variable cont: natural;
        variable write_col_to_output_cycles_buf : line;
        file output_cycles_buf : text;
        begin
            file_open(input_buf, "/home/kuru/UFSC/SD/QuartusProjects/sqrt-vhdl/inputs.txt", read_mode);
            file_open(output_buf, "/home/kuru/UFSC/SD/QuartusProjects/sqrt-vhdl/outputs_testbench.txt", write_mode);
            file_open(output_cycles_buf, "/home/kuru/UFSC/SD/QuartusProjects/sqrt-vhdl/outputs_cycles.txt", write_mode);
				
            -- wait until reset = '0';				
				
            while not endfile(input_buf) loop
                reset <= '1'; inicio <= '0';
                wait for clkp; reset <= '0';
                readline(input_buf, read_col_from_input_buf);
                read(read_col_from_input_buf, val_A);

                a <= val_A;

                wait for clkp;
                inicio <= '1';
                wait for clkp;
                inicio <= '0';
                cont := 1;
                contador <= cont;

                while (pronto = '0') loop
                    wait for clkp; cont := cont + 1;
                    contador <= cont;
                end loop;
                write(write_col_to_output_buf, saida);
                writeline(output_buf, write_col_to_output_buf);

                write(write_col_to_output_cycles_buf, cont);
                writeline(output_cycles_buf, write_col_to_output_cycles_buf);
                wait for clkp*3;
            end loop; 

            write (write_col_to_output_buf, string'("Simulation from testbench completed!"));
            writeline(output_buf, write_col_to_output_buf);

            write(write_col_to_output_cycles_buf, string'("Simulation from testbench completed!"));
            writeline(output_cycles_buf, write_col_to_output_cycles_buf);

            file_close(input_buf);
            file_close(output_buf);
            file_close(output_cycles_buf);

            wait;
        end process;
end tb;
