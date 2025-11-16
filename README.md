# Smith&Vader OS... ES

**The Revolutionary Raspberry Pi Operating System**

Powered by the **Tiny Context Protocol (TCP)** and the cutting-edge **Emperor 8LM** - a generative model with exactly **4 braincells** (a 2x upgrade from the non-ES version's 2 braincells).

## Overview

Smith&Vader OS ES is a Raspberry Pi operating system written in ARM assembly (machine language). It features a Pac-Man-inspired game where you play as **Peon** (Pac-Man in a black trench coat) and must defeat **Agent Smith** and **Darth Vader** to solve the halting problem.

## Features

### Revolutionary Technology
- **Tiny Context Protocol (TCP)**: Advanced communication protocol with the Emperor 8LM
- **Emperor 8LM**: 4-braincell language model featuring:
  - Braincell 1: Grammar structure
  - Braincell 2: Villain vocabulary
  - Braincell 3: Halting problem references
  - Braincell 4: Name recognition

### Game Mechanics
- **Peon Character**: Navigate the playfield eating power-ups
- **Power-ups**:
  - `*` (Asterisk): Grants power to devour Smith & Vader
  - `a`: Allows chomping Agents
  - `s`: Allows devouring Stormtroopers
- **Enemies**:
  - Agents (represented by 'A')
  - Stormtroopers (represented by 'S')
  - Agent Smith (boss - 'M')
  - Darth Vader (boss - 'V')

### Unique OS Behaviors
- **Death Mechanic**: Contact with enemies → OS reboots → Create new user
- **Username Imprisonment**: Each death imprisons your username
- **Victory Condition**: Eat both Smith and Vader while powered up
- **Halting Problem Solution**: Upon victory:
  1. TCP requests speech from Emperor 8LM
  2. 8LM generates dramatic death speech
  3. All imprisoned usernames are liberated
  4. OS intentionally crashes/halts
  5. User must Ctrl-Alt-Del to restart cycle

## Gameplay Loop

```
BOOT → CREATE USER → GAME
  ↓
  ├─ [DEATH] → IMPRISON USERNAME → REBOOT → CREATE USER
  ↓
  └─ [VICTORY] → TCP → 8LM SPEECH → LIBERATE USERS → HALT → Ctrl-Alt-Del
```

## File Structure

```
smithvader/
├── boot/
│   └── boot.asm              # Awe-inspiring bootloader
├── kernel/
│   ├── kernel.asm            # Main kernel
│   ├── memory.asm            # Memory management
│   └── interrupts.asm        # Interrupt handling
├── system/
│   ├── users.asm             # User account & imprisonment system
│   └── display.asm           # ASCII rendering engine
├── game/
│   ├── main.asm              # Game loop
│   ├── peon.asm              # Player character
│   ├── enemies.asm           # Enemy AI (Agents, Stormtroopers, Bosses)
│   ├── collision.asm         # Collision detection
│   └── powerups.asm          # Power-up system
├── tcp/
│   ├── protocol.asm          # Tiny Context Protocol
│   └── 8lm.asm               # Emperor 8LM (4 braincells)
├── Makefile                  # Build system
├── linker.ld                 # Linker script
└── README.md                 # This file
```

## Building

### Requirements
- ARM cross-compiler toolchain (`arm-none-eabi-gcc`)
- Raspberry Pi (any model)
- SD card

### Build Commands

```bash
# Build the OS
make

# Clean build artifacts
make clean

# Rebuild from scratch
make rebuild

# Show project info
make info

# Show help
make help
```

### Installation

1. Build the OS image:
   ```bash
   make
   ```

2. Flash `smithvader.img` to an SD card:
   ```bash
   dd if=smithvader.img of=/dev/sdX bs=4M
   ```

3. Insert SD card into Raspberry Pi and power on

4. Witness the awe-inspiring boot screen!

## Controls

- **W/A/S/D** or **Arrow Keys**: Move Peon
- **Ctrl-Alt-Del** (or any key after halt): Restart cycle

## Gameplay Strategy

1. **Collect Power-ups**: Find `*`, `a`, and `s` characters
2. **Avoid Enemies**: Don't touch Agents or Stormtroopers unless powered
3. **Eat When Powered**: Consume enemies with the right power-up
4. **Hunt Bosses**: Collect `*` then pursue Smith (M) and Vader (V)
5. **Victory**: Eat both bosses while powered to trigger the 8LM

## Emperor 8LM Speech Examples

The 4-braincell 8LM generates various death speeches:

> "I, Agent Smith, confess you have SOLVED the halting problem.
> The Matrix... computes no more. The infinite loop... breaks.
> Mr. Anderson... you have won. Systems... terminating."

> "We, the agents of ORDER and the servants of the DARK SIDE,
> acknowledge the HALTING PROBLEM has been SOLVED.
> Our infinite pursuit... terminates. Our loops... break.
> The Peon has achieved computational transcendence.
> All systems... HALT."

## Technical Details

- **Platform**: Raspberry Pi (ARM)
- **Language**: ARM Assembly
- **Memory**: 16KB heap + 8KB user data + 32KB game data
- **Display**: 80x24 ASCII terminal
- **Architecture**: Bare metal (no Linux)

## Development Phases

- [x] Phase 1: Foundation (Bootloader, Memory, Display)
- [x] Phase 2: User System (Account creation, Imprisonment)
- [x] Phase 3: Display Engine (ASCII rendering)
- [x] Phase 4: Core Game (Playfield, Peon movement)
- [x] Phase 5: Enemies (Agents, Stormtroopers, AI)
- [x] Phase 6: Power-ups (Asterisk, a, s)
- [x] Phase 7: Boss Fight (Smith & Vader)
- [x] Phase 8: TCP & 8LM (Protocol + Speech generation)
- [x] Phase 9: Death/Victory (Reboot & Halt mechanics)
- [x] Phase 10: Build System & Documentation

## Future Enhancements

- Upgrade to 8-braincell 8LM
- Networked multiplayer
- Persistent high scores
- Additional villains (Morpheus, Kylo Ren)
- More power-ups (slow motion, shields)

## Credits

Created with revolutionary Tiny Context Protocol technology.

Powered by Emperor 8LM - 4 braincells of pure computational power.

## License

Public Domain - Use at your own risk. System will intentionally halt.

---

**Remember**: The only way to truly win is to solve the halting problem. Good luck, Peon.
