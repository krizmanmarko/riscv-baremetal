# try to figure out when device interrupt assert line is deasserted
# options:
#   - after raw access to device
#   - after plic complete

# ANSWER: raw access to device deasserts uart interrupt. PLIC claim clears plics pending bit

b trap
tb suspend
c

# currently spinning in suspend
call plic_set_priority(10, 1)
call plic_set_enabled(1, 10, 1)
call plic_set_threshold(1, 0)

call plic_get_pending(10)
monitor x/b 0x10000002
write_uart A
c

# now we are in irq handler
call plic_get_pending(10)
monitor x/b 0x10000002
call plic_claim(1)

call plic_get_pending(10)
monitor x/b 0x10000002
call handle_uart()
call plic_get_pending(10)
monitor x/b 0x10000002

call plic_complete(1, 10)
call plic_get_pending(10)
monitor x/b 0x10000002

# output:

#$1 = 0
#0000000010000002: 0xc1
#
#Thread 1 hit Breakpoint 1, trap () at src/main.S:56
#56              j .
#$2 = 1024
#0000000010000002: 0xcc
#$3 = 10
#$4 = 0
#0000000010000002: 0xcc
#$5 = 0
#0000000010000002: 0xc1
#$6 = 0
#0000000010000002: 0xc1
#
