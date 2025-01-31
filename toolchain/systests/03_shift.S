  .global t03_shift
t03_shift:
  li t0, 0xe9f96f52
  slli a0, t0, 14
  srli a1, t0, 14
  srai a2, t0, 14

  li t1, 25
  sll a3, t0, t1
  srl a4, t0, t1
  sra a5, t0, t1

  li t2, 0x5bd48000
  bne a0, t2, fail
  li t2, 0x3a7e5
  bne a1, t2, fail
  li t2, -0x581b
  bne a2, t2, fail
  li t2, 0xa4000000
  bne a3, t2, fail
  li t2, 0x74
  bne a4, t2, fail
  li t2, -12
  bne a5, t2, fail

  ret
fail:
  jr x0