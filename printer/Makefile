NAME=printer
CROSS_COMPILE=riscv64-unknown-elf-

BUILD_DIR=./build

$(shell mkdir -p $(BUILD_DIR))
CC=$(CROSS_COMPILE)gcc
OBJCOPY=$(CROSS_COMPILE)objcopy

CFLAGS=-W -Wall -ggdb -ffreestanding -fno-common -nodefaultlibs -nostdlib -std=gnu17 -mcmodel=medany -fno-pic

$(BUILD_DIR)/$(NAME).bin: $(BUILD_DIR)/$(NAME)
	@$(OBJCOPY) -O binary $^ $@

$(BUILD_DIR)/$(NAME): linker.ld main.S
	@$(CC) $(CFLAGS) -T $^ -o $@
	@echo "\e[32m[+] Successfuly built $@!\e[0m"

clean:
	rm -rf $(BUILD_DIR)
