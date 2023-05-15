-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
  
  generic(N: integer := 8);
  
  port(i_D0_1 : in std_logic_vector(N-1 downto 0);
       i_D1_1 : in std_logic_vector(N-1 downto 0);
       i_D2_1 : in std_logic;
       o_S_1  : out std_logic_vector(N-1 downto 0);
       o_D_1  : out std_logic);

end fullAdder;

architecture structural of fullAdder is
  
  component fullAdderMap is
    port(i_D0    : in std_logic;
         i_D1    : in std_logic;
         i_D2    : in std_logic;
         o_S     : out std_logic;
         o_D     : out std_logic);
  end component;
  
  signal i_D4 : std_logic_vector(N downto 0);
  
  begin
    i_D4(0) <= i_D2_1;
    
    M1: for i in 0 to N-1 generate
      generic_fullAdderMap: fullAdderMap
        port map(i_D0 => i_D0_1(i),
                 i_D1 => i_D1_1(i),
                 i_D2 => i_D4(i),
                 o_S  => o_S_1(i),
                 o_D => i_D4(i+1));
      end generate;
      
      o_D_1 <= i_D4(N);
      
    
end structural;

