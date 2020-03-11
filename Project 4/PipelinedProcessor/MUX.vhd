library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX is
port(
	A_in : in std_logic_vector (31 downto 0);
	B_in : in std_logic_vector (31 downto 0);
	sel : in std_logic;
	C_out : out std_logic_vector (31 downto 0)
);
end MUX;


architecture MUX_arch of MUX is

begin
	-- since not in a process, we can't use an if case

	C_out <= B_in when(sel = '1') else A_in;


end MUX_arch;