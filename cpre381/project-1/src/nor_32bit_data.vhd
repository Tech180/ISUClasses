-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- nor_32bit_data.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain 32 bit NOR gate
-- implementation.

-- 11/05/2021 by RL:: Created 32 bit NOR gate
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity nor_32bit_data is
   port(i_D0 : in std_logic_vector(31 downto 0);
        i_D1 : in std_logic_vector(31 downto 0);
        o_O  : out std_logic_vector(31 downto 0));
end nor_32bit_data;

architecture dataflow of nor_32bit_data is
begin

   M1: for i in 0 to 31 generate
        o_O(i) <= i_D0(i) NOR i_D1(i);
   end generate;

end dataflow;

