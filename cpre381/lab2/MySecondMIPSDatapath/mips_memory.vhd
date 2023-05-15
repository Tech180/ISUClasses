-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mips_memory is

     port(i_rd		: in std_logic_vector(4 downto 0);
          i_rt		: in std_logic_vector(4 downto 0);
     	  i_rw		: in std_logic_vector(4 downto 0);
     	  op	        : in std_logic;
     	  i_ALUSrc	: in std_logic;
     	  reg_we	: in std_logic;
     	  mem_we	: in std_logic;
     	  regSel	: in std_logic;
     	  i_CLK	        : in std_logic;
     	  i_signed	: in std_logic;
     	  imm		: in std_logic_vector(15 downto 0);
     	  i_reg		: in std_logic);
end mips_memory;

architecture structural of mips_memory is

component register_file
     port(i_CLK	        : in std_logic;
          i_RST	        : in std_logic;
          rt	        : in std_logic_vector(4 downto 0);
          rd	     	: in std_logic_vector(4 downto 0);
          rw	     	: in std_logic_vector(4 downto 0);
          we         	: in std_logic;
          data       	: in std_logic_vector(31 downto 0); --data value
          o_rt       	: out std_logic_vector(31 downto 0);
          o_rd       	: out std_logic_vector(31 downto 0));
end component;

component AdderSubtractor
     port(i_D0       	: in std_logic_vector(31 downto 0);
          i_D1       	: in std_logic_vector(31 downto 0); --register
          imm		: in std_logic_vector(31 downto 0);
          i_D2       	: in std_logic;
          --i_Sel      	: in std_logic;                       --select
          ALUSrc     	: in std_logic;
          o_S         	: out std_logic_vector(31 downto 0); --sum
          o_D           : out std_logic);
end component;

component extension16to32
     port(i_D0		: in std_logic_vector(15 downto 0);
          i_signed	: in std_logic;
          o_O		: out std_logic_vector(31 downto 0));
end component;

component mux2t1_N
    generic(N : integer := 32);
    port(i_D0     	: in std_logic_vector(N-1 downto 0);
         i_D1		: in std_logic_vector(N-1 downto 0);
         i_S		: in std_logic;
         o_O		: out std_logic_vector(N-1 downto 0));
end component;

component mem
  generic(DATA_WIDTH : natural := 32;
	  ADDR_WIDTH : natural := 10);
    port(clk		: in std_logic;
         addr	     	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
         data	     	: in std_logic_vector((DATA_WIDTH-1) downto 0);
         we		: in std_logic := '1';
         q		: out std_logic_vector((DATA_WIDTH-1) downto 0));
    end component;

signal s_rd	         : std_logic_vector(31 downto 0);
signal s_rt	         : std_logic_vector(31 downto 0);
signal s_ext_imm	 : std_logic_vector(31 downto 0); --extended immediate
signal s_A	         : std_logic_vector(31 downto 0); --ALU output
signal s_mO	         : std_logic_vector(31 downto 0); --memory out signal
signal s_wr	         : std_logic_vector(31 downto 0); --write
signal s_O		 : std_logic;

begin

generic_register_file : register_file
     port map(i_CLK     => i_CLK,
              data      => s_wr,
              rw        => i_rw,
              rt        => i_rt,
              rd        => i_rd,
              we      => reg_we,
              i_RST     => i_reg,
              o_rd      => s_rd,
              o_rt      => s_rt);

generic_AdderSubtractor : AdderSubtractor
     port map(i_D0 	=> s_rd,
              i_D1 	=> s_rt,
              imm	=> s_ext_imm,
              ALUSrc 	=> i_ALUSrc,
              i_D2 	=> op,
              o_S 	=> s_A,
              o_D 	=> s_O);

generic_16to23bit_extender : extension16to32
     port map(i_D0 	=> imm,
	      i_signed 	=> i_Signed,
              o_O 	=> s_ext_imm);

generic_32bit_mux : mux2t1_N
     port map(i_D0 	=> s_A,
              i_D1 	=> s_mO,
              i_S 	=> regSel,
              o_O 	=> s_wr);

generic_memory : mem
      port map(clk 	=> i_CLK,
	       addr 	=> s_A(11 downto 2),
	       data 	=> s_rt,
	       we 	=> mem_we,
	       q 	=> s_mO);

end structural;
