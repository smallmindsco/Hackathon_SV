; Smith&Vader OS ES - Power-up System
; Power-up logic is integrated into peon.asm
; This file documents the power-up mechanics

.section .text
.global spawn_powerups

; Spawn power-ups randomly on the playfield
; This is called during populate_playfield in main.asm
spawn_powerups:
    push {r4, r5, r6, lr}

    ; Spawn a few asterisks (rare, powerful)
    mov r4, #0
.spawn_asterisk_loop:
    cmp r4, #3                  ; 3 asterisks max
    bge .spawn_agent_powers

    bl random
    and r0, r0, #0x3F
    add r0, r0, #10             ; X position

    bl random
    and r1, r0, #0x0F
    add r1, r1, #5              ; Y position

    mov r2, #'*'
    bl set_char_at

    add r4, r4, #1
    b .spawn_asterisk_loop

.spawn_agent_powers:
    ; Spawn 'a' characters (agent eaters)
    mov r4, #0
.spawn_a_loop:
    cmp r4, #8
    bge .spawn_storm_powers

    bl random
    and r0, r0, #0x3F
    add r0, r0, #10

    bl random
    and r1, r0, #0x0F
    add r1, r1, #5

    mov r2, #'a'
    bl set_char_at

    add r4, r4, #1
    b .spawn_a_loop

.spawn_storm_powers:
    ; Spawn 's' characters (stormtrooper eaters)
    mov r4, #0
.spawn_s_loop:
    cmp r4, #8
    bge .spawn_done

    bl random
    and r0, r0, #0x3F
    add r0, r0, #10

    bl random
    and r1, r0, #0x0F
    add r1, r1, #5

    mov r2, #'s'
    bl set_char_at

    add r4, r4, #1
    b .spawn_s_loop

.spawn_done:
    pop {r4, r5, r6, pc}

.section .data

powerup_info:
    .ascii "\n"
    .ascii "  Power-up Guide:\n"
    .ascii "    * = Can eat Smith & Vader (RARE!)\n"
    .ascii "    a = Can eat Agents\n"
    .ascii "    s = Can eat Stormtroopers\n"
    .ascii "\n"
    .asciz ""
