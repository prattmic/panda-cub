#include <stdint.h>
#include <smp.h>
#include <mmu.h>

/* Only implements the first level descriptors, and allocating sections. */
uint32_t mmu_first_level_table[NUM_CPUS][4096] __attribute__((section(".tlb"),aligned(32*1024)));

int mmu_set_descriptor(int type, uint32_t *phys, uint32_t *virt) {
    if (type != SECTION) {
        return -1;
    }

    /* Bits 31:20 of the virtual address are the index into the translation table */
    uint32_t index = (uint32_t) virt >> 20;

    union mmu_fld entry = {
        .section.pxn    = 0,
        .section.one    = 1,
        .section.b      = 0,
        .section.c      = 0,
        .section.xn     = 0,
        .section.domain = 0,
        .section.implementation_defined = 0,
        .section.ap_01  = 3,
        .section.ap_2   = 0,
        .section.tex    = 0,
        .section.s      = 0,
        .section.ng     = 0,
        .section.zero   = 0,
        .section.ns     = 0,
        .section.section_base_addr = ((uint32_t) phys & 0xfff00000) >> 20,
    };

    mmu_first_level_table[current_cpu()][index] = entry.val;

    return 0;
}
