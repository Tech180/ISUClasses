library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32bit_tb is
   generic (helper		: time : 50 ns);
   port(o_O                 	: out std_logic; --out
        no                  	: out std_logic); --zero
end ALU_32bit_tb;

architecture structural of ALU_32bit_tb is
 component ALU_32bit is
    port(i_D0		        : in std_logic_vector(31 downto 0);
         i_D1                	: in std_logic_vector(31 downto 0);
         i_D2                	: in std_logic_vector(2 downto 0); --op
         o_O                 	: out std_logic_vector(31 downto 0); --out
         --D3                    : in std_logic_vector(4 downto 0); --shamt
         o_C                 	: out std_logic; --c_out
         o_Overflow          	: out std_logic; --overflow
         no                  	: out std_logic); --zero
 end component;

signal s_D0             	: std_logic_vector(31 downto 0);
signal s_D1             	: std_logic_vector(31 downto 0);
signal s_D2	        	    : std_logic_vector(4 downto 0);
signal s_ALUc     		    : std_logic_vector(3 downto 0); --ALU Control
signal s_O         		    : std_logic_vector(31 downto 0) := x"00000000"; --output

signal s_Overflow           : std_logic; --overflow
signal s_no	                : std_logic; --zero
signal s_C_out		        : std_logic; --result

  
  begin
    M1: ALU_32bit
      port map(i_D0          	=> s_D0,         
               i_D1          	=> s_D1,
    	       i_D2	 	=> s_D2,         
    	       i_ALUc 		=> s_ALUc,
    	       o_Overflow	=> s_Overflow,       
    	       o_C	   	=> s_C_out, 
	       o_O     		=> s_O, --result 
    	       no       	=> s_no); --zero

               
  process
    begin

		--Instruction Reset "and"
		wait for helper;

		i_D0           	<= x"11111111";
		i_D1           	<= x"00000000";
		i_ALUc  	<= "0000";
		i_D3		<= "00000";
		i_Overflow   	<= '0';

		--Instruction Reset "and"
		wait for helper;

		i_D0           	<= x"10101010";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0000";
		i_D3		<= "00000";
		i_Overflow    	<= '0';

		wait for helper;

		--Instruction -> "and"
		i_D0           	<= x"10101010";
		i_B           	<= x"01010101";
		i_ALUc  	<= "0000";
		i_D3		<= "00000";
		i_Overflow    	<= '0';
		wait for helper;

		--Instruction Reset "or"
		i_D0           	<= x"11110000";
		i_B           	<= x"00001111";
		i_ALUc  	<= "0001";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "or"
		i_D0           	<= x"11110000";
		i_B           	<= x"10101010";
		i_ALUc  	<= "0001";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "or"
		i_D0           	<= x"00000000";
		i_B           	<= x"00000000";
		i_ALUc 	<= "0001";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "xor"
		i_D0           	<= x"10000000";
		i_B           	<= x"00000001";
		i_ALUc  	<= "0010";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "xor"
		i_D0           	<= x"10011000";
		i_B           	<= x"10000001";
		i_ALUc  	<= "0010";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "xor"
		i_D0           	<= x"11111111";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0010";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "nor"
		i_D0           	<= x"00000000";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0011";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "nor"
		i_D0           	<= x"11110000";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0011";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "nor"
		i_D0           	<= x"00000000";
		i_B           	<= x"00000000";
		i_ALUc  	<= "0011";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "add"
		i_D0           	<= x"00000001";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0100";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "add"
		i_D0           	<= x"00000000";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0100";
		i_D3		<= "00000";

		wait for helper;

		--add
		--Instruction -> "add"
		i_D0           	<= x"00004567";
		i_B           	<= x"11111111";
		i_ALUc  	<= "0100";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "sub"
		i_D0           	<= x"11110001";
		i_B           	<= x"11110000";
		i_ALUc  	<= "0101";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "sub"
		i_D0           	<= x"11110001";
		i_B           	<= x"11110011";
		i_ALUc  	<= "0101";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "sub"
		i_D0           	<= x"11110001";
		i_B           	<= x"00000000";
		i_ALUc  	<= "0101";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "slt"
		i_D0           	<= x"11000000";
		i_B           	<= x"10000000";
		i_ALUc  	<= "0110";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "slt"
		i_D0           	<= x"11000000";
		i_B           	<= x"11100000";
		i_ALUc  	<= "0110";
		i_D3		<= "00000";

		wait for helper;

		--slt
		--Instruction -> "slt"
		i_D0           	<= x"00000000";
		i_B           	<= x"00000000";
		i_ALUc  	<= "0110";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "sll"
		i_D0           	<= x"00000001";
		i_B           	<= x"00000010";
		i_ALUc  	<= "0111";
		i_D3		<= "00001";

		wait for helper;

		--Instruction Reset "sll"
		i_D0           	<= x"00000001";
		i_B           	<= x"00000010";
		i_ALUc  	<= "0111";
		i_D3		<= "00010";

		wait for helper;

		--Instruction -> "sll"
		i_D0           	<= x"00000000";
		i_B           	<= x"00000000";
		i_ALUc  	<= "0111";
		i_D3		<= "00010";

		wait for helper;

		--Instruction Reset "srl"
		i_D0           	<= x"00010010";
		i_B           	<= x"00010001";
		i_ALUc 		<= "1000";
		i_D3		<= "00001";

		wait for helper;

		--Instruction Reset "srl"
		i_D0           	<= x"00110010";
		i_B           	<= x"00110001";
		i_ALUc  	<= "1000";
		i_D3		<= "00010";
		wait for helper;

		--Instruction -> "srl"
		i_D0           	<= x"00110010";
		i_B           	<= x"00110001";
		i_ALUc  	<= "1000";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "lui"
		i_D0           	<= x"00001111";
		i_B           	<= x"00001111";
		i_ALUc  	<= "1001";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "lui"
		i_D0           	<= x"00000001";
		i_B           	<= x"00000001";
		i_ALUc  	<= "1001";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "lui"
		i_D0           	<= x"00000404";
		i_B           	<= x"00000404";
		i_ALUc  	<= "1001";
		i_D3		<= "00000";

		wait for helper;

		--Branch Instructions

		--Instruction Reset "beq"
		i_D0           	<= x"11110000";
		i_B           	<= x"11110000";
		i_ALUc  	<= "1010";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "beq"
		i_D0           	<= x"11111000";
		i_B           	<= x"11110000";
		i_ALUc  	<= "1010";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "beq"
		i_D0           	<= x"11111111";
		i_B           	<= x"11111111";
		i_ALUc  	<= "1010";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "bne"
		i_D0          	<= x"11110000";
		i_B           	<= x"00000000";
		i_ALUc  	<= "1011";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "bne"
		i_D0           	<= x"11110000";
		i_B           	<= x"11110000";
		i_ALUc  	<= "1011";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "bne"
		i_D0           	<= x"11111111";
		i_B           	<= x"00000000";
		i_ALUc  	<= "1011";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "rqlqb"
		i_D0           	<= x"00001111";
		i_B           	<= x"10100101";
		i_ALUc  	<= "1100";
		i_D3		<= "00000";

		wait for helper;

		--Instruction Reset "rqlqb"
		i_D0           	<= x"00001111";
		i_B           	<= x"10110101";
		i_ALUc  	<= "1100";
		i_D3		<= "00000";

		wait for helper;

		--Instruction -> "rqlqb"
		i_D0           	<= x"00001111";
		i_B           	<= x"10440101";
		i_ALUc  	<= "1100";
		i_D3		<= "00000";

		wait for helper;

      
    end process;
end structure;

