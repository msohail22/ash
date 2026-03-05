.code16
.section .text
.global _start

_start:
    cli

    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es

    mov $0x7C00, %sp

    sti

# ------------------------------
# Load kernel from disk
# ------------------------------

    mov $0x1000, %bx        # kernel load address
    mov $0x02, %ah          # BIOS read sectors
    mov $1, %al             # number of sectors to read
    mov $0x00, %ch          # cylinder
    mov $0x02, %cl          # sector (kernel starts at sector 2)
    mov $0x00, %dh          # head
    mov $0x00, %dl          # drive (0 = floppy in QEMU)

    int $0x13               # BIOS disk read

    jc disk_error           # jump if read failed

# ------------------------------
# Jump to kernel
# ------------------------------

    ljmp $0x0000, $0x1000

# ------------------------------
# Error message
# ------------------------------

disk_error:
    mov $error_msg, %si

print:
    lodsb
    or %al, %al
    jz hang

    mov $0x0E, %ah
    int $0x10
    jmp print

hang:
    jmp hang

error_msg:
    .ascii "Disk read error"
    .byte 0

.org 510
.word 0xAA55