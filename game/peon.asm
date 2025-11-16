; Smith&Vader OS ES - Peon Character
; Pac-Man in a black trench coat

.section .text
.global init_peon
.global update_peon
.global draw_peon
.global get_peon_pos
.global is_peon_powered

; Peon character
.equ PEON_CHAR, 'P'
.equ PEON_START_X, 40
.equ PEON_START_Y, 12

; Power-up states
.equ POWER_NONE, 0
.equ POWER_ASTERISK, 1        ; Can eat Smith & Vader
.equ POWER_AGENT, 2           ; Can eat agents
.equ POWER_STORMTROOPER, 4    ; Can eat stormtroopers

; Power-up duration (in game ticks)
.equ POWER_DURATION, 100

; Initialize Peon
init_peon:
    push {lr}

    ; Set starting position
    ldr r0, =peon_x
    mov r1, #PEON_START_X
    str r1, [r0]

    ldr r0, =peon_y
    mov r1, #PEON_START_Y
    str r1, [r0]

    ; Clear power-ups
    ldr r0, =peon_power
    mov r1, #POWER_NONE
    str r1, [r0]

    ldr r0, =peon_power_timer
    mov r1, #0
    str r1, [r0]

    ; Set alive state
    ldr r0, =peon_alive
    mov r1, #1
    str r1, [r0]

    pop {pc}

; Update Peon position based on input
; r0 = input character ('w', 'a', 's', 'd' or arrow keys)
update_peon:
    push {r4, r5, r6, lr}

    ; Check if alive
    ldr r4, =peon_alive
    ldr r4, [r4]
    cmp r4, #0
    beq .update_done

    ; Load current position
    ldr r4, =peon_x
    ldr r5, [r4]
    ldr r4, =peon_y
    ldr r6, [r4]

    ; Save old position for collision check
    push {r5, r6}

    ; Process input
    cmp r0, #'w'
    beq .move_up
    cmp r0, #'W'
    beq .move_up
    cmp r0, #'s'
    beq .move_down
    cmp r0, #'S'
    beq .move_down
    cmp r0, #'a'
    beq .move_left
    cmp r0, #'A'
    beq .move_left
    cmp r0, #'d'
    beq .move_right
    cmp r0, #'D'
    beq .move_right

    ; Arrow key escape sequences
    cmp r0, #0x1B              ; ESC
    bne .no_move
    ; TODO: Handle arrow key sequences
    b .no_move

.move_up:
    subs r6, r6, #1
    cmp r6, #0
    movlt r6, #0
    b .check_collision

.move_down:
    add r6, r6, #1
    cmp r6, #23                ; SCREEN_HEIGHT - 1
    movgt r6, #23
    b .check_collision

.move_left:
    subs r5, r5, #1
    cmp r5, #0
    movlt r5, #0
    b .check_collision

.move_right:
    add r5, r5, #1
    cmp r5, #79                ; SCREEN_WIDTH - 1
    movgt r5, #79
    b .check_collision

.check_collision:
    ; Check what's at the new position
    mov r0, r5
    mov r1, r6
    bl get_char_at

    ; r0 now contains the character at new position
    ; Check for various collectibles and obstacles
    mov r4, r0

    ; Check for asterisk (power-up)
    cmp r4, #'*'
    beq .collect_asterisk

    ; Check for 'a' (agent eater)
    cmp r4, #'a'
    beq .collect_agent_power

    ; Check for 's' (stormtrooper eater)
    cmp r4, #'s'
    beq .collect_storm_power

    ; Otherwise, allow move if it's a space or collectible
    b .apply_move

.collect_asterisk:
    ; Grant Smith/Vader eating power
    ldr r4, =peon_power
    mov r0, #POWER_ASTERISK
    str r0, [r4]
    ldr r4, =peon_power_timer
    mov r0, #POWER_DURATION
    str r0, [r4]
    b .apply_move

.collect_agent_power:
    ; Grant agent eating power
    ldr r4, =peon_power
    ldr r0, [r4]
    orr r0, r0, #POWER_AGENT
    str r0, [r4]
    ldr r4, =peon_power_timer
    mov r0, #POWER_DURATION
    str r0, [r4]
    b .apply_move

.collect_storm_power:
    ; Grant stormtrooper eating power
    ldr r4, =peon_power
    ldr r0, [r4]
    orr r0, r0, #POWER_STORMTROOPER
    str r0, [r4]
    ldr r4, =peon_power_timer
    mov r0, #POWER_DURATION
    str r0, [r4]
    b .apply_move

.apply_move:
    ; Update position
    ldr r4, =peon_x
    str r5, [r4]
    ldr r4, =peon_y
    str r6, [r4]

    ; Clear old position (pop from stack)
    pop {r0, r1}
    mov r2, #' '
    bl set_char_at
    b .update_done

.no_move:
    ; Restore position from stack
    pop {r5, r6}

.update_done:
    ; Update power timer
    bl update_power_timer

    pop {r4, r5, r6, pc}

; Update power-up timer
update_power_timer:
    push {r4, lr}

    ldr r4, =peon_power_timer
    ldr r0, [r4]

    cmp r0, #0
    beq .timer_done

    ; Decrement timer
    subs r0, r0, #1
    str r0, [r4]

    ; If timer expired, clear power
    cmp r0, #0
    bne .timer_done

    ldr r4, =peon_power
    mov r0, #POWER_NONE
    str r0, [r4]

.timer_done:
    pop {r4, pc}

; Draw Peon on screen
draw_peon:
    push {r4, r5, lr}

    ; Check if alive
    ldr r4, =peon_alive
    ldr r4, [r4]
    cmp r4, #0
    beq .draw_done

    ; Get position
    ldr r4, =peon_x
    ldr r0, [r4]
    ldr r4, =peon_y
    ldr r1, [r4]

    ; Choose character based on power state
    ldr r4, =peon_power
    ldr r4, [r4]
    cmp r4, #POWER_NONE
    moveq r2, #PEON_CHAR
    movne r2, #'@'             ; Powered-up Peon looks different

    ; Draw Peon
    bl set_char_at

.draw_done:
    pop {r4, r5, pc}

; Get Peon position
; Returns: r0 = x, r1 = y
get_peon_pos:
    push {r4, lr}
    ldr r4, =peon_x
    ldr r0, [r4]
    ldr r4, =peon_y
    ldr r1, [r4]
    pop {r4, pc}

; Check if Peon has specific power
; r0 = power flag to check
; Returns: r0 = 1 if has power, 0 otherwise
is_peon_powered:
    push {r4, lr}
    ldr r4, =peon_power
    ldr r1, [r4]
    and r0, r1, r0
    cmp r0, #0
    movne r0, #1
    pop {r4, pc}

; Kill Peon (called on collision with enemy)
kill_peon:
    push {lr}
    ldr r0, =peon_alive
    mov r1, #0
    str r1, [r0]
    pop {pc}

; Check if Peon is alive
; Returns: r0 = 1 if alive, 0 if dead
is_peon_alive:
    ldr r1, =peon_alive
    ldr r0, [r1]
    bx lr

.section .bss
    .align 4

peon_x:
    .word 0

peon_y:
    .word 0

peon_power:
    .word 0

peon_power_timer:
    .word 0

peon_alive:
    .word 0
