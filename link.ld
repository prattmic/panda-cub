MEMORY
{
    kerneldata (rw) : ORIGIN = 0xABC00000, LENGTH = 1M
    kerneltext (rx) : ORIGIN = 0xABD00000, LENGTH = 1M
}

SECTIONS
{
    .data : AT ( 0x80000000 ) { 
        . = ALIGN(4);
        *(.data*) 
        . = ALIGN(4);
    } > kerneldata

    .bss : AT ( LOADADDR (.data) + SIZEOF (.data) ) { 
        . = ALIGN(4);
        *(.bss*) 
        *(COMMON)
        . = ALIGN(4);
    } > kerneldata

    .tlb : AT ( ALIGN( LOADADDR (.bss) + SIZEOF (.bss), 0x8000 ) ) { 
        . = ALIGN(4);
        *(.tlb)
        . = ALIGN(4);
    } > kerneldata

    .text : AT ( 0x80100000 ) { 
        . = ALIGN(4);
        *(.text*) 
        *(.rodata*)
        *(.got*)    /* Global offset table */
        . = ALIGN(4);
    } > kerneltext
}

tlb_phys_addr = LOADADDR(.tlb);
