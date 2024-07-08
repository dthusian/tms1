library ieee;
use ieee.std_logic_1164.all;

package ffi is
  function rom_read(addr : integer) return integer;
  attribute foreign of rom_read : function is "VHPIDIRECT rom_read";
end ffi;

package body ffi is
  function rom_read(addr : integer) return integer is begin
    assert false severity failure;
  end rom_read;
end ffi;