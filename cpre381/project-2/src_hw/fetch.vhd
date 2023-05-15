-------------------------------------------------------------------------
-- Alexis Ancona
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the fetch logic for our processor.
--
-- NOTES:
-- 10/28/21 by AA::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetch is

  port(i_CLK : in std_logic;
       i_RST : in std_logic;
       i_A   : in std_logic_vector(31 downto 0);
       o_O   : out std_logic_vector(31 downto 0));

end fetch;

architecture behavorial of fetch is

begin
  process(i_CLK)
    begin
      if (rising_edge(i_CLK) and i_RST = '1') then
        o_O <= x"00400000";
      elsif (rising_edge(i_CLK) and i_RST = '0') then
        o_O <= i_A;
      end if;
  end process;
end behavorial;



