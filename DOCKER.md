# Smith&Vader OS ES - Docker Guide

## Overview

This guide shows you how to build and run Smith&Vader OS ES using Docker, no Raspberry Pi hardware required!

## What's Included

### Two Versions

1. **Assembly Version** - The original ARM assembly code for Raspberry Pi
2. **Demo Version** - A C implementation you can actually run and play!

### Docker Components

- **Dockerfile** - Ubuntu-based container with ARM toolchain
- **docker-compose.yml** - Easy container orchestration
- **Build scripts** - Simple shell scripts to run everything

## Quick Start

### Prerequisites

- Docker Desktop installed and running
- That's it!

### 1. Build the Docker Image

```bash
./build.sh
```

This will:
- Build a Docker image with ARM cross-compiler
- Install QEMU for emulation
- Set up the build environment

### 2. Run the Demo

```bash
./run-demo.sh
```

This will:
- Build and run the C demo version
- Let you actually play the game!
- Experience the full gameplay loop

### 3. Build the Assembly (Optional)

```bash
./run-build.sh
```

This will:
- Compile the ARM assembly code
- Generate `smithvader.img`
- Prepare for Raspberry Pi deployment

## Demo Version Gameplay

The C demo version gives you the full Smith&Vader experience:

### Controls
- **W** - Move up
- **A** - Move left
- **S** - Move down
- **D** - Move right
- **Q** - Quit

### Game Flow

1. **Boot Screen** - See the awe-inspiring ASCII art
2. **Create User** - Enter your username
3. **Play** - Navigate as Peon (P)
4. **Collect Power-ups**:
   - `*` - Can eat Smith (M) and Vader (V)
   - `a` - Can eat Agents (A)
   - `s` - Can eat Stormtroopers (S)
5. **Avoid Enemies** - Or eat them if powered!
6. **Defeat Bosses** - Eat both Smith and Vader while powered with `*`
7. **Victory** - Watch the Emperor 8LM generate a death speech
8. **Liberation** - All imprisoned usernames are freed
9. **Halt** - System "halts" (press Enter to restart)

### Death vs Victory

**Death** (touch enemy without power):
- Username gets imprisoned
- "OS reboots" (restarts game)
- Must create new user

**Victory** (eat both bosses):
- TCP activates
- Emperor 8LM's 4 braincells generate speech
- All usernames liberated
- System halts (press Enter to restart)

## Manual Docker Commands

If you prefer to run Docker commands directly:

### Build Image
```bash
docker-compose build
```

### Run Demo
```bash
docker-compose run --rm smithvader-demo
```

### Build Assembly
```bash
docker-compose run --rm smithvader-build make
```

### Interactive Shell
```bash
docker-compose run --rm smithvader-build /bin/bash
```

Inside the shell you can:
```bash
# Build assembly
make

# View source
cat boot/boot.asm

# Check build info
make info

# Explore the code
tree
```

## Docker Architecture

```
┌─────────────────────────────────────────┐
│  Docker Host (Your Computer)            │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │  smithvader-os-es Container       │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Ubuntu 22.04               │  │  │
│  │  │                             │  │  │
│  │  │  • ARM cross-compiler       │  │  │
│  │  │  • QEMU emulation           │  │  │
│  │  │  • GCC for C demo           │  │  │
│  │  │  • All source code          │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  Runs:                            │  │
│  │  - demo/demo.c (playable!)        │  │
│  │  - make (builds assembly)         │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Volume Mount: .:/smithvader            │
│  (Source code accessible)               │
└─────────────────────────────────────────┘
```

## Files Created

### Docker Files
- `Dockerfile` - Container definition
- `docker-compose.yml` - Service orchestration
- `build.sh` - Build the image
- `run-demo.sh` - Run the C demo
- `run-build.sh` - Build assembly code

### Demo Files
- `demo/demo.c` - Playable C implementation
- `demo/Makefile` - Demo build system

## Troubleshooting

### Docker not running
```
Error: Docker is not running!
```
**Solution**: Start Docker Desktop

### Permission denied on scripts
```
Permission denied: ./build.sh
```
**Solution**:
```bash
chmod +x *.sh
./build.sh
```

### Container already exists
```
Error: container name "smithvader-demo" is already in use
```
**Solution**:
```bash
docker-compose down
./run-demo.sh
```

