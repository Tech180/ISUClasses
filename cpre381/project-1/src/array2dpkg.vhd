library ieee;
  use ieee.std_logic_1164.all;

package array2dpkg is
  type array2d_32 is array (31 downto 0) of std_logic_vector(31 downto 0);
  type array2d_ram is array (2**10-1 downto 0) of std_logic_vector(31 downto 0);
end package array2dpkg;
