-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity extension16to32 is

  generic(N : integer := 16);
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_signed     : in std_logic;
       o_O          : out std_logic_vector(31 downto 0));

end extension16to32;

architecture dataflow of extension16to32 is

    begin

    M1 : for i in 0 to N-1 generate
        o_O(i) <= i_D0(i);
    end generate;

    M2 : for i in N to 31 generate
        o_O(i) <= i_signed and i_D0(N-1);
    end generate;

end dataflow;
