library IEEE;
use IEEE.std_logic_1164.all;

entity tb_programCounter is
generic(gCLK_HPER	: time	:= 10 ns);
end entity;


architecture structure of tb_programCounter is

constant cCLK_PER : time := gCLK_HPER * 2;

component programCounter is
port(i_RST       : in std_logic;--reset
     i_CLK	 : in std_logic; --clock
     i_addr	 : in std_logic_vector(31 downto 0);
     o_instr	 : out std_logic_vector(31 downto 0));
end component;

signal iCLK, reset		: std_logic;
signal s_addr			: std_logic_vector(31 downto 0);
signal s_instr			: std_logic_vector(31 downto 0);

begin DUT0: programCounter
	 port map(i_RST => reset,
              i_CLK => iCLK,
              i_addr => s_addr,
              o_instr => s_instr); 
              
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
  --reset, output:00400000
  reset <= '1';
  s_addr <= x"00000000";
    wait for gCLK_HPER;
    wait for gCLK_HPER;
  
  --Test Case 2:
  --update input = output:12341234
  
  reset <= '0';
  s_addr <= x"12341234";
    wait for gCLK_HPER/2;

  
  --Test Case 3:
  --no update(clk), input = 12341234 output:10101010  
   reset <= '0';
  s_addr <= x"12341234";
    wait for gCLK_HPER/2;

  
end process;
end architecture;