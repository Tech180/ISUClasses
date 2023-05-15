-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  signal s_reg0         : std_logic_vector(31 downto 0);
  signal s_Ext32        : std_logic_vector(31 downto 0);
  signal s_reg1         : std_logic_vector(31 downto 0);
  signal s_NextPC       : std_logic_vector(31 downto 0);
  signal s_jAddress     : std_logic_vector(31 downto 0);
  signal s_PCAddr       : std_logic_vector(31 downto 0);
  signal s_ALU1         : std_logic_vector(31 downto 0); --Q1
  signal s_O            : std_logic_vector(31 downto 0); --ALU Output
  signal s_pc4          : std_logic_vector(31 downto 0);
  signal s_sl2_1        : std_logic_vector(31 downto 0);
  signal s_sl2_2        : std_logic_vector(31 downto 0);
  signal s_jadd         : std_logic_vector(31 downto 0);
  signal s_branchtomux  : std_logic_vector(31 downto 0);
  signal s_jtoMux       : std_logic_vector(31 downto 0);
  signal s_D0         : std_logic_vector(31 downto 0); --normies
  signal s_jaltoMux     : std_logic_vector(4 downto 0);
  signal s_regDst       : std_logic;

  signal s_j            : std_logic; --jump
  signal s_bne          : std_logic;
  signal s_beq          : std_logic;
  signal s_memToReg     : std_logic;

  signal op_Code        : std_logic_vector(5 downto 0);
  signal funct	        : std_logic_vector(5 downto 0);

  signal s_ALUSrc       : std_logic;
  signal s_Signed       : std_logic;
  signal s_no           : std_logic;
  signal s_AND          : std_logic;
  signal s_jr           : std_logic;
  signal s_jal          : std_logic;
  signal s_sv           : std_logic;
  signal s_ui           : std_logic;
  signal s_ALUControl   : std_logic_vector(3 downto 0);
  signal s_sltu         : std_logic;
  signal s_branch       : std_logic;
  signal s_Overflow     : std_logic;
  signal s_Zero         : std_logic;
  signal s_jalmux       : std_logic_vector(31 downto 0);


  component controlUnit is
  port(op_Code	    		: in std_logic_vector(5 downto 0);
	Funct		    	: in std_logic_vector(5 downto 0);
	RegDst		    	: out std_logic;
	MemtoReg 	   	: out std_logic;
	MemWrite 	    	: out std_logic;
	ALUSrc 		   	: out std_logic;
	RegWrite 	   	: out std_logic;
	ALUControl	    	: out std_logic_vector(3 downto 0);
	beq 		    	: out std_logic;
 	bne 		    	: out std_logic;
	j  		        : out std_logic;
	jr 		        : out std_logic;
	sltu            	: out std_logic;
	shiftVariable   	: out std_logic;
	upper_immediate 	: out std_logic;
	halt                    : out std_logic);
  end component;
  
  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component mux_32bit_dataflow is
	generic(N 	: integer := 32);
	port(i_D0 	: in std_logic_vector(N-1 downto 0);
       	     i_D1 	: in std_logic_vector(N-1 downto 0);
             i_S 	: in std_logic;
             o_O 	: out std_logic_vector(N-1 downto 0));
  end component;

component barrel_shifter is
	port(i_clk		: in std_logic;
	     i_I		: in std_logic_vector(31 downto 0);
	     i_S		: in std_logic_vector (4 downto 0);
	     i_A		: in std_logic;		-- 0 == logical and 1 == arithmetic
	     i_L		: in std_logic;		-- 0 == right and 1 == left
	     o_O		: out std_logic_vector(31 downto 0));
end component;

component Register_File is
  port(i_CLK	    : in std_logic;
       i_RST	    : in std_logic;
       r_1	    : in std_logic_vector(4 downto 0);
       r_2	    : in std_logic_vector(4 downto 0);
       i_w	    : in std_logic_vector(4 downto 0);
       WE           : in std_logic;
       i_Data         : in std_logic_vector(N-1 downto 0);
       o_r_1         : out std_logic_vector(N-1 downto 0);
       o_r_2         : out std_logic_vector(N-1 downto 0));
end component;

component Fulladder_N is 
  port(i_fA         : in std_logic_vector(N-1 downto 0);
       i_fB         : in std_logic_vector(N-1 downto 0);
       i_fC         : in std_logic;
       o_Cry        : out std_logic;
       o_Sum        : out std_logic_vector(N-1 downto 0));

end component;

component ALU_32bit is
   port(i_D0		        : in std_logic_vector(31 downto 0);
        i_D1                	: in std_logic_vector(31 downto 0);
        i_D2                	: in std_logic_vector(3 downto 0); --op
        i_D3                    : in std_logic_vector(4 downto 0); --shamt
        i_Overflow              : in std_logic;
        o_O                 	: out std_logic_vector(31 downto 0); --out
        o_Overflow          	: out std_logic; --overflow
        o_zero                 	: out std_logic); --zero
end component;

component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;

component extender_N is

  port(i_D : in std_logic_vector(15 downto 0);
       i_S : in std_logic;
       o_O : out std_logic_vector(N-1 downto 0)
  );

