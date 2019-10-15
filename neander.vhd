----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    09:46:39 10/08/2019
-- Design Name:
-- Module Name:    neander - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity neander is
	port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		currentDATA : out STD_LOGIC_VECTOR (7 downto 0);
		ac : out STD_LOGIC_VECTOR (7 downto 0));
end neander;

architecture Behavioral of neander is

	component counter
		port (
			clk : in std_logic;
			rst : in std_logic;
			enable : in std_logic;
			load : in std_logic;
			d : in std_logic_vector(7 downto 0);
			s : out std_logic_vector(7 downto 0)
		);
	end component;

	component ctrl_unit
		port (
			clk : in std_logic;
			rst : in std_logic;
			inst : in std_logic_vector(12 downto 0);
			n : in std_logic;
			z : in std_logic;
			selREM : out std_logic;
			cgREM : out std_logic;
			cgRDM : out std_logic;
			cgAC : out std_logic;
			cgRI : out std_logic;
			cgNZ : out std_logic;
			cgPC : out std_logic;
			incPC : out std_logic;
			selULA : out std_logic_vector(2 downto 0);
			wea : out std_logic_vector(0 downto 0)
		);
	end component;

	component decod_inst
		port (
			opcode : in std_logic_vector(3 downto 0);
			operation : out std_logic_vector(12 downto 0)
		);
	end component;

	component mux2x1
		port (
			e0 : in std_logic_vector(7 downto 0);
			e1 : in std_logic_vector(7 downto 0);
			sel : in std_logic;
			s : out std_logic_vector(7 downto 0)
		);
	end component;

	component reg2
		port (
			clk : in std_logic;
			rst : in std_logic;
			d : in std_logic_vector(1 downto 0);
			load : in std_logic;
			s : out std_logic_vector(1 downto 0)
		);
	end component;

	component reg8
		port (
			clk : in std_logic;
			rst : in std_logic;
			d : in std_logic_vector(7 downto 0);
			load : in std_logic;
			s : out std_logic_vector(7 downto 0)
		);
	end component;

	component ula
		port (
			x : in std_logic_vector(7 downto 0);
			y : in std_logic_vector(7 downto 0);
			opsel : in std_logic_vector(2 downto 0);
			s : out std_logic_vector(7 downto 0);
			n : out std_logic;
			z : out std_logic
		);
	end component;

	COMPONENT memory
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

	signal outMEM, outMUX, outREM, outRDM, outAC, outRI, outPC, outULA : std_logic_vector (7 downto 0);
	signal nAux, zAux, n, z : std_logic;
	signal operation : std_logic_vector (12 downto 0);
	signal selREM, cgREM, cgRDM, cgAC, cgRI, cgNZ, cgPC, incPC : std_logic;
	signal selULA : std_logic_vector (2 downto 0);
	signal wea : std_logic_vector (0 downto 0);

begin

	PC : counter port map(
		clk => clk,
		rst => rst,
		enable => incPC,
		load => cgPC,
		d => outREM,
		s => outPC
	);

	CTRL : ctrl_unit port map(
		clk => clk,
		rst => rst,
		inst => operation,
		n => n,
		z => z,
		selREM => selREM,
		cgREM => cgREM,
		cgRDM => cgRDM,
		cgAC => cgAC,
		cgRI => cgRI,
		cgNZ => cgNZ,
		cgPC => cgPC,
		incPC => incPC,
		selULA => selULA,
		wea => wea
	);

	DECOD : decod_inst port map(
		opcode => outRI(7 downto 4),
		operation => operation
	);

	MUXREM : mux2x1 port map(
		e0 => outPC,
		e1 => outRDM,
		s => outMUX,
		sel => selREM
	);

	NZ : reg2 port map(
		clk => clk,
		rst => rst,
		d(0) => nAux,
		d(1) => zAux,
		load => cgNZ,
		s(0) => n,
		s(1) => z
	);

	RI : reg8 port map(
		clk => clk,
		rst => rst,
		d => outRDM,
		load => cgRI,
		s => outRI
	);

	AC_inst : reg8 port map(
		clk => clk,
		rst => rst,
		d => outULA,
		load => cgAC,
		s => outAC
	);

	REM_inst : reg8 port map(
		clk => clk,
		rst => rst,
		d => outMUX,
		load => cgREM,
		s => outREM
	);

	RDM : reg8 port map(
		clk => clk,
		rst => rst,
		d => outMEM,
		load => cgRDM,
		s => outRDM
	);

	ULA_inst : ula port map(
		x => outAC,
		y => outRDM,
		opsel => selULA,
		s => outULA,
		n => nAux,
		z => zAux
	);

memory_inst : memory
  PORT MAP (
    clka => clk,
    wea => wea,
    addra => outREM,
    dina => outRDM,
    douta => outMEM
  );
  
  currentDATA <= outMEM;
  ac <= outAC;

end Behavioral;
