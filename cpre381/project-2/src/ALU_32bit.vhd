-------------------------------------------------------------------------
-- Riley Lawson, Long Zeng
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain 32 bit ALU
-- implementation.

-- 11/04/2021 by RL:: Created 32 bit ALU
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32bit is
   port(i_D0		        : in std_logic_vector(31 downto 0);
        i_D1                	: in std_logic_vector(31 downto 0);
        i_D2                	: in std_logic_vector(3 downto 0); --op
        i_D3                    : in std_logic_vector(4 downto 0); --shamt
        i_Overflow              : in std_logic;
        o_O                 	: out std_logic_vector(31 downto 0); --out
        o_Overflow          	: out std_logic; --overflow
        o_zero                 	: out std_logic); --zero
end ALU_32bit;

architecture structural of ALU_32bit is

component addsub is
  generic(N : integer := 32);
  port(i_fA         : in std_logic_vector(N-1 downto 0);
       i_fB         : in std_logic_vector(N-1 downto 0);
       i_fC         : in std_logic;
       o_Cry        : out std_logic;
       o_Sum        : out std_logic_vector(N-1 downto 0));

end component;

component and_32bit_data is
   port(i_D0     		: in std_logic_vector(31 downto 0);
        i_D1     		: in std_logic_vector(31 downto 0);
        o_O      		: out std_logic_vector(31 downto 0));
end component;

component or_32bit_data is
   port(i_D0     		: in std_logic_vector(31 downto 0);
        i_D1     		: in std_logic_vector(31 downto 0);
        o_O      		: out std_logic_vector(31 downto 0));
end component;

component nor_32bit_data is
   port(i_D0     		: in std_logic_vector(31 downto 0);
        i_D1     		: in std_logic_vector(31 downto 0);
        o_O      		: out std_logic_vector(31 downto 0));
end component;

component xor_32bit_data is
   port(i_D0     		: in std_logic_vector(31 downto 0);
        i_D1     		: in std_logic_vector(31 downto 0);
        o_O      		: out std_logic_vector(31 downto 0));
end component;

component mux_32bit_dataflow is
	generic(N 	: integer := 32);
	port(i_D0 	: in std_logic_vector(N-1 downto 0);
       	     i_D1 	: in std_logic_vector(N-1 downto 0);
             i_S 	: in std_logic;
             o_O 	: out std_logic_vector(N-1 downto 0));

end component;

component barrel_shifter is
	port(i_clk		: in std_logic;
	     i_I		: in std_logic_vector(31 downto 0);
	     i_S		: in std_logic_vector (4 downto 0);
	     i_A		: in std_logic;		-- 0 == logical and 1 == arithmetic
	     i_L		: in std_logic;		-- 0 == right and 1 == left
	     o_O		: out std_logic_vector(31 downto 0));
end component;

signal s_and	         	: std_logic_vector(31 downto 0);
signal s_or	             	: std_logic_vector(31 downto 0);
signal s_nor	         	: std_logic_vector(31 downto 0);
signal s_xor	         	: std_logic_vector(31 downto 0);
signal s_add	         	: std_logic_vector(31 downto 0);
signal s_cAdd			: std_logic;
signal s_sub               	: std_logic_vector(31 downto 0);
signal s_cSub			: std_logic;

signal s_isEqual	: std_logic;
signal s_lessThan	: std_logic_vector(31 downto 0);

signal s_barrelshiftl    : std_logic_vector(31 downto 0);
signal s_barrelshiftr    : std_logic_vector(31 downto 0);
signal s_barrelshiftra   : std_logic_vector(31 downto 0);

begin

--Dataflow
generic_32bit_and : and_32bit_data
port map(i_D0 => i_D0,
         i_D1 => i_D1,
         o_O => s_and);
         
--Dataflow
generic_32bit_or : xor_32bit_data
port map(i_D0 => i_D0,
         i_D1 => i_D1,
         o_O  => s_or);
         
--Dataflow
generic_32bit_xor : xor_32bit_data
port map(i_D0 => i_D0,
         i_D1 => i_D1,
         o_O => s_xor);

--Dataflow
generic_32bit_nor : nor_32bit_data
port map(i_D0 => i_D0,
         i_D1 => i_D1,
         o_O  => s_nor);

generic_add : addsub
  port map(i_fA         => i_D0,
       i_fB             => i_D1,
       i_fC             => '0',
       o_Cry            => s_cAdd,
       o_Sum            => s_add);
       
generic_sub : addsub
  port map(i_fA         => i_D0,
       i_fB             => i_D1,
       i_fC             => '1',
       o_Cry            => s_csub,
       o_Sum            => s_sub);
       
generic_sll: barrel_shifter
  port map (i_clk		=> '1',
	     i_I		=> i_D1,
	     i_S		=> i_D3,
	     i_A		=> '0',
	     i_L		=> '1',
	     o_O		=> s_barrelshiftl);
	    
generic_srl: barrel_shifter
  port map (i_clk		=> '1',
	     i_I		=> i_D1,
	     i_S		=> i_D3,
	     i_A		=> '0',
	     i_L		=> '0',
	     o_O		=> s_barrelshiftr);
	     
generic_sra: barrel_shifter
  port map (i_clk		=> '1',
	     i_I		=> i_D1,
	     i_S		=> i_D3,
	     i_A		=> '1',
	     i_L		=> '1',
	     o_O		=> s_barrelshiftra);
	     
	     
s_isEqual <= '1'	when(s_sub = x"00000000")
			else '0';

s_lessThan <= x"00000001" when(i_D0 < i_D1 and i_D0(31) = '0' and i_D1(31) = '0') else 
              x"00000001" when(i_D0(31) = '1' and i_D1(31) = '0' and i_D0 > i_D1) else
              x"00000000" when(i_D1(31) = '1' and i_D0(31) = '0' and i_D0 < i_D1) else
              x"00000001" when(i_D0 < i_D1) else
              x"00000000";
              
o_O      <= s_and                                                                           when i_D2 = "0010" else
            s_or                                                                            when i_D2 = "0001" else
            s_xor                                                                           when i_D2 = "0100" else
            s_nor                                                                           when i_D2 = "0011" else
            s_add                                                                           when i_D2 = "1110" else
            s_sub                                                                           when i_D2 = "0110" else
            s_lessThan                                                                      when i_D2 = "0111" else
            s_barrelshiftl                                                                  when i_D2 = "1111" else
            s_barrelshiftr                                                                  when i_D2 = "1000" else
            s_barrelshiftra                                                                 when i_D2 = "1101" else
            (i_D1(15 downto 0) & x"0000")                                                    when i_D2 = "1001" else
            x"00000000"                                                                     when i_D2 = "1010" else
            x"00000000"                                                                     when i_D2 = "1011" else
            x"00000000";

o_zero <= '1' when (i_D2 = "1010" and s_isEqual = '1') else
          '1' when (i_D2 = "1011" and s_isEqual = '0') else
          '0';
o_overflow <= s_cAdd when i_D2 = "0100" else
              s_cSub when i_D2 = "0101" else
           '0';              
          
              
              
end structural;
