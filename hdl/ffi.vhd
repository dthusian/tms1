library ieee;
use ieee.std_logic_1164.all;

package ffi is
  -- rom.c
  function rom_read(addr : integer) return integer;
  attribute foreign of rom_read : function is "VHPIDIRECT rom_read";

  -- rom2.c
  procedure rom2_open(unused: integer);
  attribute foreign of rom2_open : procedure is "VHPIDIRECT rom2_open";
  procedure rom2_cycle(
    addr : std_logic_vector(31 downto 0);
    data : std_logic_vector(31 downto 0)
  );
  attribute foreign of rom2_cycle : procedure is "VHPIDIRECT rom2_cycle";
end ffi;

package body ffi is
  function rom_read(addr : integer) return integer is begin
    assert false severity failure;
  end rom_read;

  procedure rom2_open(unused: integer) is begin
    assert false severity failure;
  end rom2_open;

  procedure rom2_cycle(
    addr : std_logic_vector(31 downto 0);
    data : std_logic_vector(31 downto 0)
  ) is begin
    assert false severity failure;
  end procedure;
end ffi;