library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ffi.all;

entity main is port (
  dummy: out boolean
);
end entity main;

architecture testbench of main is
  component cpu port (
    clk : in std_logic;
    init : in std_logic;
    syshalt : out std_logic;

    mem_addr : out std_logic_vector(31 downto 0);
    mem_rdata : in std_logic_vector(31 downto 0);
    mem_wdata : out std_logic_vector(31 downto 0);
    mem_size : out std_logic_vector(1 downto 0);
    mem_read_en : out std_logic;
    mem_write_en : out std_logic;
    mem_fault : in std_logic
  );
  end component;

  signal clk : std_logic;
  signal init : std_logic;
  signal syshalt : std_logic;
  signal mem_addr : std_logic_vector(31 downto 0);
  signal mem_rdata : std_logic_vector(31 downto 0);
  signal mem_wdata : std_logic_vector(31 downto 0);
  signal mem_size : std_logic_vector(1 downto 0);
  signal mem_write_en : std_logic;
  signal mem_read_en: std_logic;
  signal mem_fault: std_logic;
begin
  CPU_INST: cpu port map (
    clk,
    init,
    syshalt,
    mem_addr,
    mem_rdata,
    mem_wdata,
    mem_size,
    mem_read_en,
    mem_write_en,
    mem_fault
  );

  process
    variable tmp_mem_rdata : std_logic_vector(31 downto 0) := X"00000000";
    variable tmp_mem_fault : std_logic := '0';
  begin
    bus_init;
    clk <= '0';
    init <= '1';
    for i in 0 to 0 loop
      wait for 50 ns;
      clk <= '1';
      wait for 50 ns;
      clk <= '0';
    end loop;
    wait for 50 ns;
    init <= '0';
    while syshalt /= '1' loop
      -- turn off init
      init <= '0';
      -- rising edge triggers CPU
      clk <= '1';
      wait for 1 ns;
      -- initiate bus cycle after CPU
      bus_cycle(  
        mem_addr,
        tmp_mem_rdata,
        mem_wdata,
        mem_size,
        mem_write_en,
        mem_read_en,
        tmp_mem_fault
      );
      mem_rdata <= tmp_mem_rdata;
      mem_fault <= tmp_mem_fault;

      wait for 49 ns;
      clk <= '0';
      wait for 50 ns;
    end loop;
    wait;
  end process;
end;

