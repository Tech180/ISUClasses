library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_D0          : in std_logic;
       i_D1          : in std_logic;
       i_S	     : in std_logic;
       o_O           : out std_logic);

end mux2t1;

architecture structural of mux2t1 is

  component andg2 is
      port(i_A              : in std_logic;
	   i_B              : in std_logic;
	   o_F               : out std_logic);
end component;

  component invg is
      port(i_A              : in std_logic;
	   o_F               : out std_logic);
end component; 

  component org2 is
      port(i_A              : in std_logic;
	   i_B              : in std_logic;
           o_F               : out std_logic);  
  end component;
 
	signal a : std_logic;
	signal b : std_logic; --not a
	signal c : std_logic; --not b
	
begin 
        M1: org2
           port MAP(i_A            => b,
             	    i_B            => c,
                    o_F            => o_O);
	M2: andg2
           port MAP(i_A            => a,
             	    i_B            => i_D0,
                    o_F            => b);
        M2_1: andg2
           port MAP(i_A            => i_S,
             	    i_B            => i_D1,
                    o_F            => c);
	M4: invg
           port MAP(i_A            => i_S,
                    o_F            => a);

end structural;
