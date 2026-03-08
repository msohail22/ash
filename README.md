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

To compile the kernel and generate the bootable ISO image, simply run:

```bash
make
```

This will create a `build/` directory containing the compiled object files, the `myos` binary, and the final `myos.iso` bootable image.

To clean up build artifacts:

```bash
make clean
```

## Running the OS

You can use QEMU to test the built OS via the Makefile:

1. **Boot directly from the kernel binary:**
   ```bash
   make run
   ```

2. **Boot from the generated ISO image:**
   ```bash
   make run-iso
   ```
