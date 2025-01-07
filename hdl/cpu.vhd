library ieee;
use ieee.std_logic_1164.all;

entity cpu is port (
  clk : in std_logic;
  syshalt : out std_logic;

  mem_addr : out std_logic_vector(31 downto 0);
  mem_rdata : in std_logic_vector(31 downto 0);
  mem_wdata : out std_logic_vector(31 downto 0);
  mem_size : out std_logic_vector(1 downto 0);
  mem_read_en : out std_logic;
  mem_write_en : out std_logic;
  mem_fault : in std_logic
);
end entity;

architecture rtl of cpu is
begin

end rtl;