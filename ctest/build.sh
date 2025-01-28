#!/bin/bash
set -e

CFLAGS="-nostartfiles -nostdlib -fno-exceptions -fno-unwind-tables -mabi=ilp32 -march=rv32i -O2"

mkdir -p build/
riscv32-unknown-elf-gcc $CFLAGS -T link.ld -o build/quadratic.elf quadratic.c newlib_impl.c crt0.S test.S -lm -lc -lgcc
./elf2rom.py build/quadratic.elf > ../run/rom.bin