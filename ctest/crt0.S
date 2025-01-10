  .section .init
  .global _start
_start:
  .option push
  .option norelax
  la gp, __global_pointer
  .option pop
  la sp, __stack_top
  la t0, __bss_start
  la t1, __bss_end
  bgeu t0, t1, bssloop_end
bssloop:
  sw x0, (t0)
  addi t0, t0, 4
  bltu t0, t1, bssloop
bssloop_end:

  jal main
spin:
  j spin