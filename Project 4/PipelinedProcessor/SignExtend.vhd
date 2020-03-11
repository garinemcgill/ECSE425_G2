library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SignExtend is
port (
	imm_Val_in : in std_logic_vector (15 downto 0);
	imm_Val_out : out std_logic_vector (31 downto 0)
);
end SignExtend;


architecture SignExtend_Arch of SignExtend is

begin

process(imm_Val_in)
begin
	-- SignExtImm (ZeroExtImm will be done elsewhere)
	if imm_Val_in(15) = '1' then					-- negative 16b number
		imm_Val_out(31 downto 16) <= "1000000000000000";	-- make a 32b negative num
	else								-- positive 16b number
		imm_Val_out(31 downto 16) <= "0000000000000000";	-- make a 32b positive num
	end if;

	imm_Val_out (15 downto 0) <= imm_Val_in;			-- set the last 16b to previous 16b num

end process;
end SignExtend_Arch;
	