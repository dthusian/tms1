library ieee;
use ieee.std_logic_1164.all;

package opcodes is

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

  -- funct7 = "0000000"
  constant F7_OP1  : std_logic_vector(6 downto 0) := "0000000";
  constant FN_ADD  : std_logic_vector(2 downto 0) := "000";
  constant FN_SLT  : std_logic_vector(2 downto 0) := "010";
  constant FN_SLTU : std_logic_vector(2 downto 0) := "011";
  constant FN_XOR  : std_logic_vector(2 downto 0) := "100";
  constant FN_OR   : std_logic_vector(2 downto 0) := "110";
  constant FN_AND  : std_logic_vector(2 downto 0) := "111";
  constant FN_SLL  : std_logic_vector(2 downto 0) := "001";
  constant FN_SRL  : std_logic_vector(2 downto 0) := "101";

  -- funct7 = "0100000"
  constant F7_OP2  : std_logic_vector(6 downto 0) := "0100000";
  constant FN_SUB  : std_logic_vector(2 downto 0) := "000";
  constant FN_SRA  : std_logic_vector(2 downto 0) := "101";

  -- funct7 = "0000001"
  constant F7_MULDIV : std_logic_vector(6 downto 0) := "0000001";
  constant FN_MUL    : std_logic_vector(2 downto 0) := "000";
  constant FN_MULH   : std_logic_vector(2 downto 0) := "001";
  constant FN_MULHSU : std_logic_vector(2 downto 0) := "010";
  constant FN_MULHU  : std_logic_vector(2 downto 0) := "011";
  constant FN_DIV    : std_logic_vector(2 downto 0) := "100";
  constant FN_DIVU   : std_logic_vector(2 downto 0) := "101";
  constant FN_REM    : std_logic_vector(2 downto 0) := "110";
  constant FN_REMU   : std_logic_vector(2 downto 0) := "111";

  constant UNDEF32 : std_logic_vector(31 downto 0) := "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

  -- branch functs
  constant FN_BEQ  : std_logic_vector(2 downto 0) := "000";
  constant FN_BNE  : std_logic_vector(2 downto 0) := "001";
  constant FN_BLT  : std_logic_vector(2 downto 0) := "100";
  constant FN_BGE  : std_logic_vector(2 downto 0) := "101";
  constant FN_BLTU : std_logic_vector(2 downto 0) := "110";
  constant FN_BGEU : std_logic_vector(2 downto 0) := "111";

  -- load/store functs
  constant FN_MB  : std_logic_vector(2 downto 0) := "000";
  constant FN_MH  : std_logic_vector(2 downto 0) := "001";
  constant FN_MW  : std_logic_vector(2 downto 0) := "010";
  constant FN_MBU : std_logic_vector(2 downto 0) := "100";
  constant FN_MHU : std_logic_vector(2 downto 0) := "101";

end opcodes;