-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mips is

   generic(helper	: time := 50 ns);

end tb_mips;

architecture behavioral of tb_mips is

--clock period
constant clock	: time := helper * 2;

component mips_memory

port(i_rd				: in std_logic_vector(4 downto 0);
     i_rt				: in std_logic_vector(4 downto 0);
     i_rw				: in std_logic_vector(4 downto 0);
     op	                : in std_logic;
     i_ALUSrc	        : in std_logic;
     reg_we	            : in std_logic;
     mem_we	            : in std_logic;
     regSel	            : in std_logic;
     i_CLK	            : in std_logic;
     i_signed	        : in std_logic;
     imm				: in std_logic_vector(15 downto 0);
     i_reg				: in std_logic_vector(31 downto 0));


end component;

signal s_rd				: std_logic_vector(4 downto 0);
signal s_rt				: std_logic_vector(4 downto 0);
signal s_rw				: std_logic_vector(4 downto 0);
signal s_op	            : std_logic;
signal s_signed	        : std_logic;
signal s_reg_we	        : std_logic;
signal s_mem_we	        : std_logic;
signal s_regSel	        : std_logic;
signal s_CLK	        : std_logic;
signal s_sign	        : std_logic;
signal s_imm		    : std_logic_vector(15 downto 0);
signal s_reg		    : std_logic_vector(31 downto 0);


begin

generic_mips_processor : mips_memory
    port map(i_rd => s_rd,
             i_rt => s_rt,
             i_rw => s_rw,
             op => s_op,
             i_ALUSrc => s_ALUSrc,
             reg_we => s_reg_we,
             mem_we => s_mem_we,
             regSel => s_regSel,
             i_CLK => s_CLK,
             i_signed => s_signed,
             i_reg => s_reg,
             imm => s_imm);

  generic_clock: process
  begin
    s_CLK <= '0';
    wait for helper;
    s_CLK <= '1';
    wait for helper;
  end process;

  P_TB: process
  begin

    --Set up/Reset
    s_rd        <= "00000";
    s_rt        <= "00000";
    s_wr        <= "00000";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '0';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '0';
    s_imm       <= x"0000";
    s_reg   <= x"11111111"; --reset bit
    wait for clock;

    --Instructions
    --addi $25, $0, 0
    s_rd        <= "00000";
    s_rt        <= "00000";
    s_wr        <= "11001";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0000";
    s_reg   <= x"00000000"; --set bits
    wait for clock;

    --addi $26, $0, 256
    s_rd        <= "00000";
    s_rt        <= "00000";
    s_wr        <= "11010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --lw $1, 0($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0000";
    wait for clock;

    --lw $2, 4($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0004";
    wait for clock;

    --add $1, $1, $2
    s_rd        <= "00001";
    s_rt        <= "00010";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --sw $1, 0($26)
    s_rd        <= "11010";
    s_rt        <= "00001";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '0';
    s_mem_we    <= '1';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0000";
    wait for clock;

    --lw $2, 8($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0008";
    wait for clock;

    --add $1, $1, $2
    s_rd        <= "00001";
    s_rt        <= "00010";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --sw $1, 4($26)
    s_rd        <= "11010";
    s_rt        <= "00001";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '0';
    s_mem_we    <= '1';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0004";
    wait for clock;

    --lw $2, 12($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"000C";
    wait for clock;

    --add $1, $1, $2
    s_rd        <= "00001";
    s_rt        <= "00010";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --sw $1, 8($26)
    s_rd        <= "11010";
    s_rt        <= "00001";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '0';
    s_mem_we    <= '1';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0008";
    wait for clock;

    --lw $2, 16($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0010";
    wait for clock;

    --add $1, $1, $2
    s_rd        <= "00001";
    s_rt        <= "00010";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --sw $1, 12($26)
    s_rd        <= "11010";
    s_rt        <= "00001";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '0';
    s_mem_we    <= '1';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"000C";
    wait for clock;

    --lw $2, 20($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0014";
    wait for clock;

    --add $1, $1, $2
    s_rd        <= "00001";
    s_rt        <= "00010";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --sw $1, 16($26)
    s_rd        <= "11010";
    s_rt        <= "00001";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '0';
    s_mem_we    <= '1';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0010";
    wait for clock;

    --lw $2, 24($25)
    s_rd        <= "11001";
    s_rt        <= "00000";
    s_wr        <= "00010";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0018";
    wait for clock;

    --add $1, $1, $2
    s_rd        <= "00001";
    s_rt        <= "00010";
    s_wr        <= "00001";
    op          <= '0';
    s_ALUSrc    <= '0';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0100";
    wait for clock;

    --addi $27, $0, 512
    s_rd        <= "00000";
    s_rt        <= "00000";
    s_wr        <= "11011";
    op          <= '0';
    s_ALUSrc    <= '1';
    s_reg_we    <= '1';
    s_mem_we    <= '0';
    s_regSel    <= '0';
    s_signed    <= '1';
    s_imm       <= x"0200";
    wait for clock;

    --sw $1, -4($27)
    s_rd        <= "11011";
    s_rt        <= "00001";
    s_wr        <= "00010";
    op          <= '1';
    s_ALUSrc    <= '1';
    s_reg_we    <= '0';
    s_mem_we    <= '1';
    s_regSel    <= '1';
    s_signed    <= '1';
    s_imm       <= x"0004";
    wait for clock;

    wait;
  end process;

end behavioral;
