library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_fetch is port (
  clk : in std_logic;
  init : in std_logic;

  -- pc management
  pc : out std_logic_vector(31 downto 0);
  pc_inc : out std_logic_vector(31 downto 0);
  next_pc : in std_logic_vector(31 downto 0);

  -- instruction management
  instr_read : in std_logic_vector(31 downto 0);
  instr_latch : in std_logic;
  instr : out std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of instr_fetch is
  signal pc_reg : std_logic_vector(31 downto 0);
  signal instr_reg : std_logic_vector(31 downto 0);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      -- update PC
      if init then
        pc_reg <= X"10000000";
      else
        pc_reg <= next_pc;
      end if;

      -- update instruction
      if init then
        instr_reg <= X"00000013"; -- no-op
      elsif instr_latch then
        instr_reg <= instr_read;
      end if;
    end if;
  end process;

  pc_inc <= std_logic_vector(unsigned(pc) + 4);
  pc <= pc_reg;
  instr <= instr_read when instr_latch else instr_reg;
end rtl;