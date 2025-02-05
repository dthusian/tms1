  .macro TEST id, name
  li t1, 0x30000000
  li t0, \id / 10 + '0'
  sb t0, (t1)
  li t0, \id % 10 + '0'
  sb t0, (t1)
  li t0, '\n'
  sb t0, (t1)
  jal ra, \name
  .endm

  .global main
main:

  // tests go here

  TEST 00,t00_add
  TEST 01,t01_bitwise
  TEST 02,t02_auipc_jmp
  TEST 03,t03_shift
  TEST 04,t04_branch
  TEST 05,t05_mem
  TEST 06,t06_slt

  // tests don't go here

print_done:
  li t1, 0x30000000
  li t0, 0x656e6f64
  sb t0, (t1)
  srli t0, t0, 8
  sb t0, (t1)
  srli t0, t0, 8
  sb t0, (t1)
  srli t0, t0, 8
  sb t0, (t1)
  li t0, '\n'
  sb t0, (t1)
done:
  nop
  j done