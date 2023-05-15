library IEEE;
use IEEE.std_logic_1164.all;

entity forwarding_dataflow is
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
end forwarding_dataflow;

architecture behavioral of forwarding_dataflow is

begin

    process
        (writeAddr_EXMEM,
        rt_IDEX,
        regWrite_MEMWB,
        writeAddr_MEMWB,
        rd_IDEX,
        rd_IFID,
        rt_IFID,
        regdst_EX,
        beq,
        bne,
        jr,
        regWrite_EXMEM,
        sltu,
        upperImmediate)

    begin
        if ((regWrite_EXMEM = '1') and (writeAddr_EXMEM /= "00000") and (writeAddr_EXMEM = rt_IDEX))
            then forwarding_mux1 <= "10";
        elsif ((regWrite_MEMWB = '1') and (writeAddr_MEMWB /= "00000") and (writeAddr_MEMWB = rt_IDEX))
            then forwarding_mux1 <= "01";
        else
            forwarding_mux1 <= "00";
        end if;


        if ((regWrite_EXMEM = '1') and (writeAddr_EXMEM /= "00000") and (writeAddr_EXMEM = rd_IDEX))
            then forwarding_mux2 <= "10";
        elsif ((regWrite_MEMWB = '1') and (writeAddr_MEMWB /= "00000") and (writeAddr_MEMWB = rd_IDEX))
            then forwarding_mux2 <= "01";
        else
            forwarding_mux2 <= "00";
        end if;


        if ((jr = '1') and (writeAddr_EXMEM = "11111"))
            then forwarding_mux <= '1';
        else
            forwarding_mux <= '0';
        end if;


        if (((beq = '1') or (bne = '1') or (jr = '1') or (sltu = '1') or (upperImmediate = '1')) and (regdst_EX = rt_IFID))
            then forwarding_mux3 <= "10";
        elsif (((beq = '1') or (bne = '1') or (jr = '1') or (sltu = '1') or (upperImmediate = '1')) and (writeAddr_EXMEM = rt_IFID))
            then forwarding_mux3 <= "11";
        elsif ((regWrite_MEMWB = '1') and (writeAddr_MEMWB = rt_IFID))
            then forwarding_mux3 <= "01";
        else
            forwarding_mux3 <= "00";
        end if;



        if (((beq = '1') or (bne = '1') or (sltu = '1') or (upperImmediate = '1')) and (regdst_EX = rd_IFID))
            then forwarding_mux4 <= "10";
        elsif (((beq = '1') or (bne = '1') or (sltu = '1') or (upperImmediate = '1')) and (writeAddr_EXMEM = rd_IFID))
            then forwarding_mux4 <= "11";
        elsif ((regWrite_MEMWB = '1') and (writeAddr_MEMWB = rd_IFID))
            then forwarding_mux4 <= "01";
        else
            forwarding_mux4 <= "00";
        end if;

    end process;
end behavioral;

