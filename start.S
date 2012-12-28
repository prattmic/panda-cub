/* Entry point for CPU 0 */
.section .start, "x"        /* Put start in its own section to ensure it is linked to the top of the kernel */
.globl start
start:
    ldr sp, =0x812FFFF0
    
    ldr r0, =0              /* We are on CPU 0 */

    bl  mmu_early_fill_identity

    /* Map kernel text */
    ldr r1, =0x81000C02     /* Map 0x800xxxxx, using same attributes as mmu_early_set_descriptor */
    ldr r2, =4*0xABC        /* Index; 0xABCxxxxx will map to 0x800xxxxx */
    bl  mmu_early_set_descriptor

    /* Map kernel data */
    ldr r1, =0x81100C02     /* Map 0x801xxxxx, using same attributes as mmu_early_set_descriptor */
    ldr r2, =4*0xABD        /* Index; 0xABDxxxxx will map to 0x800xxxxx */
    bl  mmu_early_set_descriptor

    /* Map CPU0 kernel stack */
    ldr r1, =0x81200C02     /* Map 0x802xxxxx, using same attributes as mmu_early_set_descriptor */
    ldr r2, =4*0xABE        /* Index; 0xABExxxxx will map to 0x800xxxxx */
    bl  mmu_early_set_descriptor

    bl  mmu_enable

    /* Switch stack pointer to virtual address */
    ldr r0, =0xFFF00000
    bic sp, r0
    ldr r0, =0xABE00000
    orr sp, sp, r0

    adr r0, cpu1_start      /* start_kernel takes the physical address of cpu1_start */
    ldr r1, =start_kernel
    blx r1

    b   hang

/* Entry point for CPU 1 */
.globl cpu1_start
cpu1_start:
    ldr sp, =0x813FFFF0
    
    ldr r0, =1              /* We are on CPU 1 */

    bl  mmu_early_fill_identity

    /* Map kernel text */
    ldr r1, =0x81000C02     /* Map 0x800xxxxx, using same attributes as mmu_early_set_descriptor */
    ldr r2, =4*0xABC        /* Index; 0xABCxxxxx will map to 0x800xxxxx */
    bl  mmu_early_set_descriptor

    /* Map kernel data */
    ldr r1, =0x81100C02     /* Map 0x801xxxxx, using same attributes as mmu_early_set_descriptor */
    ldr r2, =4*0xABD        /* Index; 0xABDxxxxx will map to 0x800xxxxx */
    bl  mmu_early_set_descriptor

    /* Map CPU1 kernel stack */
    ldr r1, =0x81300C02     /* Map 0x803xxxxx, using same attributes as mmu_early_set_descriptor */
    ldr r2, =4*0xABF        /* Index; 0xABFxxxxx will map to 0x800xxxxx */
    bl  mmu_early_set_descriptor

    bl  mmu_enable

    /* Switch stack pointer to virtual address */
    ldr r0, =0xFFF00000
    bic sp, r0
    ldr r0, =0xABF00000
    orr sp, sp, r0

    ldr r0, =cpu1_kernel
    blx r0

    b   hang

/* Everything else is in the .text section */
.section .text

/* MMU: Enable
 * r0: CPU number */
mmu_enable:
    ldr r1, =tlb_phys_addr  /* Load physical address of first level descriptor table */
    
    lsl r2, r0, #14         /* The table is 16KB long, so if we are on CPU 1, */
    add r1, r1, r2          /* we add 16KB to the address. */

    mcr p15, 0, r1, c2, c0, 0   /* Write table base address to TLBR0 */

    mrc p15, 0, r1, c3, c0, 0   /* Read DACR */
    orr r1, r1, #3              /* Set domain 0 to manager */
    mcr p15, 0, r1, c3, c0, 0   /* Write DACR */

    mrc p15, 0, r1, c1, c0, 0   /* Read SCTLR */
    orr r1, r1, #1              /* Enable MMU */
    mcr p15, 0, r1, c1, c0, 0   /* Write SCTLR */

    bx lr

/* MMU: Early set descriptor
 * r0: CPU number 
 * r1: descriptor value 
 * r2: table index
 * r3: clobbered (table base address)
 * r4: clobbered (shifted CPU number) */
mmu_early_set_descriptor:
    ldr r3, =tlb_phys_addr  /* Load physical address of first level descriptor table */
    
    lsl r4, r0, #14         /* The table is 16KB long, so if we are on CPU 1, */
    add r3, r3, r4          /* we add 16KB to the address. */

    str r1, [r3, r2]        /* table base + index = value */

    bx  lr

/* MMU: fill table with identity mapping
 * r0: CPU number (untouched, passed directly to mmu_early_set_descriptor
 * r1: clobbered
 * r2: clobbered */
mmu_early_fill_identity:
    /* All entries will be set to section format, with the following attributes:
     * -- Full access at all privilege levels 
     * -- Full execution permission
     * -- Domain 0
     * -- Strongly ordered memory, page sharable */
    ldr r1, =0xC02
    ldr r2, =0
    push {lr}

fill:
    bl  mmu_early_set_descriptor
    add r1, r1, #0x100000   /* Update entry to next section */
    add r2, r2, #4
    cmp r2, #4*4096
    blt fill                /* The table only has 4096 entries */

    pop {lr}
    bx  lr

hang:
    b   .
