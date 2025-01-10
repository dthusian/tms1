#include"bus.h"
#include"uart.h"
#include<stdint.h>
#include<stdlib.h>
#include<stdio.h>
#include<errno.h>
#include<pthread.h>

// emulates config registers as ignored read/writable memory

struct uart_state_t {
  // register state
  uint8_t regs[8];
  uint8_t dl[2];
  int cycle;

  // stdin read thread state
  pthread_t read_thread;
  pthread_mutex_t mutex;
  pthread_cond_t empty;
  char read_ch;
} state;

void* uart_read_thread(void*) {
  pthread_mutex_lock(&state.mutex);
  while(1) {
    printf("locked\n");
    pthread_cond_wait(&state.empty, &state.mutex);
    state.read_ch = getchar();
  }
  return NULL;
}

void uart_init() {
  state = (struct uart_state_t) {
    .regs = { },
    .dl = { },
    .cycle = 0
  };
  pthread_create(&state.read_thread, NULL, uart_read_thread, NULL);
  pthread_mutex_init(&state.mutex, NULL);
  pthread_cond_init(&state.empty, NULL);
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
  /*
  // if DR is still set, don't try to read more
  if(!(state.regs[5] & 0x1)) {
    char buf;
    if(read(STDIN_FILENO, &buf, 1)) {
      // set DR if char available
      state.regs[5] |= 1;
      state.regs[0] = buf;
      return 1;
    }
  }*/
  return 0;
}

int uart_read(uint32_t offset, uint32_t* val, int size) {
  if(size != SIZE_8B) {
    return 1;
  }
  if(offset >= 8) {
    return 1;
  }
  //printf("read %d %d\n", offset, size);

  if((state.regs[3] & 0x80) && offset < 2) {
    *val = state.dl[offset];
  } else if(offset == 0) {
    int code = pthread_mutex_trylock(&state.mutex);
    if(code == EBUSY) {
      *val = 0;
    } else {
      *val = state.read_ch;
      pthread_mutex_unlock(&state.mutex);
      pthread_cond_signal(&state.empty);
    }
  } else if(offset == 5) {
    // if the mutex can be locked, then there is a byte present
    int code = pthread_mutex_trylock(&state.mutex);
    if(code == EBUSY) {
      *val = 0;
    } else {
      *val = 1;
      pthread_mutex_unlock(&state.mutex);
    }
  } else {
    *val = state.regs[offset];
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