all:
	arm-linux-gnueabihf-gcc -g3 -Wall -fPIC -mcpu=cortex-a9 -march=armv7-a -nostdlib -ffreestanding -c -o start.o start.S
	arm-linux-gnueabihf-ld -T link.ld -o cub.elf start.o
	arm-linux-gnueabihf-objcopy cub.elf -R tlb -O binary kernel
	arm-linux-gnueabihf-objcopy cub.elf -j tlb -O binary ramdisk
	mkbootimg --kernel kernel --ramdisk ramdisk --base 80000000 --kernel_offset 300000 --ramdisk_offset 0 -o boot.img
