library ieee;
use ieee.std_logic_1164.all;
use work.cpu_parts.all;

entity cpu is port (
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
end entity;

architecture rtl of cpu is
  -- contains an instruction latch to preserve the instruction
  -- while the memory bus is used for load/store
  component instr_fetch port (
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
  end component;
  
  -- purely combinational
  component instr_decoder port (
    instr : in std_logic_vector(31 downto 0);

    invalid_instr: out std_logic;
    opcode : out std_logic_vector(6 downto 0);
    rs1 : out std_logic_vector(4 downto 0);
    rs2 : out std_logic_vector(4 downto 0);
    rd : out std_logic_vector(4 downto 0);
    funct3 : out std_logic_vector(2 downto 0);
    funct7 : out std_logic_vector(6 downto 0);
    imm : out std_logic_vector(31 downto 0)
  );
  end component;

  -- contains a state machine that allows it to handle
  -- multi-cycle instructions
  component control_unit port (
    clk : in std_logic;
    init : in std_logic;

    opcode : in std_logic_vector(6 downto 0);

    -- 1: bus3 will be written to regfile on next clock
    reg_write_en : out std_logic;
    -- 00: rs1 value 
    -- 01: pc
    -- 10: zero
    bus1_mux : out std_logic_vector(1 downto 0);
    -- 0: rs2 value
    -- 1: imm value
    bus2_mux : out std_logic;
    -- 0: alu
    -- 1: load/store unit
    bus3_mux : out std_logic;
    -- 1: reads from memory
    mem_read_en : out std_logic;
    -- 1: writes to memory
    mem_write_en : out std_logic;
    -- see mem_size in cpu
    mem_size : out std_logic_vector(1 downto 0);
    -- if currently fetching an instr
    mem_ifetch : out std_logic;
    -- 1: sign extend the thing you get from the memory
    lsu_signed : out std_logic;
    -- 00: pc
    -- 01: pc + 4
    -- 10: bus3
    -- 11: if branch unit says yes, bus3, otherwise, pc + 4
    npc_mux : out std_logic_vector(1 downto 0);
    alu_opr : out std_logic
  );
  end component;

  -- contains a register file (state)
  component reg_file port (
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
  end component;

  -- purely combinational
  component alu port (
    opr : in std_logic;
    funct3 : in std_logic_vector(2 downto 0);
    funct7 : in std_logic_vector(6 downto 0);
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);
    q : in std_logic_vector(31 downto 0)
  );
  end component;

  -- purely combinational
  component load_store_unit port (
    -- sign-extension of load values
    mem_read : in std_logic_vector(31 downto 0);
    lsu_signed : in std_logic;
    load_value : out std_logic_vector(31 downto 0)
  );
  end component load_store_unit;

  -- purely combinational
  component branch_unit port (
    funct3 : in std_logic_vector(2 downto 0);
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);

    branch: out std_logic
  );
  end component branch_unit;

  -- trap signals
  signal trap_invalid_instr : std_logic;
  signal trap_memory_fault : std_logic;

  -- instr decode signals
  signal id_opcode : std_logic_vector(6 downto 0);
  signal id_rs1 : std_logic_vector(4 downto 0);
  signal id_rs2 : std_logic_vector(4 downto 0);
  signal id_rd : std_logic_vector(4 downto 0);
  signal id_funct3 : std_logic_vector(2 downto 0);
  signal id_funct7 : std_logic_vector(6 downto 0);
  signal id_imm : std_logic_vector(31 downto 0);

  -- control unit signals
  signal cu_reg_write_en : std_logic;
  signal cu_bus1_mux : std_logic_vector(1 downto 0);
  signal cu_bus2_mux : std_logic;
  signal cu_bus3_mux : std_logic;
  signal cu_latch_instr : std_logic;
  signal cu_lsu_signed : std_logic;
  signal cu_npc_mux : std_logic_vector(1 downto 0);
  signal cu_alu_opr : std_logic;

  -- busses
  signal instr : std_logic_vector(31 downto 0);
  signal pc : std_logic_vector(31 downto 0);
  signal pc_inc : std_logic_vector(31 downto 0);
  signal next_pc : std_logic_vector(31 downto 0);
  signal rs1_val : std_logic_vector(31 downto 0);
  signal rs2_val : std_logic_vector(31 downto 0);
  signal bus1 : std_logic_vector(31 downto 0);
  signal bus2 : std_logic_vector(31 downto 0);
  signal bus3 : std_logic_vector(31 downto 0);
  signal alu_out : std_logic_vector(31 downto 0);
  signal lsu_out : std_logic_vector(31 downto 0);

  -- misc
  signal branch_out : std_logic;
  signal branch_pc : std_logic_vector(31 downto 0);

  constant UNDEF32 : std_logic_vector(31 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
begin
  trap_memory_fault <= mem_fault;

  -- assign busses
  with cu_bus1_mux select bus1 <=
    rs1_val when "00",
    pc when "01",
    X"00000000" when "10",
    X"00000000" when "11",
    UNDEF32 when others;
  with cu_bus2_mux select bus2 <=
    rs2_val when '0',
    id_imm when '1',
    UNDEF32 when others;
  with cu_bus3_mux select bus3 <=
    alu_out when '0',
    lsu_out when '1',
    UNDEF32 when others;
  with branch_out select branch_pc <=
    pc_inc when '0',
    bus3 when '1',
    UNDEF32 when others;
  with cu_npc_mux select next_pc <=
    pc when "00",
    pc_inc when "01",
    bus3 when "10",
    branch_pc when "11",
    UNDEF32 when others;

  instr_fetch_inst: instr_fetch port map(
    clk,
    init,

    pc,
    pc_inc,
    next_pc,

    mem_rdata,
    cu_latch_instr,
    instr
  );

  instr_decoder_inst: instr_decoder port map(
    instr,

    trap_invalid_instr,
    id_opcode,
    id_rs1,
    id_rs2,
    id_rd,
    id_funct3,
    id_funct7,
    id_imm
  );
  
  control_unit_inst: control_unit port map(
    clk,
    init,

    id_opcode,

    cu_reg_write_en,
    cu_bus1_mux,
    cu_bus2_mux,
    cu_bus3_mux,
    mem_read_en,
    mem_write_en,
    mem_size,
    cu_latch_instr,
    cu_lsu_signed,
    cu_npc_mux,
    cu_alu_opr
  );

  reg_file_inst: reg_file port map(
    clk,
    init,

    id_rs1,
    id_rs2,
    id_rd,

    rs1_val,
    rs2_val,
    bus3,
    cu_reg_write_en
  );

  alu_inst: alu port map(
    cu_alu_opr,
    id_funct3,
    id_funct7,
    bus1,
    bus2,
    alu_out
  );

  load_store_unit_inst: load_store_unit port map(
    mem_rdata,
    cu_lsu_signed,
    lsu_out
  );

  branch_unit_inst: branch_unit port map(
    id_funct3,
    rs1_val,
    rs2_val,
    branch_out
  );
end rtl;