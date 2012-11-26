void ghetto_puts(char *s);

void start_kernel(void) {
    ghetto_puts("Hello from C\r\n");
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
