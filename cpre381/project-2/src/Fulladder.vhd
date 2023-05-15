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

entity Fulladder is
  port(i_fA         : in std_logic;
       i_fB         : in std_logic;
       i_fC         : in std_logic;
       o_Cry          : out std_logic;
       o_Sum          : out std_logic);

end Fulladder;

architecture pizza of Fulladder is

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

  signal s_and0         : std_logic;
  signal s_and1   	: std_logic;
  signal s_xor0	        : std_logic;

begin
             
g_xor0: xorg2 
    port MAP(i_A             => i_fA,
             i_B             => i_fB,
             o_F             => s_xor0);
          
g_xor1: xorg2 
    port MAP(i_A             => s_xor0,
             i_B             => i_fC,
             o_F             => o_Sum);
             
g_and0: andg2
    port MAP(i_A             => i_fC,
             i_B             => s_xor0,
             o_F             => s_and0);
             
g_and1: andg2
    port MAP(i_A             => i_fA,
             i_B             => i_fB,
             o_F             => s_and1);
             
g_or0: org2 
    port MAP(i_A             => s_and0,
             i_B             => s_and1,
             o_F             => o_Cry);
            
             
end pizza;
