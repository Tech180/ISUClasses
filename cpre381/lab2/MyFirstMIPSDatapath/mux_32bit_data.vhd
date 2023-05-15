-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux_32bit_data.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-- - Its a synchronous counter due to its parallel counter and  the reset signal stays low for it to take effect and otherwise sets it to high rising edge
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux32_data is
port(i_A	: in std_logic_vector(31 downto 0);   --bit 1
     i_B	: in std_logic_vector(31 downto 0);   --bit 2
     i_C	: in std_logic_vector(31 downto 0);   --bit 3
     i_D	: in std_logic_vector(31 downto 0);   --bit 4
     i_E	: in std_logic_vector(31 downto 0);   --bit 5
     i_F	: in std_logic_vector(31 downto 0);   --bit 6
     i_G	: in std_logic_vector(31 downto 0);   --bit 7
     i_H	: in std_logic_vector(31 downto 0);   --bit 8
     i_I	: in std_logic_vector(31 downto 0);   --bit 9
     i_J	: in std_logic_vector(31 downto 0);   --bit 10
     i_K	: in std_logic_vector(31 downto 0);   --bit 11
     i_L	: in std_logic_vector(31 downto 0);   --bit 12
     i_M	: in std_logic_vector(31 downto 0);   --bit 13
     i_N	: in std_logic_vector(31 downto 0);   --bit 14
     i_O	: in std_logic_vector(31 downto 0);   --bit 15
     i_P	: in std_logic_vector(31 downto 0);   --bit 16
     i_Q	: in std_logic_vector(31 downto 0);   --bit 17
     i_R	: in std_logic_vector(31 downto 0);   --bit 18
     i_S	: in std_logic_vector(31 downto 0);   --bit 19
     i_T	: in std_logic_vector(31 downto 0);   --bit 20
     i_U	: in std_logic_vector(31 downto 0);   --bit 21
     i_V	: in std_logic_vector(31 downto 0);   --bit 22
     i_W	: in std_logic_vector(31 downto 0);   --bit 23
     i_Y	: in std_logic_vector(31 downto 0);   --bit 24
     i_X	: in std_logic_vector(31 downto 0);   --bit 25
     i_Z	: in std_logic_vector(31 downto 0);   --bit 26
     i_AA	: in std_logic_vector(31 downto 0);   --bit 27
     i_BB	: in std_logic_vector(31 downto 0);   --bit 28
     i_CC	: in std_logic_vector(31 downto 0);   --bit 29
     i_DD	: in std_logic_vector(31 downto 0);   --bit 30
     i_EE	: in std_logic_vector(31 downto 0);   --bit 31
     i_FF	: in std_logic_vector(31 downto 0);   --bit 32
     i_SS	: in std_logic_vector(4 downto 0);
     o_Out	: out std_logic_vector(31 downto 0));
end mux32_data;

architecture dataflow of mux32_data is

begin

with i_SS select
o_Out <= i_A when "00000",
         i_B when "00001",
         i_C when "00010",
       i_D when "00011",
       i_E when "00100",
       i_F when "00101",
       i_G when "00110",
       i_H when "00111",
       i_I when "01000",
       i_J when "01001",
       i_K when "01010",
       i_L when "01011",
       i_M when "01100",
       i_N when "01101",
       i_O when "01110",
       i_P when "01111",
       i_Q when "10000",
       i_R when "10001",
       i_S when "10010",
       i_T when "10011",
       i_U when "10100",
       i_V when "10101",
       i_W when "10110",
       i_Y when "10111",
       i_X when "11000",
       i_Z when "11001",
       i_AA when "11010",
       i_BB when "11011",
       i_CC when "11100",
       i_DD when "11101",
       i_EE when "11110",
       i_FF when "11111",
       (others => '0') when others;

end dataflow;
