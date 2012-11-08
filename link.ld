MEMORY
{
    tlb : ORIGIN = 0x80000000, LENGTH = 0x300000
    ram : ORIGIN = 0xABC00000, LENGTH = 1M
}

SECTIONS
{
    text : { 
        *(.text*) 
        *(.rodata*)
    } > ram
    data : { 
        *(.data*) 
    } > ram
    bss : { 
        *(.bss*) 
    } > ram

    tlb : {
        *(.tlb)
    } > tlb
}
