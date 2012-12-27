#include <stdint.h>
#include <smp.h>

void smp_start_cpu1(void (*func)(void)) {
    /* Address to jump to */
    AUX_CORE_BOOT_1 = (uint32_t) func;
    AUX_CORE_BOOT_0 = 4;

    /* Send event to notify core */
    asm("sev    \n");
}
