library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity extender_N is

  generic(N : integer := 32);

  port(i_D : in std_logic_vector(15 downto 0);
       i_S : in std_logic;
       o_O : out std_logic_vector(N-1 downto 0)
  );

end extender_N;

architecture behavior of extender_N is

  begin

  o_O <= std_logic_vector(resize(signed(i_D), o_O'length)) when (i_S = '1') else
         std_logic_vector(resize(unsigned(i_D), o_O'length)) when (i_S = '0');

end behavior;
