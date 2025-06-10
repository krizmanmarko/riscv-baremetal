#!/bin/bash

# use built-in OpenSBI to run image
build_dir="./build"

qemu-system-riscv64 \
	-nographic \
	-machine virt \
	-device pci-serial,chardev=pciserial1 -chardev socket,id=pciserial1,host=127.0.0.1,port=10033,server=on,wait=off,logfile=/tmp/pci_uart.log \
	-kernel $build_dir/plic_testing \
	-cpu rv64 \
	-smp 2 \
	-m 1G \
	-gdb tcp::1111 \
	-serial tcp:127.0.0.1:10010,server=on,wait=off,logfile=/tmp/uart.log \
	-monitor tcp:127.0.0.1:6666,server=on,wait=off \
	-S
