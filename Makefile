CC=$(HOME)/i686-elf/bin/i686-elf-gcc
AS=$(HOME)/i686-elf/bin/i686-elf-as
LD=$(HOME)/i686-elf/bin/i686-elf-ld

CFLAGS=-ffreestanding -O2 -Wall -Wextra
LDFLAGS=-T linker.ld

KERNEL_C_SRC := $(wildcard kernel/*.c)
KERNEL_ASM_SRC := $(wildcard kernel/*.s)

KERNEL_C_OBJ := $(KERNEL_C_SRC:.c=.o)
KERNEL_ASM_OBJ := $(KERNEL_ASM_SRC:.s=.o)

KERNEL_OBJ := $(KERNEL_C_OBJ) $(KERNEL_ASM_OBJ)

all: os-image.bin


# -------- Bootloader --------
boot.bin: boot/boot.s
	$(AS) boot/boot.s -o boot/boot.o
	$(LD) -Ttext 0x7C00 --oformat binary boot/boot.o -o boot.bin


# -------- Kernel --------
kernel/%.o: kernel/%.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel/%.o: kernel/%.s
	$(AS) $< -o $@

kernel.bin: $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o kernel.bin $(KERNEL_OBJ)


# -------- OS Image --------
os-image.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os-image.bin


# -------- Run --------
run: os-image.bin
	qemu-system-i386 -drive format=raw,file=os-image.bin


# -------- Clean --------
clean:
	rm -f boot/*.o kernel/*.o *.bin