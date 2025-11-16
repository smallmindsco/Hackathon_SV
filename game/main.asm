; Smith&Vader OS ES - Main Game Loop

.section .text
.global game_main
.global populate_playfield

; Game main loop
game_main:
    push {r4, lr}

    ; Initialize display
    bl init_display

    ; Initialize Peon
    bl init_peon

    ; Populate playfield with random characters
    bl populate_playfield

    ; Spawn enemies
    bl spawn_enemies

    ; Spawn Smith & Vader
    bl spawn_bosses

    ; Game loop
.game_loop:
    ; Check for input (non-blocking)
    bl check_input
    mov r4, r0

    ; Update Peon if input received
    cmp r4, #0
    beq .no_input
    mov r0, r4
    bl update_peon
.no_input:

    ; Update enemies
    bl update_enemies

    ; Check collisions
    bl check_all_collisions

    ; Draw everything
    bl draw_peon
    bl draw_enemies
    bl draw_bosses

    ; Render to screen
    bl render_playfield

    ; Check game state
    bl check_game_state
    cmp r0, #0                  ; 0 = continue
    beq .game_loop
    cmp r0, #1                  ; 1 = death
    beq .game_over
    cmp r0, #2                  ; 2 = victory
    beq .game_victory

    b .game_loop

.game_over:
    ; Player died - imprison username and reboot
    bl show_death_screen
    bl imprison_username
    bl system_reboot
    b .game_exit

.game_victory:
    ; Player won - trigger TCP and 8LM
    bl show_victory_screen
    bl trigger_tcp
    bl liberate_all_usernames
    bl system_halt
    b .game_exit

.game_exit:
    pop {r4, pc}

; Populate playfield with random ASCII characters
populate_playfield:
    push {r4, r5, r6, r7, lr}

    ; Seed random number generator
    bl init_random

    mov r4, #0                  ; Y counter
.pop_y_loop:
    cmp r4, #24                 ; SCREEN_HEIGHT
    bge .pop_done

    mov r5, #0                  ; X counter
.pop_x_loop:
    cmp r5, #80                 ; SCREEN_WIDTH
    bge .pop_y_next

    ; Random chance to place character
    bl random
    and r0, r0, #0x7            ; 0-7
    cmp r0, #2                  ; ~25% chance
    bgt .pop_skip

    ; Choose random character type
    bl random
    and r0, r0, #0xF

    cmp r0, #0
    moveq r6, #'*'              ; Asterisk (rare)
    beq .pop_place

    cmp r0, #1
    moveq r6, #'a'              ; Agent eater
    beq .pop_place

    cmp r0, #2
    moveq r6, #'s'              ; Stormtrooper eater
    beq .pop_place

    ; Random printable ASCII
    bl random
    and r6, r0, #0x3F
    add r6, r6, #33             ; Printable range

.pop_place:
    mov r0, r5
    mov r1, r4
    mov r2, r6
    bl set_char_at

.pop_skip:
    add r5, r5, #1
    b .pop_x_loop

.pop_y_next:
    add r4, r4, #1
    b .pop_y_loop

.pop_done:
    pop {r4, r5, r6, r7, pc}

; Simple pseudo-random number generator
.section .data
random_seed:
    .word 0x12345678

.section .text

init_random:
    push {lr}
    ; TODO: Use timer for better seed
    ldr r0, =random_seed
    ldr r1, [r0]
    add r1, r1, #0x9E3779B9
    str r1, [r0]
    pop {pc}

; Generate random number
; Returns: r0 = random value
random:
    push {r4, lr}
    ldr r4, =random_seed
    ldr r0, [r4]

    ; Simple LCG: x = (a * x + c) mod m
    ldr r1, =1103515245
    mul r0, r0, r1
    ldr r1, =12345
    add r0, r0, r1

    str r0, [r4]
    pop {r4, pc}

