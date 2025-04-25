NAME=printer

ARCH?=riscv64
ADDRESS?=0x80100000

FNAME=$(NAME)-$(ARCH)-$(ADDRESS)

CROSS_COMPILE=$(ARCH)-unknown-elf-
BUILD_DIR=./build

$(shell mkdir -p $(BUILD_DIR))
CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy

CFLAGS=-W -Wall -ggdb -ffreestanding -fno-common -nodefaultlibs -nostdlib -std=gnu17 -mcmodel=medany -fno-pic

$(BUILD_DIR)/$(FNAME).bin: $(BUILD_DIR)/$(FNAME)
	@$(OBJCOPY) -O binary $^ $@

$(BUILD_DIR)/$(FNAME): linker.ld main.S
	@$(CC) $(CFLAGS) -T $^ -o $@ -Wl,--section-start=.boot=$(ADDRESS)
	@echo "\e[32m[+] Successfuly built $@!\e[0m"

.PHONY: help
help:
	@echo "To build this app run: make ARCH=<arch> ADDRESS=<address>"
	@echo "where"
	@echo "	arch: riscv32 | riscv64"
	@echo "	address: this is where execution starts (i.e. 0x80100000)"

clean:
	rm -rf $(BUILD_DIR)
