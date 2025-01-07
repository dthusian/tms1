#include"ffi_util.h"
#include"bus.h"
#include"uart.h"
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<stdint.h>

void* mem_bootrom;
void* mem_dram;

static int read_ptr(void* ptr, uint32_t offset, uint32_t* val, int size) {
  void* p = ptr + offset;
  if(size == SIZE_8B) {
    *val = *(uint8_t*)p;
  } else if(size == SIZE_16B) {
    *val = *(uint16_t*)p;
  } else if(size == SIZE_32B) {
    *val = *(uint32_t*)p;
  } else {
    return 1;
  }
  return 0;
}

static int write_ptr(void* ptr, uint32_t offset, uint32_t val, int size) {
  void* p = ptr + offset;
  if(size == SIZE_8B) {
    *(uint8_t*)p = val;
  } else if(size == SIZE_16B) {
    *(uint16_t*)p = val;
  } else if(size == SIZE_8B) {
    *(uint32_t*)p = val;
  } else {
    return 1;
  }
  return 0;
}

// 1 on failure, 0 on success
static int read_memory(uint32_t addr, uint32_t* val, int size) {
  if(addr >= BOOTROM_BASE && addr < BOOTROM_BASE + BOOTROM_SIZE) {
    return read_ptr(mem_bootrom, addr - BOOTROM_BASE, val, size);
  } else if(addr >= DRAM_BASE && addr < DRAM_BASE + DRAM_SIZE) {
    return read_ptr(mem_dram, addr - DRAM_BASE, val, size);
  } else if(addr >= UART_BASE && addr < UART_BASE + UART_SIZE) {
    return uart_read(addr - UART_BASE, val, size);
  } else {
    return 1;
  }
}

static int write_memory(uint32_t addr, uint32_t val, int size) {
  if(addr >= BOOTROM_BASE && addr < BOOTROM_BASE + BOOTROM_SIZE) {
    return write_ptr(mem_bootrom, addr - BOOTROM_BASE, val, size);
  } else if(addr >= DRAM_BASE && addr < DRAM_BASE + DRAM_SIZE) {
    return write_ptr(mem_dram, addr - DRAM_BASE, val, size);
  } else if(addr >= UART_BASE && addr < UART_BASE + UART_SIZE) {
    return uart_write(addr - UART_BASE, val, size);
  } else {
    return 1;
  }
}

void bus_init() {
  mem_bootrom = malloc(BOOTROM_SIZE);
  memset(mem_bootrom, 0, BOOTROM_SIZE);
  FILE* bootrom = fopen("rom.bin", "rb");
  if(bootrom != NULL) {
    fread(mem_bootrom, 1, BOOTROM_SIZE, bootrom);
    fclose(bootrom);
  } else {
    fprintf(stderr, "bus: error: no bootrom");
    exit(1);
  }

  mem_dram = malloc(DRAM_SIZE);
  memset(mem_dram, 0, DRAM_SIZE);
  FILE* kernel_img = fopen("kernel.bin", "rb");
  if(kernel_img != NULL) {
    size_t s = fread(mem_dram, 1, DRAM_SIZE, kernel_img);
    fclose(kernel_img);
    fprintf(stderr, "bus: info: kernel loaded to %x with size %x", DRAM_BASE, s);
  } else {
    fprintf(stderr, "bus: warning: failed to read kernel image\n");
  }

  uart_init();
}

// read/write from perspective of CPU
void bus_cycle(
  const std_logic* addr, // 32b
  std_logic* rdata, // 32b
  const std_logic* wdata, // 32b

  const std_logic* size, // 2b, 00 = 8, 01 = 16, 10 = 32
  const std_logic write, // 1b (non-vector), 0 = read, 1 = write
  std_logic* fault // 1b, 0 = normal, 1 = fault
) {
  uart_cycle();

  int size_int = 0;
  if(logic_to_bool(size[0])) {
    size_int |= 2;
  }
  if(logic_to_bool(size[1])) {
    size_int |= 1;
  }

  uint32_t addr2 = logic_to_u32(addr);
  int fail = 0;
  if(logic_to_bool(write)) {
    uint32_t data = logic_to_u32(wdata);
    fail = write_memory(addr2, data, size_int);
    for(int i = 0; i < 32; i++) rdata[i] = HDL_X;
  } else {
    uint32_t data = 0;
    fail = read_memory(addr2, &data, size_int);
    u32_to_logic(rdata, data);
  }

  if(fail) {
    *fault = HDL_1;
  } else {
    *fault = HDL_0;
  }
}