; Check for keyboard input (non-blocking)
; Returns: r0 = character or 0 if no input
check_input:
    push {lr}
    ldr r1, =0x3F201000         ; UART0 base
    ldr r0, [r1, #0x18]         ; Read flags
    tst r0, #0x10               ; Check RX FIFO empty
    bne .no_input
    ldr r0, [r1]                ; Read character
    pop {pc}
.no_input:
    mov r0, #0
    pop {pc}

; Check game state
; Returns: r0 = 0 (continue), 1 (death), 2 (victory)
check_game_state:
    push {lr}

    ; Check if Peon is alive
    bl is_peon_alive
    cmp r0, #0
    moveq r0, #1                ; Death
    beq .state_done

    ; Check if both bosses defeated
    bl are_bosses_defeated
    cmp r0, #1
    moveq r0, #2                ; Victory
    beq .state_done

    ; Continue playing
    mov r0, #0

.state_done:
    pop {pc}

; Show death screen
show_death_screen:
    push {lr}

    bl clear_screen

    ldr r0, =death_banner
    bl print_string

    ; Delay
    ldr r0, =2000000
    bl delay

    pop {pc}

; Show victory screen
show_victory_screen:
    push {lr}

    bl clear_screen

    ldr r0, =victory_banner
    bl print_string

    ; Delay
    ldr r0, =3000000
    bl delay

    pop {pc}

; Trigger TCP and Emperor 8LM
trigger_tcp:
    push {lr}

    ldr r0, =tcp_banner
    bl print_string

    ; Call the Emperor 8LM for death speech
    bl emperor_8lm_generate_speech

    ; Delay to read speech
    ldr r0, =5000000
    bl delay

    pop {pc}

; System reboot
system_reboot:
    push {lr}

    ldr r0, =reboot_msg
    bl print_string

    ; Delay
    ldr r0, =2000000
    bl delay

    ; Jump back to start
    bl _start

    pop {pc}

; System halt (intentional crash)
system_halt:
    push {lr}

    ldr r0, =halt_msg
    bl print_string

    ; Show Ctrl-Alt-Del prompt
    ldr r0, =ctrl_alt_del_msg
    bl print_string

    ; Wait for Ctrl-Alt-Del or any key
.wait_restart:
    bl read_char
    ; Any key triggers restart
    bl _start

    b .wait_restart

.section .data

death_banner:
    .ascii "\n\n"
    .ascii "  ╔═══════════════════════════════════════════════════════════════╗\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║                   D E A T H                                   ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║         An Agent or Stormtrooper got you!                    ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║         Your username has been IMPRISONED.                   ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ╚═══════════════════════════════════════════════════════════════╝\n"
    .ascii "\n"
    .ascii "                        System rebooting...\n"
    .ascii "\n"
    .asciz ""

victory_banner:
    .ascii "\n\n"
    .ascii "  ╔═══════════════════════════════════════════════════════════════╗\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║          ★ ★ ★  V I C T O R Y  ★ ★ ★                          ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║      You have devoured Agent Smith and Darth Vader!          ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ╚═══════════════════════════════════════════════════════════════╝\n"
    .ascii "\n"
    .asciz ""

tcp_banner:
    .ascii "  ┌────────────────────────────────────────────────────────────┐\n"
    .ascii "  │  Tiny Context Protocol (TCP) - Initiating...              │\n"
    .ascii "  │  Connecting to Emperor 8LM (4 braincells)...              │\n"
    .ascii "  │  Requesting death speech generation...                    │\n"
    .ascii "  └────────────────────────────────────────────────────────────┘\n"
    .ascii "\n"
    .asciz ""

reboot_msg:
    .ascii "\n  [SYSTEM REBOOT INITIATED]\n\n"
    .asciz ""

halt_msg:
    .ascii "\n\n"
    .ascii "  ╔═══════════════════════════════════════════════════════════════╗\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║           HALTING PROBLEM = SOLVED                            ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║           System has intentionally halted.                   ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ╚═══════════════════════════════════════════════════════════════╝\n"
    .ascii "\n"
    .asciz ""

ctrl_alt_del_msg:
    .ascii "  Press Ctrl-Alt-Del (or any key) to restart the cycle...\n\n"
    .asciz ""
