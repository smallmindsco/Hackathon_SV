# Smith&Vader OS ES - System Architecture

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    SMITH&VADER OS... ES                          │
│                                                                  │
│  ┌────────────┐  ┌──────────────┐  ┌─────────────────────────┐ │
│  │   BOOT     │  │   KERNEL     │  │    GAME ENGINE          │ │
│  │            │→ │              │→ │                         │ │
│  │ Bootloader │  │ Memory Mgmt  │  │ Peon + Enemies + AI     │ │
│  │ Boot Screen│  │ Interrupts   │  │ Collision Detection     │ │
│  └────────────┘  └──────────────┘  └─────────────────────────┘ │
│                                                                  │
│  ┌────────────┐  ┌──────────────┐  ┌─────────────────────────┐ │
│  │  SYSTEM    │  │     TCP      │  │    EMPEROR 8LM          │ │
│  │            │  │              │  │                         │ │
│  │ Users      │  │ Protocol     │  │ 4-Braincell Model       │ │
│  │ Display    │  │ Communication│  │ Speech Generation       │ │
│  └────────────┘  └──────────────┘  └─────────────────────────┘ │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Layer Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 6: Emperor 8LM & TCP                                 │
│  - Tiny Context Protocol                                    │
│  - 4-Braincell Speech Generation                            │
├─────────────────────────────────────────────────────────────┤
│  Layer 5: User Management                                   │
│  - Account Creation                                         │
│  - Username Storage                                         │
│  - Imprisonment System                                      │
├─────────────────────────────────────────────────────────────┤
│  Layer 4: Game Loop                                         │
│  - Input Handling                                           │
│  - State Updates                                            │
│  - Victory/Death Detection                                  │
├─────────────────────────────────────────────────────────────┤
│  Layer 3: Game Entities                                     │
│  - Peon Character                                           │
│  - Enemy AI (Agents, Stormtroopers)                         │
│  - Boss Logic (Smith, Vader)                                │
│  - Power-up System                                          │
├─────────────────────────────────────────────────────────────┤
│  Layer 2: Display & Terminal                                │
│  - ASCII Rendering                                          │
│  - Screen Buffer                                            │
│  - Character Positioning                                    │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: Kernel & Hardware                                 │
│  - Memory Management                                        │
│  - Interrupt Handling                                       │
│  - UART Communication                                       │
├─────────────────────────────────────────────────────────────┤
│  Layer 0: Bootloader                                        │
│  - Hardware Init                                            │
│  - Boot Screen                                              │
└─────────────────────────────────────────────────────────────┘
```

## Game State Machine

```
                    ┌──────────┐
                    │   BOOT   │
                    └────┬─────┘
                         │
                         ▼
                 ┌───────────────┐
                 │ CREATE USER   │
                 └───────┬───────┘
                         │
                         ▼
                 ┌───────────────┐
                 │  GAME START   │
                 └───────┬───────┘
                         │
                    ┌────┴────┐
                    │  PLAY   │
                    └────┬────┘
                         │
            ┌────────────┼────────────┐
            │                         │
            ▼                         ▼
      ┌──────────┐              ┌──────────┐
      │  DEATH   │              │ VICTORY  │
      └────┬─────┘              └────┬─────┘
           │                         │
           ▼                         ▼
   ┌────────────────┐        ┌──────────────┐
   │ IMPRISON USER  │        │  TCP REQUEST │
   └────────┬───────┘        └──────┬───────┘
            │                       │
            ▼                       ▼
   ┌────────────────┐        ┌──────────────┐
   │    REBOOT      │        │  8LM SPEECH  │
   └────────┬───────┘        └──────┬───────┘
            │                       │
            └──────┐         ┌──────┘
                   │         │
                   ▼         ▼
                 ┌─────────────────┐
                 │ LIBERATE USERS  │
                 └────────┬────────┘
                          │
                          ▼
                    ┌──────────┐
                    │   HALT   │
                    └────┬─────┘
                         │
                         ▼
                  ┌─────────────┐
                  │ Ctrl-Alt-Del│
                  └──────┬──────┘
                         │
                         └─────────┐
                                   │
                                   ▼
                              ┌──────────┐
                              │   BOOT   │ (cycle repeats)
                              └──────────┘
```

## Memory Map

```
0x00000000  ┌─────────────────────────────┐
            │   Reserved / Exception      │
            │   Vectors                   │
0x00008000  ├─────────────────────────────┤
            │   .text (Code)              │
            │   - boot.asm                │
            │   - kernel.asm              │
            │   - All game code           │
            ├─────────────────────────────┤
            │   .rodata (Read-only Data)  │
            │   - Strings                 │
            │   - Banner art              │
            │   - 8LM speeches            │
            ├─────────────────────────────┤
            │   .data (Initialized Data)  │
            │   - Game state              │
            │   - Enemy positions         │
            ├─────────────────────────────┤
            │   .bss (Uninitialized)      │
            │   - Screen buffer (1920B)   │
            │   - User data (8KB)         │
            │   - Game data (32KB)        │
            ├─────────────────────────────┤
            │   Heap (16KB)               │
            │   - Dynamic allocation      │
            ├─────────────────────────────┤
            │   Stack                     │
            │   (grows downward)          │
