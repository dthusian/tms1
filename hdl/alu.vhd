library ieee;
use ieee.std_logic_1164.all;

entity alu is port (
  opr : in std_logic;
  funct3 : in std_logic_vector(2 downto 0);
  funct7 : in std_logic_vector(6 downto 0);
  a : in std_logic_vector(31 downto 0);
  b : in std_logic_vector(31 downto 0);
  q : out std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of alu is
begin
  
end rtl;