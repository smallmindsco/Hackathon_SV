# Smith&Vader OS... ES - Complete File Index

## 📚 Documentation Files (6)

### Getting Started
- **[README.md](README.md)** - Complete project documentation, features, installation
- **[QUICKSTART.md](QUICKSTART.md)** - User-friendly guide to playing the game
- **[PLAN.claude](PLAN.claude)** - Original development plan with all phases

### Technical Documentation
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture, diagrams, data flow
- **[EMPEROR_8LM.md](EMPEROR_8LM.md)** - Detailed 4-braincell AI specification
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Executive summary and achievements

## 💻 Source Code Files (13 assembly files)

### Boot Layer (1 file)
- **[boot/boot.asm](boot/boot.asm)** - Bootloader with awe-inspiring boot screen
  - Hardware initialization
  - Boot screen display
  - Kernel launch

### Kernel Layer (3 files)
- **[kernel/kernel.asm](kernel/kernel.asm)** - Main kernel orchestration
  - OS main loop
  - User creation to game flow

- **[kernel/memory.asm](kernel/memory.asm)** - Memory management
  - malloc/free implementation
  - Heap management (16KB)
  - User data area (8KB)
  - Game data area (32KB)

- **[kernel/interrupts.asm](kernel/interrupts.asm)** - Interrupt handling
  - Vector table setup
  - IRQ/FIQ handlers
  - Enable/disable interrupts

### System Layer (2 files)
- **[system/users.asm](system/users.asm)** - User account system
  - User creation prompt
  - Username storage
  - Imprisonment tracking (64 max users)
  - Liberation system
  - Input reading

- **[system/display.asm](system/display.asm)** - ASCII rendering engine
  - Screen buffer (80x24)
  - Character positioning
  - Playfield rendering
  - Bordered display

### Game Layer (5 files)
- **[game/main.asm](game/main.asm)** - Main game loop
  - Game initialization
  - Input → Update → Render cycle
  - Victory/death detection
  - Playfield population
  - Random number generation

- **[game/peon.asm](game/peon.asm)** - Player character (Peon)
  - Movement (W/A/S/D)
  - Power-up collection
  - Power state management
  - Character rendering
  - Alive/dead state

- **[game/enemies.asm](game/enemies.asm)** - Enemy system
  - 10 regular enemies (Agents & Stormtroopers)
  - Simple pursuit AI
  - Boss enemies (Smith & Vader)
  - Collision detection
  - Enemy rendering

- **[game/collision.asm](game/collision.asm)** - Collision utilities
  - Position-based collision checks
  - Entity type checking

- **[game/powerups.asm](game/powerups.asm)** - Power-up system
  - Asterisk spawning (*)
  - Agent eater spawning (a)
  - Stormtrooper eater spawning (s)
  - Power-up documentation

### TCP & AI Layer (2 files)
- **[tcp/protocol.asm](tcp/protocol.asm)** - Tiny Context Protocol
  - TCP initialization
  - Request/response system
  - 3-byte header ("TCP")
  - Buffer management

- **[tcp/8lm.asm](tcp/8lm.asm)** - Emperor 8LM (4 braincells)
  - Braincell 1: Grammar structure
  - Braincell 2: Villain vocabulary
  - Braincell 3: Halting problem references
  - Braincell 4: Name recognition
  - 8 speech variants
  - Death speech generation

## 🔧 Build System Files (2)

- **[Makefile](Makefile)** - Build automation
  - Targets: all, clean, rebuild, info, help
  - ARM cross-compilation
  - Dependency management

- **[linker.ld](linker.ld)** - Linker script
  - Memory layout for Raspberry Pi
  - Section organization (.text, .data, .bss)
  - Load address: 0x8000

## 📊 Data Files (1)

- **[data/sprites.dat](data/sprites.dat)** - Character definitions
  - Player sprites (P, @)
  - Enemy sprites (A, S, M, V)
  - Power-up symbols (*, a, s)
  - UI elements

## 📁 Directory Structure

```
smithvader/
├── INDEX.md              ← You are here
├── README.md
├── QUICKSTART.md
├── PLAN.claude
├── ARCHITECTURE.md
├── EMPEROR_8LM.md
├── PROJECT_SUMMARY.md
├── Makefile
├── linker.ld
│
├── boot/
│   └── boot.asm
│
├── kernel/
│   ├── kernel.asm
│   ├── memory.asm
│   └── interrupts.asm
│
├── system/
│   ├── users.asm
│   └── display.asm
│
├── game/
│   ├── main.asm
│   ├── peon.asm
│   ├── enemies.asm
│   ├── collision.asm
│   └── powerups.asm
│
├── tcp/
│   ├── protocol.asm
│   └── 8lm.asm
│
└── data/
    └── sprites.dat
```

