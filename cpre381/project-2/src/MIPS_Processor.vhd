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

  signal s_reg0                  : std_logic_vector(31 downto 0);
  signal s_Ext32                 : std_logic_vector(31 downto 0);
  signal s_reg1                  : std_logic_vector(31 downto 0);
  signal s_NextPC                : std_logic_vector(31 downto 0);
  signal s_jAddress              : std_logic_vector(31 downto 0);
  signal s_PCAddr                : std_logic_vector(31 downto 0);
  signal s_ALU1                  : std_logic_vector(31 downto 0); --Q1
  signal s_O                     : std_logic_vector(31 downto 0); --ALU Output
  signal s_pc4                   : std_logic_vector(31 downto 0);
  signal s_sl2_1                 : std_logic_vector(31 downto 0);
  signal s_sl2_2                 : std_logic_vector(31 downto 0);
  signal s_jadd                  : std_logic_vector(31 downto 0);
  signal s_branchtomux           : std_logic_vector(31 downto 0);
  signal s_jtoMux                : std_logic_vector(31 downto 0);
  signal s_D0                    : std_logic_vector(31 downto 0);
  signal s_jaltoMux              : std_logic_vector(4 downto 0);
  signal s_regDst                : std_logic;

  signal s_j                     : std_logic; --jump
  signal s_bne                   : std_logic;
  signal s_beq                   : std_logic;
  signal s_memToReg              : std_logic;

  signal op_Code                 : std_logic_vector(5 downto 0);
  signal funct	                 : std_logic_vector(5 downto 0);

  signal s_ALUSrc                : std_logic;
  signal s_Signed                : std_logic;
  signal sl			 : std_logic;
  signal sr			 : std_logic;
  signal s_no                    : std_logic;
  signal s_AND                   : std_logic;
  signal s_jr                    : std_logic;
  signal s_jal                   : std_logic;
  signal s_sv                    : std_logic;
  signal s_ui                    : std_logic; --upperImmediate
  --signal s_ALUControl            : std_logic_vector(3 downto 0);
  signal s_ALUControl 		 : std_logic;
  signal s_sltu                  : std_logic;
  signal s_branch                : std_logic;
  signal s_Overflow              : std_logic;
  signal s_Zero                  : std_logic;
  signal s_jalmux                : std_logic_vector(31 downto 0);




  signal s_ALUSrc1	             : std_logic_vector(31 downto 0);
  signal s_immediateExtend	     : std_logic_vector(31 downto 0);
  signal s_rt	                 : std_logic_vector(31 downto 0);
  signal s_rd	                 : std_logic_vector(31 downto 0);
  signal s_ALUOut	             : std_logic_vector(31 downto 0);
  signal s_upper_immediate1	     : std_logic_vector(31 downto 0);
  signal s_j_addresses_to_top	 : std_logic_vector(31 downto 0);
  signal s_O_PC	                 : std_logic_vector(31 downto 0);
  signal s_memToReg1	         : std_logic_vector(31 downto 0);
  signal s_upper_immediate_mux1	 : std_logic_vector(31 downto 0);
  signal s_sltu1	             : std_logic_vector(31 downto 0);
  signal s_j_address	         : std_logic_vector(31 downto 0);
  signal s_jumpandregister_mux1	 : std_logic_vector(31 downto 0);
  signal s_jump_mux1	         : std_logic_vector(31 downto 0);
  signal s_sltu_mux1	         : std_logic_vector(31 downto 0);
  signal s_branch_mux1	         : std_logic_vector(31 downto 0);
  signal s_O_branch	             : std_logic_vector(31 downto 0);
  signal s_immediateShiftLeft	 : std_logic_vector(31 downto 0);
  signal s_forward_data	         : std_logic_vector(31 downto 0);


  signal s_PC_IFID		         : std_logic_vector(31 downto 0);
  signal s_inst_IFID		     : std_logic_vector(31 downto 0);
  signal s_rt1_IDEX		         : std_logic_vector(31 downto 0);
  signal s_rd1_IDEX		         : std_logic_vector(31 downto 0);
  signal s_immediateExtend_IDEX  : std_logic_vector(31 downto 0);
  signal s_PC_IDEX		         : std_logic_vector(31 downto 0);
  signal s_sltu1_EXMEM		     : std_logic_vector(31 downto 0);
  signal s_upper_immediate1_EXMEM: std_logic_vector(31 downto 0);
  signal s_PC_EXMEM		         : std_logic_vector(31 downto 0);
  signal s_O_Dmem_MEMWB		     : std_logic_vector(31 downto 0);
  signal s_ALUOut_MEMWB		     : std_logic_vector(31 downto 0);
  signal s_upper_immediate1_MEMWB: std_logic_vector(31 downto 0);
  signal s_sltu1_MEMWB		     : std_logic_vector(31 downto 0);
  signal s_PC_MEMWB		         : std_logic_vector(31 downto 0);
  signal s_ALU_1_1		         : std_logic_vector(31 downto 0);
  signal s_ALU_2_1		         : std_logic_vector(31 downto 0);
  signal s_forwardingExtend_data : std_logic_vector(31 downto 0);

  signal s_D0_IFID	             : std_logic_vector(31 downto 0);
  signal s_D0_IDEX	             : std_logic_vector(31 downto 0);
  signal s_D0_EXMEM	             : std_logic_vector(31 downto 0);
  signal s_PC_mux1	             : std_logic_vector(31 downto 0);
  signal s_inst_IDEX	         : std_logic_vector(31 downto 0);
  signal s_inst_EXMEM	         : std_logic_vector(31 downto 0);
  signal s_inst1	             : std_logic_vector(31 downto 0);
  signal s_rt1	                 : std_logic_vector(31 downto 0);
  signal s_rd1	                 : std_logic_vector(31 downto 0);

  signal s_j_temp		         : std_logic_vector(31 downto 0);
  signal s_j_address_bottom	     : std_logic_vector(31 downto 0);

  signal s_shift		         : std_logic_vector(4 downto 0);
  signal s_regdst_mux1		     : std_logic_vector(4 downto 0);
  signal s_regdst_mux1_EXMEM	 : std_logic_vector(4 downto 0);
  signal s_rt_IDEX			     : std_logic_vector(4 downto 0);
  signal s_rd_IDEX			     : std_logic_vector(4 downto 0);
  signal s_shamt_IDEX			 : std_logic_vector(4 downto 0);
  signal s_writeAddress_EXMEM	 : std_logic_vector(4 downto 0);
  signal s_writeAddress_IDEX	 : std_logic_vector(4 downto 0);

  signal s_ALUOp            : std_logic_vector(3 downto 0);
  signal s_forwarding_mux1	     : std_logic_vector(1 downto 0);
  signal s_forwarding_mux2	     : std_logic_vector(1 downto 0);
  signal s_forwarding_mux3	     : std_logic_vector(1 downto 0);
  signal s_forwarding_mux4	     : std_logic_vector(1 downto 0);
  signal s_ALUOP_IDEX			 : std_logic_vector(3 downto 0);

  signal s_flush_IFID			 : std_logic;
  signal s_stall_IFID			 : std_logic;
  signal s_stall_IDEX			 : std_logic;

  signal s_stall_PC			     : std_logic;

  signal s_reset_IFID			 : std_logic;
  signal s_reset_IDEX			 : std_logic;

  signal s_memWrite	             : std_logic;

  signal s_upperImmediate_IDEX	 : std_logic;
  signal s_regdst_IDEX	         : std_logic;
  signal s_sltu_IDEX	         : std_logic;
  signal s_j_IDEX	             : std_logic;
  signal s_memToReg_IDEX	     : std_logic;
  signal s_regWrite_IDEX	     : std_logic;
  signal s_memWrite_IDEX	     : std_logic;
  signal s_ALUSrc_IDEX	         : std_logic;
  signal s_sl_IDEX	             : std_logic; --shift left
  signal s_sr_IDEX	             : std_logic; --shift right
  signal s_ALUControl_IDEX	     : std_logic;
  signal s_sv_IDEX	             : std_logic; --shift variable
  signal s_jr_IDEX	             : std_logic;

  signal s_upperImmediate_EXMEM	 : std_logic;
  signal s_sltu_EXMEM	         : std_logic;
  signal s_j_EXMEM	             : std_logic;
  signal s_memToReg_EXMEM	     : std_logic;
  signal s_regWrite_EXMEM	     : std_logic;

  signal s_upperImmediate_MEMWB	 : std_logic;
  signal s_sltu_MEMWB	         : std_logic;
  signal s_j_MEMWB	             : std_logic;
  signal s_memToReg_MEMWB	     : std_logic;

  signal s_registerWrite_IFID	 : std_logic;

  signal s_select_PC	         : std_logic;

  signal s_branch_IDEX	         : std_logic;
  signal s_forwarding_mux	     : std_logic;
  signal s_flush_IDEX	         : std_logic;


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
    port( clk          : in std_logic;
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

component register_EXMEM is
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
end component;

component register_IDEX is
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
        op				        : in std_logic_vector(3 downto 0);
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
end component;

component register_IFID is

   generic(N: integer := 32);
   port(clock         : in std_logic;
        i_rst         : in std_logic;
        i_we          : in std_logic;
        PC	      : in std_logic_vector(N-1 downto 0);
        inst	      : in std_logic_vector(N-1 downto 0);
        o_PC          : out std_logic_vector(N-1 downto 0);
        o_inst	      : out std_logic_vector(N-1 downto 0));
end component;

component register_MEMWB is
   port(clock					      : in std_logic;
        i_rst					      : in std_logic;
        i_WE					      : in std_logic;
        upperImmediate	              : in std_logic;
        sltu	                      : in std_logic;
        jal	                          : in std_logic;
        memToReg	                  : in std_logic;
        regWrite	                  : in std_logic;
        Dmem			              : in std_logic_vector(31 downto 0);
        ALU			                  : in std_logic_vector(31 downto 0);
        upperImmediate1			      : in std_logic_vector(31 downto 0);
        sltu1			              : in std_logic_vector(31 downto 0);
        PC			                  : in std_logic_vector(31 downto 0);
        D0			                  : in std_logic_vector(31 downto 0);
        inst			              : in std_logic_vector(31 downto 0);
        writeaddr				      : in std_logic_vector(4 downto 0);
        o_upperImmediate	          : out std_logic;
        o_sltu	                      : out std_logic;
        o_jal	                      : out std_logic;
        o_memToReg	                  : out std_logic;
        o_RegWrite	            : out std_logic;
        o_Dmem			        : out std_logic_vector(31 downto 0);
        o_ALU			        : out std_logic_vector(31 downto 0);
        o_upperImmediate1			: out std_logic_vector(31 downto 0);
        o_sltu1			        : out std_logic_vector(31 downto 0);
        o_PC			        : out std_logic_vector(31 downto 0);
        o_D0			        : out std_logic_vector(31 downto 0);
        o_Inst			        : out std_logic_vector(31 downto 0);
        o_writeaddr				: out std_logic_vector(4 downto 0));
end component;

component forwarding_dataflow is
  port(regWrite_EXMEM				: in std_logic;
       regWrite_MEMWB				: in std_logic;
       jr				            : in std_logic;
       beq				            : in std_logic;
       bne				            : in std_logic;
       sltu				            : in std_logic;
       upperImmediate				    : in std_logic;
       rd_IDEX		                : in std_logic_vector(4 downto 0);
       rt_IDEX		                : in std_logic_vector(4 downto 0);
       writeAddr_EXMEM		        : in std_logic_vector(4 downto 0);
       writeAddr_MEMWB		        : in std_logic_vector(4 downto 0);
       rt_IFID		                : in std_logic_vector(4 downto 0);
       rd_IFID		                : in std_logic_vector(4 downto 0);
       regdst_EX		            : in std_logic_vector(4 downto 0);

       forwarding_mux  					: out std_logic;

       forwarding_mux1				    : out std_logic_vector(1 downto 0);
       forwarding_mux2				    : out std_logic_vector(1 downto 0);
       forwarding_mux3				    : out std_logic_vector(1 downto 0);
       forwarding_mux4				    : out std_logic_vector(1 downto 0));
end component;

component mux4to1 is
	generic(N : integer := 32);
	port(i_D0 : in std_logic_vector(N-1 downto 0);
         i_D1 : in std_logic_vector(N-1 downto 0);
	     i_D2 : in std_logic_vector(N-1 downto 0);
	     i_D3 : in std_logic_vector(N-1 downto 0);
         i_F  : in std_logic_vector(1 downto 0);
         o_O  : out std_logic_vector(N-1 downto 0));
end component;

component control_hazard_dataflow is
  generic(N : integer := 32);
  port(branch					         : in std_logic;
       jump					             : in std_logic;
       branch_IDEX					     : in std_logic;
       memtoReg_IDEX	                 : in std_logic;
       jr	                             : in std_logic;
       j_IDEX	                         : in std_logic;
       jr_IDEX	                         : in std_logic;

       memtoReg_EXMEM	                 : in std_logic;

       rd_IFID		                     : in std_logic_vector(4 downto 0);
       rt_IFID		                     : in std_logic_vector(4 downto 0);
       regdst_EXMEM		                 : in std_logic_vector(4 downto 0);
       writeAddr_EXMEM		             : in std_logic_vector(4 downto 0);

       inst_IDEX						 : in std_logic_vector(31 downto 0);
       inst_EXMEM						 : in std_logic_vector(31 downto 0);

       flush_IFID	                     : out std_logic;
       stall_IFID	                     : out std_logic;
       stall_IDEX	                     : out std_logic;
       stall_PC	                         : out std_logic;
       flush_IDEX	                     : out std_logic);

end component;

--hazard unit
begin

    op_Code		   <= s_Inst (31 downto 26);
	Funct	       <= s_Inst (5 downto 0);

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


    --starts pipeline
    -- IF
    PC_increment : Fulladder_N
    port map(i_fA => s_O_PC,
             i_fB => x"00000004",
             i_FC => '0',
             o_Cry => open,
             o_Sum => s_j_addresses_to_top);

    s_NextInstAddr <= s_O_PC;
    s_select_PC <= s_branch or s_j or s_jr;

    PC_mux : mux_32bit_dataflow
    generic map(N => 32)
    port map(i_D0 => s_j_addresses_to_top,
             i_D1 => s_jumpandregister_mux1,
             i_S => s_select_PC,
             o_O => s_PC_mux1);


    -- IF/ID
    generic_IFID : register_IFID
    generic map(N => 32)
    port map(clock => iCLK,
             i_rst => s_reset_IFID,
             i_we => s_stall_IFID,
             PC => s_j_addresses_to_top,
             inst => s_inst1,
             o_PC => s_PC_IFID,
             o_inst => s_inst_IFID);

    generic_flush_IFID : process (iRST,
                                  s_flush_IFID,
                                  iCLK)
    begin
        if (iRST = '1')
            then s_reset_IFID <= '1';
        else
            s_reset_IFID <= s_flush_IFID;
        end if;
    end process;

    --ID Stage
    reg : Register_File
        port map(i_CLK => iCLK,
                 i_RST => iRST,
                 r_1 => s_inst_IFID(25 downto 21),
                 r_2 => s_inst_IFID(20 downto 16),
                 i_w => s_RegWrAddr,
                 WE => s_RegWr,
                 i_Data => s_RegWrData,
                 --o_2 => v0,
                 o_r_1 => s_rt,
                 o_r_2 => s_rd);

    generic_forwarding_mux3 : mux4to1
        generic map(N => 32)
        port map(i_D0 => s_rt,
                 i_D1 => s_RegWrData,
                 i_D2 => s_forwardingExtend_data,
                 i_D3 => s_forward_data,
                 i_F => s_forwarding_mux3,
                 o_O => s_rt1);

    generic_forwarding_mux4 : mux4to1
        generic map(N => 32)
        port map(i_D0 => s_rd,
                 i_D1 => s_RegWrData,
                 i_D2 => s_forwardingExtend_data,
                 i_D3 => s_forward_data,
                 i_F => s_forwarding_mux4,
                 o_O => s_rd1);

    jal_read_mux : mux_32bit_dataflow
        generic map(N => 5)
        port map(i_D0 => s_regdst_mux1,
                 i_D1 => "11111",
                 i_S => s_j_MEMWB,
                 o_O => s_RegWrAddr);

    generic_controlUnit : controlUnit
        port map(op_Code => s_inst_IFID(31 downto 26),
                 Funct => s_inst_IFID(5 downto 0),
                 j => s_j,
                 halt => s_Halt,
                 MemtoReg => s_memtoReg,
                 MemWrite => s_memWrite,
                 ALUSrc => s_ALUSrc,
                 RegWrite => s_registerWrite_IFID,
                 ALUControl => s_ALUOp,
                 shiftVariable => s_sv,
                 upper_immediate => s_ui,
                 sltu => s_sltu,
                 bne => s_bne,
                 beq => s_beq,
                 jr => s_jr);




    generic_immediate_extend : extender_N
        port map(i_D => s_inst_IFID(15 downto 0),
                 i_S => s_Signed,
                 o_O => s_immediateExtend);

    --temporary jumps for bit extensions
    s_j_temp(27 downto 26) <= "00";
    s_j_temp(25 downto 0) <= s_inst_IFID(25 downto 0);



    --TODO
    --FIXME
    generic_barrel_shifter : barrel_shifter
        port map(i_clk => iCLK,
		 i_I => s_j_temp,
                 i_S => "00010",
                 i_A => '1',
                 i_L => '1',
                 o_O => s_j_address_bottom);

    s_j_address(31 downto 28) <= s_PC_IFID(31 downto 28);
    s_j_address(31 downto 0) <= s_j_address_bottom;

    jump_mux : mux_32bit_dataflow
        port map(i_D0 => s_branch_mux1,
                 i_D1 => s_j_address,
                 i_S => s_j,
                 o_O => s_jump_mux1);

    generic_jr_mux : mux_32bit_dataflow
        port map(i_D0 => s_jump_mux1,
                 i_D1 => s_rt1,
                 i_S => s_jr,
                 o_O => s_jumpandregister_mux1);

    --TODO
    generic_branch_barrel_shifter: barrel_shifter
        port map(i_clk => iCLK,
		 i_I => s_immediateExtend,
                 i_S => "00010",
                 i_A => '1',
                 i_L => '1',
                 o_O => s_immediateShiftLeft);

    generic_branch_full_adder : Fulladder_N
        port map(i_fA => s_PC_IFID,
                 i_fB => s_immediateShiftLeft,
                 i_fC => '0',
                 o_Cry => open,
                 o_Sum => s_O_branch);

    branch_mux : mux_32bit_dataflow
        port map(i_D0 => s_PC_IFID,
                 i_D1 => s_O_branch,
                 i_S => s_branch,
                 o_O => s_branch_mux1);

    --hazard unit!
    --TODO
hazard: control_hazard_dataflow
  port map(branch           => s_Branch,
           jump             => s_j,
           branch_IDEX      => s_branch_IDEX,
           memtoReg_IDEX    => s_memtoReg_IDEX,
           jr               => s_jr,
           j_IDEX           => s_j_IDEX,
           jr_IDEX          => s_jr_IDEX,

           memtoReg_EXMEM   => s_memToReg_EXMEM,

           rd_IFID          => s_inst_IFID(20 downto 16),
           rt_IFID          => s_inst_IFID(25 downto 21),
           regdst_EXMEM     => s_regdst_mux1_EXMEM,
           writeAddr_EXMEM  => s_writeAddress_EXMEM,
           
           inst_IDEX        => s_inst_IDEX,
           inst_EXMEM       =>s_inst_EXMEM,

           flush_IFID       => s_flush_IFID,
           stall_IFID       => s_stall_IFID,
           stall_IDEX       => s_stall_IDEX,
           stall_PC         => s_stall_PC,
           flush_IDEX       => s_flush_IDEX);
    
    
    generic_forwarding : forwarding_dataflow
        port map(regWrite_EXMEM => s_regWrite_EXMEM,
                 regWrite_MEMWB => s_RegWr,
                 rd_IDEX => s_rd_IDEX,
                 rt_IDEX => s_rt_IDEX,
                 rt_IFID => s_inst_IFID(25 downto 21),
                 rd_IFID => s_inst_IFID(20 downto 16),
                 jr => s_jr,
                 beq => s_beq,
                 bne => s_bne,
                 sltu => s_sltu,
                 upperImmediate => s_ui,
                 regdst_EX => s_regdst_mux1_EXMEM,
                 writeaddr_EXMEM => s_writeAddress_EXMEM,
                 writeaddr_MEMWB => s_RegWrAddr,
                 forwarding_mux => s_forwarding_mux,
                 forwarding_mux1 => s_forwarding_mux1,
                 forwarding_mux2 => s_forwarding_mux2,
                 forwarding_mux3 => s_forwarding_mux3,
                 forwarding_mux4 => s_forwarding_mux4);


    -- barrel shifter
    --TODO
     generic_ALU : ALU_32bit
        port map(i_D0 => s_rt1,
		 i_D1 => s_rd1,
                 i_D2 => "0110",
                 i_D3 => "00000",
                 i_Overflow => '0',
                 o_O => open,
                 o_Overflow => open,
                 o_zero => s_zero);

    generic_branch : process (s_beq,
                              s_bne,
                              s_zero)
    begin
        if ((s_zero = '1') and (s_beq = '1'))
            then s_branch <= '1';
        elsif ((s_zero = '0') and (s_bne = '1'))
            then s_branch <= '1';
        else
            s_branch <= '0';
        end if;
    end process;


    -- ID/EX
    generic_register_IDEX : register_IDEX
    generic map(N => 32)
    port map(clock => iCLK,
             i_rst => s_reset_IDEX,
             i_we => s_stall_IDEX,
             upperImmediate => s_ui,
             regdst => s_RegDst,
             sltu => s_sltu,
             jal => s_j,
             memtoReg => s_MemtoReg,
             regWrite => s_registerWrite_IFID,
             memWrite => s_memWrite,
             ALUSrc => s_ALUSrc,
             sl => sl,
             sr => sr,
             ALUControl => s_ALUControl,
             sv => s_sv,
             branch => s_branch,
             op => s_ALUOp,
             writeaddr => s_inst_IFID(15 downto 11),
             rt => s_inst_IFID(25 downto 21),
             rd => s_inst_IFID(20 downto 16),
             shamt => s_inst_IFID(10 downto 6),
             rt1 => s_rt1,
             rd1 => s_rd1,
             immediateExtend => s_immediateExtend,
             PC => s_PC_IFID,
             D0 => s_D0_IFID,
             inst => s_inst_IFID,
             jr => s_jr,
             o_upperImmediate => s_upperImmediate_IDEX,
             o_RegDst => s_regdst_IDEX,
             o_sltu => s_sltu_IDEX,
             o_jal => s_j_IDEX,
             o_MemtoReg => s_memToReg_IDEX,
             o_RegWrite => s_regWrite_IDEX,
             o_MemWrite => s_memWrite_IDEX,
             o_ALUSrc => s_ALUSrc_IDEX,
             o_sl => s_sl_IDEX,
             o_sr => s_sr_IDEX,
             o_ALUControl => s_ALUControl_IDEX,
             o_sv => s_sv_IDEX,
             o_branch => s_branch_IDEX,
             o_jr => s_jr_IDEX,
             o_op => s_ALUOP_IDEX,
             o_writeaddr => s_writeAddress_IDEX,
             o_rd => s_rd_IDEX,
             o_rt => s_rt_IDEX,
             o_shamt => s_shamt_IDEX,
             o_rt1 => s_rt1_IDEX,
             o_rd1 => s_rd1_IDEX,
             o_immediateExtend => s_immediateExtend_IDEX,
             o_PC => s_PC_IDEX,
             o_D0 => s_D0_IDEX,
             o_inst => s_inst_IDEX);

    generic_flush_IDEX :
    process (iRST,
             s_flush_IDEX,
             iCLK)
    begin
        if (iRST = '1')
            then s_reset_IDEX <= '1';
        else
            s_reset_IDEX <= s_flush_IDEX;
        end if;
    end process;


    -- EX
    generic_regDst_mux : mux_32bit_dataflow
        generic map(N => 5)
        port map(i_D0 => s_rd_IDEX,
                 i_D1 => s_writeAddress_IDEX,
                 i_S => s_regdst_IDEX,
                 o_O => s_regdst_mux1_EXMEM);

    ALUSrc_mux : mux_32bit_dataflow
        generic map(N => 32)
        port map(i_D0 => s_ALU_2_1,
                 i_D1 => s_immediateExtend_IDEX,
                 i_S => s_ALUSrc_IDEX,
                 o_O => s_ALUSrc1);

    generic_sv_mux : mux_32bit_dataflow
        generic map(N => 5)
        port map(i_D0 => s_shamt_IDEX,
                 i_D1 => s_ALU_1_1(4 downto 0),
                 i_S => s_sv_IDEX,
                 o_O => s_shift);

    generic_ALU_mux_1 : mux4to1
        generic map(N => 32)
        port map(i_D0 => s_rt1_IDEX,
                 i_D1 => s_RegWrData,
                 i_D2 => s_forward_data,
                 i_D3 => x"00000000",
                 i_F => s_forwarding_mux1,
                 o_O => s_ALU_1_1);

    generic_ALU_mux_2 : mux4to1
        generic map(N => 32)
        port map(i_D0 => s_rd1_IDEX,
                 i_D1 => s_RegWrData,
                 i_D2 => s_forward_data,
                 i_D3 => x"00000000",
                 i_F => s_forwarding_mux2,
                 o_O => s_ALU_2_1);


  
    generic_ALU2 : ALU_32bit
        port map(i_D0 => s_ALU_1_1,
		 i_D1 => s_ALUSrc1,
                 i_D2 => s_ALUOP_IDEX,
                 i_D3 => s_shift,
                 i_Overflow => '0',
                 o_O => s_ALUOut,
                 o_Overflow => open,
                 o_zero => open);

    oALUOut <= s_ALUOut;
    

    generic_immediate_barrel_shift : barrel_shifter

        port map(i_clk => iCLK,
		 i_I => s_immediateExtend_IDEX,
                 i_S => "10000",
                 i_A => '1',
                 i_L => '1',
                 o_O => s_upper_immediate1);

    generic_forwarding_extension_select : process (s_sltu_IDEX,
                                                   s_upperImmediate_IDEX,
                                                   s_sltu1,
                                                   s_upper_immediate1,
                                                   s_ALUOut,
                                                   s_PC_IDEX,
                                                   s_j_IDEX)
        begin
            if (s_sltu_IDEX = '1')
                then s_forwardingExtend_data <= s_sltu1;
            elsif (s_upperImmediate_IDEX = '1')
                then s_forwardingExtend_data <= s_upper_immediate1;
            elsif (s_j_IDEX = '1')
                then s_forwardingExtend_data <= s_PC_IDEX;
            else
                s_forwardingExtend_data <= s_ALUOut;
            end if;
        end process;

        process (s_rt1_IDEX, s_ALUSrc1, s_ALUOut)
        begin
            if ((s_rt1_IDEX(31) = '0') and (s_ALUSrc1(31) = '1'))
                then s_sltu1 <= x"00000001";
            elsif ((s_rt1_IDEX(31) = '1') and (s_ALUSrc1(31) = '0'))
                then s_sltu1 <= x"00000000";
            else
                s_sltu1 <= s_ALUOut;
            end if;
        end process;

    -- EX/MEM
    generic_register_EXMEM : register_EXMEM
    generic map(N => 32)
    port map(clock => iCLK,
             i_rst => iRST,
             i_WE => '1',
             upperImmediate => s_upperImmediate_IDEX,
             sltu => s_sltu_IDEX,
             jal => s_j_IDEX,
             memtoReg => s_memToReg_IDEX,
             regWrite => s_regWrite_IDEX,
             memWrite => s_memWrite_IDEX,
             ALUout => s_ALUOut,
             ALU => s_ALU_2_1,
             i_writeaddr => s_regdst_mux1_EXMEM,
             sltu1 => s_sltu1,
             upperImmediate1 => s_upper_immediate1,
             PC => s_PC_IDEX,
             D0 => s_D0_IDEX,
             inst => s_inst_IDEX,
             o_upperImmediate => s_upperImmediate_EXMEM,
             o_sltu => s_sltu_EXMEM,
             o_jal => s_j_EXMEM,
             o_memtoReg => s_memToReg_EXMEM,
             o_regWrite => s_regWrite_EXMEM,
             o_memWrite => s_DMemWr,
             o_ALUout => s_DmemAddr,
             o_ALU => s_DMemData,
             o_writeaddr => s_writeAddress_EXMEM,
             o_sltu1 => s_sltu1_EXMEM,
             o_upperImmediate1 => s_upper_immediate1_EXMEM,
             o_PC => s_PC_EXMEM,
             o_D0 => s_D0_EXMEM,
             o_inst => s_inst_EXMEM);


    -- MEM
    mem_fwd_sel : process (s_sltu_EXMEM,
                           s_upperImmediate_EXMEM,
                           s_sltu1_EXMEM,
                           s_upper_immediate1_EXMEM,
                           s_DMemAddr,
                           s_PC_EXMEM,
                           s_j_EXMEM)
    begin
        if (s_sltu_EXMEM = '1')
            then s_forward_data <= s_sltu1_EXMEM;
        elsif (s_upperImmediate_EXMEM = '1')
            then s_forward_data <= s_upper_immediate1_EXMEM;
        elsif (s_j_EXMEM = '1')
            then s_forward_data <= s_PC_EXMEM;
        else
            s_forward_data <= s_DMemAddr;
        end if;
    end process;

     -- MEM/WB
    generic_register_MEMWB : register_MEMWB
    port map(clock => iCLK,
             i_rst => iRST,
             i_we => '1',
             upperImmediate => s_upperImmediate_EXMEM,
             sltu => s_sltu_EXMEM,
             jal => s_j_EXMEM,
             memtoReg => s_memToReg_EXMEM,
             regWrite => s_regWrite_EXMEM,
             Dmem => s_DMemOut,
             ALU => s_DMemAddr,
             upperImmediate1 => s_upper_immediate1_EXMEM,
             sltu1 => s_sltu1_EXMEM,
             PC => s_PC_EXMEM,
             writeaddr => s_writeAddress_EXMEM,
             D0 => s_D0_EXMEM,
             inst => s_inst_EXMEM,
             o_upperImmediate => s_upperImmediate_MEMWB,
             o_sltu => s_sltu_MEMWB,
             o_jal => s_j_MEMWB,
             o_memtoReg => s_memToReg_MEMWB,
             o_regWrite => s_RegWr,
             o_Dmem => s_O_Dmem_MEMWB,
             o_ALU => s_ALUOut_MEMWB,
             o_upperImmediate1 => s_upper_immediate1_MEMWB,
             o_sltu1 => s_sltu1_MEMWB,
             o_PC => s_PC_MEMWB,
             o_writeaddr => s_regdst_mux1,
             o_D0 => open,
             o_Inst => s_Inst);

    generic_memtoReg_mux : mux_32bit_dataflow
        generic map(N => 32)
        port map(i_D0 => s_ALUOut_MEMWB,
                 i_D1 => s_O_Dmem_MEMWB,
                 i_S => s_memToReg_MEMWB,
                 o_O => s_memToReg1);

    generic_upperImmediate_mux : mux_32bit_dataflow
        generic map(N => 32)
        port map(i_D0 => s_memToReg1,
                 i_D1 => s_upper_immediate1_MEMWB,
                 i_S => s_upperImmediate_MEMWB,
                 o_O => s_upper_immediate_mux1);

    generic_sltu_mux : mux_32bit_dataflow
        generic map(N => 32)
        port map(i_D0 => s_upper_immediate_mux1,
                 i_D1 => s_sltu1_MEMWB,
                 i_S => s_sltu_MEMWB,
                 o_O => s_sltu_mux1);

    generic_jal_mux : mux_32bit_dataflow
        port map(i_D0 => s_sltu_mux1,
                 i_D1 => s_PC_MEMWB,
                 i_S => s_j_MEMWB,
                 o_O => s_RegWrData);

    halt : process (s_D0,
                    s_Halt)
    begin
        if (s_D0 = x"0000000A")
            then s_Halt <= '1';
        else
            s_Halt <= '0';
        end if;
    end process;

end structure;

