-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- xor_32bit_data.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain 8-to-1 mux
-- implementation of dataflow.

-- 11/05/2021 by RL:: Created 32 bit XOR gate
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux8to1_32bit_data is
port(i_A            		: in std_logic_vector(31 downto 0);
     i_B 	        	: in std_logic_vector(31 downto 0);
     i_C            		: in std_logic_vector(31 downto 0);
     i_D            		: in std_logic_vector(31 downto 0);
     i_E	        	: in std_logic_vector(31 downto 0);
     i_F	        	: in std_logic_vector(31 downto 0);
     i_G	        	: in std_logic_vector(31 downto 0);
     i_H	        	: in std_logic_vector(31 downto 0);
     i_S			: std_logic_vector(2 downto 0);
     o_O			: out std_logic_vector(31 downto 0));
end mux8to1_32bit_data;

architecture dataflow of mux8to1_32bit_data is

begin

with i_S select
o_O <= i_A when "000",
       i_B when "001",
       i_C when "010",
       i_D when "011",
       i_E when "100",
       i_F when "101",
       i_G when "110",
       i_H when "111",
       (others => '0') when others;

end dataflow;
