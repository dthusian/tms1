library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ffi.all;

entity main is port (
  data : out signed(31 downto 0)
);
end entity main;

architecture testbench of main is
begin
  process
  begin
    data <= (to_signed(rom_read(0), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(4), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(8), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(12), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(16), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(20), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(24), 32));
    wait for 10 ns;
    data <= (to_signed(rom_read(28), 32));
    wait for 10 ns;
  end process;
end;

