  .section .text
  .global main
main:
  li a0, 0
  la a1, data
  la a2, scratch
  li a3, 0
loop:
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

  add t0, a2, a3
  sw a0, (t0)
  addi a3, a3, 1
  andi a3, a3, 0xF

  j loop

  .section .data
data:
  .byte 0x11
  .byte 0x33
  .byte 0x55
  .byte 0x77
  .byte 0x99
  .byte 0xbb
  .byte 0xdd
  .byte 0xff

  .section .bss
scratch:
  .skip 20,0x00