#include<stdio.h>
#include<stdint.h>
#include<stdlib.h>
#include"ffi_util.h"

static FILE* rom_fp = NULL;

void rom2_open() {
  if(rom_fp != NULL) {
    rom_fp = freopen("rom.bin", "rb", rom_fp);
  } else {
    rom_fp = fopen("rom.bin", "rb");
    if(rom_fp == NULL) {
      printf("ffi error: Failed to open ROM file");
      exit(1);
    }
  }
}

struct rom2_cycle_out {
  std_logic data_sl[32];
};

void rom2_cycle(const std_logic* addr_sl, std_logic* data_sl) {
  uint32_t addr = logic_to_u32(addr_sl);
  fseek(rom_fp, addr, SEEK_SET);
  uint8_t buf[4];
  fread(buf, 1, 4, rom_fp);
  uint32_t data = buf[0] | ((uint32_t)buf[1] << 8) | ((uint32_t)buf[2] << 16) | ((uint32_t)buf[3] << 24);
  u32_to_logic(data_sl, data);
}