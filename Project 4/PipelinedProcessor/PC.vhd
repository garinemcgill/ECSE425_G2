library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
port(
	clk : in std_logic;
	rst : in std_logic;
	count_in : in std_logic_vector (31 downto 0) := x"00000000";
	count_out : out std_logic_vector (31 downto 0)
);
end PC;


architecture PC_arch of PC is

begin

process(clk, rst)
begin

	if rst = '1' then			-- if PC counter to be reset
		count_out <= x"00000000";	-- go to top of mem (assumption that mem starts at addr 0)

	elsif rising_edge(clk) then		-- at rising edge (next CC)
		count_out <= count_in;		-- get next instruction addr
	end if;

end process;
end PC_arch;
	
	


