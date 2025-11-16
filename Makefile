# Smith&Vader OS ES - Makefile
# Build system for Raspberry Pi ARM assembly

# Tools
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy

# Flags
ASFLAGS = -mcpu=arm1176jzf-s -mfpu=vfp
LDFLAGS = -T linker.ld

# Source files
BOOT_SRC = boot/boot.asm
KERNEL_SRC = kernel/kernel.asm kernel/memory.asm kernel/interrupts.asm
SYSTEM_SRC = system/users.asm system/display.asm
GAME_SRC = game/main.asm game/peon.asm game/enemies.asm game/collision.asm game/powerups.asm
TCP_SRC = tcp/protocol.asm tcp/8lm.asm

ALL_SRC = $(BOOT_SRC) $(KERNEL_SRC) $(SYSTEM_SRC) $(GAME_SRC) $(TCP_SRC)
ALL_OBJ = $(ALL_SRC:.asm=.o)

# Output
TARGET = smithvader.img
ELF = smithvader.elf

# Default target
all: $(TARGET)

# Link all object files
$(ELF): $(ALL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

# Create kernel image
$(TARGET): $(ELF)
	$(OBJCOPY) $< -O binary $@
	@echo "===================================="
	@echo "Smith&Vader OS ES built successfully!"
	@echo "===================================="
	@echo "Image: $(TARGET)"
	@echo "Size: $$(ls -lh $(TARGET) | awk '{print $$5}')"
	@echo ""
	@echo "Flash to SD card and boot on Raspberry Pi!"

# Assemble source files
%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

# Clean build artifacts
clean:
	rm -f $(ALL_OBJ) $(ELF) $(TARGET)
	@echo "Cleaned build artifacts"

# Clean and rebuild
rebuild: clean all

# Show info
info:
	@echo "Smith&Vader OS... ES"
	@echo "===================="
	@echo "Source files: $(words $(ALL_SRC))"
	@echo "Boot:   $(BOOT_SRC)"
	@echo "Kernel: $(KERNEL_SRC)"
	@echo "System: $(SYSTEM_SRC)"
	@echo "Game:   $(GAME_SRC)"
	@echo "TCP:    $(TCP_SRC)"
	@echo ""
	@echo "Features:"
	@echo "  - Tiny Context Protocol (TCP)"
	@echo "  - Emperor 8LM (4 braincells)"
	@echo "  - Peon vs Smith & Vader"
	@echo "  - Username imprisonment system"
	@echo "  - Intentional halt on victory"

# Help
help:
	@echo "Smith&Vader OS ES - Build System"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Build the OS image (default)"
	@echo "  clean    - Remove build artifacts"
	@echo "  rebuild  - Clean and rebuild"
	@echo "  info     - Show project information"
	@echo "  help     - Show this help"
	@echo ""
	@echo "Requirements:"
	@echo "  - arm-none-eabi-gcc toolchain"
	@echo "  - Raspberry Pi (any model)"
	@echo "  - SD card for flashing"

.PHONY: all clean rebuild info help
