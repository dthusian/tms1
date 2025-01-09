library ieee;
use ieee.std_logic_1164.all;
use work.opcodes.all;

entity load_store_unit is port (
  -- sign-extension of load values
  mem_read : in std_logic_vector(31 downto 0);
  mem_size : in std_logic_vector(1 downto 0);
  lsu_signed : in std_logic;
  load_value : out std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of load_store_unit is
  signal sx8 : std_logic_vector(31 downto 0);
  signal sx16 : std_logic_vector(31 downto 0);
begin
  sx8(7 downto 0) <= mem_read(7 downto 0);
  sx8(31 downto 8) <= (others => mem_read(7));
  sx16(15 downto 0) <= mem_read(15 downto 0);
  sx16(31 downto 16) <= (others => mem_read(15));
  
  load_value <= sx8 when mem_size = "00" and lsu_signed = '1' else
                sx16 when mem_size = "01" and lsu_signed = '1' else
                X"000000" & mem_read(7 downto 0) when mem_size = "00" and lsu_signed = '0' else
                X"0000" & mem_read(15 downto 0) when mem_size = "01" and lsu_signed = '0' else
                mem_read;
end rtl;