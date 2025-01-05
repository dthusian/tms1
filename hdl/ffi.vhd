library ieee;
use ieee.std_logic_1164.all;

package ffi is
  -- rom2.c
  procedure rom2_open(unused : integer);
  attribute foreign of rom2_open : procedure is "VHPIDIRECT rom2_open";
  procedure rom2_cycle(
    addr : std_logic_vector(31 downto 0);
    data : std_logic_vector(31 downto 0)
  );
  attribute foreign of rom2_cycle : procedure is "VHPIDIRECT rom2_cycle";

  -- uart.c
  procedure uart_open(unused : integer);
  attribute foreign of uart_open : procedure is "VHPIDIRECT uart_open";
  procedure uart_cycle(
    write_en : std_logic;
    read_en : std_logic;
    data : std_logic_vector(7 downto 0)
  );
  attribute foreign of uart_cycle : procedure is "VHPIDIRECT uart_cycle";
end ffi;

package body ffi is
  procedure rom2_open(
    unused : integer
  ) is begin
    assert false severity failure;
  end rom2_open;

  procedure rom2_cycle(
    addr : std_logic_vector(31 downto 0);
    data : std_logic_vector(31 downto 0)
  ) is begin
    assert false severity failure;
  end procedure;

  procedure uart_cycle(
    write_en : std_logic;
    read_en : std_logic;
    data : std_logic_vector(7 downto 0)
  ) is begin
    assert false severity failure;
  end uart_cycle;
end ffi;