.section ".boot", "ax"
.globl _start

# previous boot stage provides:
#   a0 contains hartid
#   a1 contains pointer to device tree
_start:
	mv tp, a0
	la t1, trap
	csrw stvec, t1

	call set_timer
	call enable_interrupts
suspend:
	wfi
	j suspend

.section ".text", "ax"

print_hartid:
	add a0, tp, 48	# print ascii hartid
	li a7, 1
	ecall
	li a0, '\n'
	li a7, 1
	ecall
	ret

set_timer:
	mv t0, ra
	csrr a0, time
	li t2, 10000000
	add a0, a0, t2
	csrw stimecmp, a0
	mv ra, t0
	ret

enable_interrupts:
	csrr t1, sstatus
	ori t1, t1, 2		/* SIE bit enable */
	csrw sstatus, t1
	csrr t1, sie
	ori t1, t1, 0b100000
	csrw sie, t1
	ret

.balign 4
trap:
	call print_hartid
	call set_timer
	sret
