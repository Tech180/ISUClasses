--------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder5to32 is

  generic(helper      : time := 50 ns);

  end tb_decoder5to32;

architecture behavior of tb_decoder5to32 is

  -- clock period
  constant clock      : time := helper * 2;

  component decoder5to32_data
    port(i_D0         : in std_logic_vector(4 downto 0);
         o_O          : out std_logic_vector(31 downto 0));
  end component;

  signal s_CLK        : std_logic;
  signal s_i          : std_logic_vector(4 downto 0); --input
  signal s_O          : std_logic_vector(31 downto 0); --output

begin

  generic_5to32decoder: decoder5to32_data
  port map(i_D0 => s_i,
           o_O  => s_O);

  generic_clock: process
  begin
    s_CLK <= '0';
    wait for helper;
    s_CLK <= '1';
    wait for helper;
  end process;

  test: process
  begin

    s_i <= "00000";
    wait for clock;

    s_i <= "00001";
    wait for clock;

    s_i <= "00010";
    wait for clock;

    s_i <= "00011";
    wait for clock;

    s_i <= "11111";
    wait for clock;

    wait;
  end process;

end behavior;

