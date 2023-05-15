-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

use work.fullAdder;
use work.AdderSubtracter;

entity tb_AS is
  generic(A : integer := 8);
  port(o_C : out std_logic;
       o_S : out std_logic_vector(A-1 downto 0));

end tb_AS;

architecture structure of tb_AS is

  component AdderSubtracter is
    generic(N  : integer := 8);
    port(i_D0  : in std_logic_vector(N-1 downto 0);
         i_D1  : in std_logic_vector(N-1 downto 0);
         i_D2  : in std_logic;
         i_Sel : in std_logic;
         o_S   : out std_logic_vector(N-1 downto 0);
	 o_D   : out std_logic);
  end component;
  
  signal i_toD0 : std_logic_vector(A-1 downto 0);
  signal i_toD1 : std_logic_vector(A-1 downto 0);
  signal i_toS  : std_logic;
  signal i_toD2 : std_logic;

begin

 generic_AS: AdderSubtracter
    generic map(N  => A)
    port map(i_D0  => i_toD0,
             i_D1  => i_toD1,
             i_D2  => i_toD2,
	     i_Sel => i_toS,
	     o_S   => o_S,
	     o_D   => o_C);
  process
    begin
      i_toD2 <=  '0';
      i_toD0 <= x"00";
      i_toD1 <= x"01";
      i_toS  <=  '0';
      wait for 100 ns;
      
      i_toS  <=  '1';
      wait for 100 ns;

      i_toD0 <= x"01";
      i_toD1 <= x"01";      
      i_toS  <=  '0';
      wait for 100 ns;

      i_toS  <=  '1';
      wait for 100 ns;

      i_toD0 <= x"FF";
      i_toD1 <= x"01";      
      i_toS  <=  '0';
      wait for 100 ns;
 
      i_toS  <=  '1';
      wait for 100 ns;

      i_toD0 <= x"AA";
      i_toD1 <= x"A0";      
      i_toS  <=  '0';
      wait for 100 ns;

      i_toS  <=  '1';
      wait for 100 ns;
      
  end process;
  
end structure;


