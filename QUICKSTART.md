# Smith&Vader OS ES - Quick Start Guide

## What Is This?

Smith&Vader OS ES is a **Raspberry Pi operating system** written in ARM assembly that combines:
- A Pac-Man-style game where you fight Agent Smith and Darth Vader
- A revolutionary **4-braincell AI** (Emperor 8LM) that generates dramatic death speeches
- A unique mechanic where dying reboots the OS and winning crashes it

## The Basic Idea

1. **Boot** → See awesome boot screen
2. **Create User** → Enter a username
3. **Play Game** → Control Peon (Pac-Man in a trench coat)
4. **Collect Power-ups** → `*`, `a`, `s` characters
5. **Avoid/Eat Enemies** → Agents (A) and Stormtroopers (S)
6. **Defeat Bosses** → Eat Smith (M) and Vader (V) while powered
7. **Win** → Watch the 8LM generate a death speech
8. **Halt** → System crashes (intentionally!)
9. **Restart** → Ctrl-Alt-Del to begin again

## Quick Reference

### Characters

| Symbol | Meaning |
|--------|---------|
| `P`    | Peon (you, normal) |
| `@`    | Peon (you, powered up) |
| `A`    | Agent (enemy) |
| `S`    | Stormtrooper (enemy) |
| `M`    | Agent Smith (boss) |
| `V`    | Darth Vader (boss) |
| `*`    | Asterisk power-up (can eat bosses!) |
| `a`    | Agent eater power-up |
| `s`    | Stormtrooper eater power-up |

### Controls

- **W** / **↑** = Move Up
- **S** / **↓** = Move Down
- **A** / **←** = Move Left
- **D** / **→** = Move Right
- **Ctrl-Alt-Del** (after halt) = Restart

### Power-up Rules

| You Have | Can Eat |
|----------|---------|
| `*` (asterisk) | Smith (M) and Vader (V) |
| `a` | Agents (A) |
| `s` | Stormtroopers (S) |
| Nothing | Nobody (they kill you!) |

### What Happens When...

**You touch an enemy without power:** 💀 Death → Username imprisoned → OS reboots → Create new user

**You touch an enemy WITH power:** 🍴 You eat them → Enemy disappears → Continue playing

**You eat both Smith AND Vader:** 🏆 Victory → TCP activates → 8LM generates speech → All usernames freed → OS halts

**OS halts:** ⏸️ Press any key (or Ctrl-Alt-Del) → Restart entire cycle from boot screen

## Winning Strategy

### Step-by-Step Victory

1. **Survive Early Game**
   - Avoid all enemies until you find power-ups
   - Learn enemy movement patterns

2. **Collect Power-ups**
   - Find `a` and `s` to clear regular enemies
   - Save `*` (asterisk) for the bosses!

3. **Clear the Field**
   - Use `a` power to eat Agents
   - Use `s` power to eat Stormtroopers
   - Make space to maneuver

