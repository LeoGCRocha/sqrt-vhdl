package multiplier2_pkg is
	constant N_BITS : natural := 4;
	 
	function Bit_lenght (
		x : positive)
		return natural;
	 
end package multiplier2_pkg;

-- Package Body Section
package body multiplier2_pkg is
 
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
 
end package body multiplier2_pkg;