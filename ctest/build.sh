#!/bin/bash

CFLAGS="-ffreestanding -nostdlib -fno-exceptions -fno-unwind-tables -mabi=ilp32 -march=rv32i -O2"

mkdir -p build/
riscv64-unknown-elf-gcc $CFLAGS -T link.ld -o build/basic_test.elf basic_test.S