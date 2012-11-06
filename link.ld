MEMORY
{
    tlb : ORIGIN = 0x80000000, LENGTH = 0x300000
    ram : ORIGIN = 0x80300000, LENGTH = 256M
}

SECTIONS
{
    text : { 
        *(.text*) 
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
