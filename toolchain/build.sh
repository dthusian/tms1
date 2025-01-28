#!/bin/bash
set -e

CFLAGS="-nostartfiles -nostdlib -fno-exceptions -fno-unwind-tables -mabi=ilp32 -march=rv32i -O2 -T link.ld"
LINK_FLAGS="-lm -lc -lgcc"
CRT_FILES="newlib_impl.c crt0.S"

mkdir -p build/
riscv32-unknown-elf-gcc $CFLAGS -o build/quadratic.elf quadratic/quadratic.c $CRT_FILES $LINK_FLAGS
riscv32-unknown-elf-gcc $CFLAGS -o build/systests.elf systests/*.S $CRT_FILES $LINK_FLAGS
./elf2rom.py build/systests.elf > ../run/rom.bin