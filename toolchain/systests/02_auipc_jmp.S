  .global t02_auipc_jmp
t02_auipc_jmp:
  la t0, jmpto
  li t1, 0
  jalr a0, t0

jmpto3:
  j jmpto4

  li t1, 1
jmpto:
  j jmpto2
  li t1, 1
jmpto2:
  jal a1, jmpto3
  li t1, 1

jmpto4:
  bnez t1, fail
  la t0, jmpto3
  la t1, jmpto2
  addi a1, a1, -4
  bne t0, a0, fail
  bne t1, a1, fail

  ret
fail:
  jr x0