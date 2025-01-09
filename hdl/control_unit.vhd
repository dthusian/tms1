library ieee;
use ieee.std_logic_1164.all;
use work.opcodes.all;

-- see cpu.vhd for documentation on this component
entity control_unit is port (
  clk : in std_logic;
  init : in std_logic;

  opcode : in std_logic_vector(6 downto 0);
  funct3 : in std_logic_vector(2 downto 0);

  reg_write_en : out std_logic;
  bus1_mux : out std_logic_vector(1 downto 0);
  bus2_mux : out std_logic;
  reg_write_mux : out std_logic_vector(1 downto 0);
  mem_addr_mux : out std_logic;
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

  signal current_state : cu_state;
  signal next_state : cu_state;
begin
  -- transition section
  process(clk)
  begin
    if rising_edge(clk) then
      if init = '1' then
        current_state <= state_exec;
      else
        current_state <= next_state;
      end if;
    end if;
  end process;

  -- transition
  next_state <= state_mem
    when current_state = state_exec and (opcode = OP_LOAD or opcode = OP_STORE) 
    else state_exec;

  -- output decoder
  process(all)
  begin
    case current_state is
      when state_exec =>

        case opcode is
          when OP_BRANCH | OP_LOAD | OP_STORE | OP_FENCE | OP_SYSTEM =>
            reg_write_en <= '0';
          when others =>
            reg_write_en <= '1';
        end case;

        case opcode is
          when OP_JALR | OP_LOAD | OP_STORE | OP_OP | OP_OPIMM =>
            bus1_mux <= "00";
          when OP_JAL | OP_AUIPC | OP_BRANCH =>
            bus1_mux <= "01";
          when OP_LUI =>
            bus1_mux <= "10";
          when others =>
            bus1_mux <= "XX";
        end case;

        bus2_mux <= '0' when opcode = OP_OP else '1';

        case opcode is
          when OP_LUI | OP_AUIPC | OP_OPIMM | OP_OP =>
            reg_write_mux <= "00";
          when OP_JAL | OP_JALR =>
            reg_write_mux <= "01";
          when others =>
            reg_write_mux <= "XX"; -- reg_write_en = false = don't care
        end case;

        mem_addr_mux <= '0';
        mem_read_en <= '1';
        mem_write_en <= '0';
        mem_size <= "10";
        mem_ifetch <= '1';
        lsu_signed <= '0'; -- dont care

        case opcode is
          when OP_LOAD | OP_STORE =>
            npc_mux <= "00"; -- stay on same pc for next mem cycle
          when OP_JAL | OP_JALR =>
            npc_mux <= "10";
          when OP_BRANCH =>
            npc_mux <= "11";
          when others =>
            npc_mux <= "01";
        end case;

        alu_opr <= '1' when opcode = OP_OP else '0';

      when state_mem =>

        reg_write_en <= '1' when opcode = OP_LOAD else '0';
        bus1_mux <= "00"; -- rs1
        bus2_mux <= '1'; -- imm
        reg_write_mux <= "10"; -- lsu out
        mem_addr_mux <= '1';
        mem_read_en <= '1' when opcode = OP_LOAD else '0';
        mem_write_en <= '1' when opcode = OP_STORE else '0';
        mem_size <= funct3(1 downto 0);
        mem_ifetch <= '0';
        lsu_signed <= funct3(2);
        npc_mux <= "01"; -- pc + 4
        alu_opr <= '0';

    end case;
  end process;
end;