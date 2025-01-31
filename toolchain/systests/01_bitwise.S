  .global t01_bitwise
t01_bitwise:
  li t0, 40071
  li t1, 18323
  and a0, t0, t1
  or a1, t0, t1
  xor a2, t0, t1

  li t2, 1155
  bne a0, t2, fail
  li t2, 57239
  bne a1, t2, fail
  li t2, 56084
  bne a2, t2, fail

  andi a0, t0, 23
  ori a1, t0, 23
  xori a2, t0, 23
  xori a3, t0, -1

  li t2, 7
  bne a0, t2, fail
  li t2, 40087
  bne a1, t2, fail
  li t2, 40080
  bne a2, t2, fail
  li t2, -40072
  bne a3, t2, fail

  ret
fail:
  jr x0