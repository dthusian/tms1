library ieee;
use ieee.std_logic_1164.all;
use work.opcodes.UNDEF32;

entity shifter is port (
  a : in std_logic_vector(31 downto 0);
  b : in std_logic_vector(4 downto 0);
  -- 00: logic left shift
  -- 01: logic right shift
  -- 11: arith right shift
  op : in std_logic_vector(1 downto 0);
  q : out std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of shifter is
  signal sh1 : std_logic_vector(31 downto 0);
  signal sh2 : std_logic_vector(31 downto 0);
  signal sh3 : std_logic_vector(31 downto 0);
  signal sh4 : std_logic_vector(31 downto 0);
  signal sh5 : std_logic_vector(31 downto 0);
  signal signv : std_logic_vector(15 downto 0);
begin
  signv <= (others => a(31));
  sh1 <=  a when b(0) = '0' else
          a(30 downto 0) & "0" when op = "00" else
          "0" & a(31 downto 1) when op = "01" else
          signv(0 downto 0) & a(31 downto 1) when op = "11" else
          UNDEF32;
  sh2 <=  sh1 when b(0) = '0' else
          sh1(29 downto 0) & "00" when op = "00" else
          "00" & sh1(31 downto 2) when op = "01" else
          signv(1 downto 0) & sh1(31 downto 2) when op = "11" else
          UNDEF32;
  sh3 <=  sh2 when b(0) = '0' else
          sh2(27 downto 0) & "0000" when op = "00" else
          "0000" & sh2(31 downto 4) when op = "01" else
          signv(3 downto 0) & sh2(31 downto 4) when op = "11" else
          UNDEF32;
  sh4 <=  sh3 when b(0) = '0' else
          sh3(23 downto 0) & X"00" when op = "00" else
          X"00" & sh3(31 downto 8) when op = "01" else
          signv(7 downto 0) & sh3(31 downto 8) when op = "11" else
          UNDEF32;
  sh5 <=  sh4 when b(0) = '0' else
          sh4(15 downto 0) & X"0000" when op = "00" else
          X"0000" & sh4(31 downto 16) when op = "01" else
          signv & sh4(31 downto 16) when op = "11" else
          UNDEF32;
  q <= sh5;
end rtl;