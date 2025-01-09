  .section .init
  .global _start
_start:
  la a1, data
loop:
  li a0, 0
  lb t0, 0(a1)
  add a0, a0, t0
  lb t0, 7(a1)
  add a0, a0, t0
  lh t0, 2(a1)
  add a0, a0, t0
  lh t0, 4(a1)
  add a0, a0, t0
  lw t0, 0(a1)
  add a0, a0, t0
  lw t0, 4(a1)
  add a0, a0, t0
  j loop
data:
  .byte 0x11
  .byte 0x33
  .byte 0x55
  .byte 0x77
  .byte 0x99
  .byte 0xbb
  .byte 0xdd
  .byte 0xff