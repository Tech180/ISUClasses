-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- registerFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity tb_regFile is

  generic(helper    : time := 50 ns);

end tb_regFile;

architecture behavior of tb_regFile is

  -- clock period
  constant clock    : time := helper * 2;

  component register_file
    generic(N: integer := 32);
    port(i_CLK	    : in std_logic;
         i_RST	    : in std_logic;
         rt	        : in std_logic_vector(4 downto 0);
         rd	        : in std_logic_vector(4 downto 0);
         rw	        : in std_logic_vector(4 downto 0);
         WE         : in std_logic;
         data       : in std_logic_vector(N-1 downto 0);
         o_rt       : out std_logic_vector(N-1 downto 0);
         o_rd       : out std_logic_vector(N-1 downto 0));
  end component;

  signal s_CLK      : std_logic;
  signal s_RST      : std_logic;
  signal s_we_re    : std_logic;
  signal s_rt       : std_logic_vector(4 downto 0);
  signal s_rd       : std_logic_vector(4 downto 0);
  signal s_rw       : std_logic_vector(4 downto 0);
  signal s_wd       : std_logic_vector(31 downto 0);
  signal s_O_rt     : std_logic_vector(31 downto 0);
  signal s_O_rd     : std_logic_vector(31 downto 0);
  signal s_WE       : std_logic := '0';

begin

  regFile: Register_File
  port map(i_CLK => s_CLK,
           i_RST => s_RST,
           i_rt  => s_rt,
           i_rd  => s_rd,
           i_rw  => s_rw,
           i_WE  => s_WE,
           wd    => s_wd,
           rt    => s_O_rt,
           rd    => s_O_rd);


clock: process
  begin
    s_CLK <= '0';
    wait for helper;
    s_CLK <= '1';
    wait for helper;
  end process;

  test: process
  begin

    s_RST  <= '1';
    wait for clock;

    s_RST  <= '0';
    s_wd   <= x"00000004";
    s_rw   <= "00001";
    s_WE   <= '1';
    wait for clock;

    s_wd   <= x"00000006";
    s_rw   <= "00010";
    s_WE   <= '1';
    wait for clock;

    s_rt   <= "00001";
    s_rd   <= "00010";
    s_WE   <= '0';
    wait for clock;

    s_wd   <= s_O_rt + s_O_rd;
    s_rw   <= "00011";
    s_WE   <= '1';
    wait for clock;

    s_rt   <= "00011";
    s_rd   <= "00000";
    s_WE   <= '0';
    wait for clock;

    s_wd   <= x"00000006";
    s_rw   <= "00000";
    s_WE   <= '1';
    wait for clock;

    s_rt   <= "00011";
    s_rd   <= "00000";
    s_WE   <= '0';
    wait for clock;

    wait;
  end process;

end behavior;

