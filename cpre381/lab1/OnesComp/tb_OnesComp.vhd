-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity testbench_Ones is
  generic(A: integer := 32);
  
  port(o_a : out std_logic_vector(A-1 downto 0));
      
end testbench_Ones;


architecture behavioral of testbench_Ones is
component OnesComp
  generic(N : integer := 16);
      port(i_A  : in std_logic_vector(N-1 downto 0);
           o_F  : out std_logic_vector(N-1 downto 0));
    end component;
     
  signal i_D2 : std_logic_vector(A-1 downto 0);  
     
begin
 generic_onescomp : OnesComp
      generic map(N => A)
      port map(i_A => i_D2,
               o_F => o_a);
    
process
  begin
    i_D2 <= "00001111000011110000111100001111";
    wait for 100 ns;
    
    i_D2 <= "11001100110011001100110011001100";
    wait for 100 ns;
    
    i_D2 <= "01010101010101010101010101010101";
    wait for 100 ns;
                         
    
end process;
       
end behavioral;

