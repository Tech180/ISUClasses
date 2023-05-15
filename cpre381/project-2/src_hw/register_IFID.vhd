library IEEE;
use IEEE.std_logic_1164.all;

entity register_IFID is

   generic(N: integer := 32);
   port(clock         : in std_logic;
        i_rst         : in std_logic;
        i_we          : in std_logic;
        PC	      : in std_logic_vector(N-1 downto 0);
        inst	      : in std_logic_vector(N-1 downto 0);
        o_PC          : out std_logic_vector(N-1 downto 0);
        o_inst	      : out std_logic_vector(N-1 downto 0));

end register_IFID;

architecture structural of register_IFID is

component register32bit

generic(N: integer := 32);
   port(clock        : in std_logic;
        i_rst        : in std_logic;
        i_we         : in std_logic;
        data         : in std_logic_vector(N-1 downto 0);
        o_O          : out std_logic_vector(N-1 downto 0));

end component;

begin

generic_32bitregister : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => PC,
             o_O => o_PC);

generic_32bitregister1 : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => inst,
             o_O => o_inst);

end structural;
