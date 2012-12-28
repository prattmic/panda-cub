PROJ := cub

OUT_DIR := out

OBJS := start.o mmu.o smp.o kernel.o
OBJS := $(addprefix $(OUT_DIR)/, $(OBJS))

CFLAGS += -g3 --std=gnu99 -Wall -mcpu=cortex-a9 -march=armv7-a -nostdlib -ffreestanding -isystem include

CC=arm-linux-gnueabihf-gcc
LD=arm-linux-gnueabihf-ld
OBJCOPY=arm-linux-gnueabihf-objcopy

.SUFFIXES:
.SUFFIXES: .o .c .h .S

all: $(OUT_DIR) $(PROJ)

$(OUT_DIR)/%.o: %.S
	$(CC) $(CFLAGS) -c -o $@ $<

$(OUT_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

$(PROJ): $(OBJS)
	$(LD) -T link.ld -o $(OUT_DIR)/$(PROJ).elf $^
	$(OBJCOPY) $(OUT_DIR)/$(PROJ).elf -O binary $(OUT_DIR)/kernel
	mkbootimg --kernel $(OUT_DIR)/kernel --ramdisk NONE --base 81000000 --kernel_offset 0 -o $(OUT_DIR)/boot.img

clean:
	-rm -r $(OUT_DIR)

flash:
	fastboot flash boot $(OUT_DIR)/boot.img
