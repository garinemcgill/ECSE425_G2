library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_back is
port (ctrl_memtorg_in: in std_logic;
	ctrl_rgwrite_in: in std_logic;
	mem_in: in std_logic_vector (31 downto 0);
	alu_in : in std_logic_vector (31 downto 0);
	write_addr_in: in std_logic_vector (4 downto 0);
	mux_out : out std_logic_vector (31 downto 0);
	ctrl_rgwrite_out: out std_logic;
	write_addr_out: out std_logic_vector (4 downto 0)
  );
end write_back;

architecture behavioral of write_back is

begin
process(alu_in, mem_in, ctrl_memtorg_in, ctrl_rgwrite_in)
begin
	write_addr_out <= write_addr_in;
	ctrl_rgwrite_out <= ctrl_rgwrite_in;

	case ctrl_memtorg_in is
		when '0' =>
		-- MUX output is the input from the ALU
			mux_out <= alu_in;
		when '1' =>
		-- MUX output is the input from the MEM
			mux_out <= mem_in;
		when others =>
		-- else output default string
			mux_out <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
	end case;
end process;

end behavioral;
