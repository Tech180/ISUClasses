-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdderMap is  

  port(i_D0        : in std_logic;
       i_D1        : in std_logic;
       i_D2        : in std_logic;   --carry bit
       o_S         : out std_logic;  --add together
       o_D         : out std_logic); --carry bit
       
end fullAdderMap;

architecture structural of fullAdderMap is

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

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal o_x  : std_logic; --xor
signal o_a  : std_logic; --and
signal o_a2 : std_logic; --and

begin
              
  generic_xor  : xorg2
    port map(i_A => i_D0,
             i_B => i_D1,
             o_F => o_x);
  
  generic_xor_2 : xorg2
    port map(i_A => o_x,
             i_B => i_D2,
             o_F => o_S);
             
  generic_or    : org2
    port map(i_A => o_a,
             i_B => o_a2,
             o_F => o_D);        

  generic_and   : andg2
    port map(i_A => i_D0,
             i_B => i_D1,
             o_F => o_a);
              
  generic_and2  : andg2
    port map(i_A => o_x,
             i_B => i_D2,
             o_F => o_a2);         

end structural;

