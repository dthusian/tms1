library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ffi.all;

entity main is port (
  dummy : out boolean
);
end entity main;

architecture testbench of main is
begin
  process
    variable addr : std_logic_vector(31 downto 0);
    variable data : std_logic_vector(31 downto 0);
    variable write_en : std_logic;
    variable read_en: std_logic;
  begin
    rom2_open(0);

    write_en := '1';
    read_en := '0';

    addr := X"00000000";
    rom2_cycle(addr, data);
    uart_cycle(write_en, read_en, data(7 downto 0));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(15 downto 8));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(23 downto 16));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(31 downto 24));
    wait for 10 ns;

    addr := X"00000004";
    rom2_cycle(addr, data);
    uart_cycle(write_en, read_en, data(7 downto 0));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(15 downto 8));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(23 downto 16));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(31 downto 24));
    wait for 10 ns;

    addr := X"00000008";
    rom2_cycle(addr, data);
    uart_cycle(write_en, read_en, data(7 downto 0));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(15 downto 8));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(23 downto 16));
    wait for 10 ns;
    uart_cycle(write_en, read_en, data(31 downto 24));
    wait for 10 ns;
  end process;
end;

