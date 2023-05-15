-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- register32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32bit register
-- with a edge-triggered flip flop
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register32bit is
	generic(N : integer := 32);
	port(
             clock : in std_logic := '0';
             i_rst : in std_logic := '0';
             i_we : in std_logic := '0';
             data : in std_logic_vector(N-1 DOWNTO 0) := (others => '0');
             o_O : out std_logic_vector(N-1 DOWNTO 0) := (others => '0')
	     );

end Register32bit;

--  Architecture Body

architecture bigboy of Register32bit is

begin

process (clock, i_rst)
begin
  if (rising_edge(clock)) then
    if (not(i_rst = '1') AND i_we = '1') then
      o_O <= data;
    end if;
    if (i_rst = '1') then
      o_O <= (others => '0');
    end if;
  end if;
end process;

end bigboy;

