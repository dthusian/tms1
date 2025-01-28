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
  TEST 00,t00_add

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