library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcodes.all;

entity branch_unit is port (
  funct3 : in std_logic_vector(2 downto 0);
  a : in std_logic_vector(31 downto 0);
  b : in std_logic_vector(31 downto 0);

  branch: out std_logic
);
end entity;

architecture rtl of branch_unit is
begin
  branch <= '1' when
    (funct3 = FN_BEQ and a = b) or
    (funct3 = FN_BNE and a /= b) or
    (funct3 = FN_BLT and signed(a) < signed(b)) or
    (funct3 = FN_BGE and signed(a) >= signed(b)) or
    (funct3 = FN_BLTU and unsigned(a) < unsigned(b)) or
    (funct3 = FN_BGEU and unsigned(a) >= unsigned(b))
  else '0';
end rtl;