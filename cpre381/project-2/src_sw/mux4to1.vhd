library IEEE;
use IEEE.std_logic_1164.all;

entity mux4to1 is
	generic(N : integer := 32);
	port(i_D0 : in std_logic_vector(N-1 downto 0);
         i_D1 : in std_logic_vector(N-1 downto 0);
	     i_D2 : in std_logic_vector(N-1 downto 0);
	     i_D3 : in std_logic_vector(N-1 downto 0);
         i_F  : in std_logic_vector(1 downto 0);
         o_O  : out std_logic_vector(N-1 downto 0));
end mux4to1;

architecture structural of mux4to1 is

signal s_mux : std_logic_vector(31 downto 0);
signal s_mux1 : std_logic_vector(31 downto 0);

begin

process(i_D0,
        i_D1,
        i_D2,
        i_D3,
        i_F)
    begin
        if i_F = "00"
            then o_O <= i_D0;
        elsif i_F = "01"
            then o_O <= i_D1;
        elsif i_F = "10"
            then o_O <= i_D2;
        else
            o_O <= i_D3;
        end if;
    end process;

end structural;