### Demo display issues
The demo works best in a terminal that supports:
- UTF-8 characters (for borders)
- ANSI escape codes (for colors/clearing)

## What Happens in Each Script

### build.sh
1. Checks if Docker is running
2. Runs `docker-compose build`
3. Creates image with ARM toolchain
4. Shows next steps

### run-demo.sh
1. Checks Docker
2. Runs `docker-compose run smithvader-demo`
3. Builds C demo inside container
4. Launches the game
5. Interactive gameplay!

### run-build.sh
1. Checks Docker
2. Runs `make` inside container
3. Compiles all assembly files
4. Links into `smithvader.img`
5. Image ready for Raspberry Pi

## Advanced Usage

### Access Build Artifacts

The container mounts your local directory, so build artifacts appear on your host:

```bash
# After running ./run-build.sh
ls -la smithvader.img

# After running demo
ls -la demo/demo
```

### Modify and Rebuild

1. Edit source files on your host machine
2. Run `./run-demo.sh` or `./run-build.sh`
3. Changes are automatically used

### Clean Everything

```bash
# Clean Docker
docker-compose down
docker-compose build --no-cache

# Clean builds
docker-compose run --rm smithvader-build make clean
docker-compose run --rm smithvader-build bash -c "cd demo && make clean"
```

## System Requirements

### Host System
- Docker Desktop (Windows/Mac/Linux)
- 2GB free disk space
- 1GB RAM minimum

### Docker Container
- Ubuntu 22.04 base
- gcc-arm-none-eabi (~200MB)
- QEMU (~100MB)
- Build tools (~50MB)

## Why Two Versions?

### Assembly Version (Original)
- **Purpose**: Real Raspberry Pi deployment
- **Language**: ARM assembly
- **Runs on**: Bare metal Raspberry Pi
- **Status**: Buildable in Docker, requires hardware to run

### Demo Version (C Port)
- **Purpose**: Playable demonstration
- **Language**: C
- **Runs on**: Any system (via Docker)
- **Status**: Fully playable!

The demo version faithfully recreates the gameplay mechanics:
- Boot screen
- User creation
- Peon movement
- Enemy AI
- Power-ups
- Boss fight
- Emperor 8LM speeches
- Username imprisonment
- Liberation on victory
- Halting problem solution

## Emperor 8LM in the Demo

The demo version includes the full 4-braincell Emperor 8LM:

```
Activating braincells: █ █ █ █

Braincell 1: Grammar Structure
Braincell 2: Villain Vocabulary
Braincell 3: Halting Problem References
Braincell 4: Name Recognition
```

You'll see actual death speeches generated when you win!

## Next Steps

1. **Play the Demo**
   ```bash
   ./run-demo.sh
   ```
   Experience the full game!

2. **Explore the Code**
   ```bash
   docker-compose run --rm smithvader-build /bin/bash
   # Inside container:
   cat tcp/8lm.asm  # See the Emperor 8LM
   cat game/peon.asm  # See Peon logic
   ```

3. **Build for Raspberry Pi**
   ```bash
   ./run-build.sh
   # Flash smithvader.img to SD card
   ```

## Tips for Playing the Demo

### Survival Strategy
1. Learn the controls first (W/A/S/D)
2. Avoid enemies initially
3. Find power-ups (`*`, `a`, `s`)
4. Clear regular enemies first
5. Save asterisk (`*`) for bosses!

### Winning Fast
1. Rush for asterisk (`*`)
2. Immediately chase Smith (M) and Vader (V)
3. Eat both before power wears off
4. Victory!

### Maximum Imprisonment
1. Die multiple times with different usernames
2. Finally win to see all liberated
3. Enjoy the long list of freed souls

## Support

For issues:
1. Check DOCKER.md (this file)
2. Read QUICKSTART.md for gameplay help
3. See README.md for full documentation
4. Review docker-compose.yml for configuration

---

## Quick Reference

```bash
# Setup
./build.sh

# Play the game
./run-demo.sh

# Build assembly
./run-build.sh

# Interactive shell
docker-compose run --rm smithvader-build /bin/bash

# Clean up
docker-compose down
```

---

**The halting problem awaits. Docker is ready. Go forth and play, Peon!**
