-- LINKING ALL COMPONENTS FO THE INTRUCTION FETCH STAGE TOGETHER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity FetchStage is
port(
	clk : in std_logic;
	pc_adder : in integer;
	Mux_A_in : in std_logic_vector (31 downto 0);
	Mux_Sel : in std_logic;
	struct_stalls : in std_logic := '0';
	PC_stalls : in std_logic := '0';
	Mux_out : out std_logic_vector (31 downto 0);
	IR : out std_logic_vector (31 downto 0)
);
end FetchStage;


architecture fetch_arch of FetchStage is

-- PC 
------------------------------- 
component PC is
port(
	clk : in std_logic;
	rst : in std_logic;
	count_in : in std_logic_vector (31 downto 0) := x"00000000";
	count_out : out std_logic_vector (31 downto 0)
);
end component;


-- Add 
------------------------------- 
component ADD is
port(
	next_addr : in integer;		-- usually +4
	count_out : in std_logic_vector (31 downto 0);
	add_out : out std_logic_vector (31 downto 0)
);
end component;



-- MUX 
------------------------------- 
component MUX is
port(
	A_in : in std_logic_vector (31 downto 0);
	B_in : in std_logic_vector (31 downto 0);
	sel : in std_logic;
	C_out : out std_logic_vector (31 downto 0)
);
end component;



-- Instruction Mem 
------------------------------- 
component InstructionMem is
generic(
	ram_size : Integer := 1024;	-- nbr instructions (to be used in array, not actual ram size)
	mem_delay : time := 1 ns;
	clk_period : time := 1 ns
);

port(
	clk : in std_logic;
	addr : in integer range 0 to ram_size-1;
	mem_write : in std_logic;
	mem_read : in std_logic;
	write_data : in std_logic_vector (31 downto 0);
	read_data : out std_logic_vector (31 downto 0);
	wait_req : out std_logic
);
end component;



-- Internal signals  (every line/wire in the pipeline diagram accounted for by a signal)
------------------------------- 

signal rst : std_logic := '0';
signal write_data : std_logic_vector (31 downto 0);
signal addr : integer range 0 to 1024-1;

signal mem_write : std_logic := '0';
signal mem_read : std_logic := '1';
signal read_data : std_logic_vector (31 downto 0);
signal wait_req : std_logic;

signal PC_out : std_logic_vector (31 downto 0);
signal MUX_to_PC : std_logic_vector (31 downto 0);
signal add_out : std_logic_vector (31 downto 0);

signal stall_value : std_logic_vector (31 downto 0) := "00000000000000000000000000100000";
signal mem_value : std_logic_vector (31 downto 0);
signal PC_in : std_logic_vector (31 downto 0);



-- Instrantiation of all components needed
-- Assigning all signals to components (as per diagram)
------------------------------- 
begin

	Mux_out <= MUX_to_PC;	-- make sure that line inputting to PC = line outputing MUX
	addr <= to_integer(unsigned(add_out(9 downto 0))) / 4;		-- get instr number

	
	PC_inst : PC
	port map(
		clk => clk,
		rst => rst,
		count_in => PC_in,
		count_out => PC_out
	);


	ADD_inst : ADD
	port map(
		next_addr => pc_adder,
		count_out => PC_out,
		add_out => add_out
	);


	Fetch_MUX : MUX
	port map(
		A_in => add_out,
		B_in => Mux_A_in,
		sel => Mux_sel,
		C_out => MUX_to_PC
	);


	Struct_MUX : MUX
	port map(
		A_in => mem_value,
		B_in => stall_value,
		sel => struct_stalls,
		C_out => IR
	);


	PC_MUX : MUX
	port map(
		A_in => MUX_to_PC,
		B_in => PC_out,
		sel => PC_stalls,
		C_out => PC_in
	);


	IM_inst : InstructionMem
	generic map(
		ram_size => 1024
	)
	port map (
		clk,
		addr,
		mem_write,
		mem_read,
		write_data,
		mem_value,
		wait_req
	);


end fetch_arch;


