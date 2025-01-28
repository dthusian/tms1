  .global t00_add
t00_add:
  li t0, 510
  li t1, 999
  add t2, t0, t1
  li t3, 1509
  beq t2, t3, br0
  jr x0
br0:

  ret