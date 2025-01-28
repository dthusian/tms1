#!/usr/bin/python3

from elftools.elf.elffile import ELFFile, Segment
import argparse
import sys

ROM_SIZE = 1024*1024*2
ROM_BASE = 0x10000000

parser = argparse.ArgumentParser(prog="elf2rom.py", description="Converts an ELF file into a flashable ROM")
parser.add_argument("filename")
args = parser.parse_args()

rom = bytearray([0 for _ in range(ROM_SIZE)])

with open(args.filename, "rb") as fp:
  elf = ELFFile(fp)

  for segment in elf.iter_segments(type="PT_LOAD"):
    if segment["p_paddr"] + segment["p_filesz"] > ROM_BASE + ROM_SIZE or segment["p_paddr"] < ROM_BASE:
      print(f"elf2rom.py: warning: segment starting 0x{segment["p_paddr"]:x} with size 0x{segment["p_filesz"]:x} doesn't fit in ROM", file=sys.stderr)
    else:
      romaddr = segment["p_paddr"] - ROM_BASE
      romsz = segment["p_filesz"]
      rom[romaddr:romaddr+romsz] = segment.data()
  
  # remove trailing zeroes from rom
  while len(rom) > 0 and rom[-1] == 0:
    rom.pop()

  sys.stdout.buffer.write(rom)
  sys.stdout.buffer.flush()

