.globl start
start:
hello:
    ldr r0, =0x48020000
    mov r1, #0x48
    str r1, [r0]
    mov r1, #0x45
    str r1, [r0]
    mov r1, #0x4C
    str r1, [r0]
    mov r1, #0x4C
    str r1, [r0]
    mov r1, #0x4F
    str r1, [r0]
    mov r1, #0x0A
    str r1, [r0]
    mov r1, #0x0D
    str r1, [r0]

start_mmu:
    mov r0, #4096
    ldr r1, =0xC02
    ldr r2, =mmu_tlb
    mov r3, #0x100000

fill_table:
    str r1, [r2]
    add r1, r1, r3
    add r2, r2, #4
    adds r0, r0, #-1
    bpl fill_table

    /* Set table base */
    ldr r0, mmu_tlb_base
    mcr p15, 0, r0, c2, c0, 0
    /* Set page table entry to manager */
    mov r0, #0x3
    mcr p15, 0, r0, c3, c0, 0
    /* Enable MMU */
    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, #1
    mcr p15, 0, r0, c1, c0, 0

hang:
    b .

mmu_tlb_base:
    .word   mmu_tlb

.section    .tlb, "a"
mmu_tlb:
    .word   0x80300c02
