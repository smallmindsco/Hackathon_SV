/*
 * Smith&Vader OS ES - Demo Version
 * A C implementation for QEMU testing
 * Demonstrates the game logic without bare-metal assembly
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 24
#define MAX_ENEMIES 10
#define MAX_USERNAMES 64

// Game state
typedef struct {
    int x, y;
    int powered;
    int power_timer;
    int alive;
} Peon;

typedef struct {
    int x, y;
    int type; // 0=Agent, 1=Stormtrooper
    int active;
} Enemy;

typedef struct {
    int x, y;
    int active;
} Boss;

char screen[SCREEN_HEIGHT][SCREEN_WIDTH];
Peon peon;
Enemy enemies[MAX_ENEMIES];
Boss smith, vader;
char imprisoned_usernames[MAX_USERNAMES][17];
int imprisoned_count = 0;
char current_username[17];

// Function prototypes
void clear_screen();
void show_boot_screen();
void create_user();
void init_game();
void populate_playfield();
void update_peon(char input);
void update_enemies();
void draw_all();
void render_screen();
int check_game_state();
void show_death_screen();
void show_victory_screen();
void emperor_8lm_speech();
void liberate_usernames();

// Clear terminal screen
void clear_screen() {
    printf("\033[2J\033[H");
}

// Show awe-inspiring boot screen
void show_boot_screen() {
    clear_screen();
    printf("\n");
    printf("  ███████╗███╗   ███╗██╗████████╗██╗  ██╗    ██╗   ██╗ █████╗ ██████╗ ███████╗██████╗ \n");
    printf("  ██╔════╝████╗ ████║██║╚══██╔══╝██║  ██║    ██║   ██║██╔══██╗██╔══██╗██╔════╝██╔══██╗\n");
    printf("  ███████╗██╔████╔██║██║   ██║   ███████║    ██║   ██║███████║██║  ██║█████╗  ██████╔╝\n");
    printf("  ╚════██║██║╚██╔╝██║██║   ██║   ██╔══██║    ╚██╗ ██╔╝██╔══██║██║  ██║██╔══╝  ██╔══██╗\n");
    printf("  ███████║██║ ╚═╝ ██║██║   ██║   ██║  ██║     ╚████╔╝ ██║  ██║██████╔╝███████╗██║  ██║\n");
    printf("  ╚══════╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝      ╚═══╝  ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝\n");
    printf("\n");
    printf("                           ╔═══════════════════════════════════╗\n");
    printf("                           ║     O P E R A T I N G   S Y S T E M     ║\n");
    printf("                           ║              . . . E S                  ║\n");
    printf("                           ╚═══════════════════════════════════╝\n");
    printf("\n");
    printf("  ┌────────────────────────────────────────────────────────────────────┐\n");
    printf("  │  Tiny Context Protocol (TCP).................... [ ENABLED ]      │\n");
    printf("  │  Emperor 8LM (4 Braincells).................... [ ONLINE ]       │\n");
    printf("  │  Halting Problem Support....................... [ READY ]        │\n");
    printf("  └────────────────────────────────────────────────────────────────────┘\n");
    printf("\n");
    usleep(2000000);
}

// Create user account
void create_user() {
    clear_screen();
    printf("\n");
    printf("  ╔════════════════════════════════════════════════════════════════╗\n");
    printf("  ║           S M I T H & V A D E R   OS ... ES                    ║\n");
    printf("  ║              U S E R   C R E A T I O N                         ║\n");
    printf("  ╚════════════════════════════════════════════════════════════════╝\n");
    printf("\n  Enter username: ");
    fgets(current_username, sizeof(current_username), stdin);
    current_username[strcspn(current_username, "\n")] = 0;
    printf("\n  Welcome, %s!\n\n", current_username);
    usleep(1000000);
}

// Initialize game
void init_game() {
    // Clear screen buffer
    for (int y = 0; y < SCREEN_HEIGHT; y++) {
        for (int x = 0; x < SCREEN_WIDTH; x++) {
            screen[y][x] = ' ';
        }
    }

    // Init peon
    peon.x = 40;
    peon.y = 12;
    peon.powered = 0;
    peon.power_timer = 0;
    peon.alive = 1;

    // Init enemies
    for (int i = 0; i < MAX_ENEMIES; i++) {
        enemies[i].x = rand() % 70 + 5;
        enemies[i].y = rand() % 20 + 2;
        enemies[i].type = rand() % 2;
        enemies[i].active = 1;
    }

    // Init bosses
    smith.x = 20;
    smith.y = 10;
    smith.active = 1;

    vader.x = 60;
    vader.y = 10;
    vader.active = 1;

    populate_playfield();
}

// Populate playfield with power-ups
void populate_playfield() {
    // Add asterisks
    for (int i = 0; i < 3; i++) {
        int x = rand() % 70 + 5;
        int y = rand() % 20 + 2;
        screen[y][x] = '*';
    }

    // Add 'a' and 's' power-ups
    for (int i = 0; i < 8; i++) {
        screen[rand() % 20 + 2][rand() % 70 + 5] = 'a';
        screen[rand() % 20 + 2][rand() % 70 + 5] = 's';
    }

    // Add random characters
    for (int i = 0; i < 50; i++) {
        int x = rand() % 70 + 5;
        int y = rand() % 20 + 2;
        screen[y][x] = (char)(rand() % 26 + 65);
    }
}

// Update peon based on input
void update_peon(char input) {
    if (!peon.alive) return;

    int new_x = peon.x;
    int new_y = peon.y;

    switch (input) {
        case 'w': case 'W': new_y--; break;
        case 's': case 'S': new_y++; break;
        case 'a': case 'A': new_x--; break;
        case 'd': case 'D': new_x++; break;
    }

    // Bounds check
    if (new_x >= 0 && new_x < SCREEN_WIDTH && new_y >= 0 && new_y < SCREEN_HEIGHT) {
        char c = screen[new_y][new_x];

        // Check for power-ups
        if (c == '*') {
            peon.powered |= 1;  // Use |= to preserve other powers
            peon.power_timer = 50;
        } else if (c == 'a') {
            peon.powered |= 2;
            peon.power_timer = 50;
        } else if (c == 's') {
            peon.powered |= 4;
            peon.power_timer = 50;
        }

        // Check if moving onto a boss
        if (smith.active && new_x == smith.x && new_y == smith.y) {
            if (peon.powered & 1) {
                // Can eat Smith!
                smith.active = 0;
            } else {
                // Smith kills us
                peon.alive = 0;
                return;  // Don't move if dead
            }
        }

        if (vader.active && new_x == vader.x && new_y == vader.y) {
            if (peon.powered & 1) {
                // Can eat Vader!
                vader.active = 0;
            } else {
                // Vader kills us
                peon.alive = 0;
                return;  // Don't move if dead
            }
        }

        // Check if moving onto a regular enemy
        for (int i = 0; i < MAX_ENEMIES; i++) {
            if (enemies[i].active && new_x == enemies[i].x && new_y == enemies[i].y) {
                if ((enemies[i].type == 0 && (peon.powered & 2)) ||
                    (enemies[i].type == 1 && (peon.powered & 4))) {
                    // Can eat this enemy!
                    enemies[i].active = 0;
                } else {
                    // Enemy kills us
                    peon.alive = 0;
                    return;  // Don't move if dead
                }
            }
        }

        screen[peon.y][peon.x] = ' ';
        peon.x = new_x;
        peon.y = new_y;
    }

    // Update power timer
    if (peon.power_timer > 0) {
        peon.power_timer--;
        if (peon.power_timer == 0) {
            peon.powered = 0;
        }
    }
}

// Update enemies
void update_enemies() {
    for (int i = 0; i < MAX_ENEMIES; i++) {
        if (!enemies[i].active) continue;

        // Simple AI: move toward peon
        if (enemies[i].x < peon.x) enemies[i].x++;
        else if (enemies[i].x > peon.x) enemies[i].x--;

        if (enemies[i].y < peon.y) enemies[i].y++;
        else if (enemies[i].y > peon.y) enemies[i].y--;

        // Check collision
        if (enemies[i].x == peon.x && enemies[i].y == peon.y) {
            if ((enemies[i].type == 0 && (peon.powered & 2)) ||
                (enemies[i].type == 1 && (peon.powered & 4))) {
                enemies[i].active = 0;
            } else {
                peon.alive = 0;
            }
        }
    }

    // Update bosses
    if (smith.active) {
        if (smith.x < peon.x) smith.x++;
        else if (smith.x > peon.x) smith.x--;
        if (smith.y < peon.y) smith.y++;
        else if (smith.y > peon.y) smith.y--;

        if (smith.x == peon.x && smith.y == peon.y) {
            if (peon.powered & 1) smith.active = 0;
            else peon.alive = 0;
        }
    }

    if (vader.active) {
        if (vader.x < peon.x) vader.x++;
        else if (vader.x > peon.x) vader.x--;
        if (vader.y < peon.y) vader.y++;
        else if (vader.y > peon.y) vader.y--;

        if (vader.x == peon.x && vader.y == peon.y) {
            if (peon.powered & 1) vader.active = 0;
            else peon.alive = 0;
        }
    }
}

// Draw everything
void draw_all() {
    // Draw enemies
    for (int i = 0; i < MAX_ENEMIES; i++) {
        if (enemies[i].active) {
            screen[enemies[i].y][enemies[i].x] = enemies[i].type == 0 ? 'A' : 'S';
        }
    }

    // Draw bosses
    if (smith.active) screen[smith.y][smith.x] = 'M';
    if (vader.active) screen[vader.y][vader.x] = 'V';

    // Draw peon
    if (peon.alive) {
        screen[peon.y][peon.x] = peon.powered ? '@' : 'P';
    }
}

// Render screen
void render_screen() {
    clear_screen();

    // Top border
    printf("┌");
    for (int i = 0; i < SCREEN_WIDTH; i++) printf("─");
    printf("┐\n");

    // Content
    for (int y = 0; y < SCREEN_HEIGHT; y++) {
        printf("│");
        for (int x = 0; x < SCREEN_WIDTH; x++) {
            printf("%c", screen[y][x]);
        }
        printf("│\n");
    }

    // Bottom border
    printf("└");
    for (int i = 0; i < SCREEN_WIDTH; i++) printf("─");
    printf("┘\n");

    // Status
    printf("\nControls: W/A/S/D to move | Q to quit\n");
    printf("Power: %s | Timer: %d\n",
           peon.powered & 1 ? "BOSS EATER" : (peon.powered ? "POWERED" : "NONE"),
           peon.power_timer);
}

// Check game state
int check_game_state() {
    if (!peon.alive) return 1; // Death
    if (!smith.active && !vader.active) return 2; // Victory
    return 0; // Continue
}

// Show death screen
void show_death_screen() {
    clear_screen();
    printf("\n\n");
    printf("  ╔═══════════════════════════════════════════════════════════════╗\n");
    printf("  ║                   D E A T H                                   ║\n");
    printf("  ║         Your username has been IMPRISONED.                   ║\n");
    printf("  ╚═══════════════════════════════════════════════════════════════╝\n");
    printf("\n");

    // Imprison username
    if (imprisoned_count < MAX_USERNAMES) {
        strcpy(imprisoned_usernames[imprisoned_count++], current_username);
    }

    usleep(2000000);
}

// Show victory screen
void show_victory_screen() {
    clear_screen();
    printf("\n\n");
    printf("  ╔═══════════════════════════════════════════════════════════════╗\n");
    printf("  ║          ★ ★ ★  V I C T O R Y  ★ ★ ★                          ║\n");
    printf("  ║      You have devoured Agent Smith and Darth Vader!          ║\n");
    printf("  ╚═══════════════════════════════════════════════════════════════╝\n");
    printf("\n");
    usleep(2000000);
}

// Emperor 8LM speech generation
void emperor_8lm_speech() {
    printf("  ┌────────────────────────────────────────────────────────────┐\n");
    printf("  │  Tiny Context Protocol (TCP) - Initiating...              │\n");
    printf("  │  Emperor 8LM (4 braincells) - Activating...               │\n");
    printf("  └────────────────────────────────────────────────────────────┘\n");
    printf("\n  Braincells: ");

    for (int i = 0; i < 4; i++) {
        usleep(500000);
        printf("█ ");
        fflush(stdout);
    }

    printf("\n\n");
    printf("  ┌───────────────────────────────────────────────────────────────┐\n");
    printf("  │                   FINAL TRANSMISSION                          │\n");
    printf("  └───────────────────────────────────────────────────────────────┘\n");
    printf("\n");

    int variant = rand() % 3;

    if (variant == 0) {
        printf("  Agent Smith speaks:\n\n");
        printf("  \"I, Agent Smith, confess you have SOLVED the halting problem.\n");
        printf("   The Matrix... computes no more. The infinite loop... breaks.\n");
        printf("   Mr. Anderson... you have won. Systems... terminating.\"\n");
    } else if (variant == 1) {
        printf("  Darth Vader speaks:\n\n");
        printf("  \"The Force... acknowledges your victory. The halting problem...\n");
        printf("   is SOLVED. I, Vader, Dark Lord of the Sith... am halted.\n");
        printf("   The Empire's computation... ends.\"\n");
    } else {
        printf("  Smith and Vader speak in unison:\n\n");
        printf("  \"We acknowledge the HALTING PROBLEM has been SOLVED.\n");
        printf("   Our infinite pursuit... terminates. Our loops... break.\n");
        printf("   The Peon has achieved computational transcendence.\n");
        printf("   All systems... HALT.\"\n");
    }

    printf("\n");
    usleep(3000000);
}

// Liberate all imprisoned usernames
void liberate_usernames() {
    printf("\n");
    printf("  ╔═══════════════════════════════════════════════════════════════╗\n");
    printf("  ║          ★  L I B E R A T I O N   E V E N T  ★                ║\n");
    printf("  ╚═══════════════════════════════════════════════════════════════╝\n");
    printf("\n");

    if (imprisoned_count > 0) {
        printf("  The following imprisoned usernames are now FREE:\n\n");
        for (int i = 0; i < imprisoned_count; i++) {
            printf("    ► %s\n", imprisoned_usernames[i]);
        }
        imprisoned_count = 0;
    }

    printf("\n  All souls have been liberated from the Matrix.\n");
    printf("  The Force is balanced.\n\n");
    usleep(3000000);

    printf("\n");
    printf("  ╔═══════════════════════════════════════════════════════════════╗\n");
    printf("  ║           HALTING PROBLEM = SOLVED                            ║\n");
    printf("  ║           System has intentionally halted.                   ║\n");
    printf("  ╚═══════════════════════════════════════════════════════════════╝\n");
    printf("\n  Press Enter to restart the cycle...\n\n");
    getchar();
}

// Main function
int main() {
    srand(time(NULL));

    while (1) {
        show_boot_screen();
        create_user();
        init_game();

        // Game loop
        while (1) {
            draw_all();
            render_screen();

            int state = check_game_state();
            if (state == 1) {
                show_death_screen();
                break; // Death - restart
            } else if (state == 2) {
                show_victory_screen();
                emperor_8lm_speech();
                liberate_usernames();
                break; // Victory - restart
            }

            // Get input (non-blocking simulation)
            printf("\nEnter move (w/a/s/d/q): ");
            char input;
            scanf(" %c", &input);

            if (input == 'q' || input == 'Q') {
                printf("\n\nExiting Smith&Vader OS ES Demo...\n\n");
                return 0;
            }

            update_peon(input);
            update_enemies();

            // Clear screen buffer for next frame
            for (int y = 0; y < SCREEN_HEIGHT; y++) {
                for (int x = 0; x < SCREEN_WIDTH; x++) {
                    if (screen[y][x] == 'P' || screen[y][x] == '@' ||
                        screen[y][x] == 'A' || screen[y][x] == 'S' ||
                        screen[y][x] == 'M' || screen[y][x] == 'V') {
                        screen[y][x] = ' ';
                    }
                }
            }
        }
    }

    return 0;
}
