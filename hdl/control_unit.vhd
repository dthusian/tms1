library ieee;
use ieee.std_logic_1164.all;
use work.opcodes.all;

-- see cpu.vhd for documentation on this component
entity control_unit is port (
  clk : in std_logic;
  init : in std_logic;

  opcode : in std_logic_vector(6 downto 0);

  reg_write_en : out std_logic;
  bus1_mux : out std_logic_vector(1 downto 0);
  bus2_mux : out std_logic;
  reg_write_mux : out std_logic_vector(1 downto 0);
  mem_read_en : out std_logic;
  mem_write_en : out std_logic;
  mem_size : out std_logic_vector(1 downto 0);
  mem_ifetch : out std_logic;
  lsu_signed : out std_logic;
  npc_mux : out std_logic_vector(1 downto 0);
  alu_opr : out std_logic
);
end entity;

architecture rtl of control_unit is
  type cu_state is (
    -- instruction fetch and execute
    state_exec,
    -- memory cycle
    state_mem
  );
begin
  
end;