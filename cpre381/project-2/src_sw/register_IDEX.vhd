library IEEE;
use IEEE.std_logic_1164.all;

entity register_IDEX is
   generic(N: integer := 32);
   port(clock       			: in std_logic;
        i_rst        			: in std_logic;
        i_we         			: in std_logic;
        upperImmediate          : in std_logic;
        regdst                  : in std_logic;
        sltu                  : in std_logic;
        jal                   : in std_logic;
        memtoreg                : in std_logic;
        regWrite                : in std_logic;
        memWrite                : in std_logic;
        ALUSrc                  : in std_logic;
        sl                    : in std_logic; --shift left
        sr                    : in std_logic; --shift right
        ALUControl              : in std_logic;
        sv                      : in std_logic; --shift variable
        branch                  : in std_logic;
        jr                      : in std_logic;
        op			: in std_logic_vector(3 downto 0);
        writeaddr            	: in std_logic_vector(4 downto 0);
        rd                    	: in std_logic_vector(4 downto 0);
        rt                      : in std_logic_vector(4 downto 0);
        shamt	                : in std_logic_vector(4 downto 0);
        rt1           			: in std_logic_vector(N-1 downto 0);
        rd1  			        : in std_logic_vector(N-1 downto 0);
        immediateExtend        : in std_logic_vector(N-1 downto 0);
        PC			        : in std_logic_vector(N-1 downto 0);
        D0			        : in std_logic_vector(N-1 downto 0);
        inst			        : in std_logic_vector(N-1 downto 0);

        o_upperImmediate        : out std_logic;
        o_RegDst                : out std_logic;
        o_sltu                  : out std_logic;
        o_jal                   : out std_logic;
        o_MemtoReg              : out std_logic;
        o_RegWrite              : out std_logic;
        o_MemWrite              : out std_logic;
        o_ALUSrc                : out std_logic;
        o_sl                    : out std_logic;
        o_sr                    : out std_logic;
        o_ALUControl            : out std_logic;
        o_sv                    : out std_logic;
        o_branch                : out std_logic;
        o_jr                    : out std_logic;
        o_op				    : out std_logic_vector(3 downto 0);
        o_writeaddr	            : out std_logic_vector(4 downto 0);
        o_rd	                : out std_logic_vector(4 downto 0);
        o_rt	                : out std_logic_vector(4 downto 0);
        o_shamt	                : out std_logic_vector(4 downto 0);
        o_rt1			        : out std_logic_vector(N-1 downto 0);
        o_rd1			        : out std_logic_vector(N-1 downto 0);
        o_immediateExtend			    : out std_logic_vector(N-1 downto 0);
        o_PC		            : out std_logic_vector(N-1 downto 0);
        o_D0			        : out std_logic_vector(N-1 downto 0);
        o_inst			        : out std_logic_vector(N-1 downto 0));
end register_IDEX;

architecture structural of register_IDEX is

component register32bit
generic(N: integer := 32);
   port(clock                   : in std_logic;
        i_rst                   : in std_logic;
        i_we                    : in std_logic;
        data                    : in std_logic_vector(N-1 downto 0);
        o_O                     : out std_logic_vector(N-1 downto 0));
end component;

component dffg
   port(i_CLK        : in std_logic;     -- Clock input
        i_RST        : in std_logic;     -- Reset input
        i_WE         : in std_logic;     -- Write enable input
        i_D          : in std_logic;     -- Data value input
        o_Q          : out std_logic);   -- Data value output
end component;

begin

generic_wrAddr : register32bit
    generic map(N => 5)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => writeaddr,
             o_O => o_writeaddr);

generic_inst : register32bit
    generic map(N => 32)
    port map(clock => clock,
            i_rst => i_rst,
            i_we => i_we,
            data => inst,
            o_O => o_inst);

generic_32bitregister: register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => D0,
             o_O => o_D0);

generic_rd : register32bit
    generic map(N => 5)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => rd,
             o_O => o_rd);

generic_rt : register32bit
    generic map(N => 5)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => rt,
             o_O => o_rt);

generic_shamt : register32bit
    generic map(N => 5)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => shamt,
             o_O => o_shamt);

generic_rtD : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => rt1,
             o_O => o_rt1);

generic_rd1 : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => rd1,
             o_O => o_rd1);

generic_immediateExtend : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => immediateExtend,
             o_O => o_immediateExtend);

generic_op : register32bit
    generic map(N => 4)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => op,
             o_O => o_op);

generic_upperImmediate : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => upperImmediate,
             o_Q => o_upperImmediate);

generic_sltu : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => sltu,
             o_Q => o_sltu);

generic_jal : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => jal,
             o_Q => o_jal);

generic_memtoReg : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => memtoreg,
             o_Q => o_MemtoReg);

generic_register_Write : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => regwrite,
             o_Q => o_RegWrite);

generic_memory_Write : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => memWrite,
             o_Q => o_memWrite);

generic_ALUSrc : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => ALUSrc,
             o_Q => o_ALUSrc);

generic_sl : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => sl,
             o_Q => o_sl);

generic_sr : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => sr,
             o_Q => o_sr);

generic_ALUControl : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => ALUControl,
             o_Q => o_ALUControl);

generic_shiftvariable : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => sv,
             o_Q => o_sv);

generic_register_Dst : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => regdst,
             o_Q => o_RegDst);

generic_branch : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => branch,
             o_Q => o_branch);

generic_jump_and_register : dffg
    port map(i_CLK => clock,
             i_RST => i_rst,
             i_WE => i_we,
             i_D => jr,
             o_Q => o_jr);
generic_PC : register32bit
    generic map(N => 32)
    port map(clock => clock,
             i_rst => i_rst,
             i_we => i_we,
             data => PC,
             o_O => o_PC);

end structural;
