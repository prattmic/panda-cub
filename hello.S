.globl start
start:
    ldr r0, =cpu0_on
    bl  puts

    ldr r0, =mmu0_tlb
    bl start_mmu

    ldr r0, =mmu0_on
    bl  puts

    /* Set CPU1 boot address */
    ldr r0, =cpu1
    ldr r1, =0x48281804     /* AUX_CORE_BOOT_1 */
    str r0, [r1]

    /* Start CPU1 */
    ldr r0, =0x48281800     /* AUX_CORE_BOOT_0 */
    ldr r1, [r0]
    orr r1, r1, #4
    str r1, [r0]
    sev

    /* Make 0xABCxxxxx == 0x803xxxxx */
    ldr r0, =mmu0_tlb
    ldr r1, =2748*4
    add r0, r0, r1
    ldr r1, =0x80300C02
    str r1, [r0]

    ldr r0, =mmu_craziness
    ldr r1, =0x000FFFFF
    ldr r2, =0xABC00000
    and r0, r0, r1
    orr r0, r0, r2
    mov pc, r0

    b   hang

mmu_craziness:
    ldr r0, =crazy_addr
    bl  puts

    b   hang

hang:
    b .

hang1:
    b .

cpu1:
    ldr r0, =cpu1_on
    bl  puts

    ldr r0, =mmu1_tlb
    bl start_mmu

    ldr r0, =mmu1_on
    bl  puts

    b   hang1

/* r0 - mmu table base */
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

    /* Set table base */
    mcr p15, 0, r4, c2, c0, 0
    /* Set page table entry to manager */
    mov r0, #0x3
    mcr p15, 0, r0, c3, c0, 0
    /* Enable MMU */
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #1
    mcr p15, 0, r0, c1, c0, 0

    bx  lr

/* r0 - ptr to string */
puts:
    ldr     r2, =0x48020000
1:  ldrb    r1, [r0]
    teq     r1, #0
    bxeq    lr
    str     r1, [r2]
    add     r0, r0, #1
    b       1b

cpu0_on:
    .asciz  "CPU0 Booted\r\n"
cpu1_on:
    .asciz  "CPU1 Booted\r\n"
mmu0_on:
    .asciz  "MMU0 Started\r\n"
mmu1_on:
    .asciz  "MMU1 Started\r\n"
crazy_addr:
    .asciz  "Executing at 0xABCxxxxx\r\n"

.section    .tlb, "a"
mmu0_tlb:
    .space  4096*4
mmu1_tlb:
    .space  4096*4
