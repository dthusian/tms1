#ifndef FFI_UTIL_H
#define FFI_UTIL_H

#include<stdint.h>
#include<stddef.h>
#include<string.h>
#include"vhpi_user.h"

static const char std_logic_char[] = { 'U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-'};
enum std_logic_states {
  HDL_U = vhpiU,         /* uninitialized */
  HDL_X = vhpiX,         /* unknown */
  HDL_0 = vhpi0,         /* forcing 0 */
  HDL_1 = vhpi1,         /* forcing 1 */
  HDL_Z = vhpiZ,         /* high impedance */
  HDL_W = vhpiW,         /* weak unknown */
  HDL_L = vhpiL,         /* weak 0 */
  HDL_H = vhpiH,         /* weak 1 */
  HDL_D = vhpiDontCare   /* don't care */
};
typedef uint8_t std_logic;

static int logic_to_bool(std_logic logic) {
  return logic == HDL_1 || logic == HDL_H;
}

static uint32_t logic_to_u8(const std_logic* logic) {
  uint32_t ret = 0;
  for(size_t i = 0; i < 8; i++) {
    if(logic_to_bool(logic[i])) {
      ret |= 1 << (7 - i);
    }
  }
  return ret;
}

static void u8_to_logic(std_logic* logic, uint8_t v) {
  for(size_t i = 0; i < 8; i++) {
    if(v & (1 << (7 - i))) {
      logic[i] = HDL_1;
    } else {
      logic[i] = HDL_0;
    }
  }
}

static uint32_t logic_to_u32(const std_logic* logic) {
  uint32_t ret = 0;
  for(size_t i = 0; i < 32; i++) {
    if(logic_to_bool(logic[i])) {
      ret |= 1 << (31 - i);
    }
  }
  return ret;
}

static void u32_to_logic(std_logic* logic, uint32_t v) {
  for(size_t i = 0; i < 32; i++) {
    if(v & (1 << (31 - i))) {
      logic[i] = HDL_1;
    } else {
      logic[i] = HDL_0;
    }
  }
}

static void cstr_to_logic(char* s, std_logic* logic) {
  size_t len = strlen(s);
  for(size_t i = 0; i < len; i++) {
    switch(s[i]) {
      case 'U':
        logic[i] = HDL_U;
        break;
      case '0':
        logic[i] = HDL_0;
        break;
      case '1':
        logic[i] = HDL_1;
        break;
      case 'Z':
        logic[i] = HDL_Z;
        break;
      case 'W':
        logic[i] = HDL_W;
        break;
      case 'L':
        logic[i] = HDL_L;
        break;
      case 'H':
        logic[i] = HDL_H;
        break;
      case 'D':
        logic[i] = HDL_D;
        break;
      default:
        logic[i] = HDL_X;
    }
  }
}

#endif