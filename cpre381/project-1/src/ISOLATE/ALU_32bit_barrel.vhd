-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALU_32bit_barrel.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain 32 bit ALU
-- implementation.

-- 11/04/2021 by RL:: Created 32 bit ALU
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32bit_barrel is
	generic (helper			: time : 50 ns);
	port(i_D0 			: in std_logic_vector(31 downto 0);
             i_D1			: in std_logic_vector(31 downto 0);
	     i_D2			: in std_logic_vector(2 downto 0);
	     i_S     			: in std_logic_vector(4 downto 0);
	     i_A 			: in std_logic;
	     i_L 			: in std_logic;
	     --i_D3 			: in std_logic; --shamt
	     o_O			: out std_logic_vector(31 downto 0);
	     o_C 			: out std_logic; --C_out
             o_Overflow 		: out std_logic;
             no 			: out std_logic);
end ALU_32bit_barrel;

architecture structural of ALU_32bit_barrel is

component ALU_32bit
   port(i_D0		        	: in std_logic_vector(31 downto 0);
        i_D1                		: in std_logic_vector(31 downto 0);
        i_D2                		: in std_logic_vector(2 downto 0); --op
        o_O                 		: out std_logic_vector(31 downto 0); --out
        o_C                 		: out std_logic; --C_out
        o_Overflow          		: out std_logic; --overflow
        no                  		: out std_logic); --zero
end ALU_32bit;
end component;

component BarrelShifter
   port(--i_clk				: in std_logic;
	i_A    				: in std_logic_vector(31 downto 0);
	i_S    				: in std_logic_vector(4 downto 0);
	i_A 				: in std_logic;
	i_L 				: in std_logic;
	o_O    				: out std_logic_vector(31 downto 0));
end component;

component mux_32bit_dataflow
   generic(N 				: integer := 32);
   port(i_D0 				: in std_logic_vector(N-1 downto 0);	--0
       	i_D1 				: in std_logic_vector(N-1 downto 0);	--1
        i_S 				: in std_logic;
        o_O 				: out std_logic_vector(N-1 downto 0));
end component;

signal s_O 				: std_logic_vector(31 downto 0); --to ALU
signal s_shiftVariable 			: std_logic_vector(31 downto 0); --for shifting

begin

M1 : ALU_32bit
   port MAP(i_D0 		=> i_D0,
	    i_D1 		=> i_D1,
	    i_D2 		=> i_D2,
	    o_O 		=> s_O,
	    o_C 		=> o_C,
	    o_Overflow 		=> o_Overflow,
	    no	 		=> no);

M2 : BarrelShifter
   port MAP(i_A 		=> i_A,
	    i_S 		=> i_S,
	    i_A 		=> i_A,
	    i_L 		=> i_L,
	    o_O 		=> s_shiftVariable);

M3 : mux_32bit_dataflow
   port MAP(i_D0 		=> s_O,
	    i_D1 		=> s_shiftVariable,
	    i_S 		=> i_D3,
	    o_O 		=> o_O);

end structural;
