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


entity mux_32bit_dataflow is
	generic(N 	: integer := 32);
	port(i_D0 	: in std_logic_vector(N-1 downto 0);
       	     i_D1 	: in std_logic_vector(N-1 downto 0);
             i_S 	: in std_logic;
             o_O 	: out std_logic_vector(N-1 downto 0));

end mux_32bit_dataflow;

architecture dataflow of mux_32bit_dataflow is


	signal s_D0 	: std_logic_vector(N-1 downto 0);
	signal s_D1 	: std_logic_vector(N-1 downto 0);
	signal s_O 	: std_logic_vector(N-1 downto 0);
	signal s_F 	: std_logic_vector(N-1 downto 0);

begin

   G1: for i in 0 to N-1 generate
	s_O(i) 		<= i_S;
   end generate;

	s_F 		<= NOT s_O;
	s_D0 		<= i_D0 AND s_F;
	s_D1 		<= i_D1 AND s_O;
	o_O 		<= s_D0 OR s_D1;

end dataflow;

