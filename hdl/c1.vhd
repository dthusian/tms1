library ieee;
use ieee.std_logic_1164.all;

entity c1 is port (
  clk : in std_logic;
  
  rom_addr : out std_logic_vector(23 downto 0);
  rom_data : in std_logic_vector(31 downto 0);

  mem_addr : out std_logic_vector(23 downto 0);
  mem_ren : out std_logic;
  mem_rdata : in std_logic_vector(31 downto 0);
  mem_wen : out std_logic;
  mem_wdata : out std_logic_vector(31 downto 0);

  cons_ren : in std_logic;
  cons_rdata : in std_logic_vector(8 downto 0);
  cons_wen : out std_logic;
  cons_wdata : out std_logic_vector(8 downto 0);

  fault : out std_logic
);
end entity;