0xFFFFFFFF  └─────────────────────────────┘
```

## Emperor 8LM Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      EMPEROR 8LM                            │
│                   (4-Braincell Model)                       │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
         ┌────────────────────────────────────┐
         │      TCP Request Interface         │
         └────────────────┬───────────────────┘
                          │
         ┌────────────────┴───────────────────┐
         │                                    │
         ▼                                    ▼
┌──────────────────┐              ┌──────────────────┐
│  Braincell 1     │              │  Braincell 4     │
│  Grammar         │              │  Name Recognition│
│  Structure       │              │  & Entities      │
└────────┬─────────┘              └────────┬─────────┘
         │                                 │
         ▼                                 ▼
┌──────────────────┐              ┌──────────────────┐
│  Braincell 2     │              │  Braincell 3     │
│  Villain         │              │  Halting Problem │
│  Vocabulary      │              │  References      │
└────────┬─────────┘              └────────┬─────────┘
         │                                 │
         └────────────────┬────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │  Speech Synthesizer   │
              │  (Template Engine)    │
              └───────────┬───────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   TCP Response        │
              │   (Death Speech)      │
              └───────────────────────┘
```

## Game Entity Relationships

```
                    ┌──────────┐
                    │   PEON   │
                    │  (P/@)   │
                    └────┬─────┘
                         │
           ┌─────────────┼─────────────┐
           │                           │
           ▼                           ▼
    ┌─────────────┐            ┌─────────────┐
    │  POWER-UPS  │            │   ENEMIES   │
    └─────────────┘            └─────────────┘
           │                           │
    ┌──────┼──────┐          ┌─────────┼─────────┐
    ▼      ▼      ▼          ▼                   ▼
  ┌───┐  ┌───┐  ┌───┐   ┌─────────┐      ┌─────────────┐
  │ * │  │ a │  │ s │   │ REGULAR │      │   BOSSES    │
  └───┘  └───┘  └───┘   │ ENEMIES │      └─────────────┘
                         └─────────┘             │
                              │            ┌─────┴─────┐
                         ┌────┴────┐       ▼           ▼
                         ▼         ▼    ┌─────┐   ┌───────┐
                      ┌─────┐  ┌─────┐  │Smith│   │ Vader │
                      │Agent│  │Storm│  │ (M) │   │  (V)  │
                      │ (A) │  │ (S) │  └─────┘   └───────┘
                      └─────┘  └─────┘

Legend:
  * = Asterisk (eat bosses)
  a = Agent eater
  s = Stormtrooper eater
  P = Peon normal
  @ = Peon powered
```

## Data Flow: Victory Sequence

```
┌─────────────────┐
│ Peon eats both  │
│ Smith & Vader   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ check_game_state│
│ returns 2       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│show_victory_    │
│screen()         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ trigger_tcp()   │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ TCP sends request to Emperor 8LM    │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Braincell 1: Grammar Structure      │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Braincell 2: Villain Vocabulary     │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Braincell 3: Halting Problem Ref    │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Braincell 4: Name Recognition       │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Generate final death speech         │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ TCP response with speech            │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Display speech to user              │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ liberate_all_usernames()            │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Display liberation message          │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ system_halt()                       │
│ "Halting problem SOLVED"            │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Wait for Ctrl-Alt-Del               │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│ Jump to _start (reboot)             │
└─────────────────────────────────────┘
```

## File Dependencies

```
boot.asm
  │
  ├──> kernel.asm
  │      ├──> memory.asm
  │      ├──> interrupts.asm
  │      └──> users.asm
  │             └──> display.asm
  │
  └──> game/main.asm
         ├──> peon.asm
         │      └──> display.asm
         ├──> enemies.asm
         │      ├──> peon.asm (for position)
         │      └──> display.asm
         ├──> collision.asm
         │      └──> display.asm
         ├──> powerups.asm
         │      └──> display.asm
         └──> tcp/protocol.asm
                └──> tcp/8lm.asm
```

## Interrupt Flow

```
┌──────────────┐
│   Hardware   │
│   Interrupt  │
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│ Interrupt Vector │
│ Table            │
└──────┬───────────┘
       │
       ├──> IRQ Handler
       ├──> FIQ Handler
       ├──> SWI Handler
       └──> Others
              │
              ▼
       ┌──────────────┐
       │ Process      │
       │ Interrupt    │
       └──────┬───────┘
              │
              ▼
       ┌──────────────┐
       │ Return to    │
       │ Main Code    │
       └──────────────┘
```

## Key Algorithms

### Enemy AI (Simple Pursuit)
```
function update_enemy(enemy, peon):
    if enemy.x > peon.x:
        enemy.x -= 1
    else if enemy.x < peon.x:
        enemy.x += 1

    if enemy.y > peon.y:
        enemy.y -= 1
    else if enemy.y < peon.y:
        enemy.y += 1
```

### Collision Detection
```
function check_collision(peon, enemies):
    for each enemy in enemies:
        if peon.x == enemy.x AND peon.y == enemy.y:
            if peon.has_power_for(enemy):
                deactivate(enemy)
            else:
                kill_peon()
```

### Random Number Generation (LCG)
```
function random():
    seed = (seed * 1103515245 + 12345) mod 2^32
    return seed
```

## Performance Metrics

| Component | Lines of Code | Memory Usage |
|-----------|---------------|--------------|
| Boot | ~150 | 1KB |
| Kernel | ~200 | 2KB |
| Display | ~300 | 2KB + 1920B buffer |
| Game Logic | ~500 | 4KB |
| Enemy AI | ~400 | 640B (10 enemies) |
| TCP/8LM | ~300 | 3KB |
| **Total** | **~1850** | **~15KB** |

---

This architecture enables the revolutionary Smith&Vader OS ES to run on bare-metal Raspberry Pi hardware while providing an engaging game experience and solving the halting problem.
