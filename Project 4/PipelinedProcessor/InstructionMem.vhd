-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Reference
-- https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/hb/qts/qts_qii5v1.pdf?fbclid=IwAR0W2VBKxlM9fLyU3F30gS-ZDOVk86oeccIeO-Ad2opLLS2_TdYCgGOXl9s
-- Pages 776-777 (Example 12-15)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity InstructionMem is
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
end InstructionMem;


architecture instr_mem_arch of InstructionMem is

type mem is array(ram_size-1 downto 0) of std_logic_vector (31 downto 0);
signal ram_block : mem;
signal read_addr_reg : integer range 0 to ram_size-1;
signal write_wait_req_reg : std_logic := '1';
signal read_wait_req_reg : std_logic := '1';


begin

--Synch RAM with new data read-during-write behaviour
mem_process : process (clk)

	file f : text;
	variable row : line;
	variable row_data : std_logic_vector (31 downto 0);
	variable row_counter : integer := 0;

	begin
	
	-- at the very beginning, do this
	-- initialize Instr mem
	if (now < 1 ps) then
		file_open (f, "program.txt", READ_MODE);	-- open file with instructions

		-- while more lines to read
		while (not endfile(f)) loop
			readline(f, row);			-- get line
			read(row, row_data);			-- read data of line
			ram_block(row_counter) <= row_data;	-- initialize row in ram array
			row_counter := row_counter + 1;		-- go to next row
		end loop;

	end if;

	file_close(f);		-- close file

	-- at every CC, do
	if rising_edge(clk) then
		
		if (mem_write = '1') then		-- if writing to mem
			ram_block(addr) <= write_data;	-- set data to the corresponding row in array
		end if;

		read_addr_reg <= addr;			-- set read_addr_reg to what we would like to read
	end if;

end process;

read_data <= ram_block(read_addr_reg);		-- can read data asynch, with addr set in process



-- delaying the write wait signal
wait_request_write : process (mem_write)
	begin
	-- if want to write newly set
	if rising_edge(mem_write) then
		write_wait_req_reg <= '0' after mem_delay, '1' after mem_delay + clk_period; 	-- delay the wait by 1 CC
	end if;

end process;


-- delaying the read wait signal
wait_request_read : process (mem_read)
	begin
	--if want to read newly set
	if rising_edge(mem_read) then
		read_wait_req_reg <= '0' after mem_delay, '1' after mem_delay + clk_period;	--delay the wait by 1 CC
	end if;

end process;

wait_req <= write_wait_req_reg and read_wait_req_reg;	-- if at least 1 wait: set the general wait_req on



end instr_mem_arch;
	

