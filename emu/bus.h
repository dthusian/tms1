#ifndef BUS_H
#define BUS_H

/*
Memory Map:
- 0x10000000 (2 MB): bootrom
- 0x20000000 (64 MB): dram with preloaded kernel image
- 0x30000000 (8 bytes): 8250 UART
*/

#define BOOTROM_BASE 0x10000000
#define BOOTROM_SIZE (1024*1024*2)
#define DRAM_BASE 0x20000000
#define DRAM_SIZE (1024*1024*128)
#define UART_BASE 0x30000000
#define UART_SIZE 8

#define SIZE_8B  0b00
#define SIZE_16B 0b01
#define SIZE_32B 0b10

#endif // BUS_H