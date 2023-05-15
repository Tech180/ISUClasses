-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_N_dataflow is

  generic(N : integer := 16);
  port(i_D0          : in std_logic_vector(N-1 downto 0);
       i_D1          : in std_logic_vector(N-1 downto 0);
       i_S           : in std_logic;
       o_O           : out std_logic_vector(N-1 downto 0));

end mux2t1_N_dataflow;

architecture dataflow of mux2t1_N_dataflow is

  signal s : std_logic_vector(N-1 downto 0);
  signal a : std_logic_vector(N-1 downto 0);
  signal b : std_logic_vector(N-1 downto 0);
  signal c : std_logic_vector(N-1 downto 0);

begin

  A1: for i in 0 to N-1 generate
     s(i) <= i_S;
  end generate;

  a <= not s;
  b <= i_D0 and a;
  c <= i_D1 and s;
  o_O <= b or c;
  
end dataflow;
