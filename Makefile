all:
	arm-linux-gnueabihf-gcc -g3 -Wall -mcpu=cortex-a9 -march=armv7-a -nostdlib -ffreestanding -c -o hello.o hello.S
	arm-linux-gnueabihf-ld -T link.ld -o hello.elf hello.o
	arm-linux-gnueabihf-objcopy hello.elf -O binary hello
	mkbootimg --kernel hello --ramdisk NONE --base 80300000 --kernel_offset 0 -o boot.img
