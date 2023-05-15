-------------------------------------------------------------------------
-- Riley Lawson
-- CPR E 381
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
  generic(A : integer := 8);
  port(o_data   : out std_logic_vector(A-1 downto 0);
       o_a      : out std_logic_vector(A-1 downto 0));

end testbench;

architecture structural of testbench is

  component mux2t1_N
    generic(N : integer := 16);
    port(i_D0  : in std_logic_vector(N-1 downto 0);
         i_D1  : in std_logic_vector(N-1 downto 0);
         i_S   : in std_logic;
         o_O   : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_N_dataflow
    generic(N : integer := 16);
    port(i_D0  : in std_logic_vector(N-1 downto 0);
         i_D1  : in std_logic_vector(N-1 downto 0);
         i_S   : in std_logic;
         o_O   : out std_logic_vector(N-1 downto 0));
  end component;
  
  signal i_toS  : std_logic;
  signal i_toD0 : std_logic_vector(A-1 downto 0);
  signal i_toD1 : std_logic_vector(A-1 downto 0);

begin


  generic_m: mux2t1_N
    generic map(N => 8)
    port map(i_D0  => i_toD0,
             i_D1  => i_toD1,
             i_S  =>  i_toS,
  	     o_O  =>  o_a);

  generic_m_data: mux2t1_N_dataflow
    generic map(N => 8)
    port map(i_D0  => i_toD0,
             i_D1  => i_toD1,
             i_S  =>  i_toS,
  	     o_O  =>  o_data);
  process
    begin
      i_toD0 <= x"FF";
      i_toD1 <= x"00";
      i_toS <=  '1';
      wait for 100 ns;
      
      i_toS <=  '0';
      wait for 100 ns;

      i_toD0 <= x"00";
      i_toD1 <= x"FF";      
      i_toS <=  '1';
      wait for 100 ns;      

      i_toS <=  '0';
      wait for 100 ns;
      
	wait;
  end process;
  
end structural;

