all:
	arm-linux-gnueabihf-gcc -g3 -Wall -mcpu=cortex-a9 -march=armv7-a -nostdlib -ffreestanding -c -o hello.o hello.S
	arm-linux-gnueabihf-ld -T link.ld -o hello.elf hello.o
	arm-linux-gnueabihf-objcopy hello.elf -R tlb -O binary hello
	arm-linux-gnueabihf-objcopy hello.elf -j tlb -O binary ramdisk
	mkbootimg --kernel hello --ramdisk ramdisk --base 80000000 --kernel_offset 300000 --ramdisk_offset 0 -o boot.img
