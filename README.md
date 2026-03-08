# Axiom OS

A simple bare-bones operating system built as a learning project.

## Prerequisites

To build and run this OS, you will need the following tools:

1. **i686-elf Cross-Compiler**: `i686-elf-gcc` and `i686-elf-as` are required to compile the kernel.
2. **GRUB and ISO Tools**: Required to generate the bootable ISO image.
   ```bash
   sudo apt-get update
   sudo apt-get install -y xorriso mtools grub-pc-bin grub-efi-amd64-bin
   ```
3. **QEMU**: An emulator to test the OS.
   ```bash
   sudo apt-get install qemu-system-x86
   ```

## Building the OS

First, clean up any previous build files, then compile the bootstrapper and the kernel, and link them together into the `myos` binary:

```bash
# Clean previous builds (run this if you run into issues)
rm -rf *.o myos myos.iso isodir/

# Assemble the bootloader
i686-elf-as boot.s -o boot.o

# Compile the kernel
i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# Link the final kernel image
i686-elf-gcc -T linker.ld -o myos -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
```

## Creating a Bootable ISO

To create a bootable CD-ROM image with GRUB:

```bash
# Prepare the ISO directory structure
mkdir -p isodir/boot/grub
cp myos isodir/boot/myos
cp grub.cfg isodir/boot/grub/grub.cfg

# Generate the ISO image
grub-mkrescue -o myos.iso isodir
```

## Running the OS

You can use QEMU to test the built OS in two different ways:

1. **Boot directly from the kernel binary:**
   ```bash
   qemu-system-i386 -kernel myos
   ```

2. **Boot from the generated ISO image:**
   ```bash
   qemu-system-i386 -cdrom myos.iso
   ```
