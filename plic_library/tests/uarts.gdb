# this scenario tests whether both uarts work

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

# reached interrupt handler
call plic_claim($ctx)
set $irq = $_
if $irq = 10
	call handle_uart()
else
	echo "Something went wrong with debug UART..."
	quit
end

call plic_complete($ctx, $irq)
tb suspend
c

# currently spinning in suspend
write_pci_uart B
c

# reached interrupt handler
call plic_claim($ctx)
set $irq = $_
if $irq = 33
	call handle_pci_uart()
else
	echo "Something went wrong with PCI UART..."
	quit
end
call plic_complete($ctx, $irq)
tb suspend
c

shell grep 'EB' /tmp/pci_uart.log && grep 'DA' /tmp/uart.log && echo "SUCCESS" || echo "FAIL"
