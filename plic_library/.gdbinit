target extended-remote localhost:1111
set scheduler-locking on
maintenance packet qqemu.sstep=0x1

# testing suite

# plic_set_priority(irq_id, val)
# plic_set_enabled(ctx, irq_id, val)
# plic_set_threshold(ctx, val)

set $uart=10
set $pci_uart=33

define write_uart
	# shell is used becaus /dev/tcp is bash specific
	shell printf $arg0 >/dev/tcp/localhost/10010
end

define write_pci_uart
	# shell is used becaus /dev/tcp is bash specific
	shell printf $arg0 >/dev/tcp/localhost/10033
end

#source ./tests/uarts.gdb
#source ./tests/claim_complete_on_seperate_harts.gdb
#source ./tests/can_builtin_block_pci.gdb
#source ./tests/can_M_irq_interrupt_S_irq.gdb
#source ./tests/irq_during_irq_handling_which_disables_irq_in_plic.gdb
source ./tests/when_is_device_irq_deasserted.gdb


# used in interactive session
disp/3i $pc
set history file /tmp/.gdb_history
set history save on
