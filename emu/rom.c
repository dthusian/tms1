#include<stdint.h>
#include<stdio.h>
#include<stdlib.h>
#include"vhpi_user.h"
#include"ffi_util.h"

FILE* rom_fp = NULL;

__attribute__((constructor)) void rom_open() {
  rom_fp = fopen("rom.bin", "rb");
}

uint32_t rom_read(uint32_t addr) {
  fseek(rom_fp, addr, SEEK_SET);
  uint8_t buf[4];
  fread(buf, 1, 4, rom_fp);
  uint32_t data = buf[0] | ((uint32_t)buf[1] << 8) | ((uint32_t)buf[2] << 16) | ((uint32_t)buf[3] << 24);
  return data;
}