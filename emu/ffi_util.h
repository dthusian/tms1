#ifndef FFI_UTIL_H
#define FFI_UTIL_H

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

static uint32_t logic_to_u32(uint8_t* logic) {
  uint32_t ret = 0;
  for(unsigned int i = 0; i < 32; i++) {
    if(logic[i] == HDL_1 || logic[i] == HDL_H) {
      ret |= 1 << (31 - i);
    }
  }
  return ret;
}

static void u32_to_logic(uint8_t* logic, uint32_t v) {
  for(unsigned int i = 0; i < 32; i++) {
    if(v & (1 << (31 - i))) {
      logic[i] = HDL_1;
    } else {
      logic[i] = HDL_0;
    }
  }
}

#endif