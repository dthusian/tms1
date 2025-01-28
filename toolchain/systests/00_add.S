  .global t00_add
t00_add:
  li t0, 510
  li t1, 999
  addi t2, t0, t1
  li t3, 1509
  beq br0, t2, t3
  jr x0
br0:

  ret