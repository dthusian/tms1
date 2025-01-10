#include"bus.h"
#include"uart.h"
#include<stdint.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<stdio.h>

// emulates config registers as ignored read/writable memory

struct uart_state_t {
  uint8_t regs[8];
  uint8_t dl[2];
  int cycle;
} state;

void uart_deinit() {
  fcntl(0, F_SETFL, fcntl(0, F_GETFL) & ~O_NONBLOCK);
}

void uart_init() {
  state = (struct uart_state_t) {
    .regs = { },
    .dl = { },
    .cycle = 0
  };

  fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);
  atexit(uart_deinit);
}

int uart_cycle() {
  // calling read() a lot can become a bottleneck, so make
  // the uart only poll every 1000 cycles
  state.cycle++;
  state.cycle %= 1000;
  if(state.cycle != 0) {
    return 0;
  }
  
  fflush(stdout);
  // if DR is still set, don't try to read more
  if(!(state.regs[5] & 0x1)) {
    char buf;
    if(read(STDIN_FILENO, &buf, 1)) {
      // set DR if char available
      state.regs[5] |= 1;
      state.regs[0] = buf;
      return 1;
    }
  }
  return 0;
}

int uart_read(uint32_t offset, uint32_t* val, int size) {
  if(size != SIZE_8B) {
    return 1;
  }
  if(offset >= 8) {
    return 1;
  }

  if((state.regs[3] | 0x80) && offset < 2) {
    *val = state.dl[offset];
  } else if(offset > 0) {
    *val = state.regs[offset];
  } else { // uart register
    *val = state.regs[0];
    // clear read buf and DR
    state.regs[0] = 0;
    state.regs[5] &= ~0x1;
  }
  return 0;
}

int uart_write(uint32_t offset, uint32_t val, int size) {
  if(size != SIZE_8B) {
    return 1;
  }
  if(offset >= 8) {
    return 1;
  }

  if((state.regs[3] & 0x80) && offset < 2) {
    state.dl[offset] = val;
  } else if(offset > 0) {
    state.regs[offset] = val;
  } else {
    putchar(val);
  }
  return 0;
}