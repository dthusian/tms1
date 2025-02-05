library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcodes.all;

entity alu is port (
  opr : in std_logic;
  override_add: in std_logic;
  funct3 : in std_logic_vector(2 downto 0);
  funct7 : in std_logic_vector(6 downto 0);
  a : in std_logic_vector(31 downto 0);
  b : in std_logic_vector(31 downto 0);
  q : out std_logic_vector(31 downto 0)
);
end entity;

architecture rtl of alu is
  -- returns true if the operation is a "basic alu op"
  -- i.e. is defined as a canonical OP-IMM variant and OP with funct7 = "0000000"
  impure function basic_op(f3 : std_logic_vector(2 downto 0)) return boolean is
  begin
    return funct3 = f3 and (opr = '0' or funct7 = F7_OP1);
  end;

  -- returns true if the operation is an "extended op"
  -- i.e. is opr, and matches a specific funct3, funct7
  impure function ext_op(f3 : std_logic_vector(2 downto 0); f7 : std_logic_vector(6 downto 0)) return boolean is
  begin
    return opr = '1' and funct3 = f3 and funct7 = f7;
  end;

  function slt(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
  begin
    if signed(va) < signed(vb) then
      return X"00000001";
    else
      return X"00000000";
    end if;
  end;

  function sltu(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
  begin
    if unsigned(va) < unsigned(vb) then
      return X"00000001";
    else
      return X"00000000";
    end if;
  end;

  function mul(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable c: unsigned(63 downto 0);
  begin
    c := unsigned(va) * unsigned(vb);
    return std_logic_vector(c(31 downto 0));
  end;

  function mulhu(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable c: unsigned(63 downto 0);
  begin
    c := unsigned(va) * unsigned(vb);
    return std_logic_vector(c(63 downto 32));
  end;

  function mulh(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable sgn: boolean;
    variable ua: std_logic_vector(31 downto 0);
    variable ub: std_logic_vector(31 downto 0);
    variable uc: std_logic_vector(31 downto 0);
    variable c: signed(31 downto 0);
  begin
    ua := std_logic_vector(abs(signed(va)));
    ub := std_logic_vector(abs(signed(vb)));
    sgn := signed(va) < 0 xor signed(vb) < 0;
    uc := mulhu(ua, ub);
    c := -signed(uc) when sgn else signed(uc);
    return std_logic_vector(c);
  end;

  function mulhsu(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable sgn: boolean;
    variable ua: std_logic_vector(31 downto 0);
    variable ub: std_logic_vector(31 downto 0);
    variable uc: std_logic_vector(31 downto 0);
    variable c: signed(31 downto 0);
  begin
    ua := std_logic_vector(abs(signed(va)));
    ub := vb;
    sgn := signed(va) < 0;
    uc := mulhu(ua, ub);
    c := -signed(uc) when sgn else signed(uc);
    return std_logic_vector(c);
  end;

  function divu(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable c: unsigned(31 downto 0);
  begin
    if vb = X"00000000" then
      return X"ffffffff";
    end if;
    c := unsigned(va) / unsigned(vb);
    return std_logic_vector(c);
  end;

  function div(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable sgn: boolean;
    variable ua: std_logic_vector(31 downto 0);
    variable ub: std_logic_vector(31 downto 0);
    variable uc: std_logic_vector(31 downto 0);
    variable c: signed(31 downto 0);
  begin
    if vb = X"00000000" then
      return X"ffffffff";
    end if;
    sgn := signed(va) < 0 xor signed(vb) < 0;
    ua := std_logic_vector(abs(signed(va)));
    ub := std_logic_vector(abs(signed(vb)));
    uc := divu(ua, ub);
    c := (-signed(uc)) when sgn else signed(uc);
    return std_logic_vector(c);
  end;

  function remu(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable c: unsigned(31 downto 0);
  begin
    if vb = X"00000000" then
      return va;
    end if;
    c := unsigned(va) rem unsigned(vb);
    return std_logic_vector(c);
  end;

  function rems(va : std_logic_vector(31 downto 0); vb : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable sgn: boolean;
    variable ua: std_logic_vector(31 downto 0);
    variable ub: std_logic_vector(31 downto 0);
    variable uc: std_logic_vector(31 downto 0);
    variable c: signed(31 downto 0);
  begin
    sgn := signed(va) < 0 xor signed(vb) < 0;
    ua := std_logic_vector(abs(signed(va)));
    ub := std_logic_vector(abs(signed(vb)));
    uc := remu(ua, ub);
    c := -signed(uc) when sgn else signed(uc);
    return std_logic_vector(c);
  end;

  component shifter port (
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(4 downto 0);
    -- 00: logic left shift
    -- 01: logic right shift
    -- 11: arith right shift
    op : in std_logic_vector(1 downto 0);
    q : out std_logic_vector(31 downto 0)
  );
  end component;

  signal shifter_op : std_logic_vector(1 downto 0);
  signal shifter_out : std_logic_vector(31 downto 0);
begin
  shifter_op <= "00" when basic_op(FN_SLL) else
                "01" when funct3 = FN_SRL and funct7 = F7_OP1 else
                "11" when funct3 = FN_SRA and funct7 = F7_OP2 else
                "10";

  shifter_inst: shifter port map(
    a,
    b(4 downto 0),
    shifter_op,
    shifter_out
  );

  q <=
      std_logic_vector(unsigned(a) + unsigned(b))
        when basic_op(FN_ADD) or override_add = '1' else
      std_logic_vector(unsigned(a) - unsigned(b))
        when ext_op(FN_SUB, F7_OP2) else
      a and b
        when basic_op(FN_AND) else
      a or b
        when basic_op(FN_OR) else
      a xor b
        when basic_op(FN_XOR) else
      shifter_out
        when basic_op(FN_SLL) or (funct3 = FN_SRL and (funct7 = F7_OP1 or funct7 = F7_OP2)) else
      slt(a, b)
        when basic_op(FN_SLT) else
      sltu(a, b)
        when basic_OP(FN_SLTU) else
      mul(a, b)
        when ext_op(FN_MUL, F7_MULDIV) else
      mulh(a, b)
        when ext_op(FN_MULH, F7_MULDIV) else    
      mulhu(a, b)
        when ext_op(FN_MULHU, F7_MULDIV) else
      mulhsu(a, b)
        when ext_op(FN_MULHSU, F7_MULDIV) else
      div(a, b)
        when ext_op(FN_DIV, F7_MULDIV) else
      divu(a, b)
        when ext_op(FN_DIVU, F7_MULDIV) else
      rems(a, b)
        when ext_op(FN_REM, F7_MULDIV) else
      remu(a, b)
        when ext_op(FN_REMU, F7_MULDIV) else
      X"00000000";
end rtl;