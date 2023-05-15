-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- invg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1-input NOT 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;


entity tb_extension16to32 is

  generic(helper    : time := 50 ns);

end tb_extension16to32;

architecture behavioral of tb_extension16to32 is

  -- clock period
  constant clock    : time := helper * 2;

  component extension16to32
    generic(Y: integer := 8);
    port(D0         : in std_logic_vector(Y-1 downto 0);
         i_signed   : in std_logic;
         o_O        : out std_logic_vector(31 downto 0));
  end component;

  signal s_CLK      : std_logic;
  signal s_signed   : std_logic;
  signal s_D0       : std_logic_vector(8-1 downto 0);
  signal o_O        : std_logic_vector(31 downto 0);

begin

  generic_16to32bit_extender: extension16to32
  port map(D0       => s_D0,
           i_signed => s_signed,
           o_O      => o_O);

  generic_clock: process
  begin
    s_CLK <= '0';
    wait for helper;
    s_CLK <= '1';
    wait for helper;
  end process;


  test: process
  begin

    s_D0        <= x"FF";
    s_signed    <= '0';
    wait for clock;

    s_D0         <= x"FF";
    s_signed     <= '1';
    wait for clock;

    s_in         <= x"0F";
    s_signed     <= '0';
    wait for clock;

    s_in         <= x"0F";
    s_signed     <= '1';
    wait for clock;

    wait;
  end process;

end behavioral;
