-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder5to32 is

  port(i_D0      : in std_logic_vector(4 downto 0);
       o_O       : out std_logic_vector(31 downto 0));

end decoder5to32;

architecture dataflow of decoder5to32 is

  signal s_S     : unsigned(31 downto 0) := x"00000001";

  begin

    o_O <= std_logic_vector(SHIFT_LEFT(unsigned(s_S), to_integer(unsigned(i_D0))));

end dataflow;
