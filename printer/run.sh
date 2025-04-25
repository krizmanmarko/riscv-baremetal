#!/bin/bash

# use built-in OpenSBI to run image
build_dir="./build"

qemu-system-riscv64 \
	-nographic \
	-machine virt \
	-kernel $build_dir/printer \
	-cpu rv64 \
	-smp 1 \
	-m 6M \
	-gdb tcp::1111 \
	#-S
