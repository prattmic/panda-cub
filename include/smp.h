#ifndef __SMP_H__
#define __SMP_H__

#include <stdint.h>

#define NUM_CPUS    2

#define AUX_CORE_BOOT_0     *((uint32_t *) 0x48281800)
#define AUX_CORE_BOOT_1     *((uint32_t *) 0x48281804)

static inline uint8_t current_cpu(void) {
    uint32_t mpidr;

    /* Read MPIDR */
    asm ("mrc p15, 0, %[mpidr], c0, c0, 5   \n"
        :[mpidr] "=r" (mpidr)::);

    /* This is a little sketchy.  The use of MPIDR is implementation defined,
     * and I cannot find how the OMAP4430 defines it.  However, the affinity
     * level 0 bitfield seems to always contain 0 on CPU0 and 1 on CPU1, so
     * that is what we are going with.  Also, if it is good enough for Linux,
     * it is good enough for me. */
    return mpidr & 0xf;
}

void smp_start_cpu1(void (*func)(void));

#endif
