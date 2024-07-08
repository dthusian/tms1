ghdl := "ghdl"
ghdl_flags := "--std=08"
ghdl_flags_user := ""
build_dir := "build"
hdl_dir := "hdl"
emu_dir := "emu"
cc := "cc"
cflags := "-O2"

## High Level Recipes

build_all: build_main build_tests

build_main: (_build_one "main")

build_tests: (_build_one "test")

run: build_main
	{{build_dir}}/main

test: build_tests
	{{build_dir}}/test

## Build Components

_build_dir:
	mkdir -p build/

_analyze: _build_dir
	find {{src_dir}} -type f -name "*.vhd" | xargs {{ghdl}} -a --workdir={{build_dir}} {{ghdl_flags}} 

_elaborate TOP_LEVEL: _build_dir _build_ffi_all
	{{ghdl}} -e --workdir={{build_dir}} -o {{build_dir}}/{{TOP_LEVEL}} {{ghdl_flags}} {{TOP_LEVEL}}

_build_one TOP_LEVEL: (_analyze) (_elaborate TOP_LEVEL)

_build_ffi:
	{{cc}} {{cflags}} -o {{build_dir}}/{{FILE}}.o {{emu_dir}}/{{FILE}}.c
