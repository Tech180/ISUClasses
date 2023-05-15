library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity barrel_shifter is
	port(i_clk		: in std_logic;
	     i_I		: in std_logic_vector(31 downto 0);
	     i_S		: in std_logic_vector (4 downto 0);
	     i_A		: in std_logic;		-- 0 == logical and 1 == arithmetic
	     i_L		: in std_logic;		-- 0 == right and 1 == left
	     o_O		: out std_logic_vector(31 downto 0));
end entity;

architecture bsh of barrel_shifter is 

begin
barrel_shifter: process(i_clk)
begin
   if rising_edge(i_clk) then
		if i_A = '1' then	
			if i_L = '1' then
				o_O <= std_logic_vector(shift_left(unsigned(i_I), to_integer(unsigned(i_S))));
			else
				o_O <= std_logic_vector(shift_right(signed(i_I), to_integer(unsigned(i_S))));
			end if;
		else
			if i_L = '1' then
				o_O <= std_logic_vector(shift_left(unsigned(i_I), to_integer(unsigned(i_S))));
			else
				o_O <= std_logic_vector(shift_right(unsigned(i_I), to_integer(unsigned(i_S))));
			end if;
		end if;
	end if;
 end process barrel_shifter;
end bsh;
