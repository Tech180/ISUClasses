library IEEE;
use IEEE.std_logic_1164.all;

entity control_hazard_dataflow is
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

end control_hazard_dataflow;

architecture dataflow of control_hazard_dataflow is

    begin

    flush_IFID <= '1'
        when ((branch_IDEX = '1') or (j_IDEX = '1') or (jr_IDEX = '1'))
            else '0';

    flush_IDEX <= '1'
        when ((memtoReg_EXMEM = '1') and (memtoReg_IDEX = '1') and (inst_IDEX = inst_EXMEM))
            else '0';

    stall_IDEX <= '0'
        when (((jr = '1') or (memtoReg_IDEX = '1')) and (((regdst_EXMEM = rt_IFID) and (regdst_EXMEM  /= "00000")) or ((regdst_EXMEM = rd_IFID) and (regdst_EXMEM  /= "00000"))))
        else '1';

    stall_IFID <= '0'
        when (((memtoReg_IDEX = '1') and ((regdst_EXMEM = rt_IFID) or (regdst_EXMEM = rd_IFID)) and (regdst_EXMEM  /= "00000")) or (branch = '1') or (jump = '1') or (jr = '1'))
            else '1';

    stall_PC <= '0'
        when ((((memtoReg_IDEX = '1') or (jr = '1')) and ((regdst_EXMEM = rt_IFID) or (regdst_EXMEM = rd_IFID)) and (regdst_EXMEM /= "00000")) or  (branch_IDEX = '1') or (j_IDEX = '1') or (jr_IDEX = '1'))
            else '1';

end dataflow;
