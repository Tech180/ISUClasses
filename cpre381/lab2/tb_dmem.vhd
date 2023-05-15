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

entity tb_dmem is

  generic(helper   : time := 50 ns);

end tb_dmem;

architecture behavioral of tb_dmem is

  -- clock period
  constant clock  : time := helper * 2;


  component mem
    port(clk        : in std_logic;
         we         : in std_logic := '1';
	     addr	    : in std_logic_vector(9 downto 0);
         data       : in std_logic_vector(31 downto 0);
         q          : out std_logic_vector(31 downto 0));
  end component;


  signal s_D		: std_logic_vector(31 downto 0);
  signal s_Q		: std_logic_vector(31 downto 0);
  signal s_addr		: std_logic_vector(9 downto 0);
  signal s_CLK	    : std_logic;
  signal s_WE	    : std_logic;

begin

  generic_memory: mem
  port map(clk  => s_CLK,
           addr => s_addr,
           we   => s_WE,
           data => s_D,
           q    => s_Q);

  generic_clock: process
  begin
    s_CLK <= '0';
    wait for helper;
    s_CLK <= '1';
    wait for helper;
  end process;

  test: process
  begin

    s_addr <= "0000000000";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000000";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000000";
    s_WE  <= '0';
    s_D   <= (others => '0');
    wait for clock;


    s_addr <= "0000000001";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000001";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000001";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000000010";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000010";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000010";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000000011";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000011";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000011";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000000100";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000100";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000100";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000000101";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000101";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000101";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000000110";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000110";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000110";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000000111";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100000111";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100000111";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000001000";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100001000";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100001000";
    s_WE  <= '0';
    wait for clock;


    s_addr <= "0000001001";
    s_WE  <= '0';
    wait for clock;

    s_addr <= "0100001001";
    s_WE  <= '1';
    s_D   <= s_Q;
    wait for clock;

    s_addr <= "0100001001";
    s_WE  <= '0';
    wait for clock;

    wait;
  end process;

end behavioral;
