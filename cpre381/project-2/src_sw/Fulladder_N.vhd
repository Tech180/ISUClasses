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

entity Fulladder_N is
  generic(N : integer := 32);
  port(i_fA         : in std_logic_vector(N-1 downto 0);
       i_fB         : in std_logic_vector(N-1 downto 0);
       i_fC         : in std_logic;
       o_Cry        : out std_logic;
       o_Sum        : out std_logic_vector(N-1 downto 0));

end Fulladder_N;

architecture pizza_N of Fulladder_N is

component Fulladder is
  port(i_fA         : in std_logic;
       i_fB         : in std_logic;
       i_fC         : in std_logic;
       o_Cry          : out std_logic;
       o_Sum          : out std_logic);

end component;

signal s_C : std_logic_vector(N-1 downto 0);

begin

    ADDER0: Fulladder port map(
              i_fA         => i_fA(0),
              i_fB         => i_fB(0),
              i_fC         => i_fC,
              o_Cry        => s_C(0),  
              o_Sum        => o_Sum(0));  

  G_NBit_ADDER: for i in 1 to N-1 generate
    ADDERI: Fulladder port map(
              i_fA         => i_fA(i),
              i_fB         => i_fB(i),
              i_fC         => s_C(i-1),
              o_Cry        => s_C(i),  
              o_Sum        => o_Sum(i));  
  end generate G_NBit_ADDER;

o_Cry <= s_C(N-1);             

end pizza_N;
