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
  signal addr_out : std_logic_vector(31 downto 0);
  signal data_out : std_logic_vector(31 downto 0);
begin
  process
    variable addr : std_logic_vector(31 downto 0);
    variable data : std_logic_vector(31 downto 0);
  begin
    rom2_open(0);

    addr := X"00000000";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"00000004";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"00000008";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"0000000c";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"00000010";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"00000014";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"00000018";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;

    addr := X"0000001c";
    rom2_cycle(addr, data);
    addr_out <= addr;
    data_out <= data;
    wait for 10 ns;
  end process;
end;

