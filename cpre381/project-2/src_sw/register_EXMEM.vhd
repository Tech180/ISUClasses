library IEEE;
use IEEE.std_logic_1164.all;

entity register_EXMEM is
   generic(N: integer := 32);
   port(clock       			: in std_logic;
        i_rst        			: in std_logic;
        i_we         			: in std_logic;
        upperImmediate          : in std_logic;
        sltu                    : in std_logic;
        jal                     : in std_logic;
        memToReg                : in std_logic;
        regWrite                : in std_logic;
        memWrite                : in std_logic;
        ALUout			        : in std_logic_vector(N-1 downto 0);
        ALU	     			    : in std_logic_vector(N-1 downto 0);
        i_writeaddr			    : in std_logic_vector(4 downto 0);
        sltu1	                : in std_logic_vector(N-1 downto 0);
        upperImmediate1	        : in std_logic_vector(N-1 downto 0);
        PC	                : in std_logic_vector(N-1 downto 0);
        D0	                    : in std_logic_vector(N-1 downto 0);
        inst	                : in std_logic_vector(N-1 downto 0);

        o_upperImmediate             : out std_logic;
        o_sltu                  : out std_logic;
        o_jal                   : out std_logic;
        o_memToReg              : out std_logic;
        o_RegWrite              : out std_logic;
        o_MemWrite              : out std_logic;
        o_ALUout        		: out std_logic_vector(N-1 downto 0);
        o_ALU	     			: out std_logic_vector(N-1 downto 0);
        o_writeaddr			    : out std_logic_vector(4 downto 0);
        o_sltu1	                : out std_logic_vector(N-1 downto 0);
        o_upperImmediate1	    : out std_logic_vector(N-1 downto 0);
        o_PC	                : out std_logic_vector(N-1 downto 0);
        o_D0	                : out std_logic_vector(N-1 downto 0);
        o_inst	                : out std_logic_vector(N-1 downto 0));

end register_EXMEM;

architecture structural of register_EXMEM is

component register32bit
generic(N: integer := 32);
   port(clock        : in std_logic;
        i_rst        : in std_logic;
        i_we         : in std_logic;
        data         : in std_logic_vector(N-1 downto 0);
        o_O          : out std_logic_vector(N-1 downto 0));
end component;

component dffg
   port(i_CLK        : in std_logic;     -- Clock input
        i_RST        : in std_logic;     -- Reset input
        i_WE         : in std_logic;     -- Write enable input
        i_D          : in std_logic;     -- Data value input
        o_Q          : out std_logic);   -- Data sssssvalue output
end component;

begin

generic_ALUout : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => ALUout,
             o_O => o_ALUout);

generic_inst_register : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => inst,
             o_O => o_inst);

generic_D0 : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => D0,
             o_O => o_D0);

generic_ALU : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => ALU,
             o_O => o_ALU);

generic_writeaddr : register32bit
    generic map(N => 5)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => i_writeaddr,
             o_O => o_writeaddr);

generic_sltu1 : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => sltu1,
             o_O => o_sltu1);

generic_upperImmediate1 : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => upperImmediate1,
             o_O => o_upperImmediate1);

generic_upperImmediate : dffg
   port MAP(i_CLK => clock,
            i_RST => i_rst,
            i_WE => i_we,
            i_D => upperImmediate,
            o_Q => o_upperImmediate);

generic_sltu : dffg
   port MAP(i_CLK => clock,
            i_RST => i_rst,
            i_WE => i_we,
            i_D => sltu,
            o_Q => o_sltu);

generic_jal : dffg
   port MAP(i_CLK => clock,
            i_RST => i_rst,
            i_WE => i_we,
            i_D => jal,
            o_Q => o_jal);

memToReg1 : dffg
    port MAP(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => memToReg,
             o_Q => o_memToReg);

generic_register_Write : dffg
    port MAP(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => regWrite,
             o_Q => o_RegWrite);

generic_memory_Write : dffg
    port MAP(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => memWrite,
             o_Q => o_MemWrite);

generic_PC : register32bit
    generic map(N => 32)
    port map(clock => clock,
	     i_rst => i_rst,
	     i_we => i_we,
	     data => PC,
	     o_O => o_PC);

end structural;
