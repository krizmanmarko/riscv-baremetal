#!/bin/bash

killall qemu-system-riscv64

tmux split-window -v './debug.sh'
tmux select-pane -U
tmux split-window -h 'tail -f /tmp/pci_uart.log'
tmux select-pane -D
./kernel.sh & tail -f /tmp/uart.log
