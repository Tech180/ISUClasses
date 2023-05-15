-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--use work.register_array_type.all;

entity register_file is
  generic(N: integer := 32);
  port(i_CLK	    : in std_logic;
       i_RST	    : in std_logic;
       rt	    : in std_logic_vector(4 downto 0);
       rd	    : in std_logic_vector(4 downto 0);
       rw	    : in std_logic_vector(4 downto 0);
       we           : in std_logic;
       data         : in std_logic_vector(N-1 downto 0); --data value
       o_rt         : out std_logic_vector(N-1 downto 0);
       o_rd         : out std_logic_vector(N-1 downto 0));
end register_file;

architecture structural of register_file is

  component dffg_N
    generic(N: integer := 32);
      port(i_CLK            : in std_logic;     -- Clock input
           i_RST            : in std_logic;     -- Reset input
           i_WE             : in std_logic;     -- Write enable input
           i_D              : in std_logic_vector(N-1 downto 0);     -- Data value input
           o_Q              : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

  component decoder5to32_data
    port(i_D0               : in std_logic_vector(4 downto 0);
         o_O                : out std_logic_vector(31 downto 0));
  end component;

  component mux_32bit_data
    port(i_A	: in std_logic_vector(31 downto 0);   --bit 1
         i_B	: in std_logic_vector(31 downto 0);   --bit 2
         i_C	: in std_logic_vector(31 downto 0);   --bit 3
         i_D	: in std_logic_vector(31 downto 0);   --bit 4
         i_E	: in std_logic_vector(31 downto 0);   --bit 5
         i_F	: in std_logic_vector(31 downto 0);   --bit 6
         i_G	: in std_logic_vector(31 downto 0);   --bit 7
         i_H	: in std_logic_vector(31 downto 0);   --bit 8
         i_I	: in std_logic_vector(31 downto 0);   --bit 9
         i_J	: in std_logic_vector(31 downto 0);   --bit 10
         i_K	: in std_logic_vector(31 downto 0);   --bit 11
         i_L	: in std_logic_vector(31 downto 0);   --bit 12
         i_M	: in std_logic_vector(31 downto 0);   --bit 13
         i_N	: in std_logic_vector(31 downto 0);   --bit 14
         i_O	: in std_logic_vector(31 downto 0);   --bit 15
         i_P	: in std_logic_vector(31 downto 0);   --bit 16
         i_Q	: in std_logic_vector(31 downto 0);   --bit 17
         i_R	: in std_logic_vector(31 downto 0);   --bit 18
         i_S	: in std_logic_vector(31 downto 0);   --bit 19
         i_T	: in std_logic_vector(31 downto 0);   --bit 20
         i_U	: in std_logic_vector(31 downto 0);   --bit 21
         i_V	: in std_logic_vector(31 downto 0);   --bit 22
         i_W	: in std_logic_vector(31 downto 0);   --bit 23
         i_Y	: in std_logic_vector(31 downto 0);   --bit 24
         i_X	: in std_logic_vector(31 downto 0);   --bit 25
         i_Z	: in std_logic_vector(31 downto 0);   --bit 26
         i_AA	: in std_logic_vector(31 downto 0);   --bit 27
         i_BB	: in std_logic_vector(31 downto 0);   --bit 28
         i_CC	: in std_logic_vector(31 downto 0);   --bit 29
         i_DD	: in std_logic_vector(31 downto 0);   --bit 30
         i_EE	: in std_logic_vector(31 downto 0);   --bit 31
         i_FF	: in std_logic_vector(31 downto 0);   --bit 32
         i_SS	: in std_logic_vector(4 downto 0);
         o_Out	: out std_logic_vector(31 downto 0));
  end component;
  
  type rA is array (31 downto 0) of std_logic_vector(31 downto 0);

  signal s_rw         : std_logic_vector(31 downto 0);  
  signal we_rw        : std_logic_vector(31 downto 0);
  signal o_Q          : rA;

  begin

  generic_5to32_decoder_data: decoder5to32_data
    port map(i_D0 => rw,
             o_O  => s_rw);

  generic_32_bit_mux_dataflow: mux_32bit_data
   port map(o_Q(0),
            o_Q(1),
            o_Q(2),
            o_Q(3),
            o_Q(4),
            o_Q(5),
            o_Q(6),
            o_Q(7),
            o_Q(8),
            o_Q(9),
            o_Q(10),
            o_Q(11),
            o_Q(12),
            o_Q(13),
            o_Q(14),
            o_Q(15),
            o_Q(16),
            o_Q(17),
            o_Q(18),
            o_Q(19),
            o_Q(20),
            o_Q(21),
            o_Q(22),
            o_Q(23),
            o_Q(24),
            o_Q(25),
            o_Q(26),
            o_Q(27),
            o_Q(28),
            o_Q(29),
            o_Q(30),
            o_Q(31),
            rd,
            o_rd);

  generic_32_bit_mux_dataflow_1: mux_32bit_data
    port map(o_Q(0),
             o_Q(1),
             o_Q(2),
             o_Q(3),
             o_Q(4),
             o_Q(5),
             o_Q(6),
             o_Q(7),
             o_Q(8),
             o_Q(9),
             o_Q(10),
             o_Q(11),
             o_Q(12),
             o_Q(13),
             o_Q(14),
             o_Q(15),
             o_Q(16),
             o_Q(17),
             o_Q(18),
             o_Q(19),
             o_Q(20),
             o_Q(21),
             o_Q(22),
             o_Q(23),
             o_Q(24),
             o_Q(25),
             o_Q(26),
             o_Q(27),
             o_Q(28),
             o_Q(29),
             o_Q(30),
             o_Q(31),
             rt,
             o_rt);

  generic_d_flip_flop: dffg_N
    port map(i_CLK => i_CLK,
             i_RST => i_RST,
             i_WE => '0',
             i_D => data,
             o_Q => o_Q(0));

  M1: for i in 1 to 31 generate

    we_rw(i) <= we and s_rw(i);

    generic_d_flip_flop_1: dffg_N
    port map(i_CLK => i_CLK,
             i_RST => i_RST,
             i_WE => we_rw(i),
             i_D => data,
             o_Q => o_Q(i));
  end generate;

end structural;
