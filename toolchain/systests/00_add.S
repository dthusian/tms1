  .global t00_add
t00_add:
  li t0, 510
  li t1, 999
  add t2, t0, t1
  li t3, 1509
  bne t2, t3, fail

  li t0, 5122
  addi t2, t0, 344
  li t3, 5466
  bne t2, t3, fail

  li t0, 205
  li t1, 184
  sub t2, t1, t0
  li t3, -21
  bne t2, t3, fail

  ret
fail:
  jr x0