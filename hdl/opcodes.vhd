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

  constant FN_ADD  : std_logic_vector(2 downto 0) := "000";
  constant FN_SLT  : std_logic_vector(2 downto 0) := "010";
  constant FN_SLTU : std_logic_vector(2 downto 0) := "011";
  constant FN_XOR  : std_logic_vector(2 downto 0) := "100";
  constant FN_OR   : std_logic_vector(2 downto 0) := "110";
  constant FN_AND  : std_logic_vector(2 downto 0) := "111";
  constant FN_SLL  : std_logic_vector(2 downto 0) := "001";
  constant FN_SRL  : std_logic_vector(2 downto 0) := "101";

end opcodes;