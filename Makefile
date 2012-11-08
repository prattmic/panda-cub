PROJ = cub

SRCS = kernel.c
OBJS = $(SRCS:.c=.o)

CFLAGS += -g3 -Wall -mcpu=cortex-a9 -march=armv7-a -nostdlib -ffreestanding

CC=arm-linux-gnueabihf-gcc
LD=arm-linux-gnueabihf-ld
OBJCOPY=arm-linux-gnueabihf-objcopy

all: $(PROJ)

start.o:
	$(CC) $(CFLAGS) -fPIC -c -o start.o start.S

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(PROJ): start.o $(OBJS)
	$(LD) -T link.ld -o $(PROJ).elf start.o $(OBJS)
	$(OBJCOPY) $(PROJ).elf -R tlb -O binary kernel
	$(OBJCOPY) $(PROJ).elf -j tlb -O binary ramdisk
	mkbootimg --kernel kernel --ramdisk ramdisk --base 80000000 --kernel_offset 300000 --ramdisk_offset 0 -o boot.img

clean:
	-rm *.o *.elf kernel ramdisk boot.img

flash:
	fastboot flash boot boot.img
