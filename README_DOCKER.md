# Smith&Vader OS ES - Docker Quick Start

## 🎮 **Play It NOW!**

```bash
./build.sh      # Build Docker image
./run-demo.sh   # Play the game!
```

## What You Get

A fully playable C implementation with:
- ✅ Boot screen
- ✅ User creation
- ✅ Full gameplay (W/A/S/D controls)
- ✅ 10 enemies with AI
- ✅ Smith & Vader bosses
- ✅ Power-ups (*, a, s)
- ✅ **Emperor 8LM (4 braincells!)**
- ✅ Death speeches
- ✅ Username imprisonment
- ✅ Victory liberation
- ✅ Halting problem solution

## The Game

**Goal**: Defeat Agent Smith (M) and Darth Vader (V)

**Controls**:
- W/A/S/D - Move
- Q - Quit

**Power-ups**:
- `*` - Eat bosses (Smith & Vader)
- `a` - Eat Agents
- `s` - Eat Stormtroopers

**Mechanic**:
- Death → Username imprisoned → Reboot
- Victory → 8LM speech → Liberation → Halt

## Quick Commands

```bash
# Play the game
./run-demo.sh

# Build Docker image
./build.sh

# Interactive shell
docker-compose run --rm smithvader-build /bin/bash
```

## Documentation

- [START_HERE.md](START_HERE.md) - Quick overview
- [GETTING_STARTED.md](GETTING_STARTED.md) - Full playthrough
- [DOCKER.md](DOCKER.md) - Docker details
- [QUICKSTART.md](QUICKSTART.md) - Gameplay guide

## About Assembly Version

The project includes 13 ARM assembly files that show the full OS architecture. These are **educational reference files** demonstrating bare-metal programming.

**The playable version is the C demo** - it gives you the complete experience!

## Emperor 8LM

When you win, watch the 4-braincell AI generate a death speech:

```
Braincells: █ █ █ █

"I, Agent Smith, confess you have SOLVED the halting problem.
 The Matrix... computes no more. The infinite loop... breaks.
 Mr. Anderson... you have won. Systems... terminating."
```

## Start Playing!

```bash
./run-demo.sh
```

**The halting problem awaits!**
