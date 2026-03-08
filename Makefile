CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I include
LDFLAGS = -T linker.ld -ffreestanding -O2 -nostdlib -lgcc

# Files
C_SOURCES = $(shell find . -type f -name '*.c' ! -path '*/build/*')
S_SOURCES = $(shell find . -type f -name '*.s' ! -path '*/build/*')
OBJS = $(patsubst ./%.c, build/obj/%.o, $(C_SOURCES)) $(patsubst ./%.s, build/obj/%.o, $(S_SOURCES))

TARGET = build/axiom
ISO = build/axiom.iso

.PHONY: all clean run run-iso

all: $(ISO)

$(TARGET): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

$(ISO): $(TARGET)
	@mkdir -p build/isodir/boot/grub
	cp $(TARGET) build/isodir/boot/axiom
	cp grub.cfg build/isodir/boot/grub/grub.cfg
	grub-mkrescue -o $@ build/isodir

build/obj/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

build/obj/%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) $< -o $@

clean:
	rm -rf build

run: $(TARGET)
	qemu-system-i386 -kernel $(TARGET)

run-iso: $(ISO)
	qemu-system-i386 -cdrom $(ISO)
