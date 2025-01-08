library ieee;
use ieee.std_logic_1164.all;

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
  constant OP_LUI    : std_logic_vector(6 downto 0) := "0110111";
  constant OP_AUIPC  : std_logic_vector(6 downto 0) := "0010111";
  constant OP_JAL    : std_logic_vector(6 downto 0) := "1101111";
  constant OP_JALR   : std_logic_vector(6 downto 0) := "1100111";
  constant OP_BRANCH : std_logic_vector(6 downto 0) := "1100011";
  constant OP_LOAD   : std_logic_vector(6 downto 0) := "0000011";
  constant OP_STORE  : std_logic_vector(6 downto 0) := "0100011";
  constant OP_OP     : std_logic_vector(6 downto 0) := "0110011";
  constant OP_OPIMM  : std_logic_vector(6 downto 0) := "0010011";
  constant OP_FENCE  : std_logic_vector(6 downto 0) := "0001111";
  constant OP_SYSTEM : std_logic_vector(6 downto 0) := "1110011";
begin
  opcode <= instr(6 downto 0);
end rtl;