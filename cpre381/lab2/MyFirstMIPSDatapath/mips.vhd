-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mips is
port(i_CLK			: in std_logic;
     i_rw	        : in std_logic_vector(4 downto 0);
     i_rd	        : in std_logic_vector(4 downto 0);
     i_rt	        : in std_logic_vector(4 downto 0);
     i_as	        : in std_logic;
     ALUSrc	        : in std_logic;
     i_we_re	    : in std_logic;
     imm			: in std_logic_vector(31 downto 0);
     o_O			: out std_logic); --output
end mips;

architecture structural of mips is

component adderSubtracter
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0); --register
       --imm  : in std_logic_vector(N-1 downto 0);
       i_D2         : in std_logic; --immediate
       i_Sel        : in std_logic;                       --select
       ALUSrc       : in std_logic;
       o_S          : out std_logic_vector(N-1 downto 0); --sum
       o_D          : out std_logic);
end component;

component register_file
  port(i_CLK	    : in std_logic;
       i_RST	    : in std_logic;
       rt	        : in std_logic_vector(4 downto 0);
       rd	        : in std_logic_vector(4 downto 0);
       rw	        : in std_logic_vector(4 downto 0);
       we           : in std_logic;
       data         : in std_logic_vector(N-1 downto 0); --data value
       o_rt         : out std_logic_vector(N-1 downto 0);
       o_rd         : out std_logic_vector(N-1 downto 0));
end component;

signal s_rd 	    :  std_logic_vector(31 downto 0);
signal s_rt		    :  std_logic_vector(31 downto 0);
signal s_O	        :  std_logic_vector(31 downto 0);
signal s_RST		:  std_logic_vector(31 downto 0);

begin

generic_adderSubtractor : adderSubtracter
  port map(i_D0   => s_rd,
           i_D1   => s_rt,
           i_S    => imm,
           ALUSrc => ALUSrc,
           i_Sel  => i_as,
           o_S    => s_O,
           o_D    => o_O);


generic_register_file : register_file
  port map(i_CLK  => i_CLK,
           i_RST  => s_RST,
           rt     => i_rt,
           rd     => i_rd,
           rw     => i_rw,
           we     => i_we_re,
           data   => s_O,
           o_rt   => s_rt,
           o_rd   => s_rd);

end structural;