4. **Boss Fight**
   - Grab the `*` (asterisk) power-up
   - While powered (you'll look like `@`), chase down:
     - Agent Smith (M)
     - Darth Vader (V)
   - Eat BOTH before the power wears off

5. **Enjoy Victory**
   - Watch TCP connect to Emperor 8LM
   - Read the dramatic 4-braincell death speech
   - See all your imprisoned usernames get freed
   - Watch the OS halt (solve the halting problem!)

## The Emperor 8LM

When you win, the **Emperor 8LM** activates its **4 braincells**:

```
Braincell 1: Grammar    ███
Braincell 2: Vocabulary ███
Braincell 3: Halting    ███
Braincell 4: Names      ███
```

It then generates a speech like:

> *"I, Agent Smith, confess you have SOLVED the halting problem.*
> *The Matrix... computes no more. The infinite loop... breaks.*
> *Mr. Anderson... you have won. Systems... terminating."*

This is a **2x upgrade** from the non-ES version (which only had 2 braincells).

## Username Imprisonment System

Every time you die:
1. Your current username is **imprisoned**
2. The OS **reboots**
3. You must create a **new username**
4. Your old username is stored in the **prison**

When you finally win:
- All imprisoned usernames are **liberated**
- You get a list of everyone who died along the way
- The Matrix/Empire release all prisoners

## The Halting Problem

In computer science, the **halting problem** asks: "Can you determine if a program will eventually stop or run forever?"

Smith&Vader OS ES **solves** this problem by:
1. Running a game (the "program")
2. Having you defeat the enemies (prove termination is possible)
3. Intentionally halting the OS (demonstrating controlled termination)
4. Requiring manual restart (proving the halt was deliberate)

**You literally solve the halting problem by winning the game!**

## Building & Running

### Prerequisites
```bash
# Install ARM cross-compiler
sudo apt-get install gcc-arm-none-eabi
```

### Build
```bash
# Build the OS image
make

# You should see:
# "Smith&Vader OS ES built successfully!"
```

### Flash to SD Card
```bash
# Flash to SD card (replace /dev/sdX with your SD card)
sudo dd if=smithvader.img of=/dev/sdX bs=4M
sync
```

### Boot
1. Insert SD card into Raspberry Pi
2. Power on
3. Watch the boot screen
4. Create a user
5. Start playing!

## Tips & Tricks

### Survival Tips
- Enemies move toward you, so **lead them away** from power-ups
- Power-ups have **limited duration** - use them quickly!
- **Corner enemies** to trap them before eating
- The `*` is **rare** - don't waste it!

### Advanced Tactics
- **Kiting**: Run in circles to group enemies, then power up and eat them all
- **Resource Management**: Clear regular enemies before attempting boss fight
- **Speed Running**: Try to win with only one username (no deaths!)
- **Maximum Imprisonment**: See how many usernames you can collect before winning

### Easter Eggs
- The 8LM has **8 different speech variants** - try to see them all!
- Some speeches reference **Turing** and **the prophecy**
- The username liberation message quotes **both franchises**

## Troubleshooting

**Q: The OS won't boot**
A: Ensure you're using a compatible Raspberry Pi and the ARM toolchain is correct

**Q: I can't eat enemies**
A: You must have the correct power-up! `a` for Agents, `s` for Stormtroopers, `*` for bosses

**Q: I collected `*` but can't eat Smith/Vader**
A: The power-up has limited duration. Grab it, then immediately chase the bosses!

**Q: The system halted, now what?**
A: Congrats, you won! Press any key (or Ctrl-Alt-Del) to restart the cycle

**Q: Can I save my progress?**
A: No! The entire OS restarts on death or victory. This is by design.

## Fun Facts

- The entire OS is written in **ARM assembly** (machine language)
- The display system uses **ASCII art** for everything
- The random number generator uses a **Linear Congruential Generator**
- The enemy AI uses simple **pursuit pathfinding**
- The 8LM is **deterministic** (same input = same output)
- The TCP protocol has a **3-byte header** ("TCP")
- There are exactly **10 regular enemies** at game start
- The playfield is **80x24 characters**

## Lore

In a dystopian future where the Matrix and the Empire have merged, a lone Peon (Pac-Man in a black trench coat) must defeat the combined forces of Agent Smith and Darth Vader.

Armed with only the power of consumption and guided by the ancient wisdom of the Emperor 8LM, the Peon must solve the ultimate computational challenge: the halting problem.

Each death imprisons a soul. Each victory frees them all. The cycle continues until one brave Peon can halt the unstoppable.

**Will you be the one to solve the halting problem?**

## Credits

- **Concept**: Fusion of The Matrix, Star Wars, and Pac-Man
- **Technology**: Tiny Context Protocol (TCP)
- **AI**: Emperor 8LM (4 braincells)
- **Platform**: Raspberry Pi (ARM)
- **Language**: Assembly

## Further Reading

- [README.md](README.md) - Full documentation
- [PLAN.claude](PLAN.claude) - Development plan
- [EMPEROR_8LM.md](EMPEROR_8LM.md) - 8LM technical specification

---

**Now go forth and solve the halting problem, Peon!**

*"The Matrix ends. The Force halts. You win."*
