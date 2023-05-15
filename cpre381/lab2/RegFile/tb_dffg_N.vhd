-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dffg_N is

    generic(helper  : time := 50 ns);

end tb_dffg_N;

architecture mixed of tb_dffg_N is
 

  component dffg_N
   port(i_CLK       : in std_logic;                          -- Clock input
        i_RST       : in std_logic;                          -- Reset input
        i_WE        : in std_logic;                          -- Write enable input
        i_D         : in std_logic_vector(31 downto 0);      -- Data value input
        o_Q         : out std_logic_vector(31 downto 0));    -- Data value output
end component;

   -- clock period
  constant clock    : time := helper * 2;

  signal s_D 	    : std_logic_vector(31 downto 0);    -- Multiplexed input to the FF
  signal s_Q 	    : std_logic_vector(31 downto 0);    -- Output of the FF
  signal s_CLK      : std_logic;
  signal s_RST      : std_logic;
  signal s_WE       : std_logic;

begin
  generic_d_flip_flop_N: dffg_N
  port map(i_CLK => s_CLK,
           i_RST => s_RST,
           i_WE  => s_WE,
           i_D   => s_D,
           o_Q   => s_Q);

  generic_clock: process
  begin
    s_CLK <= '0';
    wait for helper;
    s_CLK <= '1';
    wait for helper;
  end process;

  test: process
  begin

    -- Reset
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= (others => '0');
    wait for clock;

    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= (others => '1');
    wait for clock;

    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= (others => '0');
    wait for clock;

    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= (others => '0');
    wait for clock;

    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= (others => '1');
    wait for clock;

    wait;
  end process;

end mixed;
