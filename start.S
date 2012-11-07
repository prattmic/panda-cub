.globl start
start:
    /* Save cpu1 start address */
    adr r11, cpu1_start

    ldr r0, =mmu0_tlb
    ldr r5, =cpu0_mmu_enabled
    b   start_mmu

cpu0_mmu_enabled:
    ldr r0, =mmu0_on
    bl  puts

    /* Set CPU1 boot address */
    ldr r1, =0x48281804     /* AUX_CORE_BOOT_1 */
    str r11, [r1]

    /* Start CPU1 */
    ldr r0, =0x48281800     /* AUX_CORE_BOOT_0 */
    ldr r1, [r0]
    orr r1, r1, #4
    str r1, [r0]
    sev

    b   hang

hang:
    b .

cpu1_start:
    ldr r0, =mmu1_tlb
    ldr r5, =cpu1_mmu_enabled
    b   start_mmu

cpu1_mmu_enabled:
    ldr r0, =mmu1_on
    bl  puts

    b   hang1

hang1:
    b .

/* r0 - mmu table base 
 * r5 - virtual address to jump to */
start_mmu:
    ldr r1, =0xC02
    mov r2, #4096
    mov r3, #0x100000
    mov r4, r0

fill_table:
    str r1, [r0]
    add r1, r1, r3
    add r0, r0, #4
    adds r2, r2, #-1
    bpl fill_table

    /* Map kernel to 0xABC */
    mov r0, r4
    ldr r1, =0xABC*4
    add r0, r0, r1
    ldr r1, =0x80300C02
    str r1, [r0]

    /* Set table base */
    mcr p15, 0, r4, c2, c0, 0
    /* Set page table entry to manager */
    mov r0, #0x3
    mcr p15, 0, r0, c3, c0, 0
    /* Enable MMU */
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #1
    mcr p15, 0, r0, c1, c0, 0

    bx  r5

/* r0 - ptr to string */
puts:
    ldr     r2, =0x48020000
1:  ldrb    r1, [r0]
    teq     r1, #0
    bxeq    lr
    str     r1, [r2]
    add     r0, r0, #1
    b       1b

mmu0_on:
    .asciz  "CPU0 on and MMU0 Started\r\n"
mmu1_on:
    .asciz  "CPU1 on and MMU1 Started\r\n"

.section    .tlb, "a"
mmu0_tlb:
    .space  4096*4
mmu1_tlb:
    .space  4096*4
