-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ControlUnit_tb.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain a Control  
-- implementation testbench.

-- 10/28/2021 by RL:: Created control unit testbench
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity controlUnit_tb is
end ControlUnit_tb;

architecture behavior of controlUnit_tb is

   component controlUnit
	  port(op_Code	    		: in std_logic_vector(5 downto 0);
	       Funct		    	: in std_logic_vector(5 downto 0);
	       RegDst		    	: out std_logic;
	       MemtoReg 	   	: out std_logic;
	       MemWrite 	    	: out std_logic;
	       ALUSrc 		   	: out std_logic;
	       RegWrite 	   	: out std_logic;
	       ALUControl	    	: out std_logic_vector(3 downto 0);
	       beq 		    	: out std_logic;
 	       bne 		    	: out std_logic;
	       j  		        : out std_logic;
	       jr 		        : out std_logic;
	       sltu            		: out std_logic;
	       shiftVariable   		: out std_logic;
	       upper_immediate 		: out std_logic;
	       halt                     : out std_logic);
   end component;

   signal s_O               		: std_logic_vector(5 downto 0); --opcode
   signal s_F               		: std_logic_vector(5 downto 0); --function
   signal s_R               		: std_logic;                    --RegDst
   signal s_mr              		: std_logic;                    --MemtoReg
   signal s_mw              		: std_logic;                    --MemWrite
   signal s_ALUSrc          		: std_logic;
   signal s_rw              		: std_logic;                    --RegWrite
   signal s_beq             		: std_logic;
   signal s_bne             		: std_logic;
   signal s_j               		: std_logic;
   signal s_jr              		: std_logic;
   signal s_sv              		: std_logic;                    --shiftVariable
   signal s_ui              		: std_logic;                    --upper_immediate
   signal s_sltu            		: std_logic;
   signal s_ALUc			: std_logic_vector(3 downto 0); --ALUControl
   signal s_halt                        : std_logic := '0';
begin

   generic_controlUnit : controlUnit
	port map(op_Code 		=> s_O,
             	 Funct 			=> s_F,
            	 RegDst 		=> s_R,
             	 MemtoReg 		=> s_mr,
            	 MemWrite 		=> s_mw,
             	 ALUSrc 		=> s_ALUSrc,
             	 RegWrite 		=> s_rw,
             	 beq 			=> s_beq,
             	 bne 			=> s_bne,
             	 j 			=> s_j,
             	 jr 			=> s_jr,
             	 sltu 			=> s_sltu,
             	 shiftVariable 		=> s_sv,
             	 upper_immediate 	=> s_ui,
		 ALUControl 		=> s_ALUc,
		 halt                   => s_halt);
  
  
P_TEST_CASES: process
    begin

    --each test
    --Instruction -> "add"
    s_O <= "000000";
    s_F <= "100000";
    wait for 100 ns;

    --Instruction -> "addu"
    s_O <= "000000";
    s_F <= "100001";
    wait for 100 ns;

    --Instruction -> "and"
    s_O <= "000000";
    s_F <= "100100";
    wait for 100 ns;

    --Instruction -> "nor"
    s_O <= "000000";
    s_F <= "100111";
    wait for 100 ns;

    --Instruction -> "xor"
    s_O <= "000000";
    s_F <= "100110";
    wait for 100 ns;

    --Instruction -> "or"
    s_O <= "000000";
    s_F <= "100101";
    wait for 100 ns;

    --Instruction -> "slt"
    s_O <= "000000";
    s_F <= "101010";
    wait for 100 ns;

    --Instruction -> "sltu"
    s_O <= "000000";
    s_F <= "101011";
    wait for 100 ns;

    --Instruction -> "sll"
    s_O <= "000000";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "srl"
    s_O <= "000000";
    s_F <= "000010";
    wait for 100 ns;

    --Instruction -> "sra"
    s_O <= "000000";
    s_F <= "000011";
    wait for 100 ns;

    --Instruction -> "sllv"
    s_O <= "000000";
    s_F <= "000100";
    wait for 100 ns;

    --Instruction -> "srlv"
    s_O <= "000000";
    s_F <= "000110";
    wait for 100 ns;

    --Instruction -> "srav"
    s_O <= "000000";
    s_F <= "000111";
    wait for 100 ns;

    --Instruction -> "sub"
    s_O <= "000000";
    s_F <= "100010";
    wait for 100 ns;

    --Instruction -> "subu"
    s_O <= "000000";
    s_F <= "100011";
    wait for 100 ns;

    --Immediate instructions
    --Instruction -> "addi"
    s_O <= "001000";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "addiu"
    s_O <= "001001";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "andi"
    s_O <= "001100";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "lui"
    s_O <= "001111";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "xori"
    s_O <= "001110";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "ori"
    s_O <= "001101";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "slti"
    s_O <= "001010";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "sltiu"
    s_O <= "001011";
    s_F <= "000000";
    wait for 100 ns;

    --Load and Store Instructions
    --Instruction -> "lw"
    s_O <= "100011";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "sw"
    s_O <= "101011";
    s_F <= "000000";
    wait for 100 ns;

    --Branch Instructions
    --Instruction -> "beq"
    s_O <= "000100";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "bne"
    s_O <= "000101";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "j"
    s_O <= "000010";
    s_F <= "000000";
    wait for 100 ns;

    --Instruction -> "jr" //jump and register
    s_O <= "000000";
    s_F <= "001000";
    wait for 100 ns;

    --Instruction -> "jal"
    s_O <= "000011";
    s_F <= "000000";
    wait for 100 ns;
    
    --Instruction -> "halt"
    s_O <= "010100";
    s_F <= "000000";
    wait for 100 ns;

	wait;

   end process;

end behavior;


