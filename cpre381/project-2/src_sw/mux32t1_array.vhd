-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use work.reg_array_type.all;

entity mux32t1_array is
  port(i_A  : in reg_Array;
       i_S  : in std_logic_vector(4 downto 0);
       o_F  : out std_logic_vector(31 downto 0));

end mux32t1_array;

architecture dataflow of mux32t1_array is

begin

  o_F <= i_A(to_integer(unsigned(i_S)));
  
end dataflow;
