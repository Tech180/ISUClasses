-------------------------------------------------------------------------
-- Riley Lawson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- xor_32bit_data.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain 32 bit XOR gate
-- implementation.

-- 11/05/2021 by RL:: Created 32 bit XOR gate
-------------------------------------------------------------------------


Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity MemForwardingUnit is
  port(
    rs          : in std_logic_vector(4 downto 0);
    wb_rd       : in std_logic_vector(4 downto 0);
    forward     : out std_logic);

end MemForwardingUnit;

architecture behavorial of MemForwardingUnit is

begin

    process (wb_rd, rs)
        begin
            if (not(wb_rd = "00000") and (wb_rd = rs)) then
                forward <= '1';
            else
                forward <= '0';
            end if;
    end process;

end behavorial;
