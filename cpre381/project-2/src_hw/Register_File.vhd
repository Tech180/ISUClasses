-------------------------------------------------------------------------
-- Long Zeng
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Reg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N-bit register
--
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.reg_array_type.all;

entity Register_File is
  generic(N: integer := 32);
  port(i_CLK	    : in std_logic;
       i_RST	    : in std_logic;
       r_1	    : in std_logic_vector(4 downto 0);
       r_2	    : in std_logic_vector(4 downto 0);
       i_w	    : in std_logic_vector(4 downto 0);
       WE           : in std_logic;
       i_Data         : in std_logic_vector(N-1 downto 0);
       o_r_1         : out std_logic_vector(N-1 downto 0);
       o_r_2         : out std_logic_vector(N-1 downto 0));
end Register_File;

architecture structural of Register_File is
  signal s_decoded : std_logic_vector(31 downto 0);
  signal enable_all : std_logic_vector(31 downto 0);
  signal o_Q_N : reg_Array;
  component Reg_N
    generic(N: integer := 32);
    port(i_CLK        : in std_logic;
         i_RST        : in std_logic;
         i_WE         : in std_logic;
         i_D_N          : in std_logic_vector(N-1 downto 0);
         o_Q_N          : out std_logic_vector(N-1 downto 0));
  end component;

  component decoder5t32
    port(i_I  : in std_logic_vector(4 downto 0);
         o_O  : out std_logic_vector(31 downto 0));
  end component;

  component mux32t1_array
    port(i_A  : in reg_Array;
         i_S  : in std_logic_vector(4 downto 0);
         o_F  : out std_logic_vector(31 downto 0));
  end component;
  
  
  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

  begin

  write_decoder: decoder5t32
    port map(i_I =>     i_w, 
             o_O =>     s_decoded);
             
g_and: for i in 0 to 31 generate
  and1: andg2
  port map(i_A => s_decoded(i),
           i_B => WE,
           o_F => enable_all(i)
  );
end generate g_and;                
    
  reg_0: Reg_N
    port map(i_CLK => i_CLK,
	 i_RST => '1',
         i_WE => enable_all(0),
         i_D_N => i_Data,
         o_Q_N => o_Q_N(0));
         
  G1: for i in 1 to 31 generate
    reg_i: Reg_N
    port map(i_CLK => i_CLK,
         i_RST => i_RST,
         i_WE => enable_all(i),
         i_D_N => i_Data,
         o_Q_N => o_Q_N(i));   
  end generate;
  
  read_mux_t: mux32t1_array
    port map(o_Q_N, r_1, o_r_1);
    
  read_mux_d: mux32t1_array
    port map(o_Q_N, r_2, o_r_2);
    
end structural;


