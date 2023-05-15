-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder_data is

generic(N: integer := 8);
port(i_D0 	: in std_logic_vector(N-1 downto 0);
     i_D1	: in std_logic_vector(N-1 downto 0);
     i_D2	: in std_logic;
     o_S	: out std_logic_vector(N-1 downto 0);
     o_D	: out std_logic);

end fullAdder_data;

architecture dataflow of fullAdder_data is

signal s_S	: std_logic_vector(N-1 downto 0); --carry bit

begin

   --truth table/expression
   S1:o_S(0)    <=  i_D0(0) xor i_D1(0) xor i_D2;
      s_S(0)    <= (i_D0(0) and i_D1(0)) or (i_D2 and (i_D0(0) xor i_D1(0)));

   M1: for i in 1 to N-2 generate
       o_S(i)   <= i_D0(i) xor i_D1(i) xor s_S(i-1);
       s_S(i)   <= (i_D0(i) and i_D1(i)) or (s_S(i-1) and (i_D0(i) xor i_D1(i)));
   end generate;

   S2: o_S(N-1) <= i_D0(N-1) xor i_D1(N-1) xor s_S(N-2);
       o_D      <= (i_D0(N-1) and i_D1(N-1)) or (s_S(N-2) and (i_D0(N-1) xor i_D1(N-1)));

end dataflow;

