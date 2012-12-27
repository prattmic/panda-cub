PROJ = cub

OBJS = start.o mmu.o smp.o kernel.o

CFLAGS += -g3 --std=gnu99 -Wall -mcpu=cortex-a9 -march=armv7-a -nostdlib -ffreestanding -isystem include

CC=arm-linux-gnueabihf-gcc
LD=arm-linux-gnueabihf-ld
OBJCOPY=arm-linux-gnueabihf-objcopy

all: $(PROJ)

%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(PROJ): $(OBJS)
	$(LD) -T link.ld -o $(PROJ).elf $^
	$(OBJCOPY) $(PROJ).elf -j .text -O binary kernel
	$(OBJCOPY) $(PROJ).elf -R .text -O binary ramdisk
	mkbootimg --kernel kernel --ramdisk ramdisk --base 80000000 --kernel_offset 100000 --ramdisk_offset 0 -o boot.img

clean:
	-rm *.o *.elf kernel ramdisk boot.img

flash:
	fastboot flash boot boot.img
