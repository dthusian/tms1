  .global test
test:
  li t0, 727
  slli t1, t0, 1
  slli t1, t0, 3
  slli t1, t0, 5
  li t1, 9
  sll t1, t0, t1
  nop
  nop
  nop
  nop
  ret