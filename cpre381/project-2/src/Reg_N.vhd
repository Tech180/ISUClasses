-------------------------------------------------------------------------
-- Long Zeng
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Reg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit register
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Reg_N is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D_N        : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q_N        : out std_logic_vector(N-1 downto 0));   -- Data value output

end Reg_N;

architecture abc of Reg_N is
  
component dffg is
  
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

begin
G_NBit_REG: for i in 0 to N-1 generate
g_dffg0: dffg
port map(i_CLK  => i_CLK,
         i_RST  => i_RST,
         i_WE   => i_WE,	
         i_D    => i_D_N(i),
         O_Q    => o_Q_N(i));
end generate G_NBit_REG;
  
end abc;
