-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_dataflow is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       i_S          : in std_logic;
       o_F          : out std_logic);

end mux2t1_dataflow;

architecture dataflow of mux2t1_dataflow is

  signal a : std_logic;
  signal b : std_logic;
  signal c : std_logic;

begin

  a <= not i_S;
  b <= i_A and a;
  c <= i_B and i_S;
  o_F <= b or c;
  
end dataflow;
