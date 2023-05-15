-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RegLd.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- enabled register. 
--
--
-- NOTES: Integer data type is not typically useful when doing hardware
-- design. We use it here for simplicity, but in future labs it will be
-- important to switch to std_logic_vector types and associated math
-- libraries (e.g. signed, unsigned). 


-- 1/14/18 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity RegLd is

  port(iCLK             : in std_logic;
       iD               : in integer;
       iLd              : in integer;
       oQ               : out integer);

end RegLd;

architecture behavior of RegLd is
  -- signal to hold Q value
  signal sQ : integer;
begin

  process(iCLK, iLd, iD)
  begin
    if rising_edge(iCLK) then
      if (iLd = 1) then
        sQ <= iD;
      else
        sQ <= sQ;
      end if;
    end if;
  end process;

  oQ <= sQ; -- connect internal storage signal with final output
  
end behavior;
