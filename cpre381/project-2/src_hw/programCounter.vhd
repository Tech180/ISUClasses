library IEEE;
use IEEE.std_logic_1164.all;

entity programCounter is
port(i_RST       : in std_logic;--reset
     i_CLK	 : in std_logic; --clock
     i_addr	 : in std_logic_vector(31 downto 0);
     o_instr	 : out std_logic_vector(31 downto 0));
end entity;


architecture behavorial of programCounter is
begin

process(i_CLK)
begin

if rising_edge(i_CLK) then 
    if i_RST = '1' then
      o_instr <= x"00400000";
    else
    o_instr <= i_addr;
    end if;
end if;

end process;

end architecture;