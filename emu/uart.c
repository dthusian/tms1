#include<stdio.h>
#include"ffi_util.h"

void uart_cycle(std_logic write_en, std_logic read_en, std_logic* data) {
  if(logic_to_bool(read_en)) {
    int chr = getc(stdin);
    uint8_t chr8 = (uint8_t)chr;
    u8_to_logic(data, chr8);
  } else if(logic_to_bool(write_en)) {
    int chr = logic_to_u8(data);
    putc(chr, stdout);
  } else {
    for(int i = 0; i < 8; i++) {
      data[i] = HDL_Z;
    }
  }
}