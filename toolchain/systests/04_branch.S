  .global t04_branch
t04_branch:
  
  li t0, -1
  li t1, 1

  bne t0, t1, br0
  j fail
br0:
  beq t0, t1, fail
  ble t0, t1, br1
  j fail
br1:
  blt t0, t1, br2
  j fail
br2:
  bgt t0, t1, fail
  bge t0, t1, fail
  bltu t0, t1, fail
  bleu t0, t1, fail
  bgtu t0, t1, br3
  j fail
br3:
  bgeu t0, t1, br4
  j fail
br4:
  ret

fail:
  jr x0