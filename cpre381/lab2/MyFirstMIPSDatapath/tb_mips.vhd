-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mips is

   generic(helper	: time := 50 ns);

end tb_mips;

architecture behavioral of tb_mips is

--clock period
constant clock	: time := helper * 2;

component mips

port(i_CLK			: in std_logic;
     i_rw	        : in std_logic_vector(4 downto 0);
     i_rd	        : in std_logic_vector(4 downto 0);
     i_rt	        : in std_logic_vector(4 downto 0);
     i_as	        : in std_logic;
     ALUSrc	        : in std_logic;
     i_we_re	    : in std_logic;
     imm			: in std_logic_vector(31 downto 0);
     o_O			: out std_logic); --output


end component;

signal s_rd				: std_logic_vector(4 downto 0);
signal s_rt				: std_logic_vector(4 downto 0);
signal s_rw				: std_logic_vector(4 downto 0);
signal s_op	            : std_logic;
signal s_regSel	        : std_logic;
signal s_CLK	        : std_logic;
signal s_sign	        : std_logic;
signal s_imm		    : std_logic_vector(15 downto 0);
signal s_reg		    : std_logic_vector(31 downto 0);


begin

generic_mips_processor : mips
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
    s_reg_RST   <= x"11111111";
    wait for clock;

    --Instructions
    --addi $1, $0, 1
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $2, $0, 2
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

    --addi $3, $0, 3
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $3, $0, 3
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $4, $0, 4
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $5, $0, 5
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $6, $0, 6
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $7, $0, 7
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $8, $0, 8
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $9, $0, 9
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --addi $10, $0, 10
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --add $11, $1, $2
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

    --sub $12, $11, $3
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

    --add $13, $12, $4
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

    --add $11, $1, $2
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

    --add $11, $1, $2
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

    --add $11, $1, $2
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

    --add $11, $1, $2
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

    --add $11, $1, $2
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

    --add $11, $1, $2
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

    --addi $10, $0, 10
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
    s_reg_RST   <= x"00000000";
    wait for clock;

    --add $11, $1, $2
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

    wait;
  end process;

end behavioral;
