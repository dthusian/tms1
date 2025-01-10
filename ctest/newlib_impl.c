#include <sys/stat.h>
#include <errno.h>
#undef errno
extern int errno;

volatile char* uart = (void*)0x30000000;

int _close(int file) {
  return -1;
}

int _read(int file, char *ptr, int len) {
  if(file == 0) {
    for(int i = 0; i < len; i++) {
      while(1) {
        int rdy = uart[5] & 0x1;
        if(rdy) break;
      }
      ptr[i] = *uart;
    }
    return len;
  } else {
    return 0;
  }
}

int _write(int file, char *ptr, int len) {
  if(file == 1 || file == 2) {
    for(int i = 0; i < len; i++) {
      *uart = ptr[i];
    }
    return len;
  }
  return 0;
}

int _fstat(int file, struct stat *st) {
  st->st_mode = S_IFCHR;
  return 0;
}

int _isatty(int file) {
  return 1;
}

int _lseek(int file, int ptr, int dir) {
  return 0;
}

caddr_t _sbrk(int incr) {
  extern char __stack_top;
  static char *heap_end;
  char *prev_heap_end;
 
  if (heap_end == 0) {
    heap_end = &__stack_top;
  }
  prev_heap_end = heap_end;

  heap_end += incr;
  return (caddr_t) prev_heap_end;
}

int _kill(int pid, int sig) {
  errno = EINVAL;
  return -1;
}

void _exit(int code) {
  while(1);
}

int _getpid() {
  return 1;
}