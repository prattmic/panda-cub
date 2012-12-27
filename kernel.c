#include <stdint.h>
#include <mmu.h>
#include <smp.h>

void ghetto_puts(char *s);

void start_kernel(void (*cpu1_start)(void)) {
    smp_start_cpu1(cpu1_start);

    ghetto_puts("Hello from C\r\n");

    *((char *) 0x80400000) = 'A';
    *((char *) 0x80400001) = '+';
    *((char *) 0x80400002) = '\0';

    mmu_set_descriptor(SECTION, (uint32_t *) 0x80400000, (uint32_t *) 0x01200000);

    ghetto_puts((char *) 0x01200000);
}

void cpu1_kernel(void) {
    ghetto_puts("CPU1 Booted\r\n");
}

#define UART3_THR   (*(volatile unsigned int *) 0x48020000)
void ghetto_puts(char *s) {
    while (*s) {
        UART3_THR = *s++;
    }
}
