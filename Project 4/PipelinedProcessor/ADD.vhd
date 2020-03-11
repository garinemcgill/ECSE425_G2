library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADD is
port(
	next_addr : in integer;		-- usually +4
	count_out : in std_logic_vector (31 downto 0);
	add_out : out std_logic_vector (31 downto 0)
);
end ADD;


architecture ADD_arch of ADD is

signal addition : integer;

begin

	addition <= next_addr + to_integer(unsigned(count_out));		-- add to the current address to go to next addr
	add_out <= std_logic_vector(to_unsigned(addition, add_out'length));	-- cast to std_logic_vector

end ADD_arch;

