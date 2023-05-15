-------------------------------------------------------------------------
-- Riley lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

use work.fullAdder;

entity AdderSubtracter is
  generic (N: integer := 8);
  
  port(i_D0       : in std_logic_vector(N-1 downto 0);
       i_D1       : in std_logic_vector(N-1 downto 0); --register
       --immediate  : in std_logic_vector(N-1 downto 0);
       i_D2       : in std_logic;
       i_Sel      : in std_logic;                       --select
       ALUSrc     : in std_logic;
       o_S        : out std_logic_vector(N-1 downto 0); --sum
       o_D        : out std_logic);
end AdderSubtracter;
  
architecture structural of AdderSubtracter is
  
 component fullAdder is
  generic(N: integer := 8);
  port(i_D0_1     : in std_logic_vector(N-1 downto 0);
       i_D1_1     : in std_logic_vector(N-1 downto 0);
       i_D2_1     : in std_logic;
       o_S_1      : out std_logic_vector(N-1 downto 0);
       o_D_1      : out std_logic);
 end component;
    
 component OnesComp is
    generic(N     : integer := 8);
    port(i_A      : in std_logic_vector(N-1 downto 0);
         o_F      : out std_logic_vector(N-1 downto 0));
 end component;

 component mux2t1_N_dataflow is
    generic(N : integer := 8);
    port(i_D0     : in std_logic_vector(N-1 downto 0);
         i_D1     : in std_logic_vector(N-1 downto 0);
         i_S      : in std_logic;
         o_O      : out std_logic_vector(N-1 downto 0));
 end component;
  
  signal o_Comp   : std_logic_vector(N-1 downto 0);
  signal o_Sel    : std_logic_vector(N-1 downto 0);
  --signal o_Sel2   : std_logic_vector(N-1 downto 0);
  --signal op       : std_logic_vector(N-1 downto 0);

 begin
    
    generic_OnesComp            : OnesComp
      port map(i_A => i_D1,
               o_F => o_Comp); 

    --FIXME
    generic_m_mux2t1_N_dataflow : mux2t1_N_dataflow
      port map(i_D0 => i_D1,
               i_D1 => o_Comp,
               i_S => i_Sel,
               o_O => o_Sel);

    --FIXME
    generic_m_mux2t1_N_dataflow_1 : mux2t1_N_dataflow
      port map(i_D0 => i_D1,
               i_D1 => o_Comp,
               i_S => ALUSrc,
               o_O => o_Sel);

    generic_fullAdder           : fullAdder
      port map(i_D0_1 => i_D0,
               i_D1_1 => o_Sel,
               i_D2_1 => i_Sel,
               o_S_1  => o_S,
               o_D_1 => o_D);
  
end structural;

