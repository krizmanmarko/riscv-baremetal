# what happens when during an interrupt handler we disable
# imagine: STI happens for context switch and PLIC reconfiguration takes place.
# during this handler another irq (which will be disabled during this handler) happens.
# what happens?

set $ctx=1
set $uart=10
set $pci_uart=33

b trap
tb suspend
c

call plic_set_priority($uart, 1)
call plic_set_enabled($ctx, $uart, 1)
call plic_set_priority($pci_uart, 1)
call plic_set_enabled($ctx, $pci_uart, 1)
call plic_set_threshold($ctx, 0)

# currently spinning in suspend
write_uart A
c

# entered trap with irq 10 waiting
call plic_claim($ctx)
set $irq = $_
if $irq = 10
	call handle_uart()
else
	echo "Something went wrong with debug UART..."
	quit
end
call plic_complete($ctx, $irq)

i r mip
write_pci_uart B
i r mip
call plic_set_enabled($ctx, $pci_uart, 0)
i r mip

shell grep 'EB' /tmp/pci_uart.log && grep 'DA' /tmp/uart.log && echo "SUCCESS" || echo "FAIL"