## 📈 File Statistics

| Category | Files | Lines (est.) |
|----------|-------|--------------|
| Documentation | 6 | ~2,500 |
| Assembly Code | 13 | ~1,850 |
| Build System | 2 | ~150 |
| Data | 1 | ~40 |
| **Total** | **22** | **~4,540** |

## 🎯 Where to Start

### For Players
1. **[QUICKSTART.md](QUICKSTART.md)** - Learn how to play
2. **[README.md](README.md)** - Understand the features
3. Build and run!

### For Developers
1. **[PLAN.claude](PLAN.claude)** - See the development roadmap
2. **[ARCHITECTURE.md](ARCHITECTURE.md)** - Understand the system
3. **[boot/boot.asm](boot/boot.asm)** - Start from the bootloader
4. **[game/main.asm](game/main.asm)** - Explore the game loop

### For AI Enthusiasts
1. **[EMPEROR_8LM.md](EMPEROR_8LM.md)** - 4-braincell architecture
2. **[tcp/8lm.asm](tcp/8lm.asm)** - Implementation
3. **[tcp/protocol.asm](tcp/protocol.asm)** - Communication protocol

### For Researchers
1. **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - High-level overview
2. **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical details
3. Full source code exploration

## 🔍 Quick Navigation by Topic

### Operating System Components
- Bootloader: [boot/boot.asm](boot/boot.asm)
- Memory: [kernel/memory.asm](kernel/memory.asm)
- Interrupts: [kernel/interrupts.asm](kernel/interrupts.asm)
- Main Loop: [kernel/kernel.asm](kernel/kernel.asm)

### Game Components
- Player: [game/peon.asm](game/peon.asm)
- Enemies: [game/enemies.asm](game/enemies.asm)
- Game Loop: [game/main.asm](game/main.asm)
- Collision: [game/collision.asm](game/collision.asm)

### User Interface
- Display: [system/display.asm](system/display.asm)
- User Input: [system/users.asm](system/users.asm)
- Boot Screen: [boot/boot.asm](boot/boot.asm)

### AI/TCP
- Protocol: [tcp/protocol.asm](tcp/protocol.asm)
- 8LM Engine: [tcp/8lm.asm](tcp/8lm.asm)
- Specification: [EMPEROR_8LM.md](EMPEROR_8LM.md)

## 🎮 Game Mechanics Quick Reference

| File | Mechanic |
|------|----------|
| [game/peon.asm](game/peon.asm) | Movement, power-ups, death |
| [game/enemies.asm](game/enemies.asm) | AI pursuit, spawning |
| [game/collision.asm](game/collision.asm) | Hit detection |
| [game/powerups.asm](game/powerups.asm) | `*`, `a`, `s` collection |
| [game/main.asm](game/main.asm) | Victory/death handling |
| [system/users.asm](system/users.asm) | Imprisonment/liberation |

## 🧠 Emperor 8LM Quick Reference

| Braincell | File | Function |
|-----------|------|----------|
| 1 | [tcp/8lm.asm](tcp/8lm.asm) | Grammar structure |
| 2 | [tcp/8lm.asm](tcp/8lm.asm) | Villain vocabulary |
| 3 | [tcp/8lm.asm](tcp/8lm.asm) | Halting problem refs |
| 4 | [tcp/8lm.asm](tcp/8lm.asm) | Name recognition |

## 🛠️ Build Process Flow

```
Source Files (.asm)
    ↓
Makefile
    ↓
arm-none-eabi-as (assembler)
    ↓
Object Files (.o)
    ↓
arm-none-eabi-ld (linker) + linker.ld
    ↓
ELF File
    ↓
arm-none-eabi-objcopy
    ↓
smithvader.img (bootable image)
```

## 📝 License & Usage

All files are public domain. Use for:
- Education
- Learning
- Experimentation
- Fun
- Hackathons
- Portfolio projects

## 🎊 Credits

Created as a revolutionary demonstration of:
- Bare-metal OS development
- ARM assembly programming
- Constrained AI design
- Novel game mechanics
- The solution to the halting problem

---

**Total Project Size**: 22 files, ~4,540 lines, unlimited fun!

**Status**: ✅ Complete and ready to solve the halting problem!

**Next Steps**: Build, flash, boot, play, win, halt, repeat!

---

*"The index has been compiled. The structure is clear. Begin your journey, Peon."*
