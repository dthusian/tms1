#ifndef UART_H
#define UART_H

#include<stdint.h>

// Initializes the emulated UART
void uart_init();

// Returns true to interrupt the CPU
int uart_cycle();

// Returns 0 on succcess
int uart_read(uint32_t offset, uint32_t* val, int size);

// Returns 0 on success
int uart_write(uint32_t offset, uint32_t val, int size);

#endif // UART_H