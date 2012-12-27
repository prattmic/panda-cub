#ifndef __MMU_H__
#define __MMU_H__

#include <stdint.h>

enum descriptor_formats {
    SUPERSECTION,
    SECTION,
    LRG_PAGE,
    PAGE
};

struct mmu_fld_generic {
    uint32_t mode : 2;
    uint32_t msb : 30;
} __attribute__((packed));

struct mmu_fld_page_table {
    uint32_t one : 1;
    uint32_t zero : 1;
    uint32_t pxn : 1;
    uint32_t ns : 1;
    uint32_t also_zero : 1;
    uint32_t domain : 4;
    uint32_t implementation_defined : 1;
    uint32_t page_table_base_addr : 22;
} __attribute__((packed));

struct mmu_fld_section {
    uint32_t pxn : 1;
    uint32_t one : 1;
    uint32_t b : 1;
    uint32_t c : 1;
    uint32_t xn : 1;
    uint32_t domain : 4;
    uint32_t implementation_defined : 1;
    uint32_t ap_01 : 2;
    uint32_t tex : 3;
    uint32_t ap_2 : 1;
    uint32_t s : 1;
    uint32_t ng : 1;
    uint32_t zero : 1;
    uint32_t ns : 1;
    uint32_t section_base_addr : 12;
} __attribute__((packed));

struct mmu_fld_supersection {
    uint32_t pxn : 1;
    uint32_t one : 1;
    uint32_t b : 1;
    uint32_t c : 1;
    uint32_t xn : 1;
    uint32_t extended_base_addr_39_36 : 4;
    uint32_t implementation_defined : 1;
    uint32_t ap_01 : 2;
    uint32_t tex : 3;
    uint32_t ap_2 : 1;
    uint32_t s : 1;
    uint32_t ng : 1;
    uint32_t also_one : 1;
    uint32_t ns : 1;
    uint32_t extended_base_addr_35_32 : 4;
    uint32_t supersection_base_addr : 8;
} __attribute__((packed));

union mmu_fld {
    uint32_t val;
    struct mmu_fld_generic generic;
    struct mmu_fld_page_table page_table;
    struct mmu_fld_section section;
    struct mmu_fld_supersection supersection;
};

struct mmu_sld_generic {
    uint32_t mode : 2;
    uint32_t msb : 30;
} __attribute__((packed));

struct mmu_sld_large_page {
    uint32_t one : 1;
    uint32_t zero : 1;
    uint32_t b : 1;
    uint32_t c : 1;
    uint32_t ap_01 : 2;
    uint32_t also_zero : 3;
    uint32_t ap_2 : 1;
    uint32_t s : 1;
    uint32_t ng : 1;
    uint32_t tex : 3;
    uint32_t xn : 1;
    uint32_t large_page_base_addr : 16;
} __attribute__((packed));

struct mmu_sld_small_page {
    uint32_t xn : 1;
    uint32_t one : 1;
    uint32_t b : 1;
    uint32_t c : 1;
    uint32_t ap_01 : 2;
    uint32_t tex : 3;
    uint32_t ap_2 : 1;
    uint32_t s : 1;
    uint32_t ng : 1;
    uint32_t small_page_base_addr : 24;
} __attribute__((packed));

union mmu_sld {
    uint32_t val;
    struct mmu_sld_generic generic;
    struct mmu_sld_large_page large_page;
    struct mmu_sld_small_page small_page;
};

int mmu_set_descriptor(int type, uint32_t *phys, uint32_t *virt);

#endif
