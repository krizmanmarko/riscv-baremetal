# Ad-Hoc PLIC interaction

Baremetal app contains bare minimum to interact with PLIC. That is PLIC driver,
2 seperate interrupt sources and ability to run on multiple contexts.

Idea is to use gdb's `call` command to configure plic interactively. Interrupts
can be triggered by writing to UART. Currently there are 2:

- built-in UART listening on localhost:10010
- PCI UART listening on localhost:10033

All interaction can then be done programatically through gdb scripts (look at tests/).
Just change ./.gdbinit
