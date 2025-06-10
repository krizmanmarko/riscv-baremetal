#define STACK_SIZE 0x100

.section ".boot", "ax"
.globl _start

_start:
	mv tp, a0
	la t1, trap
	csrw stvec, t1

	# try wakeup other harts
	li a0, 0
	la a1, _start
	li a2, 0
	li a6, 0
	li a7, 0x48534d
	ecall
	li a0, 1
	la a1, _start
	li a2, 0
	li a6, 0
	li a7, 0x48534d
	ecall

	# per hart stack
	li sp, 0x80101000
	li a0, STACK_SIZE
	mul a0, tp, a0
	sub sp, sp, a0

	# init uart
	call init_uart
	li a0, 0x44
	call uartputc

	# init pci uart
	call init_pci_uart
	li a0, 0x45
	call pci_uartputc

	li t1, 1
	sll t1, t1, 1
	csrs sstatus, t1	/* sstatus.sie = 1 */
	li t1, 1
	sll t1, t1, 9
	csrs sie, t1		/* sie.seie = 1 */

suspend:
	j suspend	# interactively setup plic in gdb


.section ".text", "ax"

.balign 4
trap:
	j .
	sret
