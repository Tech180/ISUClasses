-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
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

    o_O <= std_logic_vector(SHIFT_LEFT(unsigned(s_S), to_integer(unsigned(i_O))));

end dataflow;
