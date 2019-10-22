--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:18:59 10/17/2019
-- Design Name:   
-- Module Name:   C:/Users/aluno/Downloads/SD_ALINE/neander/neander_tb.vhd
-- Project Name:  neander
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: neander
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY neander_tb IS
END neander_tb;
 
ARCHITECTURE behavior OF neander_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT neander
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         currentDATA : OUT  std_logic_vector(7 downto 0);
         ac : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal currentDATA : std_logic_vector(7 downto 0);
   signal ac : std_logic_vector(7 downto 0);
	signal counter : integer := 0;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: neander PORT MAP (
          clk => clk,
          rst => rst,
          currentDATA => currentDATA,
          ac => ac
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		counter <= counter + 1;
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
      wait;
   end process;

END;
