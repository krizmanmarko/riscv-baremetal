# this scenario tests whether claim complete sequence can happen on
# seperate harts successfully

# ANSWER: Yes, completing irq on other HART works

if $_inferior_thread_count < 2
	echo "At least 2 threads must exist"
	quit
end

# thread 1
thread 1
b trap
tb suspend
c

# thread 1 currently spinning in suspend
call plic_set_priority(10, 1)
call plic_set_enabled(1, 10, 1)
call plic_set_threshold(1, 0)

# thread 2
thread 2
tb suspend
c

# thread 2 currently spinning in suspend
call plic_set_enabled(3, 10, 1)
call plic_set_threshold(3, 0)
write_uart A
c # interrupt is always taken in currently active thread

# thread 2 now in irq handler
call plic_claim(3)
call handle_uart()

# thread 1 waiting in suspend performs complete
thread 1
call plic_complete(1, 10)

# test if interrupts still work
write_uart B
c
call plic_claim(1)
call handle_uart()
call plic_complete(1, 10)
tb suspend
c

thread 2
write_uart C
c
call plic_claim(3)
call handle_uart()
call plic_complete(3, 10)
tb suspend
c

shell grep 'EE' /tmp/pci_uart.log && grep 'DDABC' /tmp/uart.log && echo "SUCCESS" || echo "FAIL"
