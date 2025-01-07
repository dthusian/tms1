library ieee;
use ieee.std_logic_1164.all;

package ffi is
  procedure bus_init;
  attribute foreign of bus_init : procedure is "VHPIDIRECT bus_init";
  procedure bus_cycle(
    addr : in std_logic_vector(31 downto 0);
    rdata : out std_logic_vector(31 downto 0);
    wdata : in std_logic_vector(31 downto 0);
    size : in std_logic_vector(1 downto 0);
    read_en : in std_logic;
    write_en : in std_logic;
    fault : out std_logic
  );
  attribute foreign of bus_cycle : procedure is "VHPIDIRECT bus_cycle";
end ffi;

package body ffi is
  procedure bus_init is begin
    assert false severity failure;
  end procedure;

  procedure bus_cycle(
    addr : in std_logic_vector(31 downto 0);
    rdata : out std_logic_vector(31 downto 0);
    wdata : in std_logic_vector(31 downto 0);
    size : in std_logic_vector(1 downto 0);
    read_en : in std_logic;
    write_en : in std_logic;
    fault : out std_logic
  ) is begin
    assert false severity failure;
  end procedure;
end ffi;