end component;

component programCounter is
port(i_RST       : in std_logic;
     i_CLK	 : in std_logic; --clock
     i_addr	 : in std_logic_vector(31 downto 0); --next instruction
     o_instr	 : out std_logic_vector(31 downto 0));--gets next instruction if anothaOne = 1 and rising edge of clock
end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment


begin

    op_Code		   <= s_Inst (31 downto 26);
	Funct	       <= s_Inst (5 downto 0);



  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


    IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
    DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

    generic_controlUnit: controlUnit
    port map(RegDst             => s_RegDst,
             j                  => s_j,
             beq                => s_beq,
             bne                => s_bne,
             MemtoReg           => s_memtoReg,
             op_Code            => op_Code,
             MemWrite           => s_DMemWr,
             ALUSrc             => s_ALUSrc,
             RegWrite           => s_RegWr,
             ALUControl         => s_ALUControl,
             halt               => s_Halt,
             jr                 => s_jr,
             shiftVariable      => s_sv,
             upper_immediate    => s_ui,
             Funct              => Funct,
             sltu               => s_sltu);

    generic_jumpandregister_mux_32bit : mux_32bit_dataflow
        port map (i_D0  => s_jtoMux,
                  i_D1  => s_reg0,
                  i_S   => s_jr,
                  o_O   => s_NextPC);

    generic_PC: programCounter
        port map(i_RST       => iRST,--reset
                 i_CLK       => iCLK,--clock
                 i_addr      => s_nextPC,
                 o_instr     => s_NextInstAddr
    );


    generic_fullAdder : Fulladder_N
        port map (i_fA          => s_NextInstAddr,
                  i_fB          => x"00000004",
                  i_fC          => '0',
                  o_Cry         => open,
                  o_Sum         => s_pc4);

                  
s_sl2_1        <= s_pc4(31 downto 28) & s_Inst(25 downto 0) & "00";
s_sl2_2        <= s_Ext32(29 downto 0) & "00";
  
    generic_branch_adding_fullAdder : Fulladder_N
        port map (i_fA          => s_pc4,
                  i_fB          => s_sl2_2,
                  i_fC          => '0',
                  o_Cry         => open,
                  o_Sum         => s_jadd);

    generic_branch_AND : andg2
        port map (i_A           => s_branch,
                  i_B           => s_no,
                  o_F           => s_AND);

    generic_PCbranch_32bit_mux : mux_32bit_dataflow
        port map(i_D0           => s_pc4,
                 i_D1           => s_jadd,
                 i_S            => s_AND,
                 o_O            => s_branchtomux);

    generic_branch_to_mux_32bit_dataflow: mux_32bit_dataflow
        port map(i_D0           => s_branchtomux,
                 i_D1           => s_sl2_1,
                 i_S            => s_j,
                 o_O            => s_jtoMux);
                 
    generic_signedextend : extender_N
    port map(i_D => s_Inst(15 downto 0),
             i_S  => s_Signed,
             o_O => s_Ext32
    );


    generic_jaldatamux: mux_32bit_dataflow
    port map(i_D0 => s_D0,
             i_D1 => s_pc4,
             i_S  => s_jal,
             o_O  => s_RegWrData
    );
    
    generic_jaladdrmux: mux_32bit_dataflow
    generic map(N => 5)
    port map(i_D0 => s_Inst(15 downto 11),
             i_D1 => "11111",
             i_S  => s_jal,
             o_O  => s_jaltoMux
    );
    
    generic_register_32bit_mux : mux_32bit_dataflow
    generic map(N => 5)
    port map(i_D0 => s_Inst(20 downto 16),
             i_D1 => s_jaltoMux,
             i_S  => s_RegDst,
             o_O  => s_RegWrAddr
    );
    

    generic_register_file : Register_File
    port map(i_CLK      => iCLK,
             i_RST      => iRST,
             r_1         => s_Inst(25 downto 21),
             r_2         => s_Inst(20 downto 16),
             i_w         => s_RegWrAddr,
             WE         => s_RegWr,
             i_data       => s_RegWrData,
             o_r_1       => s_reg0,     --alu1
             o_r_2       => s_DMemData); --alu2
                  

    generic_32bit_ALU_and_mux_32bit: mux_32bit_dataflow
    generic map(N => 32)
    port map(i_D0 => s_DMemData,
             i_D1 => s_Ext32,
             i_S  => s_ALUSrc,
             o_O  => s_ALU1);

    generic_32bit_ALU : ALU_32bit
    port map(i_D0           => s_reg0,
             i_D1           => s_ALU1,
             i_D3           => s_Inst(10 downto 6),
             i_D2           => s_ALUControl,
             i_Overflow     => s_Overflow,

             o_O            => s_DMemAddr,
             o_Overflow     => s_Overflow,
             o_zero         => s_Zero);
    oALUOut <= s_DMemAddr;

    generic_memory_output : mux_32bit_dataflow
    generic map(N => 32)
    port map(i_D0 => s_DMemAddr,
             i_D1 => s_DMemOut,
             i_S  => s_MemToReg,
             o_O  => s_D0);


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;

