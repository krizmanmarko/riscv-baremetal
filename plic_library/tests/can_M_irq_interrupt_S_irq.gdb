# this scenario tests whether M mode irq can interrupt S mode irq

# ANSWER: Yes, M mode irq does interrupt S mode irq

set $ctx=1
set $uart=10
set $pci_uart=33

b trap
tb suspend
c

# built-in UART is S-mode irq
call plic_set_priority($uart, 1)
call plic_set_enabled($ctx, $uart, 1)
call plic_set_threshold(1, 0)

# pci UART is M-mode irq
call plic_set_priority($pci_uart, 1)
call plic_set_enabled(0, $pci_uart, 1)
call plic_set_threshold(0, 0)

# enable external irqs on machine level
set $mie |= 0x800
set $mstatus |= 8
set $mtvec=0x88888880
b *$mtvec
write_uart B
si

# currently in S-mode handler
write_pci_uart C
si

# now in M-mode handler
