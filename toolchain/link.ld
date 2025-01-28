MEMORY {
    ROM (rx)  : ORIGIN = 0x10000000, LENGTH = 2M,
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128M
}

ENTRY(_start)

PHDRS {
    rom PT_LOAD;
    ram_init PT_LOAD;
    ram PT_LOAD;
}

SECTIONS {
    .text : {
        . = ALIGN(4);
        PROVIDE(__text_start = .);
        *(.init)
        *(.text .text.*)
        PROVIDE(__text_end = .);
    } > ROM AT>ROM :rom
    
    .rodata : {
        . = ALIGN(4);
        PROVIDE(__rodata_start = .);
        *(.rodata .srodata)
        PROVIDE(__rodata_end = .);
    } > ROM AT>ROM :rom

    .data : {
        . = ALIGN(4);
        __data_src = LOADADDR(.data);
        PROVIDE(__data_start = .);
        *(.data .data.*)
        PROVIDE(__global_pointer = .);
        *(.sdata .sdata.*)
        PROVIDE(__data_end = .);
    } > RAM AT>ROM :ram_init
    
    .bss : {
        . = ALIGN(4);
        PROVIDE(__bss_start = .);
        *(.bss .sbss)
        PROVIDE(__bss_end = .);
    } > RAM AT>RAM :ram
    
    . = ALIGN(16);
    PROVIDE(__stack_bot = .);
    PROVIDE(__stack_top = . + 0x100000);
}