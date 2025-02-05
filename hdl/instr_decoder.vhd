library ieee;
use ieee.std_logic_1164.all;
use work.opcodes.all;

entity instr_decoder is port (
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
end entity;

architecture rtl of instr_decoder is
  signal imm_r : std_logic_vector(31 downto 0);
  signal imm_i : std_logic_vector(31 downto 0);
  signal imm_s : std_logic_vector(31 downto 0);
  signal imm_u : std_logic_vector(31 downto 0);
  signal imm_b : std_logic_vector(31 downto 0);
  signal imm_j : std_logic_vector(31 downto 0);
begin
  opcode <= instr(6 downto 0);
  rs1 <= instr(19 downto 15);
  rs2 <= instr(24 downto 20);
  rd <= instr(11 downto 7);
  funct3 <= instr(14 downto 12);
  funct7 <= instr(31 downto 25);

  -- immediate decoding
  imm_u <= instr(31 downto 12) & X"000";
  imm_j(31 downto 20) <= (others => instr(31));
  imm_j(19 downto 12) <= instr(19 downto 12);
  imm_j(11) <= instr(20);
  imm_j(10 downto 1) <= instr(30 downto 21);
  imm_j(0) <= '0';
  imm_i(31 downto 12) <= (others => instr(31));
  imm_i(11 downto 0) <= instr(31 downto 20);
  imm_b(31 downto 12) <= (others => instr(31));
  imm_b(11) <= instr(7);
  imm_b(10 downto 5) <= instr(30 downto 25);
  imm_b(4 downto 1) <= instr(11 downto 8);
  imm_b(0) <= '0';
  imm_s(31 downto 12) <= (others => instr(31));
  imm_s(11 downto 5) <= instr(31 downto 25);
  imm_s(4 downto 0) <= instr(11 downto 7);
  
  imm <= imm_u when opcode = OP_LUI or opcode = OP_AUIPC else
         imm_j when opcode = OP_JAL else
         imm_i when opcode = OP_JALR or opcode = OP_OPIMM or opcode = OP_LOAD else
         imm_b when opcode = OP_BRANCH else
         imm_s when opcode = OP_STORE else
         X"00000000";

  -- invalid instr handling
  invalid_instr <= '0' when
    opcode = OP_LUI or opcode = OP_AUIPC or
    (opcode = OP_JALR and funct3 = "000") or
    (opcode = OP_BRANCH and funct3 /= "010" and funct3 /= "011") or
    (opcode = OP_LOAD and funct3 /= "011" and funct3 /= "110" and funct3 /= "111") or
    (opcode = OP_STORE and (funct3 = "000" or funct3 = "001" or funct3 = "010")) or
    (opcode = OP_OPIMM and funct3 /= FN_SLL and funct3 /= FN_SRL) or
    (opcode = OP_OPIMM and funct3 = FN_SLL and funct7 = "0000000") or
    (opcode = OP_OPIMM and funct3 = FN_SRL and (funct7 = "0000000" or funct7 = "0100000")) or
    (opcode = OP_OP and (
      funct7 = "0000000" or funct7 = "0000001" or
      (funct7 = "0100000" and (funct3 = FN_SUB or funct3 = FN_SRA))
    )) or
    opcode = OP_FENCE or
    opcode = OP_SYSTEM
    else '1';
end rtl;