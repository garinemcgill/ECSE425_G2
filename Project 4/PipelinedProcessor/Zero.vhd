library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Zero is
port (
	A_in : in std_logic_vector (31 downto 0);
	B_in : in std_logic_vector (31 downto 0);
	opCode : in std_logic_vector (4 downto 0);
	branch : out std_logic := '0'
);
end Zero;


architecture zero_arch of zero is
begin

process(A_in, B_in)
begin
	
	case opCode is
	
		-- BEQ
		when "10110" =>
			if (unsigned(A_in) = unsigned(B_in)) then
				branch <= '1';		-- take branch if equal
			else 
				branch <= '0';
			end if;


		-- BNE
		when "10111" =>
			if (unsigned(A_in) = unsigned(B_in)) then
				branch <= '0';
			else 
				branch <= '1';		-- take branch if not equal
			end if;


		-- J
		when "11000" =>
			branch <= '1';


		-- JR (jump register)
		when "11001" =>
			branch <= '1';


		-- JAL (jump and link)
		when "11010" =>
			branch <= '1';

		
		when others =>
			branch <= '0';


	end case;
end process;

end zero_arch;





		