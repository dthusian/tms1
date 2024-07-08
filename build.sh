#!/bin/bash

GHDL="ghdl"
GHDL_FLAGS="--std=08"

CC="cc"
CFLAGS="-O2 -std=c11"

AR="ar"

BUILD_DIR="build/"
HDL_DIR="hdl/"
EMU_DIR="emu/"

set -e

build_dir() {
  mkdir -p "$BUILD_DIR"
}

analyze() {
  HDL_FILES=`find hdl/ -type f`
  "$GHDL" -a "--workdir=$BUILD_DIR" $GHDL_FLAGS $HDL_FILES
}

elaborate() {
  "$GHDL" -e "--workdir=$BUILD_DIR" "-Wl,$BUILD_DIR/ffi.a" -o "$BUILD_DIR/$1" $GHDL_FLAGS $1
}

build_ffi() {
  mkdir -p "$BUILD_DIR/$EMU_DIR"
  "$CC" $CFLAGS -c -o "$BUILD_DIR/${1%.c}.o" "$1"
}

build_ffi_all() {
  EMU_FILES=`find "$EMU_DIR" -type f -name "*.c"`
  for F in $EMU_FILES ; do
    build_ffi $F
  done
  O_FILES=`find "$BUILD_DIR/$EMU_DIR" -type f -name "*.o"`
  "$AR" rcs "$BUILD_DIR/ffi.a" $O_FILES
}

build_all() {
  build_dir
  build_ffi_all
  analyze
  elaborate "main"
}

build_all