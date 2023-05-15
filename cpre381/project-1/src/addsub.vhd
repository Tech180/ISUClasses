------------------------------------------------------------------------
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

entity addsub is
  generic(N : integer := 32);
  port(i_fA         : in std_logic_vector(N-1 downto 0);
       i_fB         : in std_logic_vector(N-1 downto 0);
       i_fC         : in std_logic;
       o_Cry        : out std_logic;
       o_Sum        : out std_logic_vector(N-1 downto 0));

end addsub;

architecture behavior of addsub is

component Fulladder_N is
  port(i_fA         : in std_logic_vector(N-1 downto 0);
       i_fB         : in std_logic_vector(N-1 downto 0);
       i_fC         : in std_logic;
       o_Cry          : out std_logic;
       o_Sum          : out std_logic_vector(N-1 downto 0));

end component;

component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component OnesComp_N is
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

signal s_oc : std_logic_vector(N-1 downto 0);
signal s_mux : std_logic_vector(N-1 downto 0);

begin
  
    onescomp0: OnesComp_N port map(
         i_D0         => i_fB,
	 o_O          => s_oc);
	 
    mux0: mux2t1_N port map(
         i_S          => i_fC, 
         i_D0         => i_fB,
         i_D1         => s_oc,
         o_O          => s_mux);
  
    ADDERI: Fulladder_N port map(
              i_fA         => i_fA,
              i_fB         => s_mux,
              i_fC         => i_fC,
              o_Cry        => o_Cry,  
              o_Sum        => o_Sum);
              
     
             
end behavior;
