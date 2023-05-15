-------------------------------------------------------------------------
-- 
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity d-flip-flop is
  generic (flip : natural := 4);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end d-flip-flop;

architecture behavioral of d-flip-flop is
  begin
    if (i_RST = '1') then --reset every time when active
      s_Q <= '0'; -- Use "(others => '0')" for N-bit values --low
    elsif (rising_edge(i_CLK)) then --otherwise set the bits to active high 
      s_Q <= s_D;
    end if;

  end process;
		
  
end behavioral;
