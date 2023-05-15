-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_fullAdder is
 generic(A : integer := 8);
 port(o_data   : out std_logic_vector(A-1 downto 0);
      o_D0     : out std_logic;
      o_D1     : out std_logic_vector(A-1 downto 0);
      o_D2     : out std_logic);

end tb_fullAdder;

architecture structural of tb_fullAdder is

component fullAdder

generic(N : integer := 8);
  port(i_D0_1 : in std_logic_vector(N-1 downto 0);
       i_D1_1 : in std_logic_vector(N-1 downto 0);
       i_D2_1 : in std_logic;
       o_S_1  : out std_logic_vector(N-1 downto 0);
       o_D_1  : out std_logic);
end component;

component fullAdder_data

 generic(N : integer := 8);
  port(i_D0 	: in std_logic_vector(N-1 downto 0);
       i_D1	: in std_logic_vector(N-1 downto 0);
       i_D2	: in std_logic;
       o_S	: out std_logic_vector(N-1 downto 0);
       o_D	: out std_logic);
end component;

signal s_D0 : std_logic_vector(A-1 downto 0);
signal s_D1 : std_logic_vector(A-1 downto 0);
signal s_D2 : std_logic;


begin

  generic_fullAdder : fullAdder
  generic map(N => 8)
  port map(i_D0_1 => s_D0,
  	   i_D1_1 => s_D1,
	   i_D2_1 => s_D2,
	   o_S_1 => o_D1,
	   o_D_1 => o_D2);

  generic_fullAdder_data : fullAdder_data
  generic map(N => 8)
  port map(i_D0 => s_D0,
	   i_D1 => s_D1,
	   i_D2 => s_D2,
	   o_S => o_data,
	   o_D => o_D0);

process
  begin

	s_D0 <= x"00";
	s_D1 <= x"01";
	s_D2 <=  '0';
	wait for 100 ns;

	s_D0 <= x"00";
	s_D1 <= x"01";
	s_D2 <=  '1';
	wait for 100 ns;

	s_D0 <= x"01";
	s_D1 <= x"00";
	s_D2 <=  '0';
	wait for 100 ns;

	s_D0 <= x"01";
	s_D1 <= x"00";
	s_D2 <=  '1';
	wait for 100 ns;

	s_D0 <= x"FF";
	s_D1 <= x"01";
	s_D2 <= '1';
	wait for 100 ns;

	s_D0 <= x"FF";
	s_D1 <= x"01";
	s_D2 <= '0';
	wait for 100 ns;

	wait;
end process;

end structural;

