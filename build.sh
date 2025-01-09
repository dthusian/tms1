#!/bin/bash

cd "$(dirname "$0")"

GHDL="ghdl"
GHDL_FLAGS="--std=08"

CC="cc"
CFLAGS="-O2 -std=c11"

AR="ar"

BUILD_DIR="build/"
HDL_DIR="hdl/"
HDL_FILES="
hdl/ffi.vhd
hdl/main.vhd hdl/opcodes.vhd
hdl/instr_decoder.vhd
hdl/instr_fetch.vhd
hdl/cpu.vhd
hdl/alu.vhd
hdl/control_unit.vhd
hdl/shifter.vhd
hdl/reg_file.vhd"
EMU_DIR="emu/"

set -e

build_dir() {
  set -e
  mkdir -p "$BUILD_DIR"
}

analyze() {
  set -e
  for F in $HDL_FILES ; do
    printf "GHDL_A $F\n"
  done
  "$GHDL" -a "--workdir=$BUILD_DIR" $GHDL_FLAGS $HDL_FILES
}

elaborate() {
  set -e
  printf "GHDL_E $1\n"
  "$GHDL" -e "--workdir=$BUILD_DIR" "-Wl,$BUILD_DIR/ffi.a" -o "$BUILD_DIR/$1" $GHDL_FLAGS $1
}

build_ffi() {
  set -e
  mkdir -p "$BUILD_DIR/$EMU_DIR"
  printf "CC $1\n"
  "$CC" $CFLAGS -c -o "$BUILD_DIR/${1%.c}.o" "$1"
}

build_ffi_all() {
  set -e
  EMU_FILES=`find "$EMU_DIR" -type f -name "*.c"`
  for F in $EMU_FILES ; do
    build_ffi $F
  done
  O_FILES=`find "$BUILD_DIR/$EMU_DIR" -type f -name "*.o"`
  printf "AR ffi.a\n"
  "$AR" rcs "$BUILD_DIR/ffi.a" $O_FILES
}

build_all() {
  set -e
  build_dir
  build_ffi_all
  analyze
  elaborate "main"
}

clean() {
  rm -rf $BUILD_DIR
}

if [[ -z "$1" ]] ; then
  build_all
elif [[ "$1" == "clean" ]] ; then
  clean
else
  printf "build.sh: Unknown command\n"
  exit 1
fi