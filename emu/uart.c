#include"bus.h"
#include"uart.h"
#include<stdint.h>
#include<stdlib.h>
#include<stdio.h>
#include<errno.h>
#include<poll.h>
#include<unistd.h>

// returns 1 if poll succeeded
int poll_chr() {
  struct pollfd poll_fd;
  poll_fd.fd = STDIN_FILENO;
  poll_fd.events = POLLIN;
  poll_fd.revents = 0;
  int status = poll(&poll_fd, 1, 0);
  if(status < 0 || (poll_fd.revents & POLLERR) || (poll_fd.revents & POLLHUP) || (poll_fd.revents & POLLNVAL)) {
    printf("uart: error while polling");
    perror("poll");
    exit(1);
  }
  if(poll_fd.revents & POLLIN) return 1;
  else return 0;
}

// emulates config registers as ignored read/writable memory

struct uart_state_t {
  // register state
  uint8_t regs[8];
  uint8_t dl[2];
  int cycle;
} state;

void uart_init() {
  state = (struct uart_state_t) {
    .regs = { },
    .dl = { },
    .cycle = 0
  };
}

int uart_cycle() {
  return 0;
}

int uart_read(uint32_t offset, uint32_t* val, int size) {
  if(size != SIZE_8B) {
    return 1;
  }
  if(offset >= 8) {
    return 1;
  }

  if((state.regs[3] & 0x80) && offset < 2) {
    *val = state.dl[offset];
  } else if(offset == 0) {
    char c = 0;
    if(poll_chr()) {
      read(STDIN_FILENO, &c, 1);
    }
    *val = c;
  } else if(offset == 5) {
    *val = poll_chr();
  } else {
    *val = state.regs[offset];
  }
  return 0;
}

int uart_write(uint32_t offset, uint32_t val, int size) {
  if(size != SIZE_8B) {
    return 0;
  }
  if(offset >= 8) {
    return 0;
  }

  if((state.regs[3] & 0x80) && offset < 2) {
    state.dl[offset] = val;
  } else if(offset > 0) {
    state.regs[offset] = val;
  } else {
    putchar(val);
    fflush(stdout);
  }
  return 0;
}