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
        i_PC	                : in std_logic_vector(N-1 downto 0);
        D0	                    : in std_logic_vector(N-1 downto 0);
        inst	                : in std_logic_vector(N-1 downto 0);

        o_upper_imm             : out std_logic;
        o_sltu                  : out std_logic;
        o_jal                   : out std_logic;
        o_memToReg              : out std_logic;
        o_RegWrite              : out std_logic;
        o_MemWrite              : out std_logic;
        o_ALUout        		: out std_logic_vector(N-1 downto 0);
        o_ALU	     			: out std_logic_vector(N-1 downto 0);
        o_writeaddr			    : out std_logic_vector(4 downto 0);
        o_sltuD	                : out std_logic_vector(N-1 downto 0);
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
   port(clock        : in std_logic;
        i_rst        : in std_logic;
        i_we         : in std_logic;
        data         : in std_logic;
        o_O          : out std_logic);
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
             o_O => o_sltuD);

generic_upperImmediate1 : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => upperImmediate1,
             o_O => o_upperImmediate1);

generic_upperImmediate : dffg
   port MAP(clock => clock,
            i_rst => i_rst,
            i_we => i_we,
            data => upperImmediate,
            o_O => o_upper_imm);

generic_sltu : dffg
   port MAP(clock => clock,
            i_rst => i_rst,
            i_we => i_we,
            data => sltu,
            o_O => o_sltu);

generic_jal : dffg
   port MAP(clock => clock,
            i_rst => i_rst,
            i_we => i_we,
            data => jal,
            o_O => o_jal);

memToReg : dffg
    port MAP(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => memToReg,
             o_O => o_memToReg);

generic_register_Write : dffg
    port MAP(clock => clock,
            i_rst => i_rst,
            i_we => i_we,
            data => regWrite,
            o_O => o_RegWrite);

generic_memory_Write : dffg
    port MAP(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => memWrite,
             o_O => o_MemWrite);

generic_PC : register32bit
    generic map(N => 32)
    port map(clock => clock,
	     i_rst => i_rst,
	     i_we => i_we,
	     data => i_PC,
	     o_O => o_PC);

end structural;
