library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is port (
  clk : in std_logic;
  init : in std_logic;

  rs1 : in std_logic_vector(4 downto 0);
  rs2 : in std_logic_vector(4 downto 0);
  rd : in std_logic_vector(4 downto 0);

  rs1_val : out std_logic_vector(31 downto 0);
  rs2_val : out std_logic_vector(31 downto 0);
  rd_val : in std_logic_vector(31 downto 0);
  rd_write : in std_logic
);
end entity;

architecture rtl of reg_file is
  type regs is array(1 to 31) of std_logic_vector(31 downto 0);
  signal regfile : regs;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      for i in 1 to 31 loop
        if init = '1' then
          regfile(i) <= X"00000000";
        elsif i = unsigned(rd) and rd_write = '1' then
          -- reg writeback
          regfile(i) <= rd_val;
        end if;
      end loop;
    end if;
  end process;

  -- reg read
  process(all)
  begin
    if rs1 = "00000" then
      rs1_val <= X"00000000";
    end if;
    if rs2 = "00000" then
      rs2_val <= X"00000000";
    end if;

    for i in 1 to 31 loop
      if i = unsigned(rs1) then
        rs1_val <= regfile(i);
      end if;
      if i = unsigned(rs2) then
        rs2_val <= regfile(i);
      end if;
    end loop;
  end process;
end rtl;