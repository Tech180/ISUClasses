-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- TPU_MV_Element.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a processing
-- element for the systolic matrix-vector multiplication array inspired 
-- by Google's TPU.
--
--
-- NOTES:
-- 1/14/19 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity TPU_MV_Element is

  port(iCLK                         : in std_logic;
       iX 		            : in integer;
       iW 		            : in integer;
       iLdW 		            : in integer;
       iY                           : in integer;
       oY 		            : out integer;
       oX 		            : out integer);

end TPU_MV_Element;

architecture structure of TPU_MV_Element is
  
  -- Describe the component entities as defined in Adder.vhd, Reg.vhd,
  -- Multiplier.vhd, RegLd.vhd (not strictly necessary).
  component Adder
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

  component Multiplier
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

  component Reg
    port(iCLK           : in std_logic;
         iD             : in integer;
         oQ             : out integer);
  end component;

  component RegLd
    port(iCLK           : in std_logic;
         iD             : in integer;
         iLd            : in integer;
         oQ             : out integer);
  end component;


  -- Signal to carry stored weight
  signal s_W         : integer;
  -- Signals to carry delayed X
  signal s_X1, sX2   : integer;
  -- Signal to carry delayed Y
  signal s_Y1        : integer;
  -- Signal to carry stored W*X
  signal s_WxX       : integer;

begin

  ---------------------------------------------------------------------------
  -- Level 0: Conditionally load new W
  ---------------------------------------------------------------------------
 
  g_Weight: RegLd
    port MAP(iCLK             => iCLK,
             iD               => iW,
             iLd              => iLdW,
             oQ               => s_W);


  ---------------------------------------------------------------------------
  -- Level 1: Delay X and Y, calculate W*X
  ---------------------------------------------------------------------------
  g_Delay1: Reg
    port MAP(iCLK             => iCLK,
             iD               => iX,
             oQ               => s_X1);
  
  g_Delay2: Reg
    port MAP(iCLK             => iCLK,
             iD               => iX,
             oQ               => s_Y1);

  g_Mult1: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => iX,
             iB               => s_W,
             oC               => s_WxX);

    
  ---------------------------------------------------------------------------
  -- Level 2: Delay X, calculate Y += W*X
  ---------------------------------------------------------------------------
  g_Delay3: Reg
    port MAP(iCLK             => iCLK,
             iD               => s_X1,
             oQ               => oX);

  g_Add1: Adder
    port MAP(iCLK             => iCLK,
             iA               => s_WxX,
             iB               => s_Y1,
             oC               => oY);
    

  end structure;
