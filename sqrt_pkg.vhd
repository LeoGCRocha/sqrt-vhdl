package sqrt_pkg is
	constant n_bits : natural := 4;
	--constant LOG_N: natural := 8;
	
	function Bit_lenght (
		x : positive)
		return natural;
	 
end package sqrt_pkg;

-- Package Body Section
package body sqrt_pkg is
 
	function Bit_lenght (
		x : positive) 
	return natural is
      variable i : natural;
   begin
      i := 0;  
      while (2**i < x) and i < 31 loop
         i := i + 1;
      end loop;
		 i := i + 1;
      return i;
   end function;
 
end package body sqrt_pkg;