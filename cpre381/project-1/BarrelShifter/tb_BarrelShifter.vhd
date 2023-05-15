library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tb_barrel_shifter is 
	generic(gCLK_HPER	: time	:= 10 ns);
end tb_barrel_shifter;

architecture structure of tb_barrel_shifter is 

constant cCLK_PER : time := gCLK_HPER * 2;

component barrel_shifter is 
	port(i_clk		: in std_logic;
	     i_I		: in std_logic_vector(31 downto 0);
	     i_S		: in std_logic_vector (4 downto 0);
	     i_A		: in std_logic;		-- 0 == logical and 1 == arithmetic
	     i_L		: in std_logic;		-- 0 == right and 1 == left
	     o_O		: out std_logic_vector(31 downto 0));
	     
end component;

signal iCLK, reset		: std_logic	:= '0';
signal s_I			: std_logic_vector(31 downto 0);
signal s_S			: std_logic_vector(4 downto 0);
signal s_A			: std_logic;
signal s_L			: std_logic;
signal s_O			: std_logic_vector(31 downto 0);

begin DUT0: barrel_shifter
		port map(
				i_clk			=> iCLK,
				i_I			=> s_I,
				i_S			=> s_S,
				i_A 			=> s_A,
				i_L			=> s_L,
				o_O			=> s_O);
				

  P_CLK: process
  begin
    iCLK <= '1';
    wait for gCLK_HPER;
    iCLK <= '0'; 
    wait for gCLK_HPER; 
  end process;

  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;
  
  -- Assign inputs for each test case.
  P_TEST_CASES: process
  begin
  wait for gCLK_HPER/2;
	
  --Test Case 1:
  --Input: 00100100001000010100000000001010, logical shift right 5. (srl by 1)  
  s_I	<= "00100100001000010100000000001010";
  s_S	<= "00101";
  s_A	<= '0';
  s_L	<= '0';
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  --expect s_Output to be "00000001001000010000101000000000"
  
  --Test Case 2:
  --Input: 00100100001000010100000000001010, logical shift left 5. (sll by 5)
  s_I	<= "00100100001000010100000000001010";
  s_S	<= "00101";
  s_A	<= '0';
  s_L	<= '1';
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  --expect s_Output to be "10000100001010000000000101000000"
  
    --Test Case 3:
  --Input: 00100100001000010100001001001011, logical shift right 5. (sra by 5)
  s_I	<= "00100100001000010100001001001011";
  s_S	<= "00101";
  s_A	<= '1';
  s_L	<= '0';
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  --expect s_Output to be "10000100001010000100100101100000"
  
  end process;
end structure;